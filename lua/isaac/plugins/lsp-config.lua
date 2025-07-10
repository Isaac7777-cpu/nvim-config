return {
  {

    -- For lsp features in code cells / embedded code
    "jmbuhr/otter.nvim",
    dev = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    opts = {
      verbose = {
        no_code_found = false,
      },
    },
  },
  -- none-ls is a tool that can do automatic installation of the linting source, but also requires lsps
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      -- referenced from http://github.com/milanglacier/nvim/blob/db850bbe400766932c1290c11d1e17672c324cbb/lua/conf/lsp_tools.lua#L135
      local util = require("null-ls.utils")
      local helper = require("null-ls.helpers")

      local function root_pattern_wrapper(patterns)
        -- referenced from
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/diagnostics/flake8.lua
        return helper.cache.by_bufnr(function(params)
          return util.root_pattern(".git", unpack(patterns or {}))(params.bufname)
        end)
      end

      local function source_wrapper(args)
        local source = args[1]
        local patterns = args[2]
        args[1] = nil
        args[2] = nil
        args.cwd = args.cwd or root_pattern_wrapper(patterns)
        return source.with(args)
      end

      local sql_formatter_config_file = os.getenv("HOME") .. "/.config/sql_formatter/sql_formatter.json"

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript",
              "typescript",
              "css",
              "scss",
              "html",
              "json",
              "yaml",
              "markdown",
              "graphql",
              "md",
              "quarto",
              "txt",
            },
          }),
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.csharpier,
          null_ls.builtins.completion.spell,

          null_ls.builtins.diagnostics.pylint.with({
            diagnostic_config = { underline = false, virtual_text = false, signs = false },
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),

          -- referenced from http://github.com/milanglacier/nvim/blob/db850bbe400766932c1290c11d1e17672c324cbb/lua/conf/lsp_tools.lua#L135
          source_wrapper({
            null_ls.builtins.formatting.prettierd,
            { ".prettirrc", ".prettirrc.json", ".prettirrc.yaml" },
            filetypes = { "markdown.pandoc", "json", "markdown", "rmd", "yaml", "quarto" },
          }),
          source_wrapper({
            null_ls.builtins.formatting.sql_formatter,
            args = vim.fn.empty(vim.fn.glob(sql_formatter_config_file)) == 0
                and { "--config", sql_formatter_config_file }
                or nil,
            -- This expression = 0 means this file exists.
          }),
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,

    opts = {
      servers = {
        tailwindcss = {},
      },
    },
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
          "tailwindcss",
          "clangd",
          "cmake",
          "jdtls",
          "hls",
          "html",
          "marksman",
          "omnisharp",
          "csharp_ls",
          "r_language_server",
          "yamlls",
          "jsonls",
          "harper_ls",
          "ltex",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    config = function()
      -- This file only contains the list of lsp supported.
      --
      -- The definition of the required plugins are stated in lsp-config.lua
      --
      -- -- Migrate to Neovim 0.11+ using native `vim.lsp.config` and `vim.lsp.enable`
      vim.diagnostic.config({
        virtual_text = { current_line = true },
      })

      -- Common capabilities for all servers
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
        end,
      })

      -- Setup for Python
      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = vim.fs.root(0, { ".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt" }),
        settings = {
          python = {
            pythonPath = vim.g.python3_host_prog,
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })
      vim.lsp.config("pylint", {})

      -- Setup for Lua
      vim.lsp.config("lua_ls", {})

      -- Setup webdev things
      vim.lsp.config("ts_ls", {
        root_dir = vim.fs.root(".git", "tsconfig.json"),
      })
      vim.lsp.config("tailwindcss", {})
      vim.lsp.config("html", {})
      require("isaac.plugins.lsp.vue")


      -- Setup C and C++
      vim.lsp.config("clangd", {})
      vim.lsp.config("cmake", {})

      -- Setup Dockers
      vim.lsp.config("dockerls", {})

      -- Setup json server
      vim.lsp.config("jdtls", {})

      -- Setup for Haskell
      vim.lsp.config("hls", {})

      -- Setup for C#
      vim.lsp.config("omnisharp", {})

      -- Setup for R
      vim.lsp.config("r_language_server", {})

      -- Setup for YAML
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "",
            },
          },
        },
      })

      -- Text Editing Support
      vim.lsp.config("marksman", {
        filetypes = { "markdown", "quarto" },
        root_dir = vim.fs.root(0, { ".git", ".marksman.toml", "_quarto.yml" }),
      })
      vim.lsp.config("ltex", {
        autostart = false,
        settings = {
          ltex = {
            checkFrequency = "save",
            language = "en-US",
            additionalRules = {
              languageModel = "~/.local/share/ngrams/",
            },
            disabledRules = {
              ["en"] = { "MORFOLOGIK_RULE_EN" },
              ["en-GB"] = { "MORFOLOGIK_RULE_EN_GB" },
              ["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
              ["de"] = { "MORFOLOGIK_RULE_DE_DE" },
            },
          },
        },
      })
      vim.lsp.config("harper_ls", {
        filetypes = {
          "c",
          "cpp",
          "cs",
          "gitcommit",
          "go",
          "html",
          "java",
          "javascript",
          "lua",
          "markdown",
          "nix",
          "python",
          "ruby",
          "rust_analyzer",
          "taplo",
          "swift",
          "typescript",
          "typescriptreact",
          "haskell",
          "cmake",
          "typst",
          "php",
          "dart",
          "bashls",
        },
        settings = {
          ["harper-ls"] = {
            markdown = {
              ignore_link_title = true,
            },
          },
        },
      })

      -- Setup SQL Language Server
      vim.lsp.config("sqls", {
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
      })
      vim.lsp.config("sql-formatter", {})

      -- Setup for Rust
      vim.lsp.config("rust_analyzer", {})
      vim.lsp.config("taplo", {})

      -- Setup for shell script
      vim.lsp.config("bashls", {})

      -- Enable all configured servers
      vim.lsp.enable({
        "pyright",
        "lua_ls",
        "tsserver",
        "tailwindcss",
        "clangd",
        "cmake",
        "dockerls",
        "jdtls",
        "hls",
        "html",
        "marksman",
        "omnisharp",
        "csharp_ls",
        "r_language_server",
        "yamlls",
        "ltex",
        "harper_ls",
        "sqls",
        "rust_analyzer",
        "taplo",
        "intelephense",
        -- "sqls",
      })
    end,
  },
  {
    -- For lsp features in code cells / embedded code
    "jmbuhr/otter.nvim",
    dev = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    opts = {
      verbose = {
        no_code_found = false,
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- For default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          sign = false,
        },
        ui = {
          code_action = " ",
        },
      })

      definition = {
        edit = "<CR>", -- default jump behavior
      }
      vim.keymap.set("n", "gK", "<cmd>Lspsaga hover_doc<CR>", { desc = "Lspsaga Hover Documentation" })
      vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "LSP Go to Declaration" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Lspsaga Go to Definition" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Lspsaga Code Action" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
      vim.keymap.set("n", "grpn", "<cmd>Lspsaga project_replace<CR>", { desc = "Lspsaga Project Wise Rename" })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons",  -- optional
    },
  },
}
