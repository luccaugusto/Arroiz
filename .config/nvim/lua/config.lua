vim.opt.termguicolors = true
vim.cmd.colorscheme('melange')
require'colorizer'.setup({}, {
	RGB      = true;         -- #RGB hex codes
	RRGGBB   = true;         -- #RRGGBB hex codes
	names    = true;         -- "Name" codes like Blue
	RRGGBBAA = true;        -- #RRGGBBAA hex codes
	rgb_fn   = true;        -- CSS rgb() and rgba() functions
	hsl_fn   = true;        -- CSS hsl() and hsla() functions
	css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
	-- Available modes: foreground, background
	mode     = 'background'; -- Set the display mode.
})

require("nvim-autopairs").setup {}

vim.api.nvim_create_augroup("AutoFormat", {})

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
		pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !black --line-length 140 -q %")
            vim.cmd("edit")
        end,
    }
)

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
		pattern = {"*.js", "*.ts", "*.jsx", "*.tsx"},
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !prettier --log-level silent -w %")
            vim.cmd("edit")
        end,
    }
)

vim.keymap.set({"n", "i", "x"}, "<M-j>", "<Cmd>MultipleCursorsAddDown<CR>")
vim.keymap.set({"n", "i", "x"}, "<M-k>", "<Cmd>MultipleCursorsAddUp<CR>")
vim.keymap.set({"n", "i"}, "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>")
vim.keymap.set({"n", "x"}, "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>")

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "jsonc", "lua", "vim", "vimdoc", "query", "python", "javascript" },
  sync_install = false,
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require('telescope').setup{
	defaults = {
		layout_strategy = 'horizontal',
		layout_config = { height = 0.95, width = 0.85 },
		mappings = {
			i = {
				["<C-d>"] = "delete_buffer",
				["<C-j>"] = "preview_scrolling_down",
				["<C-k>"] = "preview_scrolling_up",
			}
		},
		file_ignore_patterns = {'node_modules/', '^.*/node_modules/', '__pycache__', '^.*/__pycache__/', '^.*/*.png', '^.*/*.jpg'}
	},
}

-- Setup comment nvim
require('Comment').setup()

-- setup nvim tree
require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 45,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
		custom = {
			"node_modules", -- filter out node_modules directory
		},
		exclude = {
			".env",
		},
	},
	disable_netrw = true,
	hijack_netrw = true,
	renderer = {
		highlight_git = true,
		root_folder_modifier = ":t",
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					deleted = "D",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
		},
	},
})

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-Space>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
		['<C-n>'] = cmp.mapping.select_next_item(select_opts),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name =  'path' },
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function()
	-- Mappings.
	vim.keymap.set("n", "gD",         vim.lsp.buf.declaration            , {buffer=0})
	vim.keymap.set("n", "gd",         vim.lsp.buf.definition             , {buffer=0})
	vim.keymap.set("n", "K",          vim.lsp.buf.hover                  , {buffer=0})
	vim.keymap.set("n", "gi",         vim.lsp.buf.implementation         , {buffer=0})
	vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename                 , {buffer=0})
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action            , {buffer=0})
	vim.keymap.set("n", "<Leader>dj", vim.diagnostic.goto_next           , {buffer=0})
	vim.keymap.set("n", "gr",         "<cmd>Telescope lsp_references<CR>", {buffer=0})
	vim.keymap.set("n", "<Leader>dk", vim.diagnostic.goto_prev           , {buffer=0})
	vim.keymap.set("n", "<Leader>dt", "<cmd>Telescope diagnostics<CR>"   , {buffer=0})
	--vim.keymap.set("n", "<Leader>fm", vim.lsp.buf.formatting             , {buffer=0})
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = {
			spacing = 4,
			prefix = '~',
		},
		-- Use a function to dynamically turn signs off
		-- and on, using buffer local variables
		signs = function(bufnr, client_id)
			local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
			-- No buffer local variable set, so just enable by default
			if not ok then
				return true
			end

			return result
		end,
	}
)

-- Copilot chat
require("CopilotChat").setup {
	debug = true,
	context = nil,
}

vim.keymap.set({'n', 'v'}, '<Leader>cp',
	function()
		local input = vim.fn.input("Quick Chat: ")
		if input ~= "" then
			require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
		end
	end
)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
local configs = require('lspconfig.configs')
local lspconfig = require('lspconfig')
-- local util = require("lspconfig.util")
--
-- if not configs.ruby_lsp then
-- 	local enabled_features = {
-- 		"documentHighlights",
-- 		"documentSymbols",
-- 		"foldingRanges",
-- 		"selectionRanges",
-- 		-- "semanticHighlighting",
-- 		"formatting",
-- 		"codeActions",
-- 	}
--
-- 	configs.ruby_lsp = {
-- 		default_config = {
-- 			cmd = { "ruby-lsp" },
-- 			filetypes = { "ruby" },
-- 			root_dir = util.root_pattern("Gemfile", ".git"),
-- 			init_options = {
-- 				--enabledFeatures = enabled_features,
-- 				formatter = "auto",
-- 			},
-- 		},
-- 		commands = {
-- 			FormatRuby = {
-- 				function()
-- 					vim.lsp.buf.format({
-- 						name = "ruby_lsp",
-- 						async = true,
-- 					})
-- 				end,
-- 				description = "Format using ruby-lsp",
-- 			},
-- 		},
-- 	}
-- end
--
-- lspconfig.ruby_lsp.setup({ on_attach = on_attach, capabilities = capabilities })

local servers = {
	'bashls',
	'clangd',
	'emmet_language_server',
	--'eslint',
	--'lua_ls',
	'phpactor',
	--'pylsp',
	'pyright',
	'quick_lint_js',
	--'rubocop',
	'ruby_lsp',
	--'ruff',
	'solargraph',
	'sqlls',
	'ts_ls',
	'yamlls',
}
for _, lsp in pairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

-- Configure intelephense separately to clean up home
lspconfig.intelephense.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { 'env', 'HOME=/tmp', 'intelephense', '--stdio' },
}

-- basedpyright is listed on server configurations but it's not working out of the box
--[[ require('lspconfig.configs').basedpyright = {
  default_config = {
    cmd = {"basedpyright-langserver", "--stdio"},
    filetypes = {'python'},
    root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git"),
	single_file_support = true,
    settings = {
	  basedpyright = {
		python = {
			pythonPath = ".venv/python3",
		},
	    analysis = {
		  autoSearchPaths = true,
		  diagnosticMode = "openFilesOnly",
		  useLibraryCodeForTypes = true
		}
	  }
	},
  };
}
lspconfig.basedpyright.setup{} ]]

local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end

--[[ sign({name = 'DiagnosticSignError', text = 'x'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = '»'}) ]]
