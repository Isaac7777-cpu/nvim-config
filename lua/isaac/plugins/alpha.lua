-- local telescope = require("telescope")
-- local pickers = require("telescope.pickers")
-- local finders = require("telescope.finders")
-- local conf = require("telescope.config").values
-- local Path = require("plenary.path")

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
			dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("r", "  Recent Files", oldfiles_in_cwd),
			dashboard.button("g", "  Find Text", "<cmd>Telescope live_grep<CR>"),
			-- dashboard.button("g", "  Find Text", require("isaac.plugins.telescope.multigrep").multigrep),
			dashboard.button("d", "  Edit Directory", ":e .<CR>"),
			dashboard.button("c", "  Open Config (~/.config/nvim)", ":e ~/.config/nvim<CR>"),
			dashboard.button("L", "󰒲  Lazy Plugin Manager", ":Lazy<CR>"),
			dashboard.button("a", "  Mason", "<cmd>Mason<CR>"),
			dashboard.button("l", "  View Logs", "<cmd>MasonLog<CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}
		local function footer()
			-- Footer section (dynamically generated)
			local datetime = os.date("📅 %Y-%m-%d\t\t⏰ %H:%M:%S")

			-- Get Neovim version
			local version = vim.version()
			-- local nvim_version = string.format("🧪 Neovim\t\tv%d.%d.%d", version.major, version.minor, version.patch)
			local nvim_version = string.format("🚧 Neovim\t\tv%d.%d.%d", version.major, version.minor, version.patch)

			-- Lazy plugin stats
			local lazy_plugins = require("lazy").stats()
			local lazy_info = string.format("📦 Lazy Plugins\t\t%d", lazy_plugins.count)

			-- Mason LSP stats
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
			local handle = io.popen("ls -1 " .. mason_path .. " 2>/dev/null | wc -l")
			local lsp_count = handle and handle:read("*n") or 0
			if handle then
				handle:close()
			end
			local mason_info = string.format("🔧 Mason LSPs\t\t%d", lsp_count)

			-- Combine all lines for alignment
			local footer_lines = {
				datetime,
				nvim_version,
				lazy_info,
				mason_info,
			}

			-- Collect lines and calculate column widths
			local footer_lines = { datetime, nvim_version, lazy_info, mason_info }
			local left_parts = {}
			local right_parts = {}
			local max_left_width = 0
			local max_right_width = 0

			-- Process each line to extract columns
			for _, line in ipairs(footer_lines) do
				local left, right = line:match("^(.-)\t\t(.*)$")
				if not left then -- Fallback for malformed lines
					left = line
					right = ""
				end

				local left_width = vim.fn.strdisplaywidth(left)
				local right_width = vim.fn.strdisplaywidth(right)

				table.insert(left_parts, left)
				table.insert(right_parts, right)

				if left_width > max_left_width then
					max_left_width = left_width
				end
				if right_width > max_right_width then
					max_right_width = right_width
				end
			end

			-- Generate aligned lines with right-aligned second column
      const_paddig = "                        "
			local aligned_lines = {}
			for i = 1, #footer_lines do
				local padding = string.rep(" ", max_left_width - vim.fn.strdisplaywidth(left_parts[i]))
				local left_padded = left_parts[i] .. padding .. const_paddig
				local right_padded = string.rep(" ", max_right_width - vim.fn.strdisplaywidth(right_parts[i])) .. right_parts[i]

				-- Use 4-space separator between columns
				table.insert(aligned_lines, left_padded .. right_padded)
			end

			-- Now use aligned_lines instead of the original footer lines

			return {
				"",
				aligned_lines[1],
				"",
				aligned_lines[2],
				"",
				aligned_lines[3],
				"",
				aligned_lines[4],
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
