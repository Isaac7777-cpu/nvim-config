return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = "ivy",
					},
				},
				extensions = {
					fzf = {},
				},
				defaults = {
					mappings = {
						n = {
							["dd"] = require("telescope.actions").delete_buffer, -- Use dd
						},
						i = {
							["<C-d>"] = require("telescope.actions").delete_buffer, -- Use <C-d>
						},
					},
				},
			})
			local function rg_files(opts)
				local ignore = opts.ignore or {}

				local args = {
					"rg",
					"--files",
					"--hidden",
					"--no-ignore",
				}

				for _, dir in ipairs(ignore) do
					args[#args + 1] = "-g"
					args[#args + 1] = "!" .. dir
				end

				return args
			end
			require("telescope").load_extension("fzf")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader><leader>", function()
				require("telescope.builtin").find_files({
					find_command = rg_files({
						ignore = { ".git", "node_modules", "target", "dist", "build", "bin" },
					}),
					layout_config = { height = 0.3 },
				})
			end)
			vim.keymap.set("n", "<leader>fxa", function()
				builtin.diagnostics({ severity = { min = vim.diagnostic.severity.INFO } })
			end, { desc = "Show all diagnostic message." })
			vim.keymap.set("n", "<leader>fxw", function()
				builtin.diagnostics({ severity = { min = vim.diagnostic.severity.WARN } })
			end, { desc = "Show only WARN or above." })
			vim.keymap.set("n", "<leader>fxx", function()
				builtin.diagnostics({ severity = { min = vim.diagnostic.severity.ERROR } })
			end, { desc = "Show only ERROR." })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume searching" })
			require("isaac.plugins.telescope.multigrep").setup() -- This set the keymap
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"smartpde/telescope-recent-files",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("recent_files")
		end,
	},
}
