return {
	-- none-ls is a tool that can do automatic installation of the linting source, but also requires lsps
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

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
					"dockerls",
					"jdtls",
					"hls",
					"html",
					"marksman",
					"omnisharp",
					"csharp_ls",
					"r_language_server",
					"yamlls",
					"jsonls",
					"ltex",
					"harper_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")

			-- Set up lspconfig.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- lsp flags
			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			-- See https://github.com/neovim/neovim/issues/23291
			-- disable lsp watcher.
			-- Too lags on linux for python projects
			-- because pyright and nvim both create too many watchers otherwise
			if capabilities.workspace == nil then
				capabilities.workspace = {}
				capabilities.workspace.didChangeWatchedFiles = {}
			end
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

			lspconfig.pyright.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				cmd = { "pyright-langserver", "--stdio" },
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
				root_dir = function(fname)
					return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(
						fname
					) or util.path.dirname(fname)
				end,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.cmake.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.dockerls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.jdtls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.hls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.marksman.setup({
				capabilities = capabilities,
				filetypes = { "markdown" },
				root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
			})

			lspconfig.omnisharp.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.csharp_ls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.r_language_server.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					yaml = {
						schemaStore = {
							enable = true,
							url = "",
						},
					},
				},
			})

			-- lspconfig.ltex.setup({
			--   filetypes = { "quarto" },
			--   settings = {
			--     ltex = {
			--       language = "en",
			--       additionalRules = {
			--         languageModel = "~/ltex-models/ngrams",
			--       },
			--     },
			--   },
			-- })

			lspconfig.harper_ls.setup({
				capabilities = capabilities,
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
					"rust",
					"swift",
					"toml",
					"typescript",
					"typescriptreact",
					"haskell",
					"cmake",
					"typst",
					"php",
					"dart",
				},
				settings = {
					["harper-ls"] = {
						markdown = {
							ignore_link_title = true,
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
