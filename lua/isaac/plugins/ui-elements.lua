return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup({})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		filter = {
			event = "msg_show",
			find = "Checking document",
		},
		opts = {
			-- add any options here
			skip = true,
		},
		dependencies = {
			-- If you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
			"ibhagwan/fzf-lua",
		},
		config = function()
			-- Configure nvim-notify with custom stages
			require("notify").setup({
				direction = "bottom_up",
				stages = require("isaac.plugins.notify.customn-stage")("bottom_up"), -- Use the custom stages
			})

			-- Set `nvim-notify` as the global notification handler
			vim.notify = require("notify")

			-- The actual setup for noice
			require("noice").setup({
				lsp = {
					-- Override Markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
}
