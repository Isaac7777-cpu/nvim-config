vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set nowrap")
vim.cmd(":filetype on")
vim.cmd("set nohlsearch")

-- vim.o.hlsearch = false

vim.opt.scrolloff = 5

vim.g.mapleader = " "

vim.cmd("set guicursor=n-v-c:block")
vim.cmd("set guicursor=i:block-blinkwait1000-blinkon300-blinkoff300")

vim.opt.signcolumn = "yes:1"

vim.opt.foldenable = false

-- hide the ~ at end of buffer
vim.opt.fillchars:append({ eob = " " })
