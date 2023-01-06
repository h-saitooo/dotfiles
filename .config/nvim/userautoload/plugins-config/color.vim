"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
if has ('termguicolors')
  set termguicolors
endif

" Background: 'dark' or 'light'
set background=dark

" Contrast 'hard' or 'medium(default)' or 'soft'
let g:everforest_background = 'medium'

" For better performance
let g:everforest_better_performance = 1

colorscheme everforest
