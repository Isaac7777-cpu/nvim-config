return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			require("nvim-treesitter.parsers").blade = {
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
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			auto_install = true,
			sync_install = false,
			ensure_installed = {},
			ignore_install = {},
			highlight = { enable = true },
			indent = { enable = true },
			fold = { enable = false },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			for _, mode in ipairs({ "x", "o" }) do
				vim.keymap.set(mode, "ajcell", function()
					require("nvim-treesitter-textobjects.select").select_textobject("@cell", "textobjects")
				end, { desc = "Select cell" })
				vim.keymap.set(mode, "ijcell", function()
					require("nvim-treesitter-textobjects.select").select_textobject("@cellcontent", "textobjects")
				end, { desc = "Select cell content" })
			end

			for _, mode in ipairs({ "n", "x", "o" }) do
				vim.keymap.set(mode, "]jcell", function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@cellseparator", "textobjects")
				end, { desc = "Next cell" })
				vim.keymap.set(mode, "[jcell", function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@cellseparator", "textobjects")
				end, { desc = "Previous cell" })
			end
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
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = true, -- Enable multiwindow support.
				max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true })
			local palette = require("catppuccin.palettes").get_palette()
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = palette.surface0 })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = palette.overlay1, bg = palette.surface0 })
			vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
				underline = false,
				sp = palette.overlay0,
			})
		end,
	},
}
