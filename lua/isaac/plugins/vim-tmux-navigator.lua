return {
    {
        "christoomey/vim-tmux-navigator",
        vim.keymap.set("n", "<c-k><c-h>", ":TmuxNavigateLeft<cr>"),
        vim.keymap.set("n", "<c-k><c-j>", ":TmuxNavigateDown<cr>"),
        vim.keymap.set("n", "<c-k><c-k>", ":TmuxNavigateUp<cr>"),
        vim.keymap.set("n", "<c-k><c-l>", ":TmuxNavigateRight<cr>"),
        vim.keymap.set("n", "<c-k><c-\\>", ":TmuxNavigatePrevious<cr>"),
    },
}
