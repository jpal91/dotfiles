
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
  }
}
