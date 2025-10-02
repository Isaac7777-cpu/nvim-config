-- lua/mywrap.lua
local M = {}

---Taken an array of lines to wrap and wrap it to specify width.
---@param lines string[] The array of lines. Commonly returned by `vim.api.nvim_get_buf_line`
---@param width integer The width to wrap to.
---@return table
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

			-- print(text)

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

---Wrap a range of lines to a specified width
---@param start_line number The starting line number (1-indexed, as shown in display)
---@param end_line number the ending line number (1-indexed, as shown in display)
---@param width? number|nil The widht to wrap to. If nil, use textwidth if set, otherwise defaults to 90
function M.wrap_range(start_line, end_line, width)
	local bufnr = 0
	local tw = vim.bo.textwidth
	local w = width or (tw > 0 and tw or 90)

	-- Convert to zero-indexing of lines
	-- The end line should also be exclusive
	local start_at_0 = start_line - 1
	local end_at_0 = end_line

	-- get lines (0-indexed; end exclusive -> +1)
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_at_0, end_at_0, true)
	if #lines == 0 then
		return 0
	end

	local wrapped = wrap_paragraphs(lines, w)

	vim.api.nvim_buf_set_lines(bufnr, start_at_0, end_at_0, true, wrapped)

	return #wrapped
end

---Returns the boundaries of a visual paragraphs. This is characterised by
---having the different indentation of an empty barrier line.
---
---@return integer?, integer?
local function get_paragraph_boundaries()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1] -- 0-indexed
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local n_lines = #lines

	-- If current line is empty, no paragraph found
	if lines[cursor_line]:match("^%s*$") then
		return nil, nil
	end

	-- Find paragraph start
	local start_line = cursor_line
	while start_line > 0 do
		if lines[start_line]:match("^%s*$") then -- Empty line
			break
		end
		-- Check if indentation changes
		local current_indent = lines[start_line]:match("^%s*")
		local prev_indent = lines[start_line - 1]:match("^%s*")
		if current_indent ~= prev_indent then
			break
		end
		start_line = start_line - 1
	end

	-- Find paragraph end
	local end_line = cursor_line
	while end_line < n_lines - 1 do
		if lines[end_line + 1]:match("^%s*$") then -- Empty line
			break
		end
		-- Check if indentation changes
		local current_indent = lines[end_line]:match("^%s*")
		local next_indent = lines[end_line + 1]:match("^%s*")
		if current_indent ~= next_indent then
			break
		end
		end_line = end_line + 1
	end

	-- -- Verify we found a valid paragraph (not just a single line with different indentation)
	-- if start_line == end_line then
	-- 	return nil, nil
	-- end

	return start_line, end_line
end

---Wrap the paragraph at the current cursor position
---Automatically detects paragraph boundaries based on indentation and empty lines
---Uses textwidth if set, otherwise defaults to 85 characters
---Shows a warning message if no paragraph is found at the cursor position
---
---@param width? number|nil The widht to wrap to. If nil, use textwidth if set, otherwise defaults to 90
function M.auto_wrap_para(width)
	local start_line, end_line = get_paragraph_boundaries()

	-- -- Debug Purpose
	-- print(start_line, end_line)

	if not start_line or not end_line then
		require("noice").notify("word-wrap.lua:auto_wrap_para (line 177)\nNo paragraph found at cursor position", "warn", {
			title = "Text Wrap Error",
		})
		return
	end

	-- Record the position before wrapping
	local pos_before_wrap = vim.api.nvim_win_get_cursor(0)[1]
	-- Use the marker for whether to put the cursor after wrapping
	local mark = (start_line + end_line) / 2

	local linecount = M.wrap_range(start_line, end_line, width)

	-- Restore cursor to the start
	if pos_before_wrap < mark then
		vim.api.nvim_win_set_cursor(0, { start_line, 0 })
	else
		local wrapped_end = start_line + linecount - 1
		local end_line_content = vim.api.nvim_buf_get_lines(0, wrapped_end - 1, wrapped_end, false)[1]
		local end_line_length = #end_line_content
		vim.api.nvim_win_set_cursor(0, { wrapped_end, end_line_length })
	end

	-- Recenter horizontally
	vim.cmd("normal! 0^")
end

return M
