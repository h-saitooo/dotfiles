-- =============================================================================
-- システム計測 (macOS 実装)
-- =============================================================================
-- macOS には /proc が無いため shell に fork して計測する。
-- 値は 2 秒キャッシュして毎フレームの fork を避ける。
--
--   CPU  : top -l 1 -n 0 のヘッダ行を解析
--   RAM  : sysctl hw.memsize + vm_stat
--   GPU  : powermetrics は sudo 必須なので未対応 (nil 返却)
-- =============================================================================

local M = {}

--- shell コマンドを実行して stdout を返す。失敗時は空文字。
local function popen_read(cmd)
  local h = io.popen(cmd)
  if not h then return '' end
  local out = h:read('*a') or ''
  h:close()
  return out
end


-- -----------------------------------------------------------------------------
-- CPU 使用率
-- -----------------------------------------------------------------------------
-- top の "CPU usage: 12.50% user, 6.25% sys, 81.25% idle" 行を解析。
-- top -l 1 は単発サンプルなので初回は起動以来の平均値が出る点に注意。

local cpu_cache = { t = 0, val = 0 }

function M.cpu_pct()
  local now = os.time()
  if now - cpu_cache.t < 2 then return cpu_cache.val end

  local out = popen_read('top -l 1 -n 0 2>/dev/null')
  local user, sys = out:match('CPU usage:%s+([%d%.]+)%%%s+user,%s+([%d%.]+)%%%s+sys')
  local pct = (tonumber(user) or 0) + (tonumber(sys) or 0)

  cpu_cache = { t = now, val = pct }
  return pct
end


-- -----------------------------------------------------------------------------
-- RAM 使用率
-- -----------------------------------------------------------------------------
-- "使用量" の定義は active + wired + compressed (アクティビティモニタ準拠)。
-- inactive は再利用可能なので除外する。

local ram_cache = { t = 0, val = nil }

function M.ram_info()
  local now = os.time()
  if now - ram_cache.t < 2 and ram_cache.val then
    return ram_cache.val[1], ram_cache.val[2], ram_cache.val[3]
  end

  local total_bytes = tonumber(popen_read('sysctl -n hw.memsize 2>/dev/null'):match('(%d+)')) or 0
  local vm = popen_read('vm_stat 2>/dev/null')

  -- ページサイズは Apple Silicon で 16384、Intel で 4096
  local page_size = tonumber(vm:match('page size of (%d+) bytes')) or 4096

  local function pages(label)
    return tonumber(vm:match(label .. ':%s+(%d+)')) or 0
  end

  local active     = pages('Pages active')
  local wired      = pages('Pages wired down')
  local compressed = pages('Pages occupied by compressor')

  local used_bytes = (active + wired + compressed) * page_size

  if total_bytes == 0 then
    ram_cache = { t = now, val = { 0, 0, 0 } }
    return 0, 0, 0
  end

  local pct       = used_bytes  / total_bytes * 100
  local used_gib  = used_bytes  / 1024 / 1024 / 1024
  local total_gib = total_bytes / 1024 / 1024 / 1024

  ram_cache = { t = now, val = { pct, used_gib, total_gib } }
  return pct, used_gib, total_gib
end


-- -----------------------------------------------------------------------------
-- GPU
-- -----------------------------------------------------------------------------
-- macOS で GPU 使用率を取るには powermetrics が必要だが sudo を要するため、
-- ここでは未対応とする。status.lua 側で nil を許容している。

function M.gpu_info()
  return nil
end

return M
