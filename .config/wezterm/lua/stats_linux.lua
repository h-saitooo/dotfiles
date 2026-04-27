-- =============================================================================
-- システム計測: CPU / RAM / GPU / VRAM
-- =============================================================================
-- 計測方針:
--   - CPU/RAM : /proc を直読み（fork 不要で軽量）
--   - GPU/VRAM: nvidia-smi を 2 秒キャッシュで間引いて呼び出し
-- =============================================================================

local M = {}

--- ファイル全体を文字列として読み込む。失敗時は nil。
local function read_file(path)
  local f = io.open(path, 'r')
  if not f then return nil end
  local s = f:read('*a')
  f:close()
  return s
end


-- -----------------------------------------------------------------------------
-- CPU 使用率（/proc/stat から差分計算）
-- -----------------------------------------------------------------------------
-- /proc/stat の cpu 行は累積 jiffies なので、前回値との差分で % を求める。
-- 初回呼び出し時は前回値が無いため 0% を返す。

local last_cpu  -- { t = total_jiffies, a = active_jiffies }

function M.cpu_pct()
  local s = read_file('/proc/stat')
  if not s then return 0 end

  -- user, nice, system, idle, iowait, irq, softirq
  local u, n, sy, id, io_, ir, sf =
    s:match('cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)')

  local total  = u + n + sy + id + io_ + ir + sf
  local active = total - id - io_  -- idle と iowait を除いたものがアクティブ

  local pct = 0
  if last_cpu then
    local td = total  - last_cpu.t
    local ad = active - last_cpu.a
    if td > 0 then pct = ad / td * 100 end
  end

  last_cpu = { t = total, a = active }
  return pct
end


-- -----------------------------------------------------------------------------
-- RAM 使用率（/proc/meminfo）
-- -----------------------------------------------------------------------------
-- MemAvailable はカーネルが「実質的に確保可能」と判断した値。
-- free コマンド等で表示される "available" と一致する。

function M.ram_info()
  local s = read_file('/proc/meminfo')
  local total = tonumber(s:match('MemTotal:%s+(%d+)'))      -- KiB
  local avail = tonumber(s:match('MemAvailable:%s+(%d+)'))  -- KiB
  local used  = total - avail

  -- 戻り値: 使用率(%), 使用量(GiB), 総量(GiB)
  return used / total * 100,
         used  / 1024 / 1024,
         total / 1024 / 1024
end


-- -----------------------------------------------------------------------------
-- GPU / VRAM 使用率（nvidia-smi、2 秒キャッシュ）
-- -----------------------------------------------------------------------------
-- nvidia-smi は起動コストが大きい（数十〜百 ms）ので、
-- 毎フレーム呼ぶと描画が引っかかる。短期キャッシュで間引く。
--
-- マルチ GPU 環境で特定の GPU だけ見たい場合は --id=0 等を付ける。

local gpu_cache = { t = 0, val = nil }

function M.gpu_info()
  local now = os.time()
  if now - gpu_cache.t < 2 and gpu_cache.val then
    return gpu_cache.val
  end

  local h = io.popen(
    'nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total ' ..
    '--format=csv,noheader,nounits 2>/dev/null'
  )
  if not h then return nil end
  local out = h:read('*a')
  h:close()

  -- "12, 3456, 10240" のような CSV を分解
  local g, mu, mt = out:match('(%d+),%s*(%d+),%s*(%d+)')
  if not g then return nil end

  gpu_cache = {
    t = now,
    val = { tonumber(g), tonumber(mu), tonumber(mt) },  -- {利用率%, 使用MB, 総MB}
  }
  return gpu_cache.val
end

return M
