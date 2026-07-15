-- Windows では tree-sitter CLI が既定で MSVC (cl.exe) を探すため、
-- 無い環境では mingw の gcc でパーサをコンパイルさせる。
-- （spec ファイルは lazy.nvim の起動時スキャンで読まれるので build/:TSUpdate より先に効く）
if vim.fn.has("win32") == 1 and vim.fn.executable("cl") == 0 then
  vim.env.CC = "gcc"
end

return {
  "nvim-treesitter/nvim-treesitter",
  -- main はリライト版。旧 nvim-treesitter.configs API は廃止され、
  -- パーサ導入は install()、ハイライト/インデントは FileType autocmd で有効化する。
  -- main 版は遅延ロード非対応のため lazy = false が必須。
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- 導入したいパーサ群（旧 ensure_installed 相当）。
    local ensure_installed = {
      "bash",
      "c",
      "html",
      "css",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "go",
      "rust",
      "toml",
    }

    -- 未導入のパーサのみ非同期インストール（install は導入済みなら no-op）。
    ts.install(ensure_installed)

    -- ファイルを開いたとき、対応パーサがあればハイライトとインデントを有効化する。
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        -- パーサ未導入のファイルタイプでは start が失敗するため pcall で握りつぶす。
        if pcall(vim.treesitter.start, args.buf) then
          -- treesitter ベースのインデント（main 版では experimental）。
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
