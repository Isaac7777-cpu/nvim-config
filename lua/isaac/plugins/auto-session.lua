return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		-- Will use Telescope if installed or a vim.ui.select picker otherwise
		{ "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
		{ "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
		-- optional helpers
		{ "<leader>wI", "<cmd>AutoSessionSuppressAdd<CR>", desc = "Ignore cwd (denylist)" },
		{ "<leader>weI", "<cmd>AutoSessionSuppressEdit<CR>", desc = "Edit ignored dirs" },
		{ "<leader>wA", "<cmd>AutoSessionAllowAdd<CR>", desc = "Save cwd (allowlist)" },
		{ "<leader>weA", "<cmd>AutoSessionAllowEdit<CR>", desc = "Edit saved dirs" },
	},

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = function()
		-- The following are already the default values, no need to provide them if these are already the settings you want.
		local dirs = require("isaac.custom-scripts.auto-session-dirs")
		return {
			picker = nil, -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also manually choose one. Falls back to vim.ui.select
			mappings = {
				-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
				delete_session = { "i", "<C-d>" },
				alternate_session = { "i", "<C-s>" },
				copy_session = { "i", "<C-y>" },
			},
			-- Telescope only: If load_on_setup is false, make sure you use `:AutoSession search` to open the picker as it will initialize everything first
			load_on_setup = true,
			git_use_branch_name = true,
			git_auto_restore_on_branch_change = true,
			bypass_save_filetypes = { "alpha", "dashboard", "snacks_dashboard" }, -- or whatever dashboard you use
			-- Dynamically load allowed and suppressed dirs
			allowed_dirs = dirs.load_allowed(),
			suppressed_dirs = dirs.load_suppressed(),
		}
	end,
	config = function(_, opts)
		require("auto-session").setup(opts)
		require("isaac.custom-scripts.auto-session-dirs").setup()
	end,
}
