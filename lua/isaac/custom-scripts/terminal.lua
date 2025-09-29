local terminal_job_id = nil
local terminal_bufnr = nil

function TestCmd()
	local cwd = vim.loop.cwd()
	local markers = {
		"package.json", -- JavaScript/TypeScript
		"Cargo.toml", -- Rust
		"pyproject.toml", -- Python
		"requirements.txt", -- Python
		"go.mod", -- Go
		"Gemfile", -- Ruby
		"build.gradle", -- Java/Kotlin
		"build.gradle.kts", -- Kotlin
		"mix.exs", -- Elixir
		"Makefile", -- Generic
	}

	-- Find project root by checking parent directories
	local function find_root(path)
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			return nil
		end

		for _, marker in ipairs(markers) do
			if vim.fn.filereadable(parent .. "/" .. marker) == 1 then
				return parent
			end
		end

		return find_root(parent)
	end

	local project_root = find_root(vim.fn.expand("%:p")) or cwd
	local test_command = ""

	-- Determine test command based on project files
	if vim.fn.filereadable(project_root .. "/package.json") == 1 then
		test_command = "npm test"
	elseif vim.fn.filereadable(project_root .. "/Cargo.toml") == 1 then
		test_command = "ulimit -n 10000 && cargo test"
	elseif
		vim.fn.filereadable(project_root .. "/pyproject.toml") == 1
		or vim.fn.filereadable(project_root .. "/requirements.txt") == 1
	then
		test_command = "pytest"
	elseif vim.fn.filereadable(project_root .. "/go.mod") == 1 then
		test_command = "go test ./..."
	elseif vim.fn.filereadable(project_root .. "/Gemfile") == 1 then
		test_command = "bundle exec rspec"
	elseif
		vim.fn.filereadable(project_root .. "/build.gradle") == 1
		or vim.fn.filereadable(project_root .. "/build.gradle.kts") == 1
	then
		test_command = "./gradlew test"
	elseif vim.fn.filereadable(project_root .. "/mix.exs") == 1 then
		test_command = "mix test"
	else
		test_command = "echo 'No test structure recognized'"
	end

	-- Change to project root and run tests
	return 'cd "' .. project_root .. '" && ' .. test_command .. "\r"
end

-- Heuristic: character width/height ratio (tweak if your font looks wider/narrower)
-- e.g., 0.55 means one cell is 0.55 as wide as it is tall.
local CELL_WH_RATIO = vim.g.char_cell_wh_ratio or 0.56

-- Open terminal in bottom split
vim.keymap.set("n", "<leader>st", function()
	local ui = vim.api.nvim_list_uis()[1]
	-- Fallback if UI info is missing
	local cols = (ui and ui.width) or vim.o.columns
	local rows = (ui and ui.height) or vim.o.lines
	-- Approximate physical width/height:
	-- physical_width  ~ cols * (cell_width)
	-- physical_height ~ rows * (cell_height)
	-- Let cell_height = 1, cell_width = CELL_WH_RATIO.
	local approx_phys_width = cols * CELL_WH_RATIO
	local approx_phys_height = rows * 1.0

	local cmd
	if approx_phys_width > approx_phys_height then
		-- Prefer a right vsplit (~33% of total columns)
		local target = math.floor(cols * 0.33)
		cmd = string.format("botright vsplit | vertical resize %d | terminal", target)
	else
		-- Prefer a bottom split (12 lines)
		cmd = "botright 12split | terminal"
	end
	vim.cmd(cmd)

	terminal_bufnr = vim.api.nvim_get_current_buf()
	terminal_job_id = vim.b.terminal_job_id

	-- Automatically terminate job when buffer closes
	vim.api.nvim_buf_attach(terminal_bufnr, false, {
		on_detach = function()
			if terminal_job_id and vim.fn.jobwait({ terminal_job_id }, 0)[1] == -1 then
				vim.fn.jobstop(terminal_job_id)
			end
			terminal_job_id = nil
			terminal_bufnr = nil
		end,
	})
end, { desc = "Open terminal in bottom split" })

-- Close terminal and job safely
vim.api.nvim_create_user_command("CloseTerm", function()
	if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
		-- Send exit command first to gracefully terminate shell
		vim.fn.chansend(terminal_job_id, "exit\r")

		-- Wait briefly for process to exit, then force close
		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(terminal_bufnr) then
				vim.api.nvim_buf_delete(terminal_bufnr, { force = true })
			end
		end, 100)
	end
end, { desc = "Close terminal and terminate job" })

-- Enhanced test command
vim.api.nvim_create_user_command("Test", function()
	if not terminal_job_id or vim.fn.jobwait({ terminal_job_id }, 0)[1] ~= -1 then
		print("Creating new terminal...")
		vim.cmd("botright 12split | terminal")
		terminal_bufnr = vim.api.nvim_get_current_buf()
		terminal_job_id = vim.b.terminal_job_id
	end

	local test_cmd = TestCmd()
	vim.fn.chansend(terminal_job_id, test_cmd .. "\r")
end, { desc = "Run project-specific tests" })
