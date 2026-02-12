vim.opt.cursorline = true

local palette = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.overlay2, bold = true })
