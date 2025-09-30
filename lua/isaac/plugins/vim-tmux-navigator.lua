return {
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.keymap.set("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
			vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
			vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
			vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
			vim.keymap.set("n", "<leader><c-\\>", "<cmd>TmuxNavigatePrevious<cr>")

			-- Terminal-mode mappings: exit terminal-mode, then run the command
			local t = [[<C-\><C-n>]]
			vim.keymap.set("t", "<C-h>", t .. "<cmd>TmuxNavigateLeft<CR>", { silent = true })
			vim.keymap.set("t", "<C-j>", t .. "<cmd>TmuxNavigateDown<CR>", { silent = true })
			vim.keymap.set("t", "<C-k>", t .. "<cmd>TmuxNavigateUp<CR>", { silent = true })
			vim.keymap.set("t", "<C-l>", t .. "<cmd>TmuxNavigateRight<CR>", { silent = true })
		end,
	},
}
