" Plug for plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'cespare/vim-toml'
Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'     " Git Commands
Plug 'benekastah/neomake'     " Nevoim specific plugins
Plug 'tpope/vim-unimpaired'   " Pairs of handy bracket mappings
Plug 'tpope/vim-commentary'   " Make commenting easier
Plug 'tpope/vim-vinegar'      " Make netrw way better
Plug 'mileszs/ack.vim'        " search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'hashivim/vim-terraform'
call plug#end()


set background=dark " Set background to dark for base16
syntax on " Syntax highlighting FTW
set directory=/tmp " Move swp to a standard location
:let mapleader = ',' " Remap the leader key
colorscheme base16-tomorrow-night

" Yank to system clipboard
vnoremap <leader>y "*y
nnoremap <leader>y "*y

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap :F :Files<CR>

" Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir

" Setting Spacing and Indent (plus line no)
set nu
set tabstop=2 shiftwidth=2 expandtab
set ts=2
set nowrap

" Set 256 colors
set t_Co=256
set guifont=Inconsolata:h16

" Hidden characters
set listchars=tab:\ \ ,trail:█
set list

" Auto update commands run not too fast and not too slow
set updatetime=500

" Unbreak YAML indents
autocmd FileType yaml setlocal indentexpr=

" Run neomake on buffer write
call neomake#configure#automake('w')
autocmd! BufWritePost * Neomake " Run neomake, it's like syntastic

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
"function! InsertTabWrapper()
"    let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k'
"        return "\<tab>"
"    else
"        return "\<c-p>"
"    endif
"endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>
"inoremap <s-tab> <c-n>

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif


" hit the space bar to remove search highlights
nnoremap <space> :noh<cr>
let g:airline_theme='base16_tomorrow'
let base16colorspace=256
set termguicolors
