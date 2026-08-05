return {
  {
    "vim-jp/vimdoc-ja",
    event = "VeryLazy",
    init = function()
      -- vimdoc-ja は doc/tags-ja をリポジトリに含めているが、helplang=ja の
      -- Neovim が helptags を生成すると !_TAG_FILE_ENCODING 行が落ちて
      -- 差分になり、lazy.nvim の update が
      -- "You have local changes ... Please remove them to update." で止まる。
      -- lazy.nvim が自動復元するのは doc/tags のみ（doc/tags-ja は対象外）なので、
      -- update 系の処理が走る前に自前で復元しておく。
      vim.api.nvim_create_autocmd("User", {
        pattern = { "LazyUpdatePre", "LazySyncPre", "LazyCheckPre" },
        callback = function()
          local dir = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "vimdoc-ja")
          if vim.fn.isdirectory(dir) == 1 then
            vim.system({ "git", "-C", dir, "checkout", "--", "doc/tags-ja" }):wait()
          end
        end,
      })
    end,
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