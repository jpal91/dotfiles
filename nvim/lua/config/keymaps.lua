-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local help = vim.fn.stdpath("config") .. "/HELP.md"

map("n", "<leader>h", "<cmd>e " .. help .. "<cr>", { desc = "Open Help" })
map("n", "gd", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
map("n", "gD", "<cmd>BufferLinePickClose<cr>", { desc = "Close Pick Buffer" })
map("n", "<leader>to", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Open Terminal" })
map("n", "<leader>dd", "<cmd> lua vim.diagnostic.open_float() <cr>", { desc = "Open diagnostic message" })
