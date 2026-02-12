-- lua/utils/auto_session_dirs.lua
local M = {}

local uv = vim.uv or vim.loop

local function state_dir()
	local ok, p = pcall(vim.fn.stdpath, "state")
	if ok and type(p) == "string" then
		return p
	end
	return vim.fn.stdpath("data")
end

local function base_dir()
	return vim.fs.joinpath(state_dir(), "auto-session")
end

local function list_file(kind) -- "allowed" | "suppressed"
	return vim.fs.joinpath(base_dir(), kind .. "_dirs.txt")
end

local function ensure_parent(path)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
end

local function read_lines(path)
	if vim.fn.filereadable(path) == 0 then
		return {}
	end
	local lines = vim.fn.readfile(path)
	local out = {}
	for _, l in ipairs(lines) do
		l = vim.trim(l)
		if l ~= "" and not l:match("^#") then
			table.insert(out, l)
		end
	end
	return out
end

local function write_lines(path, lines)
	ensure_parent(path)
	vim.fn.writefile(lines, path)
end

local function uniq_sorted(lines)
	local seen, out = {}, {}
	for _, l in ipairs(lines) do
		if not seen[l] then
			seen[l] = true
			table.insert(out, l)
		end
	end
	table.sort(out)
	return out
end

local function normalize_dir(path)
	path = path or uv.cwd()
	path = vim.fn.expand(path)
	local rp = uv.fs_realpath(path)
	if rp then
		path = rp
	end
	path = vim.fs.normalize(path)

	-- If it's not a glob, store it as a directory prefix match (with trailing slash)
	if not path:match("[%*%?%[]") and not path:match("/$") then
		path = path .. "/"
	end

	return path
end

function M.load_allowed()
	return read_lines(list_file("allowed"))
end

function M.load_suppressed()
	return read_lines(list_file("suppressed"))
end

function M.add(kind, path)
	local f = list_file(kind)
	local lines = read_lines(f)
	local entry = normalize_dir(path)
	table.insert(lines, entry)
	lines = uniq_sorted(lines)
	write_lines(f, lines)
	return entry
end

function M.remove(kind, path)
	local f = list_file(kind)
	local entry = normalize_dir(path)
	local lines = read_lines(f)
	local out = {}
	for _, l in ipairs(lines) do
		if l ~= entry then
			table.insert(out, l)
		end
	end
	out = uniq_sorted(out)
	write_lines(f, out)
	return entry
end

function M.open(kind)
	vim.cmd.edit(list_file(kind))
end

-- Optional: dynamic decision helper (see config section below)
local function matches_glob(glob, path)
	glob = vim.fn.expand(glob)
	local re = vim.regex(vim.fn.glob2regpat(glob))
	return re and re:match_str(path) ~= nil
end

function M.cwd_is_managed()
	local cwd = normalize_dir(uv.cwd())
	local allowed = M.load_allowed()
	local suppressed = M.load_suppressed()

	local allowed_ok = true
	if #allowed > 0 then
		allowed_ok = false
		for _, g in ipairs(allowed) do
			if matches_glob(g, cwd) then
				allowed_ok = true
				break
			end
		end
	end

	if not allowed_ok then
		return false
	end

	for _, g in ipairs(suppressed) do
		if matches_glob(g, cwd) then
			return false
		end
	end

	return true
end

function M.allow(path)
	local entry = M.add("allowed", path)
	-- ensure it isn't also suppressed
	M.remove("suppressed", path)
	return entry
end

function M.suppress(path)
	local entry = M.add("suppressed", path)
	-- optional: ensure it isn't also allowed
	M.remove("allowed", path)
	return entry
end

function M.setup()
	local function cmd(name, fn, desc)
		vim.api.nvim_create_user_command(name, fn, { desc = desc })
	end

	cmd("AutoSessionAllowAdd", function()
		print("Added: " .. M.allow())
	end, "Add cwd to AutoSession allowlist")
	cmd("AutoSessionAllowRemove", function()
		print("Removed: " .. M.remove("allowed"))
	end, "Remove cwd from AutoSession allowlist")
	cmd("AutoSessionAllowEdit", function()
		M.open("allowed")
	end, "Edit AutoSession allowlist file")

	cmd("AutoSessionSuppressAdd", function()
		print("Added: " .. M.suppress())
	end, "Add cwd to AutoSession denylist")
	cmd("AutoSessionSuppressRemove", function()
		print("Removed: " .. M.remove("suppressed"))
	end, "Remove cwd from AutoSession denylist")
	cmd("AutoSessionSuppressEdit", function()
		M.open("suppressed")
	end, "Edit AutoSession denylist file")
end

return M
