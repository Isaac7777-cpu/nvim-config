return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				sync_install = false,
				ensure_installed = {},
				ignore_install = {},
				modules = {},
			})

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			vim.filetype.add({
				pattern = {
					[".*%.blade%.php"] = "blade",
				},
			})

			--   -- Let's use the nvim_ufo instead.
			-- -- Enable Tree-sitter based folding
			-- vim.o.foldmethod = "expr"
			-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
			--
			-- -- Optional: control default folding behavior
			-- vim.o.foldenable = false -- Do not fold by default
			-- vim.o.foldlevel = 99 -- Allow all folds to be open
			-- vim.o.foldlevelstart = 99
			-- vim.o.foldcolumn = "1" -- Show fold column (optional)
		end,
	},
	{
		"jmacadie/telescope-hierarchy.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				-- Choose your own keys, this works for me
				"<leader>gsi",
				"<cmd>Telescope hierarchy incoming_calls<cr>",
				desc = "LSP: [S]earch [I]ncoming Calls",
			},
			{
				"<leader>gso",
				"<cmd>Telescope hierarchy outgoing_calls<cr>",
				desc = "LSP: [S]earch [O]utgoing Calls",
			},
		},
		opts = {
			-- don't use `defaults = { }` here, do this in the main telescope spec
			extensions = {
				hierarchy = {
					initial_multi_expand = false, -- Run a multi-expand on open? If false, will only expand one layer deep by default
					multi_depth = 5, -- How many layers deep should a multi-expand go?
					layout_strategy = "horizontal",
					previewer = true,
				},
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("hierarchy")
		end,
	},
}
