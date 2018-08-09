"maintainer:	Lucca Augusto	
" Last change:	2017 Jun 18
"
" File copied from vimtutor and modified
"
"

"execute pathogen#infect()
filetype plugin indent on
set tabstop=4
set shiftwidth=4
"set expandtab
set smartindent
set breakindent
set list
set listchars=tab:\.\ 

syntax on
autocmd Filetype tex setl updatetime=1000


"set relativenumber    "sets the line numbers relative to the current line
set number
set nocompatible
set autoindent        "auto indentation when enter is pressed
set showmode          "shows vim current mode
set wildmenu          "auto completion when ctrl+n is pressed
set incsearch         "searches as you type each letter
set lazyredraw        "only redraws the screen when really needed
set foldenable        "allows code folding when zf is pressed. zd to unfold


nnoremap j gj
nnoremap k gk
nnoremap <leader><space> :nohlsearch<CR>
nnoremap Y y$ 
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
inoremap { {<++>}<++><Esc>hhh?<++><Enter>xxxxi
inoremap {<Enter> {<Enter><++><Enter>}<++><Esc>hhhh?<++><Enter>xxxxa
inoremap ( (<++>)<++><Esc>hhh?<++><Enter>xxxxi
inoremap [ [<++>]<++><Esc>hhh?<++><Enter>xxxxi
inoremap " "<++>"<++><Esc>hhh?<++><Enter>xxxxi
inoremap ' '<++>'<++><Esc>hhh?<++><Enter>xxxxi

au FileType tex map <buffer> <F10> :w<CR>:!pdflatex<Space>%<CR>
au FileType java map <buffer> <F10> :w<CR>:!javac<Space>%<CR>
au FileType java map <buffer> <F7> :!java<Space>'%:t:r'<CR>



"~~~~~~~~~~~~~vimtutor file~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
"source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  "set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif


