-- -----------------------------------------------------------------------------
-- 接続先ドメイン（起動時に開くシェル）
-- -----------------------------------------------------------------------------
-- Windows では既定の PowerShell ではなく WSL に接続する。
-- macOS / Linux はローカルシェルをそのまま使うので何もしない。

local wezterm  = require 'wezterm'
local platform = require 'platform'

local M = {}

function M.apply(config)
  if platform.name ~= 'windows' then
    return
  end

  -- wsl.exe から検出したディストリビューションを WSL ドメインとして返す。
  -- 各要素は { name = "WSL:<distro>", distribution = "<distro>", default_cwd = "~" }。
  local domains = wezterm.default_wsl_domains()
  if #domains == 0 then
    -- WSL 未導入の環境ではローカルシェルにフォールバックする
    return
  end

  -- 複数ある場合は wsl.exe -l の並び順の先頭を使う。
  -- 別のディストリビューションを既定にしたいときは ~/.wezterm.local.lua で
  -- config.default_domain を上書きする。
  config.default_domain = domains[1].name
end

return M
