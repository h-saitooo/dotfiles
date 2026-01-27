return {
  {
    "vim-jp/vimdoc-ja",
    event = "VeryLazy",
  },
  {
    "cohama/lexima.vim",
    event = "InsertEnter",
    config = function()
      vim.g.lexima_enable_basic_rules = 1
      vim.g.lexima_enable_newline_rules = 1
    end,
  },
}