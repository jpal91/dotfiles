-- init.lua
return {
  "lukas-reineke/headlines.nvim",
  opts = function()
    local opts = {}
    for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
      opts[ft] = {
        headline_highlights = {},
        -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
        bullets = {},
        fat_headlines = false,
        -- fat_headlines_lower_string = "▔",
        -- fat_headlines_upper_string = "▁",
      }
      for i = 1, 6 do
        local hl = "Headline" .. i
        vim.api.nvim_set_hl(0, hl, { link = "Headline", bold = true })
        table.insert(opts[ft].headline_highlights, hl)
      end
    end
    return opts
  end,
  ft = { "markdown", "norg", "rmd", "org" },
  config = function(_, opts)
    -- PERF: schedule to prevent headlines slowing down opening a file
    vim.schedule(function()
      require("headlines").setup(opts)
      require("headlines").refresh()
    end)
  end,
}
