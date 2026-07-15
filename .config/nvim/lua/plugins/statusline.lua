return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        -- catppuccin の更新で lualine テーマ名が flavour 別（catppuccin-mocha 等）になった
        theme = "catppuccin-mocha",
      },
    })
  end,
}