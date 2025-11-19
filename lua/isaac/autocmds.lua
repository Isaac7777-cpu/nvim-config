-- Enable Line Numbers
vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	callback = function(args)
		-- Check if the filetype is not "alpha"
		local ft = vim.api.nvim_buf_get_option(args.buf, "filetype")
		if ft ~= "alpha" then
			vim.wo.number = true
			vim.wo.relativenumber = true
		end
	end,
})

-- Function for stopping snippets
function LeaveSnippet()
	if
		((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
		and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
		and not require("luasnip").session.jump_active
	then
		require("luasnip").unlink_current()
	end
end

-- Stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua LeaveSnippet()
]])

-- Activate alpha on empty
local grp = vim.api.nvim_create_augroup("alpha_fallback", { clear = true })

-- Make Alpha unlisted (use the event arg 'ev', not a global 'args')
vim.api.nvim_create_autocmd("FileType", {
	group = grp,
	pattern = "alpha",
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
	end,
})

local function mru_hidden_buf()
	local infos = vim.fn.getbufinfo({ buflisted = 1 })
	local hidden = {}
	for _, i in ipairs(infos) do
		if #vim.fn.win_findbuf(i.bufnr) == 0 then
			table.insert(hidden, i)
		end
	end
	table.sort(hidden, function(a, b)
		return (a.lastused or 0) > (b.lastused or 0)
	end)
	return hidden[1] and hidden[1].bufnr or nil, infos
end

local function mru_hidden_buf()
	local infos = vim.fn.getbufinfo({ buflisted = 1 })
	local hidden = {}
	for _, i in ipairs(infos) do
		if #vim.fn.win_findbuf(i.bufnr) == 0 then
			table.insert(hidden, i)
		end
	end
	table.sort(hidden, function(a, b)
		return (a.lastused or 0) > (b.lastused or 0)
	end)
	return hidden[1] and hidden[1].bufnr or nil, infos
end

vim.api.nvim_create_autocmd("User", {
	group = grp,
	pattern = "BDeletePost *",
	callback = function()
		if vim.bo.filetype == "alpha" then
			return
		end

		-- treat a lone empty [No Name] as none
		local listed = vim.fn.getbufinfo({ buflisted = 1 })
		if #listed == 1 then
			local b = listed[1]
			if (b.name or "") == "" and vim.bo[b.bufnr].buftype == "" then
				vim.bo[b.bufnr].buflisted = false
				listed = {}
			end
		end

		-- prefer MRU hidden; otherwise show Alpha (don’t reuse visible buffers)
		local target = mru_hidden_buf()
		if target then
			vim.api.nvim_set_current_buf(target)
		elseif #listed == 0 or #vim.fn.win_findbuf(vim.api.nvim_get_current_buf()) > 1 then
			require("alpha").start(false)
		end
	end,
})

-- Disable Line Number in Alpha
vim.api.nvim_create_autocmd("FileType", {
	pattern = "alpha",
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

-- Layout Preserved `BufferDelete`
vim.api.nvim_create_user_command("BufferDelete", function()
	---@diagnostic disable-next-line: missing-parameter
	local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
	local modified = vim.api.nvim_buf_get_option(0, "modified")

	if file_exists == 0 and modified then
		local user_choice = vim.fn.input("The file is not saved, whether to force delete? Press enter or input [y/n]:")
		if user_choice == "y" or string.len(user_choice) == 0 then
			vim.cmd("bd!")
		end
		return
	end

	local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"

	vim.cmd(force and "bd!" or string.format("bp | bd! %s", vim.api.nvim_get_current_buf()))
end, { desc = "Delete the current Buffer while maintaining the window layout" })

-- Terminal and Some Custom Terminal Using Commands Settings
require("isaac.custom-scripts.terminal")

-- Activate spelling when a any text like buffer is entered
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "tex", "quarto" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_au" }
	end,
})

-- No spell signs
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.cmd([[
      highlight clear SpellBad
      " highlight clear SpellCap
      " highlight clear SpellRare
      " highlight clear SpellLocal
      highlight SpellCap gui=underline
      highlight SpellRare gui=underline
      highlight SpellLocal gui=underline
    ]])
	end,
})
