-- -----------------------------------------------------------------------------
-- 外観 / フォント / ウィンドウ
-- -----------------------------------------------------------------------------
-- カラースキーム一覧: https://wezterm.org/colorschemes/index.html

local wezterm  = require 'wezterm'
local platform = require 'platform'

local M = {}

-- 本文フォントに無いコードポイント (アイコン・絵文字など) は
-- OS 標準のフォントにフォールバックして描画する。
local ICON_FONTS = {
  macos   = { 'Apple Color Emoji', 'Apple Symbols' },
  linux   = { 'Noto Color Emoji', 'Noto Sans Symbols 2' },
  windows = { 'Segoe UI Emoji', 'Segoe UI Symbol' },
}

function M.apply(config)
  config.initial_cols = 120
  config.initial_rows = 40

  local fonts = { 'Monaspace Argon' }
  for _, f in ipairs(ICON_FONTS[platform.name] or {}) do
    table.insert(fonts, f)
  end
  config.font = wezterm.font_with_fallback(fonts)
  config.font_size = 16
  config.line_height = 1.2

  config.color_scheme = 'TokyoNight (Gogh)'
  config.window_background_opacity = 1.0
end

return M
