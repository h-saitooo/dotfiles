-- -----------------------------------------------------------------------------
-- OS 判定
-- -----------------------------------------------------------------------------
-- wezterm.target_triple は実行中バイナリのターゲットを返す。
--   Linux  : "x86_64-unknown-linux-gnu"
--   macOS  : "aarch64-apple-darwin" / "x86_64-apple-darwin"
--   Win    : "x86_64-pc-windows-msvc"

local wezterm = require 'wezterm'
local triple  = wezterm.target_triple

local M = {}

if triple:find('darwin') then
  M.name = 'macos'
elseif triple:find('linux') then
  M.name = 'linux'
elseif triple:find('windows') then
  M.name = 'windows'
else
  M.name = 'other'
end

return M
