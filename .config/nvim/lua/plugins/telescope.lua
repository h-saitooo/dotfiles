return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- telescope 0.1.x のプレビューは nvim-treesitter の旧 master API
    -- (nvim-treesitter.parsers.ft_to_lang 等) に依存しているが、main 版へ移行した
    -- ため該当 API が消え、プレビュー時に ft_to_lang で落ちる。
    -- プレビューの TS ハイライトを Neovim 標準の vim.treesitter.start へ差し替える
    -- （ft→lang 変換・パーサ有無判定・ハイライタ起動を一括で行う）。
    -- パーサ未導入なら pcall が false を返し、telescope が regex ハイライトへ fallback する。
    require("telescope.previewers.utils").ts_highlighter = function(bufnr, ft)
      local lang = vim.treesitter.language.get_lang(ft) or ft
      return pcall(vim.treesitter.start, bufnr, lang)
    end

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!**/.git/*",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
          },
        },
      },
    })

    telescope.load_extension("fzf")

    local keymap = vim.keymap.set

    keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}