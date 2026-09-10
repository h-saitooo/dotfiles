# dotfiles

個人用の設定ファイル群。詳細やエージェント向けガイドは [CLAUDE.md](./CLAUDE.md) を参照。

## 管理対象

- `.zshrc` / `.zsh/` — zsh 設定（asdf / direnv / starship を初期化）
- `.gitconfig` — git 設定（pager に delta）
- `.config/nvim/` — Neovim 設定（lazy.nvim ベース。詳細は `.config/nvim/README.md`）
- `.config/wezterm/` — WezTerm 設定
- `.config/herdr/config.toml` — herdr（ターミナルワークスペースマネージャ）のキーバインド・UI 設定
- `.local/bin/dcx` — devcontainer 内で claude / codex を起動する herdr 用ラッパー
- `.asdfrc` / `.uim` — asdf / 日本語入力（uim）設定
- `Brewfile` — macOS のパッケージ（`brew bundle --file=Brewfile`）

## 配置

`.config/nvim` と `.config/wezterm` はディレクトリごと、`.config/herdr/config.toml` はファイル単位で `~/.config/` 配下へ手動でシンボリックリンクする（herdr の設定ディレクトリはログ・ソケットが同居するため、ディレクトリではなくファイルを張る）。
`.local/bin/dcx` は `~/.local/bin/` へシンボリックリンクする。
ホーム直下のファイル（`.zshrc` / `.gitconfig` 等）は手動配置。
