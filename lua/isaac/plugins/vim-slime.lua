return {
	{
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_no_mappings = true
			vim.g.slime_target = "neovim"
		end,
		config = function()
			vim.g.slime_input_pid = false
			vim.g.slime_suggest_default = true
			vim.g.slime_menu_config = false
			vim.g.slime_neovim_ignore_unlisted = false
			-- options not set here are g:slime_neovim_menu_order, g:slime_neovim_menu_delimiter, and g:slime_get_jobid
			-- see the documentation above to learn about those options

			-- Set to use ipython
			-- vim.g.slime_python_ipython = true
			vim.g.slime_bracketed_paste = true

			-- called MotionSend but works with textobjects as well
			vim.keymap.set("n", "<Enter>", "<Plug>SlimeLineSendj", { remap = true, silent = false })
			vim.keymap.set("x", "<Enter>", "<Plug>SlimeRegionSendj", { remap = true, silent = false })
			-- I personally don't want too many shortcuts
			-- vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
			-- vim.keymap.set("n", "gzc", "<Plug>SlimeConfig", { remap = true, silent = false })
		end,
	},
}
