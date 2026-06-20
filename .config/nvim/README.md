# Neovim Configuration

Leader キーは `Space` に設定。

## 前提条件

この設定は外部コマンド・ツールに依存している。新しい環境で使う前に以下を導入しておくこと（未導入だと該当プラグインが起動時にエラーを出す）。

| 必要なもの | 用途 | 備考 |
|---|---|---|
| **Neovim 0.12+** | 本体 | nvim-treesitter の main 版が 0.12 必須。LSP は新 API（0.11+ の `vim.lsp.config`/`vim.lsp.enable`）を使用 |
| **git / curl / tar** | lazy.nvim の bootstrap、treesitter パーサの取得 | |
| **C コンパイラ（gcc / make）** | telescope-fzf-native のビルド、treesitter パーサのコンパイル | Debian/Ubuntu 系は `sudo apt install build-essential` |
| **tree-sitter CLI 0.26.1+** | nvim-treesitter main 版がパーサのビルドに使用 | npm 版ではなくバイナリ/パッケージで入れる。プリビルドを `~/.local/bin` 等 PATH の通った場所へ配置。apt の `tree-sitter-cli` は古い場合あり |
| **ripgrep（`rg`）** | Telescope のファイル検索・live grep | |
| **Nerd Font** | アイコン表示（nvim-web-devicons / lualine / nvim-tree） | GUI フォントは `HackGen Console NF` |
| **Node.js** | LSP サーバ `ts_ls` / `pyright` の実行に必要 | |
| **LSP サーバ本体（`lua_ls` / `ts_ls` / `pyright`）** | LSP 機能 | mason は使っていないので手動でインストールし PATH を通すこと |

プラグイン本体は初回起動時に lazy.nvim が自動取得する。treesitter パーサは設定読み込み時に自動インストールされる（`tree-sitter` CLI が PATH 上にあること）。

## 基本設定

| 設定 | 値 |
|---|---|
| 行番号 | 相対行番号を表示 |
| カーソル行 | ハイライト表示 |
| 折り返し | 無効 |
| タブ幅 | 2 スペース (expandtab) |
| インデント | autoindent + smartindent |
| 検索 | 大文字小文字無視 (smartcase 有効) |
| クリップボード | システムクリップボード連携 (`unnamedplus`) |
| マウス | 有効 |
| 分割方向 | 下・右に開く |
| Undo | ファイル保存 (undofile) |
| スワップ / バックアップ | 無効 |
| エンコーディング | UTF-8 |
| フォント (GUI) | HackGen Console NF:h14 |
| カラースキーム | catppuccin-mocha |

## プラグイン一覧

| プラグイン | 用途 |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | プラグインマネージャー |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | カラースキーム (Mocha) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | ファイルエクスプローラー |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト / インデント |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP クライアント設定 (lua_ls, ts_ls, pyright) |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 自動補完 |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | スニペットエンジン |
| [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim) | EditorConfig 対応 |
| [vimdoc-ja](https://github.com/vim-jp/vimdoc-ja) | Vim ヘルプ日本語化 |
| [lexima.vim](https://github.com/cohama/lexima.vim) | 括弧自動閉じ |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code 連携 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | ファイルアイコン |
| [nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) | LSP ファイル操作 |

## キーバインド

### 一般

| キー | モード | 説明 |
|---|---|---|
| `<leader>w` | Normal | ファイル保存 |
| `<leader>q` | Normal | 終了 |
| `<Esc>` | Normal | 検索ハイライト解除 |
| `<leader>wr` | Normal | Word wrap 切り替え |

### ウィンドウ操作

| キー | モード | 説明 |
|---|---|---|
| `Ctrl+h/j/k/l` | Normal | ウィンドウ間移動 (左/下/上/右) |
| `<leader>sv` | Normal | 縦分割 |
| `<leader>sh` | Normal | 横分割 |
| `<leader>se` | Normal | 分割サイズ均等化 |
| `<leader>sx` | Normal | 現在の分割を閉じる |

### 編集

| キー | モード | 説明 |
|---|---|---|
| `<` / `>` | Visual | インデント調整 (選択維持) |
| `J` / `K` | Visual | 行の上下移動 |

### ファイルパスコピー

| キー | モード | 説明 |
|---|---|---|
| `<leader>yp` | Normal | 相対パスをコピー (cwd 基準) |
| `<leader>ya` | Normal | 絶対パスをコピー |
| `<leader>yf` | Normal | ファイル名のみコピー |
| `<leader>yd` | Normal | 親ディレクトリの絶対パスをコピー |

### 日本語入力

| キー | モード | 説明 |
|---|---|---|
| `Ctrl+j` | Insert | 日本語入力切替 |
| `<leader>ji` | Normal | 日本語入力 ON |
| `<leader>je` | Normal | 日本語入力 OFF |

### ファイルエクスプローラー (nvim-tree)

| キー | モード | 説明 |
|---|---|---|
| `<leader>ee` | Normal | ツリー表示/非表示 |
| `<leader>ef` | Normal | 現在のファイル位置でツリー表示 |
| `<leader>ec` | Normal | ツリー全折りたたみ |
| `<leader>er` | Normal | ツリー更新 |
| `<leader>eo` | Normal | ツリーにフォーカス |

### Telescope (ファジーファインダー)

| キー | モード | 説明 |
|---|---|---|
| `<leader>ff` | Normal | ファイル検索 |
| `<leader>fr` | Normal | 最近開いたファイル検索 |
| `<leader>fs` | Normal | 文字列検索 (live grep) |
| `<leader>fc` | Normal | カーソル下の文字列を検索 |

Telescope 内操作:

| キー | 説明 |
|---|---|
| `Ctrl+j/k` | 候補の上下移動 |
| `Ctrl+q` | 選択項目を quickfix に送る |

### LSP

| キー | モード | 説明 |
|---|---|---|
| `gd` | Normal | 定義へ移動 |
| `gD` | Normal | 宣言へ移動 |
| `gR` | Normal | 参照一覧 |
| `gi` | Normal | 実装一覧 |
| `gt` | Normal | 型定義一覧 |
| `K` | Normal | ドキュメント表示 |
| `<leader>ca` | Normal / Visual | コードアクション |
| `<leader>rn` | Normal | リネーム |
| `<leader>D` | Normal | バッファの診断一覧 |
| `<leader>d` | Normal | 行の診断表示 |
| `[d` / `]d` | Normal | 前/次の診断へ移動 |
| `<leader>rs` | Normal | LSP 再起動 |

### 補完 (nvim-cmp)

| キー | モード | 説明 |
|---|---|---|
| `Ctrl+j/k` | Insert | 補完候補の上下移動 |
| `Ctrl+b/f` | Insert | ドキュメントスクロール |
| `Ctrl+Space` | Insert | 補完を手動で開く |
| `Ctrl+e` | Insert | 補完をキャンセル |
| `Enter` | Insert | 補完を確定 |

### Claude Code

| キー | モード | 説明 |
|---|---|---|
| `<leader>ac` | Normal | Claude Code の表示/非表示 |
| `<leader>af` | Normal | Claude Code にフォーカス |
| `<leader>ar` | Normal | Claude Code を再開 (resume) |
| `<leader>aC` | Normal | Claude Code を続行 (continue) |
| `<leader>am` | Normal | Claude モデル選択 |
| `<leader>ab` | Normal | 現在のバッファを Claude に追加 |
| `<leader>as` | Visual | 選択範囲を Claude に送信 |
| `<leader>as` | Normal (ツリー内) | ツリーのファイルを Claude に追加 |
| `<leader>aa` | Normal | diff を承認 |
| `<leader>ad` | Normal | diff を拒否 |
