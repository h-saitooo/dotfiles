# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

個人用 dotfiles リポジトリ。アプリケーションではなく設定ファイル群なので、ビルド / テスト / lint は無い。コード内コメントと付随ドキュメントは日本語で書かれているため、編集時も日本語コメントに合わせること。

## デプロイ方法

- 自動インストール / シンボリックリンク作成スクリプトは**コミットされていない**（探さないこと）。
- `.config/nvim` と `.config/wezterm` は `~/.config/` 配下へ手動でシンボリックリンクされている（`~/.config/nvim -> <repo>/.config/nvim`）。ファイルを編集すれば即座に実環境へ反映される。
- ホーム直下の `.zshrc` / `.gitconfig` 等は手動配置で、`~/` の実体とリポジトリ版が一致しないことがある。

## パッケージ管理

- **Brewfile**（macOS）: `brew bundle --file=Brewfile`。
- 言語ランタイムは asdf、ディレクトリ別環境は direnv で管理（`.zshrc` で初期化）。

## .config/nvim — Neovim 設定

lazy.nvim ベース。Leader は `Space`。**全キーバインド・プラグイン一覧・基本設定は `.config/nvim/README.md` に網羅されているので、まずそれを参照すること。**

ロード順（`init.lua`）:
1. lazy.nvim を `stdpath("data")` 配下へ自動 bootstrap
2. `require("config.options")` → `require("config.keymaps")`
3. `require("lazy").setup("plugins")`

ディレクトリ構造:
- `lua/config/` — プラグインに依らない設定。`options.lua`（vim.opt 全般・日本語入力・GUI フォント）、`keymaps.lua`（汎用キーマップ）。
- `lua/plugins/` — **1 ファイル = 1 プラグイン spec**。lazy.nvim が `plugins` ディレクトリを自動走査するので、新規プラグインは lazy spec テーブルを `return` する新ファイルを追加するだけ。
- `lazy-lock.json` — プラグインのロックファイル（バージョン固定）。

注意点:
- LSP は新 API（Neovim 0.11+ の `vim.lsp.config(...)` / `vim.lsp.enable(...)`）を使用。サーバは `lua_ls` / `ts_ls` / `pyright`（`lua/plugins/lsp.lua`）。LSP キーマップは `LspAttach` autocmd 内で buffer-local に定義する。
- 補完・Telescope などプラグイン固有のキーは各 plugin ファイル内で定義され、README に集約されている。

## .config/wezterm — WezTerm 設定

モジュール分割構成。エントリは `wezterm.lua`：`package.path` に `lua/` を追加 → `appearance.apply(config)` と `status.setup(config)` を呼ぶ。WezTerm が設定ファイルを自動ウォッチするためホットリロードが効く。

モジュール（`lua/`）:
- `platform.lua` — `wezterm.target_triple` から OS 判定し `M.name`（`macos` / `linux` / `windows` / `other`）を返す。**OS 依存処理は必ずこれ経由で分岐する。**
- `appearance.lua` — フォント（`Monaspace Argon` + OS 別アイコンフォントのフォールバック）、TokyoNight 配色、ウィンドウサイズ。
- `domain.lua` — 起動時の接続先。Windows では `wezterm.default_wsl_domains()` の先頭を `default_domain` に設定して WSL に接続する。macOS / Linux は何もしない（ローカルシェル）。
- `stats.lua` — 計測ディスパッチャ。Linux なら `stats_linux` を返し、他 OS は 0 を返すスタブ。
- `stats_linux.lua` — `/proc/stat`・`/proc/meminfo` 直読み（fork 不要）、GPU/VRAM は `nvidia-smi` を 2 秒キャッシュで呼ぶ。
- `status.lua` — 右ステータスバー（CPU/RAM/GPU/VRAM）。Linux 以外では何も表示しない。

設計上の重要な制約:
- **macOS では外部コマンド呼び出しを避ける**（重く、フリーズの原因になるため、計測系は意図的にスタブ化）。新機能を足すときも macOS で `io.popen` 等を毎フレーム呼ばない。
- ローカル上書きは `~/.wezterm.local.lua`（dotfiles 管理外）に `.apply(config)` を持つテーブルを置くと読み込まれる。`~/.wezterm.lua` は WezTerm のエントリ候補なので使用不可。

## その他

- `.zshrc` — zsh 設定。asdf / direnv / starship を初期化し、`~/.zshrc_local` で機密・ローカル設定を分離。プロンプトは末尾の `starship init zsh` で有効化（starship 自体は設定ファイルを持たずデフォルト構成）。
- `.gitconfig` — pager に delta（side-by-side / line-numbers / navigate）。
