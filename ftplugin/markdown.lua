vim.b.slime_cell_delimiter = "```"

-- Set conceal level to 1 for obsidian to work
vim.o.conceallevel = 1

-- I don't really like to have quarto for Markdown file, so let's not do it.
-- require("isaac.custom-scripts.smart-vim-wrap").smart_wrap()
-- ~/.config/nvim/ftplugin/markdown.lua
-- if pcall(require, "quarto") then
-- 	print("Activating quarto (markdown)")
-- 	vim.b.slime_cell_delimiter = "```"
-- 	require("quarto").activate()
-- end

