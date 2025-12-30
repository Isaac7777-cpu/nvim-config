return {
	{ -- Adopted from kickstarter
		-- for complete functionality (language features)
		"quarto-dev/quarto-nvim",
		dev = false,
		ft = { "quarto", "markdown" },
		dependencies = {
			-- for language features in code cells
			-- configured in lua/plugins/lsp.lua
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			-- quarto mappings
			require("quarto").setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					enabled = true,
					chunks = "curly",
					languages = { "r", "python", "julia", "bash", "html" },
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = {
						enabled = true,
					},
				},
				codeRunner = {
					enabled = true,
					default_method = "iron", -- "molten", "slime", "iron" or <function>
					ft_runners = {
						python = "molten",
					}, -- filetype to runner, ie. `{ python = "molten" }`.
					-- Takes precedence over `default_method`
					never_run = { "yaml" }, -- filetypes which are never sent to a code runner
				},
			})
			local quarto = require("quarto")
			vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })

			-- quarto runner mappings
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
			vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
			vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
			vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
			vim.keymap.set("x", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
			vim.keymap.set("n", "<localleader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages", silent = true })
		end,
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		build = ":UpdateRemotePlugins",
		init = function()
			-- these are examples, not defaults. Please see the readme
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,
	},
	{
		"3rd/image.nvim",
		event = "VeryLazy",
		ft = { "quarto" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			-- "leafo/magick",
		},
		opts = {
			backend = "sixel",
			integrations = {
				markdown = {
					enabled = true,
					only_render_image_at_cursor = true,
					only_render_image_at_cursor_mode = "popup",
					filetypes = { "markdown", "vimwiki", "quarto" },
				},
			},
			editor_only_render_when_focused = false,
			window_overlap_clear_enabled = true,
			tmux_show_only_in_active_window = true,
			max_width = 100, -- tweak to preference
			max_height = 12,
			max_height_window_percentage = math.huge, -- this is necessary for a good experience
			max_width_window_percentage = math.huge,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			-- kitty_method = "normal",
		},
	},
}
