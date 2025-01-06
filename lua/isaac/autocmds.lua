local autocmd = vim.api.nvim_create_autocmd

-- Enable Line Numbers
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	callback = function()
		-- vim.wo.number = true -- Enable absolute line numbers
		vim.wo.relativenumber = true -- Enable relative line numbers
	end,
})
