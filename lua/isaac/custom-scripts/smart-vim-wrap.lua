M = {}

-- session-persistent flag
vim.g.wrapenabled = vim.g.wrapenabled or 0

local function on()
	vim.wo.wrap = true
	vim.wo.linebreak = true
	vim.wo.breakindent = true
	vim.wo.showbreak = "| > "
	vim.wo.list = false
	vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
	vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
	vim.keymap.set("n", "0", "g0", { noremap = true, silent = true })
	vim.keymap.set("n", "^", "g^", { noremap = true, silent = true })
	vim.keymap.set("n", "$", "g$", { noremap = true, silent = true })
	vim.keymap.set("n", "A", "g$i", { noremap = true, silent = true })
end

local function off()
	vim.wo.wrap = false
	vim.wo.linebreak = false
	vim.wo.breakindent = false
	pcall(vim.keymap.del, "n", "j")
	pcall(vim.keymap.del, "n", "k")
	pcall(vim.keymap.del, "n", "0")
	pcall(vim.keymap.del, "n", "^")
	pcall(vim.keymap.del, "n", "$")
	pcall(vim.keymap.del, "n", "A")
end

function M.smart_wrap()
	if vim.g.wrapenabled == 1 then
		off()
		vim.g.wrapenabled = 0
	else
		on()
		vim.g.wrapenabled = 1
	end
end

return M
