set smartindent
set breakindent
set encoding=utf-8
"no ugly | cursor, only block cursor
set guicursor=
set noerrorbells
"set signcolumn=yes
set scrolloff=8
set hidden
set nowrap

set clipboard=unnamed,unnamedplus

"Split panels in a more natural way
set splitbelow
set splitright

"Configure tab size
set tabstop=4
set shiftwidth=4
"set expandtab "indent with spaces
set noexpandtab "do not indent with spaces

"Get trailing characters on tab to view indents more easily
"set list
"set listchars=tab:\.\

set number
set relativenumber    "sets the line numbers relative to the current line
set nocompatible	  "no behaving like vi
set autoindent        "auto indentation when enter is pressed
set showmode          "shows vim current mode
"set wildmenu          "auto completion when ctrl+n is pressed
"set wildmode=longest,list,full
set incsearch         "searches as you type each letter
"set lazyredraw        "only redraws the screen when really needed
set foldenable        "allows code folding when zf is pressed. zd to unfold
"set noundofile       "do not save an undo file
set undofile
set undodir=/tmp      "Save undo files in tmp directory
"set nobackup         "do not save a backup file
set backup
set backupdir=/tmp    "Save backup files in tmp directory
set hlsearch
set ignorecase "search is case insensitive
set smartcase "case sensitive search in case the is an uppercase character in search
set background=dark

"set cursorline
"set cursorcolumn
highlight CursorLine cterm=underline gui=underline ctermbg=none ctermfg=none

" CMP settings
set completeopt=menu,menuone,noselect

" Vimwiki settings
let g:vimwiki_list = [{'path': '~/.config/nvim/vimwiki/'}]

" Open md files in Goyo
au BufReadPost *.md Goyo | set wrap
