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

hi User1 ctermfg=000 ctermbg=003
hi User2 ctermfg=000 ctermbg=003
hi User3 ctermfg=000 ctermbg=003
hi User4 ctermfg=000 ctermbg=003
hi User5 ctermfg=000 ctermbg=003
hi User7 ctermfg=000 ctermbg=003
hi User8 ctermfg=000 ctermbg=003
hi User9 ctermfg=000 ctermbg=003
