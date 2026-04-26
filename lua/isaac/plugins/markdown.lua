return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		ft = "markdown",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			latex = {
				enabled = true,
				render_modes = { "n", "i", "c", "t" },
				converter = { "utftex", "latex2text" },
				-- converter = {},
			},
		},
	},
	-- -- lazy.nvim
	-- {
	-- 	"folke/snacks.nvim",
	-- 	---@type snacks.Config
	-- 	opts = {
	-- 		image = {
	-- 			-- your image configuration comes here
	-- 			-- or leave it empty to use the default settings
	-- 			-- refer to the configuration section below
	-- 			force = true,
	-- 			convert = {
	-- 				notify = true,
	-- 			},
	-- 			img_dirs = {},
	-- 			math = {
	-- 				latex = {
	-- 					font_size = "small",
	-- 				},
	-- 			},
	-- 			resolve = function(path, src)
	-- 				local api = require("obsidian.api")
	-- 				if api.path_is_note(path) then
	-- 					return api.resolve_attachment_path(src)
	-- 				end
	-- 			end,
	-- 		},
	-- 	},
	-- },
	{
		"3rd/image.nvim",
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
		ft = { "markdown", "quarto" },
		config = function()
			require("image").setup({
				backend = "kitty", -- or "ueberzug" or "sixel"
				processor = "magick_cli", -- or "magick_rock"
				kitty_method = "normal",
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = true,
						only_render_image_at_cursor_mode = "popup", -- or "inline"
						floating_windows = false, -- if true, images will be rendered in floating markdown windows
						filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
					},
					neorg = {
						enabled = true,
						filetypes = { "norg" },
					},
					typst = {
						enabled = false,
						filetypes = { "typst" },
					},
					html = {
						enabled = false,
					},
					css = {
						enabled = false,
					},
				},
				max_width = nil,
				max_height = nil,
				max_width_window_percentage = nil,
				max_height_window_percentage = 50,
				scale_factor = 1.0,
				window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
				editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
				tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
			})
		end,
	},
}
