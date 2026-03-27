-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup
--
-- local general = augroup("General", { clear = true })
--
-- autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
--   callback = function()
--     if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
--       vim.cmd("silent! w")
--     end
--   end,
--   group = general,
--   desc = "Auto Save",
-- })
--
--- some

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

autocmd("TermOpen", {
  callback = set_terminal_keymaps,
})
