"                              ___           ___           ___     
"     ___        ___          /__/\         /  /\         /  /\    
"    /__/\      /  /\        |  |::\       /  /::\       /  /:/    
"    \  \:\    /  /:/        |  |:|:\     /  /:/\:\     /  /:/     
"     \  \:\  /__/::\      __|__|:|\:\   /  /:/~/:/    /  /:/  ___ 
" ___  \__\:\ \__\/\:\__  /__/::::| \:\ /__/:/ /:/___ /__/:/  /  /\
"/__/\ |  |:|    \  \:\/\ \  \:\~~\__\/ \  \:\/:::::/ \  \:\ /  /:/
"\  \:\|  |:|     \__\::/  \  \:\        \  \::/~~~~   \  \:\  /:/ 
" \  \:\__|:|     /__/:/    \  \:\        \  \:\        \  \:\/:/  
"  \__\::::/      \__\/      \  \:\        \  \:\        \  \::/   
"      ~~~~                   \__\/         \__\/         \__\/    
"                                                        
"maintainer:	Lucca Augusto

"============================
"      Basic Settings
"============================
	execute pathogen#infect()
	execute pathogen#helptags()
	filetype plugin indent on
	syntax on
	set smartindent
	set breakindent

	colorscheme wal
	
	"Split panels in a more natural way
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
	set number
	set relativenumber    "sets the line numbers relative to the current line
	set nocompatible
	set autoindent        "auto indentation when enter is pressed
	set showmode          "shows vim current mode
	set wildmenu          "auto completion when ctrl+n is pressed
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
	set wildmode=longest,list,full
	set ignorecase "search is case insensitive
	set smartcase "case sensitive search in case the is an uppercase character in search
	
	"Remap j and k so i can navigate on lines that break
	nnoremap j gj
	nnoremap k gk
	vnoremap j gj
	vnoremap k gk

"==============================
"        StatusLine
"=============================
set laststatus=2
set statusline=
set statusline+=%8*\ [%n]                 " buffernr
set statusline+=%8*\ %<%F\ %m\ %r\ %w\ 	  " File+path
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%9*\ %=                   " Space
set statusline+=%8*\ %y\                  " FileType
set statusline+=%8*\ %-3(%{FileSize()}%)  " File size
set statusline +=%1*%=%5l%*				  "current line
set statusline +=%2*/%L%*				  "total lines

hi User1 ctermfg=007 ctermbg=003
hi User2 ctermfg=007 ctermbg=003
hi User3 ctermfg=007 ctermbg=003
hi User4 ctermfg=007 ctermbg=003
hi User5 ctermfg=007 ctermbg=003
hi User7 ctermfg=007 ctermbg=003
hi User8 ctermfg=007 ctermbg=003
hi User9 ctermfg=007 ctermbg=003


"===============================
"Mappings to make things quicker
"===============================
	map <C-s> :w<CR>
	nmap <C-s> :w<CR>
	nmap <leader>w :wq<CR>
	nnoremap <leader>c :close<CR>
	nnoremap <leader>o :q<CR>

	"Spell checking
	nnoremap <leader>p :set spell spelllang=pt_br<CR>
	nnoremap <leader>e :set spell spelllang=en_us<CR>

	"Splits
	nnoremap <leader>v :vsplit 
	nnoremap <leader>s :split 

	"Tabs
	nnoremap <leader>t :tabedit 
	"Move faster between tabs
	nnoremap <leader>j :tabnext<CR>
	nnoremap <leader>k :tabprevious<CR>

	nnoremap <leader>f :filetype detect<CR>
	
	"Allow to copy and paste from the system register
	vnoremap <C-y> "*y :let @+=@*<CR>
	nnoremap <C-p> "+P
	
	"Save a key press on changing windows
	nnoremap <C-h> <C-w>h
	nnoremap <C-j> <C-w>j
	nnoremap <C-k> <C-w>k
	nnoremap <C-l> <C-w>l

"update bindings when sxhkd config is updated
	autocmd BufWritePost sxhkdrc killall sxhkd; setsid sxhkd &
"recompile suckless programs after editing
	autocmd BufWritePost dwm.c !sudo make clean; sudo make; sudo make install
	autocmd BufWritePost config.def.h !sudo make clean;sudo make; sudo make install
	autocmd BufWritePost st.c !sudo make clean; sudo make; sudo make install

"===============================
"SNIPPETS
"===============================

	"insert tags like this <++> for faster navigation
	"when inserting brackets, etc.
	"Snippets
	nnoremap <leader><space> :nohlsearch<CR>
	inoremap <Space><Space> <Esc>/<++><CR>"_c4l
	inoremap { {<++>}<++><Esc>3h?<++><CR>4xi
	inoremap {<CR> {<CR><++><CR>}<++><Esc>4h?<++><CR>4xa
	inoremap ( (<++>)<++><Esc>3h?<++><CR>4xi
	inoremap () ()
	inoremap [ [<++>]<++><Esc>3h?<++><CR>4xi
	"inoremap " "<++>"<++><Esc>3h?<++><CR>4xi
	"inoremap ' '<++>'<++><Esc>3h?<++><CR>4xi
	au FileType c inoremap /* /*<++> */<++><Esc>3h?<++><CR>4xi
	au FileType c inoremap /*<CR> /*<CR><++><CR> */<++><Esc>4h?<++><CR>4xa
	
	"Some compile commands for these file types
	au FileType tex map <buffer> <F10> :w<CR>:!pdflatex<Space>%<CR>
	au FileType java map <buffer> <F10> :w<CR>:!javac<Space>%<CR>
	au FileType java map <buffer> <F7> :!java<Space>'%:t:r'<CR>
	au FileType c map <buffer> <F10> :w<CR>:!gcc<Space>-o<Space>expand('%:t:r').out<Space>expand('%:t')<CR>
	au FileType sh inoremap [ [ <++> ]<++><Esc>3h?<++><CR>4xi

	"Some scripts to make things quicker when creating specific files
	au FileType c map <buffer> <F9> :Bc<CR>
	au FileType java map <buffer> <F9> :Bj<CR>

"====================================
"			Functions
"===================================
command! Bc call BeginC()
function! BeginC()
	normal! i#include <stdlib.h>
	normal! o#include <stdio.h>
	normal! o
	normal! oint main()
	normal! o{
	normal! o
	normal! oreturn 0;
	normal! o}
	normal! 2k
endfunction

command! Bj call BeginJ()
function! BeginJ()
	normal! ipublic class <++> {
	normal! o
	normal! opublic static void main(String[] args) {
	normal! o
	normal! o}
	normal! o}
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif
  if bytes <= 0
    return '0'
  endif
  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

