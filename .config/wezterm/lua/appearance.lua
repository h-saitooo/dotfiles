-- -----------------------------------------------------------------------------
-- 外観 / フォント / ウィンドウ
-- -----------------------------------------------------------------------------
-- カラースキーム一覧: https://wezterm.org/colorschemes/index.html

local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  config.initial_cols = 120
  config.initial_rows = 40

  config.font = wezterm.font 'Monaspace Argon'
  config.font_size = 12
  config.line_height = 1.2

  config.color_scheme = 'TokyoNight (Gogh)'
  config.window_background_opacity = 1.0
end

return M
