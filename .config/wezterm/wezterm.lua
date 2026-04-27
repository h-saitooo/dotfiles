-- =============================================================================
-- WezTerm 設定エントリポイント
-- =============================================================================
-- 各モジュールは lua/ 配下に配置。
-- 設定ファイル群は WezTerm が自動でウォッチするので hot reload も効く。

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- lua/ 配下を require できるようにする
package.path = wezterm.config_dir .. '/lua/?.lua;' .. package.path

require('appearance').apply(config)
require('status').setup(config)

return config
