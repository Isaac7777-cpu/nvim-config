local autocmd = vim.api.nvim_create_autocmd

-- Enable Line Numbers
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  callback = function()
    vim.wo.number = true       -- Enable absolute line numbers
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

-- Disable Line Number in Alpha
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

-- Layout Preserved `BufferDelete`
vim.api.nvim_create_user_command("BufferDelete", function()
  ---@diagnostic disable-next-line: missing-parameter
  local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
  local modified = vim.api.nvim_buf_get_option(0, "modified")

  if file_exists == 0 and modified then
    local user_choice = vim.fn.input("The file is not saved, whether to force delete? Press enter or input [y/n]:")
    if user_choice == "y" or string.len(user_choice) == 0 then
      vim.cmd("bd!")
    end
    return
  end

  local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"

  vim.cmd(force and "bd!" or string.format("bp | bd! %s", vim.api.nvim_get_current_buf()))
end, { desc = "Delete the current Buffer while maintaining the window layout" })

-- Terminal and Some Custom Terminal Using Commands Settings
require('isaac.custom-scripts.terminal')

-- Activate spelling when a any text like buffer is entered
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "tex", "quarto" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_au" }
  end,
})

