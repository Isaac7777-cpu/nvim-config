local autocmd = vim.api.nvim_create_autocmd

-- Enable Line Numbers
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	callback = function()
		vim.wo.number = true -- Enable absolute line numbers
		vim.wo.relativenumber = false -- Enable relative line numbers
	end,
})

function leave_snippet()
    if
        ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
        require('luasnip').unlink_current()
    end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua leave_snippet()
]])
