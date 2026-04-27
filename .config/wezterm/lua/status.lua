-- =============================================================================
-- 右ステータスバー: CPU / RAM / GPU / VRAM 表示
-- =============================================================================

local wezterm = require 'wezterm'
local stats   = require 'stats'

local M = {}

-- TokyoNight 配色
local COLOR = {
  fg     = '#c0caf5',
  dim    = '#565f89',
  cpu    = '#7aa2f7', -- blue
  ram    = '#9ece6a', -- green
  gpu    = '#bb9af7', -- purple
  vram   = '#7dcfff', -- cyan
}

local function seg(icon, label, label_color, value)
  return {
    { Foreground = { Color = label_color } }, { Text = icon .. ' ' .. label .. ' ' },
    { Foreground = { Color = COLOR.fg } },    { Text = value },
  }
end

local function sep()
  return {
    { Foreground = { Color = COLOR.dim } }, { Text = ' │ ' },
  }
end

local function flatten(segments)
  local out = {}
  for i, s in ipairs(segments) do
    if i > 1 then
      for _, item in ipairs(sep()) do table.insert(out, item) end
    end
    for _, item in ipairs(s) do table.insert(out, item) end
  end
  table.insert(out, 1, { Text = ' ' })
  table.insert(out,    { Text = ' ' })
  return out
end

function M.setup(config)
  wezterm.on('update-right-status', function(window, _pane)
    local cpu        = stats.cpu_pct()
    local rp, ru, rt = stats.ram_info()

    local segments = {
      seg('', 'CPU', COLOR.cpu, string.format('%3.0f%%', cpu)),
      seg('', 'RAM', COLOR.ram, string.format('%3.0f%% %.1f/%.0fG', rp, ru, rt)),
    }

    local g = stats.gpu_info()
    if g then
      table.insert(segments, seg('', 'GPU',  COLOR.gpu,  string.format('%3d%%',     g[1])))
      table.insert(segments, seg('', 'VRAM', COLOR.vram, string.format('%d/%dMB', g[2], g[3])))
    end

    window:set_right_status(wezterm.format(flatten(segments)))
  end)

  -- ステータス更新間隔（ms）。CPU 差分計算の精度にも影響する。
  config.status_update_interval = 1000
end

return M
