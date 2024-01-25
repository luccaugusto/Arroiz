"===============================
"Mappings to make things quicker
"===============================

"Remap j and k so i can navigate on lines that break
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"gp selects pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
"Remap p for autoindenting
nnoremap <leader>P p
nnoremap p p`[v`]=

"open a terminal
nnoremap <leader>s :terminal<CR>
nnoremap <leader>ht :split<CR>:terminal<CR>
nnoremap <leader>vt :vsplit<CR>:terminal<CR>
nnoremap <leader>tt :tabnew<CR>:terminal<CR>

nnoremap <leader>b :buffers<CR>:bd<space>

"Add a FIXME tag for selected lines
noremap <leader>cf :s/^/\/*FIXME*\//<CR>:nohlsearch<CR>
noremap <leader>crf :s/^\/\*FIXME\*\///<CR>:nohlsearch<CR>

map <C-s> :w<CR>
nmap <C-s> :w<CR>
nnoremap <leader>cc :close<CR>
nnoremap <leader>E :Explore<CR>
nnoremap <leader>o :q<CR>
nnoremap <leader>L :30Lex<CR>

nnoremap <leader>w :set wrap<CR>
nnoremap <leader>nw :set nowrap<CR>

"indenting on visual
vnoremap > >gv
vnoremap < <gv

"Spell checking
nnoremap <leader>p :set spell spelllang=pt_br<CR>
nnoremap <leader>e :set spell spelllang=en_us<CR>

"Splits
nnoremap <leader>vs :vsplit<space>
nnoremap <leader>hs :split<space>

"Tabs
nnoremap <leader>t :tabnew<CR>
"Move faster between tabs
nnoremap <leader>j :tabnext<CR>
nnoremap <leader>k :tabprevious<CR>

nnoremap <leader>f :filetype detect<CR>

"Allow to copy and paste from the system register
" Only used on vim, nvim can copy and pastewith y and p
"vnoremap <C-y> "*y :let @+=@*<CR>
"nnoremap <C-p> "+p

"Save a key press on changing windows
"only sideways because C-j and C-k are
"for moving lines around
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"Faster resizing
nnoremap <leader>A 5<C-w>>
nnoremap <leader>S 5<C-w><

"center cursor on search and J cmd
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

"move entire lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
"i always use visual mode for moving lines up and down
"nnoremap <C-j> :m .+1<CR>==
"nnoremap <C-k> :m .-2<CR>==

"toogle hl CursorLine
nnoremap <leader>hl :set cursorline<CR>
nnoremap <leader>nhl :set nocursorline<CR>

"===============================
"DRAG VISUALS PLUGIN
"===============================
vmap  <expr>  <c-h>  DVB_Drag('left')
vmap  <expr>  <c-l>  DVB_Drag('right')
vmap  <expr>  <c-j>  DVB_Drag('down')
vmap  <expr>  <c-k>  DVB_Drag('up')
vmap  <expr>  <c-d>  DVB_Duplicate()

"===============================
"TELESCOPE
"===============================
nnoremap <c-p> :Telescope find_files<CR>
nnoremap <c-b> :Telescope buffers<CR>
nnoremap <c-g>g :Telescope live_grep<CR>

"===============================
"SNIPPETS
"===============================

"break one line functions into multiple lines
vnoremap <leader>s :s/,/,\r/g<CR>va(:s/(/(\r/g<CR>va(:s/)/\r)/g<CR>va(=:nohlsearch<CR>
"one line functions into only one line
vnoremap <leader>l :s/,\n\s*/, /g<CR>va(:s/\n\s*)/)/g<CR>va(:s/(\n\s*/(/g<CR>:nohlsearch<CR>

"insert tags like this <++> for faster navigation
"when inserting brackets, etc.
"Snippets
nnoremap <space><space> :nohlsearch<CR>
"inoremap <leader><Space> <Esc>/<++><CR>"_c4l
inoremap jf <Esc>/<++><CR>"_c4l

"with smart undo
inoremap { {}<++><Esc>4hi
inoremap {<CR> {<CR>}<Esc>ko
inoremap {jf {}
inoremap ( ()<++><Esc>4hi
inoremap (jf ()
inoremap () ()
inoremap [ []<++><Esc>4hi

"smart undo at breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap } }<c-g>u
inoremap ] ]<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ; ;<c-g>u
inoremap ) )<c-g>u

"inoremap " ""<++><Esc>3h?<++><CR>4xi
"inoremap ' ''<++><Esc>3h?<++><CR>4xi
au FileType sh inoremap [ [  ]<++><Esc>5hi
au FileType c inoremap /* /*  */<++><Esc>6hi
au FileType c inoremap /*<CR> /* <CR><CR> */<++><Esc>ka
au FileType h inoremap /* /*  */<++><Esc>6hi
au FileType h inoremap /*<CR> /* <CR><CR> */<++><Esc>ka
au FileType tex nnoremap <leader>li o<CR>\begin{figure}[ht]<CR>\centering<CR>\includegraphics[width=.5\textwidth]{<++>}<CR>\caption{<++>}<CR>\label{<++>}<CR>\end{figure}<Esc>4k/<++><CR>"_c4l
