call plug#begin()

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'luochen1990/rainbow'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-repeat'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'honza/vim-snippets'

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

Plug 'sbdchd/neoformat'
Plug 'airblade/vim-gitgutter'

Plug 'h-225/odin.vim'
Plug('ziglang/zig.vim')
Plug 'tikhomirov/vim-glsl'

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
set smartcase
set expandtab
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

set colorcolumn=80,120

set cursorline

nnoremap <silent> <leader>/ <cmd>RG<cr>
nnoremap <silent> <F12> :RG \b<C-R><C-W>\b<CR>
nnoremap ; :
noremap <C-_> :Commentary<CR>
noremap <C-l> :CHADopen<CR>
nnoremap <C-p> :GFiles<cr>

noremap <silent>  <C-S>  :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

autocmd VimEnter * CHADopen --nofocus
autocmd TabNewEntered * CHADopen --nofocus
autocmd BufEnter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif
autocmd BufWrite * Neoformat
inoremap <silent> <C-v> <C-r>+

autocmd filetype javascript setlocal shiftwidth=2 tabstop=2
autocmd filetype typescript setlocal shiftwidth=2 tabstop=2
autocmd filetype javascriptreact setlocal shiftwidth=2 tabstop=2
autocmd filetype typescriptreact setlocal shiftwidth=2 tabstop=2
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

nnoremap <silent> <c-Left> :wincmd h<CR>
nnoremap <silent> <c-Right> :wincmd l<CR>
nnoremap <silent> <c-Up> :wincmd k<CR>
nnoremap <silent> <c-Down> :wincmd j<CR>

nnoremap <silent> <C-g> :Buffers<CR>

let g:chadtree_settings = { 'keymap.primary': ['t', '<enter>', '<tab>'], 'keymap.trash': [], "view.sort_by": ["is_folder", "file_name"] }


lua <<EOF

local lsp = require('lspconfig')

lsp.tsserver.setup({})
lsp.clangd.setup({})

require('nvim-autopairs').setup {}
-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

EOF
