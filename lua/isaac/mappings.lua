-- -- Use Control of Leader + h/j/k/l to move between panes
-- -- If you use the tmux-nvim plugin https://github.com/christoomey/vim-tmux-navigator
-- -- Then you would just use the c-h, c-k, c-j, c-l to move around.
-- vim.keymap.set({ "n" }, "<leader>kh", "<C-w>h", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<leader>kj", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<leader>kk", "<C-w>k", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<leader>kl", "<C-w>l", { noremap = true, silent = true })

-- terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- Delete without pasting (sending to the black hole register)
vim.keymap.set({ "n", "v" }, "<leader>'", '"_', { noremap = true, silent = true })

-- common keyboard shortcuts
vim.keymap.set({ "n" }, "<leader>aa", "gg<S-V><S-G>", { noremap = true, silent = true })
vim.keymap.set({ "i" }, "<S-CR>", "<C-o>o", { noremap = true, silent = true })

-- for quicker closing buffers
-- vim.keymap.set({ "n" }, "<leader>bd", "<Cmd>BufferDelete<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bd", function()
	require("bufdelete").bufwipeout(0, false)
end, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bad", function()
	local bd = require("bufdelete")

	local bufs = vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
	end, vim.api.nvim_list_bufs())

	bd.bufdelete(bufs, true) -- true = force
end, { noremap = true, silent = true })

vim.keymap.set({ "n" }, "<leader>bod", function()
	local bd = require("bufdelete")

	local bufs = vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= vim.api.nvim_get_current_buf() -- keep current buffer
	end, vim.api.nvim_list_bufs())

	bd.bufdelete(bufs, true) -- true = force
end, { noremap = true, silent = false })

-- Map `<leader>w` to toggle wrap
-- vim.api.nvim_set_keymap("n", "<leader>ew", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>ew",
	require("isaac.custom-scripts.smart-vim-wrap").smart_wrap,
	{ noremap = true, silent = true }
)

-- Set <leader>gf to use conform.nvim to format
vim.keymap.set({ "n", "x" }, "<leader>gf", function()
	require("conform").format({ async = false, lsp_fallback = true }, function(err)
		if not err then
			local mode = vim.api.nvim_get_mode().mode
			if vim.startswith(string.lower(mode), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
			end

			-- Reset horizontal scroll WITHOUT moving cursor
			local view = vim.fn.winsaveview()
			view.leftcol = 0
			vim.fn.winrestview(view)
		end
	end)
end, { desc = "Format code" })

-- Custom setup for wrapping. I have to write a lot of latex and hence find
-- it would be useful if it can automatically wrap the text for me.
-- This is only for plain text and not for code documentation.
-- Set <leader>gwr to use word wrap
vim.api.nvim_create_user_command("Wrap", function(opts)
	local start_line = opts.line1
	local end_line = opts.line2
	local width = tonumber(opts.fargs[1]) or 90
	-- print(start_line, end_line)
	require("isaac.custom-scripts.word-wrap").wrap_range(start_line, end_line, width)
end, {
	range = true,
	nargs = "?",
	desc = "Join paragraphs (blank-line separated) and rewrap to width (default: &textwidth or 90)",
})

-- Visual mode: select a block then <leader>w to wrap
vim.keymap.set("x", "<leader>gwr", ":Wrap<CR>0^", { silent = true, desc = "Wrap selection" })
vim.keymap.set(
	"n",
	"<leader>gwr",
	require("isaac.custom-scripts.word-wrap").auto_wrap_para,
	{ silent = true, desc = "Auto Wrap with Detected Para." }
)

-- A smarter resize
local function resize_left()
	local win = vim.api.nvim_get_current_win()
	local col = vim.api.nvim_win_get_position(win)[2]
	local width = vim.api.nvim_win_get_width(win)
	local total = vim.o.columns

	-- midpoint of this window
	local mid = col + width / 2
	local is_right_half = mid > total / 2

	if is_right_half then
		vim.cmd("vertical resize +2")
	else
		vim.cmd("vertical resize -2")
	end
end

local function resize_right()
	local win = vim.api.nvim_get_current_win()
	local col = vim.api.nvim_win_get_position(win)[2]
	local width = vim.api.nvim_win_get_width(win)
	local total = vim.o.columns

	local mid = col + width / 2
	local is_right_half = mid > total / 2

	if is_right_half then
		vim.cmd("vertical resize -2")
	else
		vim.cmd("vertical resize +2")
	end
end

vim.keymap.set("n", "<S-Left>", resize_left, { silent = true, desc = "Resize smart left" })
vim.keymap.set("n", "<S-Right>", resize_right, { silent = true, desc = "Resize smart right" })

-- LSP related binding
-- stylua: ignore start
vim.keymap.set("n", "<leader>dd", function() vim.diagnostic.open_float(nil, { focus = false }) end, { silent = true, desc = "Showing diagnostic in floating window" })
vim.keymap.set( "n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP: Go to Definition" })
vim.keymap.set( "n", "<leader>gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "LSP: Go to Declaration" })
vim.keymap.set( "n", "<leader>gt", vim.lsp.buf.type_definition, { noremap = true, silent = true, desc = "LSP: Type Definition" })
vim.keymap.set( "n", "<leader>gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "LSP: Implementation" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "LSP: References" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: Code Action" })
-- stylua: ignore end
