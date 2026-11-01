# macOS のセットアップ

新しい Mac に、この dotfiles の環境を作る手順です。
対象は WezTerm、herdr、Neovim、zsh で、Apple silicon の Mac を想定しています。

各設定の詳細は次のページにあります。

- [Neovim の前提条件とキーバインド](../.config/nvim/README.md)
- [リポジトリの構成](../CLAUDE.md)

## Homebrew の導入

コマンドラインツールと Homebrew を入れます。

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## リポジトリの取得

```bash
git clone https://github.com/h-saitooo/dotfiles.git ~/dotfiles
```

## パッケージの導入

必要なものだけを個別に入れます。
リポジトリの `Brewfile` は使いません。
`openssl@1.1` など Homebrew に見つからない項目が含まれているうえ、WezTerm、mise、ripgrep、starship が入っていないためです。

```bash
brew install \
  neovim mise herdr starship direnv git-delta gh jq ripgrep ffmpeg \
  tree-sitter-cli zsh-completions \
  lua-language-server typescript-language-server typescript pyright
brew install --cask wezterm font-monaspace font-hackgen-nerd
```

Node.js は、シェルの設定を終えてから mise で入れます。

## 設定ファイルの配置

`.config` 配下と `.local/bin` 配下はシンボリックリンクにします。
リポジトリのファイルを編集すると、すぐに反映されます。

```bash
mkdir -p ~/.config/herdr ~/.local/bin
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/herdr/config.toml ~/.config/herdr/config.toml
ln -s ~/dotfiles/.local/bin/mmdc ~/.local/bin/mmdc
ln -s ~/dotfiles/.local/bin/dcx ~/.local/bin/dcx
```

## シェルと git の設定

`.zshrc` と `.gitconfig` はコピーして使います。
`.zshrc` には asdf と Rancher Desktop の行が残っているので、コピーした側から削除します。
asdf の行が読み込む `asdf.sh` は、asdf 0.16 以降では使われません。

```bash
cp ~/dotfiles/.zshrc ~/dotfiles/.gitconfig ~/
sed -i '' '/asdf\.sh/d; /RANCHER DESKTOP/d; /\.rd\/bin/d' ~/.zshrc
git config --global user.name "<名前>"
```

`.zshrc` は `~/.zshrc_local` を必ず読み込むので、このファイルも作ります。
`mmdc` と `dcx` を見つけられるよう、`~/.local/bin` を PATH に入れます。

```bash
cat > ~/.zshrc_local <<'EOF'
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate zsh)"
EOF
exec zsh
```

## Node.js と Mermaid の描画環境

mise で Node.js を入れてから、`mmdc` を一度実行します。
初回の実行で mermaid-cli と chrome-headless-shell を取得し、最後に `12.0.0` と表示します。

```bash
mise use -g node@lts
mmdc --version
```

md-render.nvim の `mmdc` 呼び出しには 30 秒のタイムアウトがあるので、この取得を先に済ませておきます。

## WezTerm と herdr の起動

WezTerm を起動します。
macOS の WezTerm はローカルのシェルを直接開くので、Windows のような SSH ドメインと `~/.wezterm.local.lua` は要りません。

次に WezTerm の中で `herdr` を起動し、そのペインで `prefix+f` に割り当てているプラグインを入れます。

```bash
herdr plugin install Tyru5/herdr-floax
```

herdr サーバーは起動したときの環境変数を保持します。
ほかの端末から herdr サーバーを起動していると `TERM_PROGRAM` が WezTerm にならず、Neovim で画像が出ません。

## devcontainer で Claude Code と Codex を起動する dcx

`dcx` は、herdr の `prefix+alt+c` と `prefix+alt+x` から呼ばれます。
使う場合は devcontainer CLI と Docker Desktop を入れます。

```bash
mise use -g npm:@devcontainers/cli
brew install --cask docker-desktop
```

## Neovim の初回起動と動作確認

`nvim` を起動すると、lazy.nvim が `lazy-lock.json` のコミットでプラグインを取得します。
treesitter のパーサも自動で入ります。

動作は herdr のペインの中で次の順に確かめます。

```bash
echo $TERM_PROGRAM
printf '# テスト\n\n```mermaid\nflowchart LR\n  A[開始] --> B[終了]\n```\n' > /tmp/test.md
nvim /tmp/test.md
```

| 確認すること | 期待する結果 |
|---|---|
| `echo $TERM_PROGRAM` | `WezTerm` と表示される |
| `:MdRender demo` | デモが崩れずに表示され、画像が出る |
| `test.md` で `<leader>mp` | Mermaid の図が日本語のラベル付きで表示される |

## 図や画像が表示されないとき

Mermaid の図がコードブロックのまま表示されるときは、`mmdc` の失敗を疑います。
md-render.nvim は失敗を通知しないので、次のコマンドでエラーを確かめます。

```bash
printf 'flowchart LR\n  A[開始] --> B[終了]\n' > /tmp/t.mmd
mmdc -i /tmp/t.mmd -o /tmp/t.png
```

画像がまったく出ないときは、`TERM_PROGRAM` を確かめます。
Neovim 0.12 の md-render.nvim は、この変数で kitty graphics protocol（端末に画像を描かせる仕組み）の対応を判定します。
`WezTerm` でなければ、WezTerm の中で herdr サーバーを起動し直します。

## このガイドの検証状況

手順は macOS の実機では実行していません。
パッケージ名は Homebrew の API で確認しました。
`mmdc` と md-render.nvim の動作は、WSL の Ubuntu と Windows 版 WezTerm の組み合わせでのみ確認しています。
