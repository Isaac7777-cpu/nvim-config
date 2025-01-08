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

-- for quicker closing buffers
vim.keymap.set({ 'n' }, "<leader>bd", "<Cmd>bd<CR>", { noremap = true, silent = true})
