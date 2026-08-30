local M = {}

local focused_panes = {}
local diagnostic_symbols = {
	[vim.diagnostic.severity.ERROR] = "",
	[vim.diagnostic.severity.WARN] = "",
	[vim.diagnostic.severity.INFO] = "󰋽",
	[vim.diagnostic.severity.HINT] = "󰌶",
}
local diagnostic_highlights = {
	[vim.diagnostic.severity.ERROR] = "PaneFocusDiagnosticError",
	[vim.diagnostic.severity.WARN] = "PaneFocusDiagnosticWarn",
	[vim.diagnostic.severity.INFO] = "PaneFocusDiagnosticInfo",
	[vim.diagnostic.severity.HINT] = "PaneFocusDiagnosticHint",
}

vim.api.nvim_set_hl(0, "PaneFocusLabel", { bg = "NONE" })
vim.api.nvim_set_hl(0, "PaneFocusDiagnosticError", { fg = "#f7768e", bg = "NONE" })
vim.api.nvim_set_hl(0, "PaneFocusDiagnosticWarn", { fg = "#e0af68", bg = "NONE" })
vim.api.nvim_set_hl(0, "PaneFocusDiagnosticInfo", { fg = "#9ece6a", bg = "NONE" })
vim.api.nvim_set_hl(0, "PaneFocusDiagnosticHint", { fg = "#9ece6a", bg = "NONE" })

local function buffer_name(bufnr)
	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
	return name ~= "" and name or "[No Name]"
end

local function diagnostic_footer(bufnr)
	local counts = vim.diagnostic.count(bufnr)
	local footer = {}

	for _, severity in ipairs({
		vim.diagnostic.severity.ERROR,
		vim.diagnostic.severity.WARN,
		vim.diagnostic.severity.INFO,
		vim.diagnostic.severity.HINT,
	}) do
		local count = counts[severity] or 0
		if count > 0 then
			table.insert(footer, {
				string.format("%s %d ", diagnostic_symbols[severity], count),
				diagnostic_highlights[severity],
			})
		end
	end

	return #footer > 0 and footer or { { "No diagnostics", "PaneFocusLabel" } }
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		for _, focus in pairs(focused_panes) do
			if focus.buffer == args.buf and vim.api.nvim_win_is_valid(focus.window) then
				vim.api.nvim_win_set_config(focus.window, { footer = diagnostic_footer(args.buf) })
			end
		end
	end,
})

function M.toggle_popup()
	local tab = vim.api.nvim_get_current_tabpage()
	local focus = focused_panes[tab]

	if focus and vim.api.nvim_win_is_valid(focus.window) then
		local view = vim.api.nvim_win_call(focus.window, vim.fn.winsaveview)
		focused_panes[tab] = nil
		vim.api.nvim_win_close(focus.window, true)

		if vim.api.nvim_win_is_valid(focus.source) then
			vim.api.nvim_set_current_win(focus.source)
			vim.fn.winrestview(view)
		end
		return
	end

	local source = vim.api.nvim_get_current_win()
	local buffer = vim.api.nvim_get_current_buf()
	local view = vim.fn.winsaveview()
	local width = math.max(1, math.floor((vim.o.columns - 2) * 0.95))
	local height = math.max(1, math.floor((vim.o.lines - 2) * 0.95))
	local focus_window = vim.api.nvim_open_win(buffer, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
		row = math.max(0, math.floor((vim.o.lines - height - 2) / 2)),
		style = "minimal",
		border = "rounded",
		title = { { " " .. buffer_name(buffer) .. " ", "PaneFocusLabel" } },
		title_pos = "left",
		footer = diagnostic_footer(buffer),
		footer_pos = "right",
		zindex = 50,
	})

	focused_panes[tab] = { window = focus_window, source = source, buffer = buffer }
	vim.fn.winrestview(view)
end

function M.toggle_tab()
	local source_tab = vim.t.pane_focus_source_tab

	if source_tab and vim.api.nvim_tabpage_is_valid(source_tab) then
		vim.cmd("tabclose")
		vim.api.nvim_set_current_tabpage(source_tab)
		return
	end

	source_tab = vim.api.nvim_get_current_tabpage()
	vim.cmd("tab split")
	vim.t.pane_focus_source_tab = source_tab
end

return M
