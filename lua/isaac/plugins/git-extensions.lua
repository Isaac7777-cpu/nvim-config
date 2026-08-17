return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 300,
					virt_text_pos = "eol",
				},
			})

			vim.keymap.set("n", "<leader>gth", ":Gitsigns preview_hunk<CR>", {})
			vim.keymap.set("n", "<leader>gtt", ":Gitsigns toggle_current_line_blame<CR>", {})
		end,
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gty", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<leader>gtY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
	{
		"tpope/vim-fugitive",
	},
}
