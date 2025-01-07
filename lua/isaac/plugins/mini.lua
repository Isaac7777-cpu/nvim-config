return {
    {
        -- Active indent guide and indent text objects. When you're browsing
        -- code, this highlights the current level of indentation, and animates
        -- the highlighting.
        {
            "echasnovski/mini.indentscope",
            version = false, -- wait till new 0.7.0 release to put it back on semver
            opts = {
                -- symbol = "▏",
                symbol = "│",
                options = { try_as_border = true },
            },
            init = function()
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = {
                        "Trouble",
                        "alpha",
                        "dashboard",
                        "fzf",
                        "help",
                        "lazy",
                        "mason",
                        "neo-tree",
                        "notify",
                        "snacks_dashboard",
                        "snacks_notif",
                        "snacks_terminal",
                        "snacks_win",
                        "toggleterm",
                        "trouble",
                    },
                    callback = function()
                        vim.b.miniindentscope_disable = true
                    end,
                })

                vim.api.nvim_create_autocmd("User", {
                    pattern = "SnacksDashboardOpened",
                    callback = function(data)
                        vim.b[data.buf].miniindentscope_disable = true
                    end,
                })
            end,
        },

        -- disable inent-blankline scope when mini-indentscope is enabled
        {
            "lukas-reineke/indent-blankline.nvim",
            optional = true,
            opts = {
                scope = { enabled = false },
            },
        },
    },
    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = true, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair
            -- and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        },
        config = function(_, opts)
            require("mini.pairs").setup()
        end,
    },
}
