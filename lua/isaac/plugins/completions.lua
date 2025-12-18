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
		-- HACK: Remove this later when figure why the newer version has a weird icon in front
		commit = "a7bcf1d88069fc67c9ace8a62ba480b8fe879025",
		dependencies = {
			{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"octaltree/cmp-look",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"saadparwaiz1/cmp_luasnip",
			"f3fora/cmp-spell",
			"ray-x/cmp-treesitter",
			"kdheepak/cmp-latex-symbols",
			"jmbuhr/cmp-pandoc-references",
			"L3MON4D3/LuaSnip",
			"Isaac7777-cpu/friendly-snippets",
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
							Keyword = "",
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
							TypeParameter = "",
							BladeNav = "",
							["Magic"] = "󱡄",
							["Path"] = "",
							["Dict key"] = "󱏅",
							["Instance"] = "󱃻",
							["Statement"] = "󱇯",
							["Comment"] = "",
							String = "",
							Type = "",
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
			local compare = require("cmp.config.compare")
			local kind_mapper = require("cmp.types").lsp.CompletionItemKind

			local kind_score = {
				-- -- You can add these in so that these will come up on top of the list.
				-- -- But I like it better with not explictly having these on top.
				-- Variable = 1,
				-- Class = 2,
				-- Method = 3,
				-- Keyword = 4,
				Text = 200,
			}

			-- This comparator will explictly give the score to one defined above otherwise all equals at 100
			local kind_discriminative_comparator = function(entry1, entry2)
				local kind1 = kind_score[kind_mapper[entry1:get_kind()]] or 100
				local kind2 = kind_score[kind_mapper[entry2:get_kind()]] or 100

				return kind1 < kind2
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				preselect = "None",
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				mapping = {
					-- Disable for reserving the bindings for the tmux navigator
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),

					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = false,
					}),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						-- This causes unwanted behaviour for me which some of the snippets just expanded out of nowhere
						-- elseif require("luasnip").expand_or_jumpable() then
						-- 	require("luasnip").expand_or_jump()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				autocomplete = false,
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							otter = "[Otter]",
							nvim_lsp = "[LSP]",
							nvim_lsp_signature_help = "[Sig]",
							luasnip = "[snip]",
							buffer = "[buf]",
							look = "[Dict]",
							path = "[Path]",
							spell = "[Spell]",
							pandoc_references = "[Ref]",
							tags = "[Tag]",
							treesitter = "[TS]",
							calc = "[Calc]",
							latex_symbols = "[TeX]",
							emoji = "[Emoji]",
							render_markdown = "[MD]",
							["blade-nav"] = "[Blade]",
							lazydev = "[LazyDev]",
							cmp_r = "[CMP-R]",
							vimtex = "[VimTex]",
							neopyter = "[Neopyter]",
						},
					}),
				},
				sources = {
					{ name = "otter" }, -- for code chunks in quarto
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
					-- { name = "nvim_lsp", max_item_count = 40 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "pandoc_references" },
					{ name = "buffer", keyword_length = 3, max_item_count = 10 },
					{ name = "spell" },
					{ name = "treesitter", keyword_length = 3, max_item_count = 10 },
					{ name = "calc" },
					-- { name = "latex_symbols" },
					-- { name = "emoji" },
					{ name = "render_markdown" },
					{ name = "BladeNav" },
					{
						name = "look",
						keyword_length = 2,
						max_item_count = 10,
						optiion = {
							convert_case = true,
							loud = true,
						},
					},
					{ name = "lazydev", group_index = 0 },
					{ name = "cmp_r", priority = 900 },
					{
						name = "omni",
						option = {
							disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
						},
						priority = 1000,
					},
					{ name = "neopyter" },
				},
				sorting = {
					priority_weight = 1,
					comparators = {
						compare.exact,
						kind_discriminative_comparator,
						-- compare.recently_used,
						compare.length,
					},
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
			require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "latex" } })
			-- for custom vscode snippets
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
			-- for custom lua snippets
			require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/isaac/snippets" })

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
