-- Use Control of Leader + h/j/k/l to move between panes
vim.keymap.set({ 'n' }, '<leader>kh', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>kj', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>kk', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>kl', '<C-w>l', { noremap = true, silent = true })

-- terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- delete without pasting (sending to the blackhole register)
vim.keymap.set({ 'n', 'v' }, "'", '"_', { noremap = true, silent = true })

-- common keyboard shortcuts
vim.keymap.set({ 'n' }, "<leader>aa", "gg<S-V><S-G>", { noremap = true, silent = true })
vim.keymap.set({ 'i' }, "<S-CR>", "<C-o>o", { noremap = true, silent = true})

-- for quicker closing buffers
vim.keymap.set({ 'n' }, "<leader>bd", "<Cmd>bd<CR>", { noremap = true, silent = true})

local wrapenabled = 0

function ToggleWrap()
  vim.opt.wrap = true
  vim.opt.list = false

  if wrapenabled == 1 then
    vim.opt.linebreak = false
    vim.api.nvim_del_keymap("n", "j")
    vim.api.nvim_del_keymap("n", "k")
    vim.api.nvim_del_keymap("n", "0")
    vim.api.nvim_del_keymap("n", "^")
    vim.api.nvim_del_keymap("n", "$")
    vim.api.nvim_del_keymap("v", "j")
    vim.api.nvim_del_keymap("v", "k")
    vim.api.nvim_del_keymap("v", "0")
    vim.api.nvim_del_keymap("v", "^")
    vim.api.nvim_del_keymap("v", "$")
    wrapenabled = 0
  else
    vim.opt.linebreak = true
    vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "0", "g0", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "^", "g^", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "$", "g$", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "j", "gj", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "k", "gk", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "0", "g0", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "^", "g^", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "$", "g$", { noremap = true, silent = true })
    wrapenabled = 1
  end
end

-- Map <leader>w to toggle wrap
vim.api.nvim_set_keymap("n", "<leader>w", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })
