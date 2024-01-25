require('telescope').setup{
	defaults = {
		layout_strategy = 'vertical',
		layout_config = { height = 0.95, width = 0.85 },
		mappings = {
			i = {
				["<C-d>"] = "delete_buffer",
			}
		},
		file_ignore_patterns = {'node_modules/', '^.*/node_modules/', '^.*/vendor/', '__pycache__', '^.*/__pycache__/', '^.*/*.png', '^.*/*.jpg'}
	},
}

-- Setup comment nvim
require('Comment').setup()

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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
local configs = require('lspconfig.configs')
local lspconfig = require('lspconfig')

local servers = {
	'quick_lint_js',
	'phpactor',
	'bashls' ,
	'tsserver',
	'eslint',
	'pylsp',
	'rubocop',
	'solargraph',
	'emmet_language_server'
}
 for _, lsp in pairs(
	 servers
	 ) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end
-- Configure intelephense separately to clean up home
lspconfig.intelephense.setup{
	on_attach = on_attach,
	cmd = { 'env', 'HOME=/tmp', 'intelephense', '--stdio' },
}

local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end

sign({name = 'DiagnosticSignError', text = 'x'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = '»'})
