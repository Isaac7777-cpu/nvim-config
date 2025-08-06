return {
	{
		"ficcdaf/academic.nvim",
		-- recommended: rebuild on plugin update
		build = ":AcademicBuild",
		-- ONLY uncomment this if you want to change the defaults!
		-- you do NOT need to set opts for Academic to load!
		-- opts = {
		-- -- change settings here
		-- }
	},
	{
		"psliwka/vim-dirtytalk",
		build = ":DirtytalkUpdate",
		config = function()
			vim.opt.spelllang = { "en", "programming" }
		end,
	},
	{
		"ravibrock/spellwarn.nvim",
		-- event = "VeryLazy",
		config = function()
			require("spellwarn").setup({
				severity = { -- severity for each spelling error type (false to disable diagnostics for that type)
					spellbad = "WARN",
					spellcap = "WARN",
					spelllocal = "WARN",
					spellrare = "WARN",
				},
			})
		end,
	},
}
