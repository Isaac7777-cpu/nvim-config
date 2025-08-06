return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			float = {
				transparent = true,
				solid = true,
			},
			transparent_background = true,
			auto_integrations = true,
			flavour = "mocha",
			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
