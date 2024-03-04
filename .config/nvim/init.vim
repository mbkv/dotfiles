let g:formatters_javascript = [ 'prettier' ]
let g:coq_settings = { 'auto_start': v:true }

call plug#begin()

Plug 'tpope/vim-surround'
" Plug 'ctrlpvim/ctrlp.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'w0rp/ale'

Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'vim-autoformat/vim-autoformat'
Plug 'mileszs/ack.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }

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

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap ; :
noremap <C-_> :Commentary<CR>
noremap <C-l> :CHADopen<CR>
nnoremap <C-p> :Telescope find_files<cr>

noremap <silent> <C-S>  :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

autocmd VimEnter * CHADopen --nofocus
autocmd TabNewEntered * CHADopen --nofocus
autocmd BufEnter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif
autocmd BufWrite * Autoformat

nmap <silent> <c-Left> :wincmd h<CR>
nmap <silent> <c-Right> :wincmd l<CR>
nmap <silent> <c-Up> :wincmd k<CR>
nmap <silent> <c-Down> :wincmd j<CR>

let g:chadtree_settings = { 'keymap.primary': [], 'keymap.secondary': [], 'keymap.tertiary': ['t', '<enter>', '<tab>'], 'keymap.trash': [] }

