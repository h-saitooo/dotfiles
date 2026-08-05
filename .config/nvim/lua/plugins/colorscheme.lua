return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      -- pane（ウィンドウ）の境界とアクティブ / 非アクティブの区別を強調する
      custom_highlights = function(colors)
        return {
          -- ウィンドウ境界線。デフォルトは背景に埋もれるほど暗いので明るい色にする
          -- （もっと主張させたいなら colors.blue、控えめにするなら colors.overlay0）
          WinSeparator = { fg = colors.overlay2 },
          -- 非アクティブな pane の背景を一段暗くして、アクティブな pane を浮かせる
          NormalNC = { bg = colors.mantle },
          -- floating window の枠も境界線と同じ色に揃える
          FloatBorder = { fg = colors.overlay2, bg = colors.base },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
