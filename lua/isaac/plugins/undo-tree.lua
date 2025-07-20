return {
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)

      -- Persistent Undo History
      local undodir = "/tmp/.vim-undo-dir"

      -- Create undo directory if it doesn't exist
      local stat = vim.loop.fs_stat(undodir)
      if not stat then
        local ok, err = vim.loop.fs_mkdir(undodir, 448) -- 0700 in decimal
        if not ok then
          vim.notify("Failed to create undo directory: " .. err, vim.log.levels.ERROR)
        end
      end

      -- Enable persistent undo
      vim.opt.undodir = undodir
      vim.opt.undofile = true
    end,
  },
}
