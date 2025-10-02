return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = "ivy",
					},
				},
				extensions = {
					fzf = {},
				},
			})
			require("telescope").load_extension("fzf")
			local builtin = require("telescope.builtin")
			vim.keymap.set(
				"n",
				"<leader><leader>",
				"<cmd>lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git', '-g', '!node_modules' }, layout_config = { height = 0.3 }}<cr>"
			)
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {}) -- use the multigrep instead.
			require("isaac.plugins.telescope.multigrep").setup()
			vim.keymap.set("n", "<leader>fx", builtin.diagnostics, { desc = "Show all diagnostics (errors/warnings)" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume searching" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"smartpde/telescope-recent-files",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("recent_files")
		end,
	},
}
