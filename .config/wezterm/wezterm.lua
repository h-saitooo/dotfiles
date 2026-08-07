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
require('domain').apply(config)
require('status').setup(config)

-- キーバインド
-- Alt+Enter の全画面切り替えを無効化
config.keys = {
  { key = 'Enter', mods = 'ALT', action = wezterm.action.DisableDefaultAssignment },
}

-- ~/.wezterm.local.lua があればローカル上書きとして読み込む（dotfiles 管理外）
-- 注: ~/.wezterm.lua は WezTerm のエントリポイント候補なので使用不可。
local local_file = wezterm.home_dir .. '/.wezterm.local.lua'
local f = io.open(local_file, 'r')
if f then
  f:close()
  local ok, local_module = pcall(dofile, local_file)
  if ok and type(local_module) == 'table' and local_module.apply then
    local_module.apply(config)
  end
end

return config
