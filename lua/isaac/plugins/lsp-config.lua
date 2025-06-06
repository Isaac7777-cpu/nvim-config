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
					-- "dockerls",
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
					-- "texlab",
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

			-- Common capabilities for all servers
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				on_attach = function(_, bufnr)
					local opts = { buffer = bufnr, noremap = true, silent = true }
					vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
				end,
			})

			-- Example configuration for pyright
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

			-- Add other servers similarly
			vim.lsp.config("lua_ls", {})
			vim.lsp.config("tsserver", {})
			vim.lsp.config("tailwindcss", {})
			vim.lsp.config("clangd", {})
			vim.lsp.config("cmake", {})
			vim.lsp.config("dockerls", {})
			vim.lsp.config("jdtls", {})
			vim.lsp.config("hls", {})
			vim.lsp.config("html", {})
			vim.lsp.config("marksman", {
				filetypes = { "markdown", "quarto" },
				root_dir = vim.fs.root(0, { ".git", ".marksman.toml", "_quarto.yml" }),
			})
			vim.lsp.config("omnisharp", {})
			vim.lsp.config("csharp_ls", {})
			vim.lsp.config("r_language_server", {})
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
			vim.lsp.config("sqls", {})

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
			})
		end,

		-- Deprecated config as per nvim 0.11 update
		-- config = function()
		-- 	local lspconfig = require("lspconfig")
		-- 	local util = require("lspconfig.util")
		--
		-- 	-- Set up lspconfig.
		-- 	local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- 	-- lsp flags
		-- 	local lsp_flags = {
		-- 		allow_incremental_sync = true,
		-- 		debounce_text_changes = 150,
		-- 	}
		--
		-- 	lspconfig.lua_ls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.ts_ls.setup({
		-- 		capabilities = capabilities,
		-- 	})
		--
		-- 	lspconfig.tailwindcss.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	-- See https://github.com/neovim/neovim/issues/23291
		-- 	-- disable lsp watcher.
		-- 	-- Too lags on linux for python projects
		-- 	-- because pyright and nvim both create too many watchers otherwise
		-- 	if capabilities.workspace == nil then
		-- 		capabilities.workspace = {}
		-- 		capabilities.workspace.didChangeWatchedFiles = {}
		-- 	end
		-- 	capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
		--
		-- 	vim.lsp.config('pyright',{
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 		cmd = { "pyright-langserver", "--stdio" },
		-- 		settings = {
		-- 			python = {
		-- 				pythonPath = vim.g.python3_host_prog,
		-- 				analysis = {
		-- 					autoSearchPaths = true,
		-- 					useLibraryCodeForTypes = true,
		-- 					diagnosticMode = "workspace",
		-- 				},
		-- 			},
		-- 		},
		-- 		root_dir = function(fname)
		-- 			return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(
		-- 				fname
		-- 			) or util.path.dirname(fname)
		-- 		end,
		-- 	})
		--
		-- 	lspconfig.clangd.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.cmake.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.dockerls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.jdtls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.hls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.html.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.marksman.setup({
		-- 		capabilities = capabilities,
		-- 		filetypes = { "markdown", "quarto" },
		-- 		root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
		-- 	})
		--
		-- 	lspconfig.omnisharp.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.csharp_ls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.r_language_server.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	lspconfig.yamlls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 		settings = {
		-- 			yaml = {
		-- 				schemaStore = {
		-- 					enable = true,
		-- 					url = "",
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	lspconfig.ltex_plus.setup({
		-- 		cmd = { "ltex-ls-plus" },
		-- 		filetypes = {
		-- 			"bib",
		-- 			"context",
		-- 			"gitcommit",
		-- 			"html",
		-- 			"markdown",
		-- 			"org",
		-- 			"pandoc",
		-- 			"plaintex",
		-- 			"quarto",
		-- 			"mail",
		-- 			"mdx",
		-- 			"rmd",
		-- 			"rnoweb",
		-- 			"rst",
		-- 			"tex",
		-- 			"text",
		-- 			"typst",
		-- 			"xhtml",
		-- 		},
		-- 		settings = {
		-- 			ltex = {
		-- 				checkFrequency = "save",
		-- 				language = "en-GB",
		-- 				additionalRules = {
		-- 					languageModel = "~/ltex-models/ngrams",
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	lspconfig.harper_ls.setup({
		-- 		capabilities = capabilities,
		-- 		filetypes = {
		-- 			"c",
		-- 			"cpp",
		-- 			"cs",
		-- 			"gitcommit",
		-- 			"go",
		-- 			"html",
		-- 			"java",
		-- 			"javascript",
		-- 			"lua",
		-- 			"markdown",
		-- 			"nix",
		-- 			"python",
		-- 			"ruby",
		-- 			"rust",
		-- 			"swift",
		-- 			"toml",
		-- 			"typescript",
		-- 			"typescriptreact",
		-- 			"haskell",
		-- 			"cmake",
		-- 			"typst",
		-- 			"php",
		-- 			"dart",
		-- 		},
		-- 		settings = {
		-- 			["harper-ls"] = {
		-- 				markdown = {
		-- 					ignore_link_title = true,
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	lspconfig.sqls.setup({
		-- 		capabilities = capabilities,
		-- 		flags = lsp_flags,
		-- 	})
		--
		-- 	-- Deprecated: Use Lspsaga instead
		-- 	-- vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
		-- 	-- vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
		-- 	-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
		-- 	-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		-- end,
		-- servers = {
		-- 	ltex = {
		-- 		autostart = false,
		-- 		filetypes = {},
		-- 		settings = {
		-- 			ltex = {
		-- 				checkFrequency = "save",
		-- 				language = "en-US",
		-- 				additionalRules = {
		-- 					languageModel = "~/.local/share/ngrams/",
		-- 					-- enablePickyRules = true,
		-- 					-- motherTongue = "de",
		-- 				},
		-- 				disabledRules = {
		-- 					["en"] = { "MORFOLOGIK_RULE_EN" },
		-- 					["en-GB"] = { "MORFOLOGIK_RULE_EN_GB" },
		-- 					["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
		-- 					["de"] = { "MORFOLOGIK_RULE_DE_DE" },
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- },
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
			require("lspsaga").setup({})

			definition = {
				edit = "<CR>", -- default jump behavior
			}
			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Lspsaga Hover Documentation" })
			vim.keymap.set(
				"n",
				"<leader>gD",
				"<cmd>lua vim.lsp.buf.declaration()<CR>",
				{ desc = "LSP Go to Declaration" }
			)
			vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Lspsaga Go to Definition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Lspsaga Code Action" })
			vim.keymap.set("n", "<leader>gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
