return {
    -- none-ls is a tool that can do automatic installation of the linting source, but also requires lsps
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.isort,
                    -- null_ls.builtins.diagnostics.pylint.with({
                    --     pythonPath = vim.g.python3_host_prog,
                    -- }),
                    null_ls.builtins.completion.spell,
                },
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                    "clangd",
                    "cmake",
                    "dockerls",
                    "jdtls",
                    "hls",
                    "html",
                    "marksman"
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Set up lspconfig.
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                cmd = { "pyright-langserver", "--stdio" },
                settings = {
                    python = {
                        pythonPath = vim.g.python3_host_prog,
                    }
                }
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
            lspconfig.cmake.setup({
                capabilities = capabilities,
            })
            lspconfig.dockerls.setup({
                capabilities = capabilities,
            })
            lspconfig.jdtls.setup({
                capabilities = capabilities,
            })
            lspconfig.hls.setup({
                capabilities = capabilities,
            })
            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.marksman.setup({
                capabilities = capabilities,
            })

            vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
