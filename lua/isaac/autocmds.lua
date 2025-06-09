local autocmd = vim.api.nvim_create_autocmd

-- Enable Line Numbers
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	callback = function()
		vim.wo.number = true -- Enable absolute line numbers
		vim.wo.relativenumber = true -- Enable relative line numbers
	end,
})

function leave_snippet()
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
    autocmd ModeChanged * lua leave_snippet()
]])

local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })

vim.api.nvim_create_autocmd("BufDelete", {
	group = alpha_on_empty,
	callback = function()
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()
			local info = vim.fn.getbufinfo(buf)[1]

			local is_no_name = info.name == "" and info.listed == 1 and info.linecount <= 1
			if is_no_name then
				vim.cmd("Alpha")
			end
		end)
	end,
})
