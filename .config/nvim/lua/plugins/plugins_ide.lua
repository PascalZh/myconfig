local M = {}

table.insert(M, {
  'williamboman/mason.nvim',
  after = 'nvim-lspconfig',
  config = function() require('mason').setup() end
})

table.insert(M, {
  'williamboman/mason-lspconfig.nvim',
  after = 'mason.nvim',
  config = function()
    require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls', 'pylsp' } })
    require('mason-lspconfig').setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require('lspconfig')[server_name].setup({})
      end,
      -- Next, you can provide a dedicated handler for specific servers.
      -- For example, a handler override for the `rust_analyzer`:
      ['rust_analyzer'] = function() require('rust-tools').setup({}) end,
      ['lua_ls'] = function()
        require('lspconfig').lua_ls.setup({
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. '/.luarc.json') and
                not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua,
                {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                  },
                  diagnostics = { globals = { 'vim' } },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    library = { vim.env.VIMRUNTIME }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file('', true)
                  }
                })

              client.notify('workspace/didChangeConfiguration',
                { settings = client.config.settings })
            end
            return true
          end
        })
      end
    })
  end
})

table.insert(M, 'rafamadriz/friendly-snippets')
table.insert(M, {
  'L3MON4D3/LuaSnip',
  config = function() require('luasnip.loaders.from_vscode').lazy_load() end
})

table.insert(M, {
  'simrat39/symbols-outline.nvim',
  disable = true,
  cond = MUtils.not_vscode,
  config = function()
    vim.cmd('au FileType Outline setlocal nowrap | setlocal nolist | setlocal signcolumn=no')
    vim.g.symbols_outline = { width = 50 }
  end
})

table.insert(M, {
  'nvim-treesitter/nvim-treesitter',
  cond = MUtils.not_vscode,
  run = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'c', 'lua', 'python', 'vim', 'vimdoc', 'haskell', 'cpp', 'fish' },
      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false
      },

      auto_install = true,

      indent = { enable = true },
      autopairs = { enable = true },
      rainbow = {
        enable = true,
        -- disable = { 'jsx', 'cpp' }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil  -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
      matchup = {
        enable = true -- mandatory, false will disable the whole extension
        -- disable = { 'c', 'ruby' },  -- optional, list of language that will be disabled
      }
    })
    if vim.fn.has('win32') == 1 then require('nvim-treesitter.install').compilers = { 'clang' } end
  end
})

-- use {'nvim-lua/completion-nvim', dependencies = {'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'}}

table.insert(M, {
  'neovim/nvim-lspconfig',
  config = function()
    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<M-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl',
          function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, opts)
      end
    })
  end
})

table.insert(M, {
  'mhartington/formatter.nvim',
  config = function()
    -- Utilities for creating configurations
    local util = require('formatter.util')

    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require('formatter').setup({
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
          require('formatter.filetypes.lua').luaformat
        },

        -- Use the special '*' filetype for defining formatter configurations on
        -- any filetype
        ['*'] = {
          -- 'formatter.filetypes.any' defines default configurations for any
          -- filetype
          require('formatter.filetypes.any').remove_trailing_whitespace
        }
      }
    })
    vim.cmd([[
    nnoremap <silent> <M-F> :Format<CR>
    ]])
  end
})

table.insert(M, {
  'lewis6991/gitsigns.nvim',
  cond = MUtils.not_vscode,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function() require('gitsigns').setup() end
})

-- develop nvim plugins
table.insert(M, {
  'mfussenegger/nvim-dap',
  cond = MUtils.not_vscode,
  config = function()
    local dap = require('dap')
    dap.configurations.lua = {
      { type = 'nlua', request = 'attach', name = 'Attach to running Neovim instance' }
    }

    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8088 })
    end
  end
})

table.insert(M, {
  'jbyuki/one-small-step-for-vimkind',
  cond = MUtils.not_vscode,
  dependencies = 'mfussenegger/nvim-dap'
})

-- Language support
table.insert(M, { 'lervag/vimtex', ft = { 'tex', 'latex' } })

table.insert(M, {
  'plasticboy/vim-markdown',
  config = function()
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_new_list_item_indent = 2
  end
})

table.insert(M, 'enomsg/vim-haskellConcealPlus')

table.insert(M, 'neovimhaskell/haskell-vim')

table.insert(M, 'dag/vim-fish')

return M
