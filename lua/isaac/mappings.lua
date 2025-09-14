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
vim.keymap.set({ "n" }, "<leader>bd", "<Cmd>BufferDelete<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bad", "<Cmd>%bd<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bod", "<Cmd>BufferLineCloseOthers<CR>", { noremap = true, silent = false })

-- Map `<leader>w` to toggle wrap
-- vim.api.nvim_set_keymap("n", "<leader>ew", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>ew",
	require("isaac.custom-scripts.smart-vim-wrap").smart_wrap,
	{ noremap = true, silent = true }
)

-- Exiting Terminal
vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })

-- Set rename symbol.
vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Set <leader>gf to use conform.nvim to format
vim.keymap.set("n", "<leader>gf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format buffer with conform.nvim" })

-- Set <leader>gwr to use word wrap
vim.api.nvim_create_user_command("Wrap", function(opts)
	local start_line = opts.line1 - 1
	local end_line = opts.line2 - 1
	local width = tonumber(opts.fargs[1]) or 90
	require("isaac.custom-scripts.word-wrap").wrap_range(start_line, end_line, width)
end, {
	range = true,
	nargs = "?",
	desc = "Join paragraphs (blank-line separated) and rewrap to width (default: &textwidth or 90)",
})

-- Visual mode: select a block then <leader>w to wrap
vim.keymap.set("x", "<leader>gwr", ":Wrap<CR>", { silent = true, desc = "Wrap selection" })
