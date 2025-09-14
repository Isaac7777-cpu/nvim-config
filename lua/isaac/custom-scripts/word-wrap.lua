-- lua/mywrap.lua
local M = {}

local function wrap_paragraphs(lines, width)
	local out = {}
	local i = 1

	-- Helper function to get string length (handles UTF-8 if available)
	local function ulen(s)
		if utf8 and utf8.len then
			local ok, len = pcall(utf8.len, s)
			return ok and len or #s
		end
		return #s
	end

	while i <= #lines do
		-- Skip empty/whitespace lines
		if not lines[i]:match("%S") then
			-- Only add one blank line between paragraphs
			if #out == 0 or out[#out] ~= "" then
				table.insert(out, "")
			end
			i = i + 1
		else
			-- Collect a paragraph (non-empty consecutive lines)
			local para = {}
			while i <= #lines and lines[i]:match("%S") do
				table.insert(para, lines[i])
				i = i + 1
			end

			-- Get indentation from first line
			local indent = para[1]:match("^%s*") or ""
			local indent_len = ulen(indent)

			-- Join paragraph into single string and normalize whitespace
			local text = table.concat(para, " ")
			text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

			-- If the entire paragraph fits within the width, just add it
			if ulen(text) + indent_len <= width then
				table.insert(out, indent .. text)
			else
				-- Split text into words
				local words = {}
				for word in text:gmatch("%S+") do
					table.insert(words, word)
				end

				-- Wrap the paragraph
				local current_line = indent
				local current_length = indent_len

				for j, word in ipairs(words) do
					local word_len = ulen(word)
					local space_needed = current_length > indent_len and 1 or 0

					-- Check if we need to start a new line
					if current_length + space_needed + word_len > width then
						-- Add current line to output
						table.insert(out, current_line)

						-- Start new line with indent
						current_line = indent
						current_length = indent_len
					end

					-- Add space if not the first word in line
					if current_length > indent_len then
						current_line = current_line .. " " .. word
						current_length = current_length + 1 + word_len
					else
						current_line = current_line .. word
						current_length = current_length + word_len
					end
				end

				-- Add the last line of the paragraph
				if current_length > indent_len then
					table.insert(out, current_line)
				end
			end
		end
	end

	-- Remove trailing blank lines (keep at most one)
	while #out > 0 and out[#out] == "" do
		if #out == 1 or out[#out - 1] ~= "" then
			break
		end
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
