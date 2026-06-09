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