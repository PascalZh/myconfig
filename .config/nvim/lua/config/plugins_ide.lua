local M = {}

table.insert(M, {
	"williamboman/mason.nvim",
	after = "nvim-lspconfig",
	config = function()
		require("mason").setup()
	end,
})

table.insert(M, {
	"williamboman/mason-lspconfig.nvim",
	after = "mason.nvim",
	config = function()
		require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "pylsp" } })
		require("mason-lspconfig").setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({})
			end,
			-- Next, you can provide a dedicated handler for specific servers.
			-- For example, a handler override for the `rust_analyzer`:
			["rust_analyzer"] = function()
				require("rust-tools").setup({})
			end,
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if
							not vim.loop.fs_stat(path .. "/.luarc.json")
							and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
						then
							client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
								runtime = {
									-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
								},
								-- Make the server aware of Neovim runtime files
								workspace = {
									library = { vim.env.VIMRUNTIME },
									-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
									-- library = vim.api.nvim_get_runtime_file('', true)
								},
							})

							client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						end
						return true
					end,
				})
			end,
		})
	end,
})

table.insert(M, "rafamadriz/friendly-snippets")
table.insert(M, {
	"L3MON4D3/LuaSnip",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
})

table.insert(M, {
	"simrat39/symbols-outline.nvim",
	disable = true,
	cond = MUtils.not_vscode,
	config = function()
		vim.cmd("au FileType Outline setlocal nowrap | setlocal nolist | setlocal signcolumn=no")
		vim.g.symbols_outline = {
			width = 50,
		}
	end,
})

table.insert(M, {
	"nvim-treesitter/nvim-treesitter",
	cond = MUtils.not_vscode,
	run = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "python", "vim", "vimdoc", "haskell", "cpp", "fish" },
			highlight = {
				enable = true, -- false will disable the whole extension
				additional_vim_regex_highlighting = false,
			},

			auto_install = true,

			indent = {
				enable = true,
			},
			autopairs = {
				enable = true,
			},
			rainbow = {
				enable = true,
				-- disable = { 'jsx', 'cpp' }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			matchup = {
				enable = true, -- mandatory, false will disable the whole extension
				-- disable = { 'c', 'ruby' },  -- optional, list of language that will be disabled
			},
		})
		if vim.fn.has("win32") == 1 then
			require("nvim-treesitter.install").compilers = { "clang" }
		end
	end,
})

-- Completion sources
table.insert(M, { "hrsh7th/cmp-buffer", after = "nvim-cmp" })
--table.insert(M, { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' })
table.insert(M, { "hrsh7th/cmp-nvim-lsp", cond = MUtils.not_vscode })

table.insert(M, {
	"hrsh7th/nvim-cmp",
	after = { "nvim-autopairs", "cmp-nvim-lsp", "LuaSnip" },
	config = function()
		-- hrsh7th/nvim-cmp {{{
		local cmp = require("cmp")

		vim.opt.completeopt = { "menu", "menuone", "noselect" }

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local feedkey = function(key, mode)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		end

		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					--vim.fn['vsnip#anonymous'](args.body)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = { documentation = cmp.config.window.bordered() },
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() and not luasnip.in_snippet() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() and not luasnip.in_snippet() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				-- { name = 'vsnip' }, -- For vsnip users.
				{ name = "luasnip" }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, {
				{ name = "buffer" },
			}),
		})
		-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
		MUtils.capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- you need setup cmp first put this after cmp.setup() {{{
		-- If you want insert `(` after select function or method item
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on(
			"confirm_done",
			cmp_autopairs.on_confirm_done({
				map_char = {
					tex = "",
				},
			})
		)

		-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { 'clojure', 'clojurescript', 'fennel', 'janet' }
		--cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = 'racket'
		-- }}}

		-- }}}
	end,
})

-- use {'nvim-lua/completion-nvim', requires = {'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'}}

table.insert(M, {
	"neovim/nvim-lspconfig",
	after = "nvim-cmp",
	config = function()
		-- Global mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
	end,
})

table.insert(M, {
	"mhartington/formatter.nvim",
	config = function()
		-- Utilities for creating configurations
		local util = require("formatter.util")

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup({
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.WARN,
			-- All formatter configurations are opt-in
			filetype = {
				-- Formatter configurations for filetype 'lua' go here
				-- and will be executed in order
				lua = {
					-- 'formatter.filetypes.lua' defines default configurations for the
					-- 'lua' filetype
					require("formatter.filetypes.lua").stylua,
				},

				-- Use the special '*' filetype for defining formatter configurations on
				-- any filetype
				["*"] = {
					-- 'formatter.filetypes.any' defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})
		vim.cmd([[
    nnoremap <silent> <M-F> :Format<CR>
    ]])
	end,
})

table.insert(M, {
	"lewis6991/gitsigns.nvim",
	cond = MUtils.not_vscode,
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitsigns").setup()
	end,
})

-- develop nvim plugins
table.insert(M, {
	"mfussenegger/nvim-dap",
	cond = MUtils.not_vscode,
	config = function()
		local dap = require("dap")
		dap.configurations.lua =
			{ {
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
			} }

		dap.adapters.nlua = function(callback, config)
			callback({
				type = "server",
				host = config.host or "127.0.0.1",
				port = config.port or 8088,
			})
		end
	end,
})

table.insert(M, {
	"jbyuki/one-small-step-for-vimkind",
	cond = MUtils.not_vscode,
	requires = "mfussenegger/nvim-dap",
})

-- Language support
table.insert(M, { "lervag/vimtex", ft = { "tex", "latex" } })

table.insert(M, {
	"plasticboy/vim-markdown",
	config = function()
		vim.g.vim_markdown_math = 1
		vim.g.vim_markdown_folding_disabled = 1
		vim.g.vim_markdown_new_list_item_indent = 2
	end,
})

table.insert(M, "enomsg/vim-haskellConcealPlus")

table.insert(M, "neovimhaskell/haskell-vim")

table.insert(M, "dag/vim-fish")

return M
