let g:coq_settings = { 'auto_start': v:true }

call plug#begin()

Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}


Plug 'nanotech/jellybeans.vim'

call plug#end()

filetype plugin indent on

set syntax

set clipboard+=unnamedplus
set number
set relativenumber
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4

set undofile
set undodir=~/.config/nvim/undodir
"
" 24-bit Color support
set termguicolors

set foldmethod=indent
set nofoldenable
set foldlevel=1

set wildmenu
set ignorecase
set nospell
set mouse=nv

set background=dark
colorscheme jellybeans

set cursorline

nnoremap ; :
noremap <C-_> :Commentary<CR>
noremap <C-l> :CHADopen<CR>

autocmd VimEnter * CHADopen --nofocus
autocmd TabNewEntered * CHADopen --nofocus
autocmd BufEnter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif

nmap <silent> <c-Left> :wincmd h<CR>
nmap <silent> <c-Right> :wincmd l<CR>
nmap <silent> <c-Up> :wincmd k<CR>
nmap <silent> <c-Down> :wincmd j<CR>

let g:chadtree_settings = { 'keymap.primary': [], 'keymap.secondary': [], 'keymap.tertiary': ['t', '<enter>', '<tab>'], 'keymap.trash': [] }


