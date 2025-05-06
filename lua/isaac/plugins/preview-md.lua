return {
    {
        "Isaac7777-cpu/markdown-preview.nvim",
        name = "markdown-preview.nvim", -- Optional name used internally
        cond = function()
            if vim.fn.executable("glow") ~= 1 then
                vim.notify("[markdown-preview.nvim] Skipped: glow not found in PATH", vim.log.levels.WARN)
                return false
            end
            return true
        end,
        config = function()
            require("markdown_preview") -- loads lua/markdown_preview/init.lua

            vim.keymap.set("n", "KF", "<cmd>DocumentationPreview<CR>",
                { desc = "Full Documentation Preview with Glow to see a nice layout of documentation." })
        end,
    },
}
