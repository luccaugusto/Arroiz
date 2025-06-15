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
"
"============================
"         Plugins
"============================

"auto install plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

	Plug 'elkowar/yuck.vim'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'

	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	Plug 'windwp/nvim-autopairs'

	Plug 'luccaugusto/melange-nvim'

	Plug 'tpope/vim-rails'
	Plug 'tpope/vim-fugitive'
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'

	Plug 'MunifTanjim/prettier.nvim'

	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'

	Plug 'numToStr/Comment.nvim'

	" telescope requirements...
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-fzy-native.nvim'

	Plug 'junegunn/goyo.vim'
	Plug 'vimwiki/vimwiki'
	Plug 'tpope/vim-endwise'

	Plug 'github/copilot.vim'

	Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}

	Plug 'norcalli/nvim-colorizer.lua'

	" load local plugin folder
	Plug expand('%:p:h') . 'plugin/vmath.vim'
	Plug expand('%:p:h') . 'plugin/dragvisuals.vim'

call plug#end()

"============================
"      Basic Settings
"============================
filetype plugin indent on
syntax on

"get rid of trailling spaces
autocmd BufWritePre * %s/\s\+$//e

"Custom indentation rules
autocmd Filetype html              setlocal shiftwidth=4 tabstop=4 expandtab
autocmd Filetype php               setlocal shiftwidth=4 tabstop=4 expandtab
autocmd Filetype rs                setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd Filetype javascript        setlocal shiftwidth=2 tabstop=2 expandtab
autocmd Filetype typescript        setlocal shiftwidth=2 tabstop=2 expandtab
autocmd Filetype typescriptreact   setlocal shiftwidth=2 tabstop=2 expandtab

let loaded_netrwPlugin = 1

lua require("config")
