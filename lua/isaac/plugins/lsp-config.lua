return {
	{

		-- for lsp features in code cells / embedded code
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
				filetypes = { "markdown", "quarto" },
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

			lspconfig.ltex.setup({
				filetypes = { "quarto" },
				settings = {
					ltex = {
						checkFrequency = "save",
						language = "en",
						additionalRules = {
							languageModel = "~/ltex-models/ngrams",
						},
					},
				},
			})

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

			lspconfig.sqls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
		servers = {
			ltex = {
				autostart = false,
				filetypes = {},
				settings = {
					ltex = {
						checkFrequency = "save",
						language = "en-US",
						additionalRules = {
							languageModel = "~/.local/share/ngrams/",
							-- enablePickyRules = true,
							-- motherTongue = "de",
						},
						disabledRules = {
							["en"] = { "MORFOLOGIK_RULE_EN" },
							["en-GB"] = { "MORFOLOGIK_RULE_EN_GB" },
							["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
							["de"] = { "MORFOLOGIK_RULE_DE_DE" },
						},
					},
				},
			},
		},
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
}
