vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- cursorline はウィンドウごとの設定で非アクティブな pane にも残るため、
-- アクティブな pane だけに表示させる（NormalNC の背景差と合わせて現在位置を明確にする）
local cursorline_group = vim.api.nvim_create_augroup("ActiveWindowCursorline", { clear = true })

vim.api.nvim_create_autocmd("WinLeave", {
  group = cursorline_group,
  callback = function()
    -- cursorline を意図的にオフにしているウィンドウを復帰時に壊さないよう値を控える
    vim.w.cursorline_saved = vim.wo.cursorline
    vim.wo.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = cursorline_group,
  callback = function()
    -- 一度も離れていないウィンドウ（新規 split 等）はグローバル既定値に従う
    local saved = vim.w.cursorline_saved
    if saved == nil then
      saved = vim.go.cursorline
    end
    vim.wo.cursorline = saved
  end,
})

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.list = true
opt.listchars = {
  tab = "→ ",
  lead = "·",
  trail = "·",
  nbsp = "␣",
  extends = "▶",
  precedes = "◀",
}

-- ウィンドウ境界を罫線文字で描く（lualine の globalstatus = true と併用して
-- 各ウィンドウの statusline を消すと、縦横の境界が繋がって枠線状に見える）
opt.fillchars:append({
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

-- floating window（LSP hover / 診断など枠指定のないもの）にも枠を付けて split 側と見た目を揃える
opt.winborder = "rounded"

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.background = "dark"

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.splitbelow = true
opt.splitright = true

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.updatetime = 300
opt.timeoutlen = 500
opt.autoread = true

-- Auto-reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Japanese language support
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.ambiwidth = "single"
opt.iminsert = 0
opt.imsearch = -1

-- Font settings for Japanese
if vim.fn.has("gui_running") == 1 then
  opt.guifont = "HackGen Console NF:h14"
end