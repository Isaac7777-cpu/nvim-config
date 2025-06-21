local autocmd = vim.api.nvim_create_autocmd

-- Enable Line Numbers
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	callback = function()
		vim.wo.number = true -- Enable absolute line numbers
		vim.wo.relativenumber = true -- Enable relative line numbers
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

-- Terminal Settings
autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

function CreateBottomTerminal()

	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)

	return vim.bo.channel
end

vim.keymap.set("n", "<space>st", function()
	-- vim.cmd.vnew()
	-- vim.cmd.term()
	-- vim.cmd.wincmd("J")
	-- vim.api.nvim_win_set_height(0, 12)
	--
	-- job_id = vim.bo.channel
  CreateBottomTerminal()
end)

vim.api.nvim_create_user_command("Test", function()
	local job_id = CreateBottomTerminal()
  local test_cmd = TestCmd()
	vim.fn.chansend(job_id, { test_cmd })
end, {desc = "Automatically Fetch the Test"})

function TestCmd()
	local test_cmd = ""

	if vim.fn.filereadable("package.json") == 1 then
		-- JavaScript/TypeScript (npm)
		test_cmd = "npm test"
	elseif vim.fn.filereadable("Cargo.toml") == 1 then
		-- Rust
		test_cmd = "cargo test"
	elseif vim.fn.filereadable("pyproject.toml") == 1 or vim.fn.filereadable("requirements.txt") == 1 then
		-- Python
		test_cmd = "pytest"
	elseif vim.fn.filereadable("go.mod") == 1 then
		-- Go
		test_cmd = "go test ./..."
	elseif vim.fn.filereadable("Gemfile") == 1 then
		-- Ruby
		test_cmd = "bundle exec rspec"
	elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
		-- Java/Kotlin (Gradle)
		test_cmd = "./gradlew test"
	elseif vim.fn.filereadable("mix.exs") == 1 then
		-- Elixir
		test_cmd = "mix test"
	elseif vim.fn.filereadable("Cargo.toml") == 1 then
		test_cmd = "cargo test"
	else
		test_cmd = "echo 'No test structure recognised'"
	end

	return test_cmd .. "\r\n"
end
