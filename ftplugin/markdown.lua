vim.b.slime_cell_delimiter = "```"

-- require("isaac.custom-scripts.smart-vim-wrap").smart_wrap()

-- ~/.config/nvim/ftplugin/markdown.lua
if pcall(require, "quarto") then
	print("Activating quarto (markdown)")
	vim.b.slime_cell_delimiter = "```"
	require("quarto").activate()
end
