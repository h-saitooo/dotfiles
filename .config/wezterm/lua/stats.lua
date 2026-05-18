-- =============================================================================
-- システム計測 (CPU / RAM / GPU) ディスパッチャ
-- =============================================================================
-- 実装は OS 別ファイルに委譲する。
--   Linux : /proc を直読み (stats_linux)
--   その他: 0 を返すスタブ (macOS は外部コマンド呼び出しが重くフリーズの原因になるため無効化)
-- =============================================================================

local platform = require 'platform'

if platform.name == 'linux' then
  return require 'stats_linux'
else
  return {
    cpu_pct  = function() return 0 end,
    ram_info = function() return 0, 0, 0 end,
    gpu_info = function() return nil end,
  }
end
