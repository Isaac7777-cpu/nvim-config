local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local Path = require("plenary.path")

local function oldfiles_in_cwd()
	local cwd = vim.loop.cwd()
	local filtered = {}

	for _, file in ipairs(vim.v.oldfiles) do
		if vim.loop.fs_stat(file) then
			local rel_path = require("plenary.path"):new(file):make_relative(cwd)
			if not rel_path:match("^/") then
				table.insert(filtered, file)
			end
		end
	end

	require("telescope.pickers")
		.new({
			prompt_title = "Recent Files (cwd)",
			cwd = cwd, -- 👈 key fix for preview path!
		}, {
			finder = require("telescope.finders").new_table({
				results = filtered,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			previewer = require("telescope.config").values.file_previewer({ cwd = cwd }),
		})
		:find()
end

return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		vim.g.startuptime = vim.loop.hrtime()

		-- Set header
		dashboard.section.header.val = {
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠹⣿⡿⠿⠿⠛⠛⠛⠙⠙⠛⠛⠻⠿⠿⣿⡟⠁⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⣠⣿⣿⣿⣿⣿⠿⠛⠛⠛⢿⣿⣿⣿⣿⣿⡿⠛⠛⠛⠻⢿⣿⣿⣿⣿⣧⠀⢀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢠⣿⣿⣿⣿⠟⠁⠀⠀⠠⠀⢸⣿⣿⣿⣿⣿⡇⠀⠀⠄⠀⠀⠙⣿⣿⣿⣿⣇⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀⢠⡟⠉⠁⠀⠀⠈⠛⡂⠀⠀⠀⠀⠀⢸⣿⣿⠿⠛⠀⠈⠋⠉⠙⠿⢿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠟⠸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⣿⣧⣄⠀⠀⠀⢀⣴⣿⡆⠀⠀⠀⠀⢸⣿⠀⠀⠀⢰⡆⠀⣶⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣆⠀⠀⣀⣴⣿⡛⠿⡿⠃⢻⣿⠟⣿⣷⣄⠀⠀⣠⣿⡇⠀⠸⠂⠀⣀⣀⣀⠀⠺⠂⠀⢸⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠠⣾⣿⣿⣿⣷⠀⠀⠀⢸⣿⣿⣿⣿⡿]],
			[[⣤⣤⣤⣤⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤]],
			[[⣿⣿⣿⣿⣿⣿⣧⣤⣄⡀⠀⠀⠀⠀⠀⣠⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣷⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
		}
		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			-- dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("r", "  Recent Files", oldfiles_in_cwd),
			dashboard.button("g", "  Find Text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("c", "  Open Config (~/.config/nvim)", ":e ~/.config/nvim<CR>"),
			dashboard.button("L", "󰒲  Lazy Plugin Manager", ":Lazy<CR>"),
			dashboard.button("a", "  Mason", "<cmd>Mason<CR>"),
			dashboard.button("l", "  View Logs", "<cmd>MasonLog<CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}
		local function footer()
			-- Footer 部分（动态生成）
			local datetime = os.date("📅 %Y-%m-%d             ⏰ %H:%M:%S")

			-- 获取 Neovim 版本
			local version = vim.version()
			local nvim_version =
				string.format("🧪 Neovim	                   v%d.%d.%d", version.major, version.minor, version.patch)

			-- Lazy 插件统计
			local lazy_plugins = require("lazy").stats()
			local lazy_info = string.format("📦 Lazy Plugins        	          %d", lazy_plugins.count)

			-- Mason LSP 统计
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
			local handle = io.popen("ls -1 " .. mason_path .. " 2>/dev/null | wc -l")
			local lsp_count = handle and handle:read("*n") or 0
			if handle then
				handle:close()
			end
			local mason_info = string.format("🔧 Mason LSPs           	          %d", lsp_count)

			return {
				"",
				datetime,
				"",
				nvim_version,
				"",
				lazy_info,
				"",
				mason_info,
				"",
			}
		end

		-- Set footer
		dashboard.section.footer.val = footer()
		dashboard.section.footer.opts = {
			position = "center",
		}
		dashboard.section.footer.opts.hl = "Constant"
		require("alpha").setup(dashboard.config)
		alpha.setup(dashboard.opts)

		vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
	end,
}
