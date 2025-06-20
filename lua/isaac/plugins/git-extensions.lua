return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 300,
                    virt_text_pos = "eol",
                }
            })

			vim.keymap.set("n", "<leader>gih", ":Gitsigns preview_hunk<CR>", {})
			vim.keymap.set("n", "<leader>git", ":Gitsigns toggle_current_line_blame<CR>", {})
		end,
	},
}
