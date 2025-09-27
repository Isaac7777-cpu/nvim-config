local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return "No LSP"
	end
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return table.concat(names, ", ")
end

local function word_count()
	if vim.bo.filetype ~= "markdown" and vim.bo.filetype ~= "text" and vim.bo.filetype ~= "tex" then
		return ""
	end
	local wc = vim.fn.wordcount()
	return wc.words .. " words"
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_palenight = require("lualine.themes.palenight")
		custom_palenight.normal.c.bg = "NONE"

		local rstt = {
			{ "-", "#aaaaaa" }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
			{ "S", "#757755" }, -- 2: nclientserver started, but not ready yet.
			{ "S", "#117711" }, -- 3: nclientserver is ready.
			{ "S", "#ff8833" }, -- 4: nclientserver started the TCP server
			{ "S", "#3388ff" }, -- 5: TCP server is ready
			{ "R", "#ff8833" }, -- 6: R started, but nvimcom was not loaded yet.
			{ "R", "#3388ff" }, -- 7: nvimcom is loaded.
		}

		local rstatus = function()
			if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
				-- No R file type (R, Quarto, Rmd, Rhelp) opened yet
				return ""
			end
			return rstt[vim.g.R_Nvim_status][1]
		end

		local rsttcolor = function()
			if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
				-- No R file type (R, Quarto, Rmd, Rhelp) opened yet
				return { fg = "#000000" }
			end
			return { fg = rstt[vim.g.R_Nvim_status][2] }
		end

		require("lualine").setup({
			options = {
				theme = custom_palenight,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_c = {
					"filename",
					"filesize",
					word_count,
				},
				lualine_x = {
					-- {
					-- 	require("noice").api.status.message.get_hl,
					-- 	cond = require("noice").api.status.message.has,
					-- },
					{
						lsp_clients,
					},
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						-- color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has,
						-- color = { fg = "#ff9e64" },
					},
					"filetype",
				},
				lualine_y = {
					"progress",
					{ rstatus, color = rsttcolor },
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"buffers",
						show_filename_only = true, -- Shows shortened relative path when set to false.
						hide_filename_extension = false, -- Hide filename extension when set to true.
						show_modified_status = true, -- Shows indicator when the buffer is modified.

						mode = 0, -- 0: Shows buffer name
						-- 1: Shows buffer index
						-- 2: Shows buffer name + buffer index
						-- 3: Shows buffer number
						-- 4: Shows buffer name + buffer number

						max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
						-- it can also be a function that returns
						-- the value of `max_length` dynamically.
						filetype_names = {
							TelescopePrompt = "Telescope",
							dashboard = "Dashboard",
							packer = "Packer",
							fzf = "FZF",
							alpha = "Alpha",
						}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

						-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
						use_mode_colors = false,

						symbols = {
							modified = " ●", -- Text to show when the buffer is modified
							alternate_file = "#", -- Text to show to identify the alternate file
							directory = "", -- Text to show when the buffer is a directory
						},
					},
				},
			},
		})
	end,
}
