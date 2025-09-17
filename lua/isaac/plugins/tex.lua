return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			-- I recommend using tdf to view the pdf right in the terminal
			vim.g.vimtex_view_method = "skim" -- Disable PDF viewer
			-- vim.g.vimtex_view_general_viewer = ""
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_mode = 0
		end,
	},
}
