" _____     _______   _____  _______      _______   _________        _________
"/\   \    /*/   /  /*|   | /*|    \     /*/    |  /|   __   \      /        |
"\*\   \  /*/   /   |*|   | |*|     \   /*/     | |*|  | *|   |    /    _____|
" \*\   \/*/   /    |*|   | |*|  |\  \ /*/  /|  | |*|  | *|   |  *|    /
"  \*\   \/   /     |*|   | |*|  |*\  \*/  /*|  | |*|  |__|  /   *|   |
"   \*\      /      |*|   | |*|  |\*\     /|*|  | |*|   __  |    *|    \_____
"    \*\    /       |*|   | |*|  | \*\   / |*|  | |*|  |\*\  \   \*\         |
"     \*\__/        |*|___| |*|__|  \*\_/  |*|__| |*|__| \*\__\   \*\________|
"      
"
"maintainer:	Lucca Augusto

"Basic Settings
execute pathogen#infect()
execute pathogen#helptags()
filetype plugin indent on
syntax on
set smartindent
set breakindent

"Split pannels in a more natural way
set splitbelow
set splitright

"Configure tab size
set tabstop=4
set shiftwidth=4
"set expandtab

"Get trailing characters on tab to view indents more easily
"set list
"set listchars=tab:\.\ 

"Some more personal settings
"set relativenumber    "sets the line numbers relative to the current line
set number
set nocompatible
set autoindent        "auto indentation when enter is pressed
set showmode          "shows vim current mode
set wildmenu          "auto completion when ctrl+n is pressed
set incsearch         "searches as you type each letter
set lazyredraw        "only redraws the screen when really needed
set foldenable        "allows code folding when zf is pressed. zd to unfold
"set noundofile       "do not save an undo file
set undodir=/tmp/     "Save undo files in tmp directory
"set nobackup         "do not save a backup file
set backupdir=/tmp/   "Save backup files in tmp directory
set hlsearch

"Remap j and k so i can navigate on lines that break
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"Mappings to make things quicker
map <C-s> :w<CR>
nmap <C-s> :w<CR>

"Allow to copy and paste from the system register
vnoremap <C-y> "*y :let @+=@*<CR>
nnoremap <C-v> "+P

"Save a key press on changing windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Move faster between tabs
nnoremap <leader>j :tabNext<CR>

"Snippets
nnoremap <leader><space> :nohlsearch<CR>
nnoremap Y y$
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
inoremap { {<++>}<++><Esc>3h?<++><Enter>4xi
inoremap {<Enter> {<Enter><++><Enter>}<++><Esc>4h?<++><Enter>4xa
inoremap ( (<++>)<++><Esc>3h?<++><Enter>4xi
inoremap [ [<++>]<++><Esc>3h?<++><Enter>4xi
inoremap " "<++>"<++><Esc>3h?<++><Enter>4xi
inoremap ' '<++>'<++><Esc>3h?<++><Enter>4xi

"Some compile commands for these file types
au FileType tex map <buffer> <F10> :w<CR>:!pdflatex<Space>%<CR>
au FileType java map <buffer> <F10> :w<CR>:!javac<Space>%<CR>
au FileType java map <buffer> <F7> :!java<Space>'%:t:r'<CR>
