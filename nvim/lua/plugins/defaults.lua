
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "max397574/better-escape.nvim",
    config = function()
        require("better_escape").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                ".git",
                },
            },
        },
    }
  }
}
