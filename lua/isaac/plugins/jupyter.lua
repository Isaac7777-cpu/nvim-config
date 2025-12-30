return {
	{
	-- WARNING: This plugin was very buggy last time I tried, had to swtich to jupynium to fix the issue

		"SUSTech-data/neopyter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter", -- neopyter don't depend on `nvim-treesitter`, but does depend on treesitter parser of python
			"AbaoFromCUG/websocket.nvim", -- for mode='direct'
		},

		---@type neopyter.Option
		opts = {
			mode = "direct",
			remote_address = "127.0.0.1:9001",
			file_pattern = { "*.ju.*" },
			textobject = {
				enable = true,
				queries = {
					"linemagic",
					"cellseparator",
					"cellcontent",
					"cell",
				},
			},
			on_attach = function(buf)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
				end
				map("n", "<localleader>sc", "<cmd>Neopyter execute notebook:run-cell<cr>", "run selected")
				map("n", "<space>X", "<cmd>Neopyter execute notebook:run-all-above<cr>", "run all above cell")
				map("n", "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", "restart kernel")
				map(
					"n",
					"<Enter>",
					"<cmd>Neopyter execute notebook:run-cell-and-select-next<cr>",
					"run selected and select next"
				)
				map(
					"n",
					"<M-Enter>",
					"<cmd>Neopyter execute notebook:run-cell-and-insert-below<cr>",
					"run selected and insert below"
				)
				map("n", "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", "restart kernel and run all")
			end,
		},
	},
	-- {
	-- 	"GCBallesteros/jupytext.nvim",
	-- 	lazy = false,
	-- 	opts = {
	-- 		-- default conversion style
	-- 		format = "py:percent", -- use the "percent" Python script style
	--
	-- 		-- per-language overrides
	-- 		custom_language_formatting = {
	-- 			python = {
	-- 				-- convert Python notebooks to .ju.py
	-- 				extension = "ju.py", -- use .ju.py extension
	-- 				style = "percent", -- match py:percent format
	-- 				force_ft = "python", -- ensure filetype is Python
	-- 			},
	-- 			r = {
	-- 				-- R notebooks still convert to Quarto markdown
	-- 				extension = "qmd",
	-- 				style = "quarto",
	-- 				force_ft = "quarto",
	-- 			},
	-- 		},
	--
	-- 		-- always keep .ipynb paired
	-- 		autosync = true, -- convert back on save and keep sync
	-- 	},
	-- },
	-- {
	-- 	"kiyoon/jupynium.nvim",
	-- 	build = "pip install .",
	-- 	dependencies = {
	-- 		"stevearc/dressing.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 	},
	-- 	config = function()
	-- 		require("jupynium").setup({
	-- 			-- python_host = vim.fn.exepath("python3"),
	-- 			python_host = vim.g.python3_host_prog,
	-- 			default_notebook_URL = "http://localhost:8888",
	-- 			auto_start_server = {
	-- 				enable = false, -- IMPORTANT (avoid double servers)
	-- 			},
	-- 			use_default_keybindings = true,
	-- 			jupyter_command = "jupyter",
	-- 		})
	-- 	end,
	-- },
}
