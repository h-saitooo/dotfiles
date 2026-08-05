return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        -- catppuccin の更新で lualine テーマ名が flavour 別（catppuccin-mocha 等）になった
        theme = "catppuccin-mocha",
        -- statusline を画面下部に1本だけ表示（laststatus = 3 相当）。
        -- ウィンドウごとの statusline が消えるため、水平境界が fillchars の
        -- 罫線で描かれ pane の枠線が繋がる（options.lua の fillchars と対応）
        globalstatus = true,
      },
    })
  end,
}