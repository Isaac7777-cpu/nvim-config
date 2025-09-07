return {
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
}
