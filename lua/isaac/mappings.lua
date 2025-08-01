-- Use Control of Leader + h/j/k/l to move between panes
vim.keymap.set({ "n" }, "<leader>kh", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>kj", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>kk", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>kl", "<C-w>l", { noremap = true, silent = true })

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

-- for wrapping the texts
local wrapenabled = 0

function ToggleWrap()
	vim.opt.wrap = true
	vim.opt.list = false

	if wrapenabled == 1 then
		vim.opt.linebreak = false
		vim.api.nvim_del_keymap("n", "j")
		vim.api.nvim_del_keymap("n", "k")
		vim.api.nvim_del_keymap("n", "0")
		vim.api.nvim_del_keymap("n", "^")
		vim.api.nvim_del_keymap("n", "$")
		wrapenabled = 0
	else
		vim.opt.linebreak = true
		vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "0", "g0", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "^", "g^", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "$", "g$", { noremap = true, silent = true })
		wrapenabled = 1
	end
end

-- -- Do not wrap in default
-- ToggleWrap()

-- Map `<leader>w` to toggle wrap
vim.api.nvim_set_keymap("n", "<leader>ew", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })

-- Exiting Terminal
vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })

-- Set rename symbol.
vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Set <leader>gf to use conform.nvim to format
vim.keymap.set("n", "<leader>gf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format buffer with conform.nvim" })
