return {
	-- {
	-- 	"jpalardy/vim-slime",
	-- 	-- ft = { "python", "haskell", "quarto" },
	-- 	init = function()
	-- 		vim.g.slime_no_mappings = true
	-- 		vim.g.slime_target = "neovim"
	-- 		-- vim.g.slime_target = "tmux" -- Seems to be harder to setup
	-- 		-- Note that I only use this plugin if I want my session to
	-- 		-- persist even after I have closed my nvim session. Therefore,
	-- 		-- I will use tmux for such functions.
	-- 	end,
	-- 	config = function()
	-- 		vim.g.slime_input_pid = false
	-- 		vim.g.slime_suggest_default = true
	-- 		vim.g.slime_menu_config = false
	-- 		vim.g.slime_neovim_ignore_unlisted = false
	-- 		-- options not set here are g:slime_neovim_menu_order, g:slime_neovim_menu_delimiter, and g:slime_get_jobid
	-- 		-- see the documentation above to learn about those options
	--
	-- 		-- Set to use ipython
	-- 		-- vim.g.slime_python_ipython = true
	-- 		vim.g.slime_bracketed_paste = true
	--
	-- 		-- I don't really like this because it really just opens another terminal and does not work really well over tmux
	-- 		-- At least my Tmux
	-- 		-- called MotionSend but works with textobjects as well
	-- 		vim.keymap.set("n", "<leader>pp", "<Plug>SlimeLineSendj", { remap = true, silent = false, buffer = true })
	-- 		vim.keymap.set("x", "<c-c><c-c>", "<Plug>SlimeRegionSendj", { remap = true, silent = false, buffer = true })
	-- 		-- I personally don't want too many shortcuts
	-- 		-- vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
	-- 		-- vim.keymap.set("n", "gzc", "<Plug>SlimeConfig", { remap = true, silent = false })
	-- 	end,
	-- },
	{
		"R-nvim/R.nvim",
		-- Only required if you also set defaults.lazy = true
		-- lazy = false,
		ft = { "R", "rmd" },
		-- R.nvim is still young and we may make some breaking changes from time
		-- to time (but also bug fixes all the time). If configuration stability
		-- is a high priority for you, pin to the latest minor version, but unpin
		-- it and try the latest version before reporting an issue:
		-- version = "~0.1.0"
		config = function()
			-- Create a table with the options to be passed to setup()
			---@type RConfigUserOpts
			local opts = {
				hook = {
					on_filetype = function()
						vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
						vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
					end,
				},
				R_args = { "--quiet", "--no-save" },
				min_editor_width = 72,
				rconsole_width = 78,
				objbr_mappings = { -- Object browser keymap
					c = "class", -- Call R functions
					["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
					v = function()
						-- Run lua functions
						require("r.browser").toggle_view()
					end,
				},
				disable_cmds = {
					-- "RClearConsole",
					"RCustomStart",
					-- "RSPlot",
					-- "RSaveClose",
				},
			}
			-- Check if the environment variable "R_AUTO_START" exists.
			-- If using fish shell, you could put in your config.fish:
			-- alias r "R_AUTO_START=true nvim"
			if vim.env.R_AUTO_START == "true" then
				opts.auto_start = "on startup"
				opts.objbr_auto_start = true
			end
			require("r").setup(opts)
		end,
	},
	{
		"Vigemus/iron.nvim",
		ft = { "python", "haskell", "quarto", "sh", "lua" },
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")

			iron.setup({
				config = {
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					-- Your repl definitions come here
					repl_definition = {
						sh = {
							-- Can be a table or a function that
							-- returns a table (see below)
							command = { "zsh" },
						},
						python = {
							-- command = { "python3" }, -- or { "ipython", "--no-autoindent" }
							command = { "ipython", "--no-autoindent" },
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
						},
						-- haskell = {
						-- 	command = function(meta)
						-- 		local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
						-- 		return { "cabal", "v2-repl", filename }
						-- 	end,
						-- },
					},
					-- set the file type of the newly created repl to ft
					-- bufnr is the buffer id of the REPL and ft is the filetype of the
					-- language being used for the REPL.
					repl_filetype = function(bufnr, ft)
						return ft
						-- or return a string name such as the following
						-- return "iron"
					end,
					-- Send selections to the DAP repl if an nvim-dap session is running.
					-- dap_integration = true,

					repl_open_cmd = view.split(function()
						local ui = vim.api.nvim_list_uis()[1]
						-- Fallback if UI info is missing
						local cols = (ui and ui.width) or vim.o.columns
						local rows = (ui and ui.height) or vim.o.lines
						-- Approximate physical width/height:
						-- physical_width  ~ cols * (cell_width)
						-- physical_height ~ rows * (cell_height)
						-- Let cell_height = 1, cell_width = CELL_WH_RATIO.
						local approx_phys_width = cols * 0.56
						local approx_phys_height = rows * 1.0
						if approx_phys_width > approx_phys_height then
							-- Prefer a right vsplit (~33% of total columns)
							local target = math.floor(cols * 0.33)
							return string.format("botright vsplit | vertical resize %d | terminal", target)
						else
							-- Prefer a bottom split (12 lines)
							return "botright 12split | terminal"
						end
					end),
				},
				-- Iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				keymaps = {
					toggle_repl = "<localleader>rr", -- toggles the repl open and closed.
					restart_repl = "<localleader>rR", -- calls `IronRestart` to restart the repl
					send_motion = "<localleader>sc",
					visual_send = "<localleader>sc",
					send_file = "<localleader>sf",
					send_line = "<localleader>sl",
					send_paragraph = "<localleader>sp",
					send_until_cursor = "<localleader>su",
					send_mark = "<localleader>sm",
					send_code_block = "<localleader>sb",
					send_code_block_and_move = "<localleader>sn",
					mark_motion = "<localleader>mc",
					mark_visual = "<localleader>mc",
					remove_mark = "<localleader>md",
					cr = "<localleader>s<cr>",
					interrupt = "<localleader>s<localleader>",
					exit = "<localleader>sq",
					clear = "<localleader>cl",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					-- italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- You can just use tmux navigation motion to move around
			-- -- iron also has a list of commands, see :h iron-commands for all available commands
			vim.keymap.set("n", "<Enter>", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},
}
