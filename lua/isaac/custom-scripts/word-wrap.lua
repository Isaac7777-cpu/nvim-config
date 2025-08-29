-- lua/mywrap.lua
local M = {}

-- Simple list marker detector: returns marker text and hanging indent size
local function detect_list_marker(s)
	-- bullets: -, *, +
	local indent, bullet = s:match("^(%s*)([-*+])%s+")
	if indent and bullet then
		local marker = indent .. bullet .. " "
		return marker, #marker
	end
	-- numbered: 1.  a)  i)
	local indent2, num = s:match("^(%s*)([%divx]+[.)])%s+")
	if indent2 and num then
		local marker = indent2 .. num .. " "
		return marker, #marker
	end
	return nil, 0
end

local function wrap_text(text, width, indent, hanging)
	local out = {}
	local line = indent or ""
	local linelen = #line
	local first = true
	for word in text:gmatch("%S+") do
		local add = (linelen > (first and #line or 0) and 1 or 0) + #word
		if linelen + add <= width then
			if linelen > 0 then
				line = line .. " " .. word
			else
				line = word
			end
			linelen = #line
		else
			table.insert(out, line)
			-- after first line of a list item, apply hanging indent
			if hanging and hanging > 0 then
				line = string.rep(" ", hanging) .. word
			else
				line = (indent or "") .. word
			end
			linelen = #line
			first = false
		end
	end
	table.insert(out, line)
	return out
end

local function wrap_paragraphs(lines, width)
  local out, i = {}, 1

  local function ulen(s)
    if utf8 and utf8.len then
      return select(2, pcall(utf8.len, s)) or #s
    else
      return #s
    end
  end

  while i <= #lines do
    -- collect one paragraph (stop at blank/whitespace-only line)
    local para = {}
    while i <= #lines and lines[i]:match("%S") do
      table.insert(para, lines[i])
      i = i + 1
    end

    if #para == 0 then
      -- preserve a single blank between paragraphs
      if #out == 0 or out[#out] ~= "" then table.insert(out, "") end
      i = i + 1
    else
      -- indentation from first non-empty line
      local indent = (para[1]:match("^%s*")) or ""
      -- flatten lines -> single spaced text
      local text = table.concat(para, " ")
      text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

      local line = indent
      local linelen = ulen(line)

      for word in text:gmatch("%S+") do
        local add = (linelen > ulen(indent) and 1 or 0) + ulen(word)
        if linelen + add <= width then
          if linelen > ulen(indent) then
            line = line .. " " .. word
          else
            line = line .. word
          end
          linelen = ulen(line)
        else
          -- if current line only has indent, still place the long word
          if linelen == ulen(indent) then
            table.insert(out, indent .. word)
            line = indent
            linelen = ulen(line)
          else
            table.insert(out, line)
            line = indent .. word
            linelen = ulen(line)
          end
        end
      end
      table.insert(out, line)
    end
  end

  -- trim trailing blank lines to at most one
  while #out > 1 and out[#out] == "" and out[#out-1] == "" do
    table.remove(out)
  end

  return out
end

function M.wrap_range(start_line, end_line, width)
	local bufnr = 0
	local tw = vim.bo.textwidth
	local w = width or (tw > 0 and tw or 80)

	-- get lines (0-indexed; end exclusive -> +1)
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)
	if #lines == 0 then
		return
	end

	local wrapped = wrap_paragraphs(lines, w)

	vim.api.nvim_buf_set_lines(bufnr, start_line, end_line + 1, false, wrapped)
end

return M
