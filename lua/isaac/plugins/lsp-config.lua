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
				no_code_found = true,
			},
		},
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				-- 🔧 Formatter setup per filetype
				formatters_by_ft = {
					lua = { "stylua" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					javascript = { "prettier" },
					typescript = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					md = { "prettier" },
					quarto = { "prettier" },
					txt = { "prettier" },
					blade = { "blade-formatter" },
					php = { "blade-formatter" },
					sql = { "sql_formatter" },
					tex = { "tex-fmt", "latexindent", stop_after_first = true },
					rust = { "rustfmt", lsp_format = "fallback" },
					zig = { "zigfmt", lsp_format = "fallback" },
					sh = { "shfmt" },
					java = { "google-java-format", lsp_format = "fallback" },
					groovy = { "npm-groovy-lint" },
					r = { "air", lsp_format = "fallback" },
				},

				-- -- Optional: set formatter options (you can add more)
				-- formatters = {
				-- 	sql_formatter = {
				-- 		prepend_args = {
				-- 			"--config",
				-- 			vim.fn.expand("~/.config/sql_formatter/sql_formatter.json"),
				-- 		},
				-- 	},
				-- },
			})
			-- Customize the "injected" formatter
			require("conform").formatters.injected = {
				-- Set the options field
				options = {
					-- Set to true to ignore errors
					ignore_errors = false,
					-- Map of treesitter language to filetype
					lang_to_ft = {
						bash = "sh",
						zsh = "sh",
					},
					lang_to_formatters = {
						json = { "jq" },
						bash = "sh",
						javascript = "js",
						latex = "tex",
						markdown = "md",
						python = "py",
						rust = "rs",
						typescript = "ts",
						r = { "air", lsp_format = "fallback" },
					},
				},
			}

			require("conform").formatters["tex-fmt"] = {
				prepend_args = { "--nowrap" },
			}

			-- Format command
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
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
					-- Lua
					"lua_ls",
					-- Python
					-- "pyright",
					-- "pyrefly",
					-- -- I tend to want to have ruff and ty isntall just as a standalone tool using uv rather than Mason
					-- "ruff",
					-- "ty",
					-- R
					"r_language_server",
					"air",
					-- Rust
					"rust_analyzer",
					-- Shell Scripts
					"bashls",
					-- Web dev
					-- "ts_ls",
					"vtsls",
					"tailwindcss",
					"html",
					-- System
					-- "clangd", -- I think I should use the system clangd
					"cmake",
					-- Java
					"jdtls",
					-- Haskell
					"hls",
					-- C#
					"omnisharp",
					"csharp_ls",
					-- General Writing
					"marksman",
					"harper_ls",
					"ltex",
					-- Latex
					"texlab",
					-- Data File
					"yamlls",
					"jsonls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		config = function()
			vim.diagnostic.config({
				-- virtual_text = {
				-- 	severity = {
				-- 		min = "WARN",
				-- 	},
				-- },
				float = {
					border = {
						{ "╔", "FloatBorder" },
						{ "═", "FloatBorder" },
						{ "╗", "FloatBorder" },
						{ "║", "FloatBorder" },
						{ "╝", "FloatBorder" },
						{ "═", "FloatBorder" },
						{ "╚", "FloatBorder" },
						{ "║", "FloatBorder" },
					},
					source = "always",
					update_in_insert = true,
					severity_sort = true,
				},
				virtual_lines = {
					only_current_line = true,
					severity = {
						min = "ERROR",
					},
				},
				signs = true,
				underline = true,
				update_in_insert = true,
			})

			vim.keymap.set("n", "gK", function()
				local new_config = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({ virtual_lines = new_config })
			end, { desc = "Toggle diagnostic virtual_lines" })

			-- Setup for Python
			-- -- Wonderful things from Astral...
			-- -- In favour of that, I have deprecated the setting for pyrefly and pyright
			vim.lsp.config("ty", {})
			vim.lsp.config("ruff", {})
			vim.lsp.config("pyrefly", {
				init_options = {
					pythonPath = vim.g.python3_host_prog,
				},
			})
			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				root_dir = vim.fs.root(0, { ".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt" }),
				settings = {
					python = {
						checkFrequency = "save",
						pythonPath = vim.g.python3_host_prog,
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			})

			-- Setup for Lua
			vim.lsp.config("lua_ls", {})
			-- We will also setup the LazyDev package below for better Lua LSP
			-- when writing this config which uses lazy to install packages

			-- Setup webdev things
			-- INFO: The setup is already in the following file as it is quite complicated.
			--       Note that they are also enabled, nothing should be needed to configure in this script.
			require("isaac.plugins.lsp.vue")

			-- Setup for php
			vim.lsp.config("intelephense", {
				filetypes = { "php", "blade", "php_only" },
				settings = {
					intelephense = {
						filetypes = { "php", "blade", "php_only" },
						files = {
							associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
							maxSize = 5000000,
						},
					},
				},
			})
			vim.lsp.config("blade-formatter", {})

			-- Setup C and C++
			vim.lsp.config("clangd", {})
			vim.lsp.config("cmake", {})

			-- Setup Dockers
			vim.lsp.config("dockerls", {})

			-- Setup Java
			-- Configure jdtls
			vim.lsp.config("jdtls", {
				cmd = {
					vim.fn.expand("$HOME/.local/share/nvim/mason/bin/jdtls"),
					"--jvm-arg=-Djava.home=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
				},
				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
									default = true,
								},
								{
									name = "JavaSE-21",
									path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
								},
								{
									name = "JavaSE-11",
									path = "/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home",
								},
							},
						},
						signatureHelp = { enabled = true },
					},
				},
			})
			vim.lsp.config("google-java-format", {})

			-- Groovy (for gradle)
			vim.lsp.config("groovyls", {
				filetypes = { "groovy" },
			})
			vim.lsp.config("npm-groovy-lint", {})

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

			-- Setup for Latex
			vim.lsp.config("texlab", {
				filetype = { "tex" },
			})

			-- Text Editing Support
			vim.lsp.config("marksman", {
				filetypes = { "markdown", "quarto" },
				root_dir = vim.fs.root(0, { ".git", ".marksman.toml", "_quarto.yml" }),
			})

			-- General Writing
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
					"tex",
				},
				settings = {
					["harper-ls"] = {
						markdown = {
							ignore_link_title = true,
						},
						dialect = "Australian",
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

			-- Setup for Zig
			vim.lsp.config("zls", {})

			-- Setup for shell script
			vim.lsp.config("bashls", {
				filetypes = { "sh", "zsh", "bash" },
			})

			-- Enable all configured servers
			vim.lsp.enable({
				-- Python
				-- "pyright",
				"pyrefly",
				"ruff", -- For linting and static type checking
				-- "ty", -- For LSP functions
				-- Lua
				"lua_ls",
				-- Typescripts, tailwinds, webdev...
				-- "tsserver",
				"tailwindcss",
				"html",
				-- C & C++
				"clangd",
				"cmake",
				-- Docker
				"dockerls",
				-- Java (& Groovy)
				"jdtls",
				"groovyls",
				-- Haskle
				"hls",
				-- Markdown
				"marksman",
				-- Injection
				"omnisharp",
				-- C#
				"csharp_ls",
				-- R
				"r_language_server",
				-- Latex
				"texlab",
				-- SQLs
				"sqls",
				-- Rust
				"rust_analyzer",
				-- YAML
				"yamlls",
				-- TOML
				"taplo",
				-- PHP
				"intelephense",
				-- Shells
				"bashls",
				-- General Writing...
				"ltex",
				"harper_ls",
			})
		end,

		dependencies = {
			"ricardoramirezr/blade-nav.nvim",
			dependencies = {
				"hrsh7th/nvim-cmp",
			},
			ft = { "blade", "php" },
			opts = {
				-- This applies for `nvim-cmp`, for blink refer to the configuration of this plugin
				close_tag_on_complete = true,
			},

			config = function()
				-- local kind_icons = {
				-- 	BladeNav = " ",
				-- }
				--
				-- local cmp = require("cmp")
				--
				-- cmp.setup({
				-- 	formatting = {
				-- 		format = function(entry, item)
				-- 			if kind_icons[item.kind] then
				-- 				item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
				-- 			end
				--
				-- 			return item
				-- 		end,
				-- 	},
				-- })
			end,
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
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {},
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					sign = false,
				},
				finder = {
					methods = {
						["tyd"] = "textDocument/typeDefinition",
					},
					keys = {
						vsplit = "v",
						split = "x",
            toggle_or_open = '<CR>'
					},
				},
				ui = {
					code_action = " ",
				},
			})

			definition = {
				edit = "<CR>", -- default jump behavior
			}
			vim.keymap.set("n", "gK", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP: Lspsaga Hover Documentation" })
			vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "LSP: Lspsaga Go to Definition" })
			vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "LSP: Go to Declaration" })
			vim.keymap.set("n", "<leader>gt", "<cmd>Lspsaga finder tyd<CR>", { desc = "LSP: Find Type Definition " })
			vim.keymap.set("n", "<leader>gi", "<cmd>Lspsaga finder imp<CR>", { desc = "LSP: Find Implementation " })
			vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Lspsaga Code Action" })
			vim.keymap.set("n", "<leader>gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "LSP: Peek Definition" })
			vim.keymap.set("n", "<leader>gr", "<cmd>Lspsaga finder ref<CR>", { desc = "LSP: Find references" })
			vim.keymap.set("n", "grpn", "<cmd>Lspsaga project_replace<CR>", { desc = "Lspsaga Project Wise Rename" })

			-- The following is disabled because I am using Tree-sitter instead
			-- vim.keymap.set("n", "gsi", "<cmd>Lspsaga incoming_calls<CR>", { desc = "Lspsaga Show Incoming Call Stacks" })
			-- vim.keymap.set("n", "gso", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Lspsaga Show Outgoing Call Stacks" })
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		"mfussenegger/nvim-jdtls",
	},
}
