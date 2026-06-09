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

-- font_size は pt 指定だが、pt→px 変換に使う DPI の既定値が OS で異なる。
-- macOS は Retina スケーリングを OS 側で処理するため実質 72dpi 基準、
-- Linux/Windows は 96dpi 基準なので、同じ値でも後者が約 1.33 倍 (96/72) 大きく描画される。
-- 見た目を揃えるため OS ごとに pt を変える（macOS 16pt ≒ Linux 12pt）。
local FONT_SIZE = {
  macos   = 16,
  linux   = 12,
  windows = 12,
}

function M.apply(config)
  config.initial_cols = 120
  config.initial_rows = 40

  local fonts = { 'Monaspace Argon' }
  for _, f in ipairs(ICON_FONTS[platform.name] or {}) do
    table.insert(fonts, f)
  end
  config.font = wezterm.font_with_fallback(fonts)
  config.font_size = FONT_SIZE[platform.name] or 16
  config.line_height = 1.2
  -- Monaspace は字面が縦に詰まり気味で、ヒンティングによるグリフのグリッド
  -- スナップでセル上下が切れることがある。ヒンティングを無効化して回避する。
  -- なお上下の切れが残る場合は line_height を 1.3 程度まで上げると改善する。
  config.freetype_load_flags = 'NO_HINTING'

  config.color_scheme = 'TokyoNight (Gogh)'
  config.window_background_opacity = 1.0
end

return M
