local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.base46_cache = vim.fn.stdpath("config") .. "/lua/isaac/config/"

-- Check for active Conda environment, if found, use it
local conda_prefix = os.getenv("CONDA_PREFIX")
if conda_prefix then
  -- Set python3_host_prog dynamically based on the current Conda environment
  vim.g.python3_host_prog = conda_prefix .. "/bin/python3"
else
  -- Fallback to a default Python interpreter if no Conda environment is active
  vim.g.python3_host_prog = "/usr/bin/python3"
end

require("isaac.vim-options")
require("isaac.autocmds")
require("lazy").setup("isaac.plugins")
require("isaac.mappings")
