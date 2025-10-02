vim.b.slime_cell_delimiter = "#\\s\\=%%"

-- #### Custom Shortcut ####
-- helper: find next "meaningful" line (non-blank, not just whitespace)
local function next_meaningful_line(start_line)
	local last = vim.api.nvim_buf_line_count(0)
	for l = start_line, last do
		local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1]
		if line and line:match("%S") and string.sub(line, 1, 1) ~= "#" then
			return l
		end
	end
	return last
end

-- Run current line, then move to the next line
vim.keymap.set("n", "<Enter>", function()
	local iron = require("iron.core")
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local last = vim.api.nvim_buf_line_count(0)
	local line = vim.api.nvim_buf_get_lines(0, cur - 1, cur, false)[1] or ""
	iron.send_line()
	-- local nextline = math.min(cur + 1, last)
	local next_mline = next_meaningful_line(math.min(cur + 1, last))
	vim.api.nvim_win_set_cursor(0, { next_mline, 0 })
end, { buffer = 0, silent = true, desc = "Python: run line & move down" })

-- Run visual selection, then move to the line after the selection
vim.keymap.set("x", "<Enter>", function()
	local iron = require("iron.core")
	vim.cmd([[ execute "normal! \<ESC>" ]])
	local e = vim.api.nvim_buf_get_mark(0, ">")[1]
	vim.cmd([[ execute "normal! gv" ]])
	local last = vim.api.nvim_buf_line_count(0)
	-- Ensure a final newline; Iron accepts a list of lines
	iron.visual_send()
	-- Leave Visual mode and place cursor on the line after the selection
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	-- local target = math.min(e + 1, last)
	local next_mline = next_meaningful_line(math.min(e + 1, last))
	vim.api.nvim_win_set_cursor(0, { next_mline, 0 })
end, { buffer = 0, silent = true, desc = "Python: run selection & move after" })
