filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'

Plugin 'easymotion/vim-easymotion'

Plugin 'tpope/vim-surround'

Plugin 'scrooloose/nerdcommenter'

Plugin 'dracula/vim'

Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'godlygeek/tabular'

Plugin 'luochen1990/rainbow'

Plugin 'Raimondi/delimitMate'

Plugin 'itchyny/lightline.vim'

" All of your Plugins must be added before the following line
call vundle#end()           
filetype plugin indent on    

colorscheme dracula " color scheme

set number          " show line numbers
set expandtab       " tab to spaces
set cursorline      " highlight current line
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set laststatus=2    " To display lighline
set noshowmode      " Get rid of -- INSERT -- at the bottom

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
map <C-n> :NERDTreeToggle<CR>

 "NERDCommenter
map <C-k> <plug>NERDCommenterToggle

" Easy Motion
map <C-m> <Plug>(easymotion-bd-f)

" RainBow
let g:rainbow_active = 1 " 0 to enable it manually with toggle

" DelimitMate
let delimitMate_expand_cr = 1

" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

if !has('gui_running')
    set t_Co=256
endif

