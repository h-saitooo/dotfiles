# dotfiles

個人用の設定ファイル群。詳細やエージェント向けガイドは [CLAUDE.md](./CLAUDE.md) を参照。

## 管理対象

- `.zshrc` / `.zsh/` — zsh 設定（asdf / direnv / starship を初期化）
- `.gitconfig` — git 設定（pager に delta）
- `.config/nvim/` — Neovim 設定（lazy.nvim ベース。詳細は `.config/nvim/README.md`）
- `.config/wezterm/` — WezTerm 設定
- `.asdfrc` / `.uim` — asdf / 日本語入力（uim）設定
- `Brewfile` — macOS のパッケージ（`brew bundle --file=Brewfile`）

## 配置

`.config/nvim` と `.config/wezterm` は `~/.config/` 配下へ手動でシンボリックリンクする。
ホーム直下のファイル（`.zshrc` / `.gitconfig` 等）は手動配置。
