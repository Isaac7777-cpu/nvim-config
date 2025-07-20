return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"saadparwaiz1/cmp_luasnip",
			"f3fora/cmp-spell",
			"ray-x/cmp-treesitter",
			"kdheepak/cmp-latex-symbols",
			"jmbuhr/cmp-pandoc-references",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			{
				"onsails/lspkind-nvim",
				config = function()
					require("lspkind").init({
						symbol_map = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
							BladeNav = "",
						},
					})
				end,
			},
			"jmbuhr/otter.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				preselect = "none",
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				mapping = {
					-- Disable for keeping the tmux navigator
					-- ["<C-k>"] = cmp.mapping.select_prev_item(),
					-- ["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-o>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),

					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = false,
					}),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif require("luasnip").expand_or_jumpable() then
							require("luasnip").expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif require("luasnip").jumpable(-1) then
							require("luasnip").jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				autocomplete = false,

				formatting = {
					format = function(entry, vim_item)
						vim_item.kind = lspkind.presets.default[vim_item.kind]
						if entry.source.name == "blade-nav" then
							vim_item.kind = " "
						end
						vim_item.menu = ({
							otter = "[🦦]",
							nvim_lsp = "[LSP]",
							nvim_lsp_signature_help = "[sig]",
							luasnip = "[snip]",
							buffer = "[buf]",
							path = "[path]",
							spell = "[spell]",
							pandoc_references = "[ref]",
							tags = "[tag]",
							treesitter = "[TS]",
							calc = "[calc]",
							latex_symbols = "[tex]",
							emoji = "[emoji]",
							render_markdown = "[md]",
							["blade-nav"] = "[blade]",
						})[entry.source.name]

						return vim_item
					end,

					-- This is the deprecated way with using lspkind.cmp_format
					-- which provides less customization possible.
					--
					-- ```lua
					-- format = lspkind.cmp_format({
					-- 	mode = "symbol_text",
					-- 	menu = {
					-- 		otter = "[🦦]",
					-- 		nvim_lsp = "[LSP]",
					-- 		nvim_lsp_signature_help = "[sig]",
					-- 		luasnip = "[snip]",
					-- 		buffer = "[buf]",
					-- 		path = "[path]",
					-- 		spell = "[spell]",
					-- 		pandoc_references = "[ref]",
					-- 		tags = "[tag]",
					-- 		treesitter = "[TS]",
					-- 		calc = "[calc]",
					-- 		latex_symbols = "[tex]",
					-- 		emoji = "[emoji]",
					-- 		render_markdown = "[MD]",
					-- 		BladeNav = "[Blade]",
					-- 	},
					-- }),
					-- ```
				},
				sources = {
					{ name = "otter" }, -- for code chunks in quarto
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "pandoc_references" },
					{ name = "buffer", keyword_length = 3, max_item_count = 10 },
					{ name = "spell" },
					{ name = "treesitter", keyword_length = 3, max_item_count = 10 },
					{ name = "calc" },
					{ name = "latex_symbols" },
					{ name = "emoji" },
					{ name = "render_markdown" },
					{ name = "BladeNav" },
				},
				view = {
					docs = {
						auto_open = true,
					},
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			-- for friendly snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			-- for custom snippets
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
			-- Link quarto and rmarkdown to markdown snippets
			luasnip.filetype_extend("quarto", { "markdown" })
			luasnip.filetype_extend("rmarkdown", { "markdown" })

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},
}
