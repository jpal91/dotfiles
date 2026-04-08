-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" then
      return
    end

    local maybe_dir = vim.fn.fnamemodify(arg, ":p")
    local stat = vim.loop.fs_stat(maybe_dir)

    if stat and stat.type == "directory" then
      require("neo-tree.command").execute({
        action = "show",
        reveal_file = maybe_dir,
        reveal_force_cwd = true,
      })
    else
      local path = vim.fn.fnamemodify(maybe_dir, ":h")
      require("neo-tree.command").execute({
         action = "show",
         reveal_file = path,
        reveal_force_cwd = true
      })
    end
  end,
})
