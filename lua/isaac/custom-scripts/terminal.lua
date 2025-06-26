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

-- Open terminal in bottom split
vim.keymap.set("n", "<space>st", function()
	vim.cmd("botright 12split | terminal")
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
