set nocompatible    " be iMproved, required
set number          " show line numbers
set relativenumber
set expandtab       " tab to spaces
set cursorline      " highlight current line
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent
set laststatus=2    " To display lighline
set noshowmode      " Get rid of -- INSERT -- at the bottom
set background=dark
set noswapfile

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'

Plugin 'easymotion/vim-easymotion'

Plugin 'tpope/vim-surround'

Plugin 'scrooloose/nerdcommenter'

Plugin 'morhetz/gruvbox'

Plugin 'shinchu/lightline-gruvbox.vim'

Plugin 'itchyny/lightline.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme gruvbox

let mapleader = "\<Space>"

" system clipboard
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>y "+yy
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" file operations
nmap <C-s> :w<CR>
nmap <C-q> :q<CR>

" Unmap the arrow keys
no <left> <Nop>
no <right> <Nop>
no <up> ddkP
no <down> ddp
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>

" Map shift+j & shift+k new line in normal mode
nmap <S-J> o<Esc>
nmap <S-K> O<Esc>

" Disable mouse
set mouse=nicr                  " Disable mouse in visual mode
set mousehide                   " Hide mouse when typing

" Deactivate mouse wheel
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>

" NERDTree
let g:NERDTreeDirArrowExpandable  = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeShowHidden=1
map <C-n> :NERDTreeToggle<CR>

" NERDCommenter
map <leader>k <plug>NERDCommenterToggle

" Easy Motion
nmap <leader>m <Plug>(easymotion-bd-f)

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

if !has('gui_running')
    set t_Co=256
endif

