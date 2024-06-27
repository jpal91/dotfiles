-- bootstrap lazy.nvim, LazyVim and your plugins
-- if not vim.g.neovide then
--   require("config.lazy")
-- end
require("config.lazy")

local plug = vim.fn.stdpath("config") .. "/vim_conf/plug.vim"
vim.cmd.source(plug)

-- neovide
vim.g.neovide_scale_factor = 0.7
vim.g.neovide_cursor_animation_length = 0
