return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- use latest release, remove to use latest commit
		ft = "markdown",
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			legacy_commands = true, -- this will be removed in the next major release
			ui = { enable = false },
			workspaces = {
				{
					name = "dynamic_workspace",
					-- The 'path' field is a function that returns the vault path dynamically.
					-- This example returns the current working directory as the vault path.
					path = function()
						-- You might want to add more sophisticated logic here
						-- to find a specific vault root or handle different scenarios.
						return vim.fn.getcwd()
					end,
				},
				-- {
				-- 	name = "personal",
				-- 	path = "~/vaults/personal",
				-- },
				-- {
				-- 	name = "work",
				-- 	path = "~/vaults/work",
				-- },
			},
		},
	},
}
