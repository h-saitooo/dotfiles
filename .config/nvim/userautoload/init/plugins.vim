" vim-plug
"-----------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" カラースキーム
Plug 'sainnhe/everforest'
" 非同期処理
Plug 'Shougo/vimproc.vim', {'do': 'make'}
" 多機能整形ツール
Plug 'junegunn/vim-easy-align'
" File system explorer
Plug 'preservim/nerdtree'
" ステータスライン表示強化
Plug 'itchyny/lightline.vim'
" Syntax Highlight
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" インデント可視化
Plug 'Yggdroot/indentLine'
" 末尾の全角半角スペースをハイライト
Plug 'bronson/vim-trailing-whitespace'
" 構文エラーチェック
Plug 'scrooloose/syntastic'
" Typescript ツール
Plug 'Quramy/tsuquyomi'
" Typescript Syntax
Plug 'leafgarland/typescript-vim'
" CtrlPの拡張プラグイン
Plug 'ctrlpvim/ctrlp.vim'
" CtrlPの拡張プラグイン 関数検索
Plug 'tacahiroy/ctrlp-funky'
" CtrlPの拡張プラグイン コマンド履歴検索
Plug 'suy/vim-ctrlp-commandline'
" CtrlPの検索にagを使う
Plug 'rking/ag.vim'
" プロジェクトに入ってるESLintを読み込む
Plug 'pmsorhaindo/syntastic-local-eslint.vim'
" Editorの統一性を高める
Plug 'editorconfig/editorconfig-vim'
" Wakatimeで作業時間を計測する
Plug 'wakatime/vim-wakatime'
" VIM tsx
Plug 'ianks/vim-tsx'
" VIM Typescript
Plug 'leafgarland/typescript-vim'
" vim-go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Emmet
Plug 'mattn/emmet-vim'
" GitHub Copilot
Plug 'github/copilot.vim'


Plug 'Shougo/neomru.vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

call plug#end()
