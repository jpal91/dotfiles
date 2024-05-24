-- bootstrap lazy.nvim, LazyVim and your plugins
-- if not vim.g.neovide then
--   require("config.lazy")
-- end
require("config.lazy")

-- local vim_config = vim.fn.stdpath("config") .. "/vim_conf/plugins.vim"
-- local source_cmd = "source " .. vim_config
-- vim.cmd(source_cmd)

-- neovide
vim.g.neovide_scale_factor = 0.7
vim.g.neovide_cursor_animation_length = 0
