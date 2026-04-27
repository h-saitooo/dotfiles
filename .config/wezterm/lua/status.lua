-- =============================================================================
-- 右ステータスバー: CPU / RAM / GPU / VRAM 表示
-- =============================================================================

local wezterm = require 'wezterm'
local stats   = require 'stats'

local M = {}

function M.setup(config)
  wezterm.on('update-right-status', function(window, _pane)
    local cpu        = stats.cpu_pct()
    local rp, ru, rt = stats.ram_info()

    local parts = {
      string.format('CPU %3.0f%%',            cpu),
      string.format('RAM %3.0f%% %.1f/%.0fG', rp, ru, rt),
    }

    local g = stats.gpu_info()
    if g then
      table.insert(parts, string.format('GPU %3d%%',    g[1]))
      table.insert(parts, string.format('VRAM %d/%dMB', g[2], g[3]))
    end

    -- セパレータは細い縦棒で区切る
    window:set_right_status(' ' .. table.concat(parts, ' │ ') .. ' ')
  end)

  -- ステータス更新間隔（ms）。CPU 差分計算の精度にも影響する。
  config.status_update_interval = 1000
end

return M
