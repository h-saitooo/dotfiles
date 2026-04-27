-- =============================================================================
-- システム計測 (CPU / RAM / GPU) ディスパッチャ
-- =============================================================================
-- 実装は OS 別ファイルに委譲する。
--   Linux : /proc を直読み (stats_linux)
--   macOS : top / vm_stat / sysctl を呼ぶ (stats_macos)
--   その他: 0 を返すスタブ
-- =============================================================================

local platform = require 'platform'

if platform.name == 'linux' then
  return require 'stats_linux'
elseif platform.name == 'macos' then
  return require 'stats_macos'
else
  return {
    cpu_pct  = function() return 0 end,
    ram_info = function() return 0, 0, 0 end,
    gpu_info = function() return nil end,
  }
end
