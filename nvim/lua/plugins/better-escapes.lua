return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      default_mappings = true,
      timeout = vim.o.timeoutlen,
    })
  end,
}
