return {
    {
        -- I mainly use this plugin, which is written myself, to have a quick view of documentation from lsp.
        -- Therefore, it is only very basic and is not recommended for direct use with markdown.
        "Isaac7777-cpu/markdown-preview.nvim",
        cond = function()
            if vim.fn.executable("glow") ~= 1 then
                vim.notify("[markdown-preview.nvim] Skipped: glow not found in PATH", vim.log.levels.WARN)
                return false
            end
            return true
        end,
        config = function()
            require("markdown_preview") -- loads lua/markdown_preview/init.lua

            vim.keymap.set("n", "<leader>kK", "<cmd>DocumentationPreview<CR>",
                { desc = "Full Documentation Preview with Glow to see a nice layout of documentation." })
        end,
    },
}
