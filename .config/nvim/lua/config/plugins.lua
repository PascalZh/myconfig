local env = require('config.inject_env')
setmetatable(env, {__index = _G})
setfenv(1, env)

local packer = require('packer')

local packer_config = {
  -- profile = {
  --   enable = false,
  --   threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  -- },
  display = {
    open_fn = require('packer.util').float,
  },
  git = {
    clone_timeout = 5 * 60,
    --default_url_format = 'https://hub.fastgit.org/%s'
  },
}

local M = packer.startup {
  function (use)
    use {'wbthomason/packer.nvim'}

    use 'PascalZh/vim-color-explorer'
    use 'PascalZh/NeoSolarized'

    -- Neovim Library
    use 'nvim-lua/plenary.nvim'

    for _, plugin in ipairs(require'config.plugins_ui') do
      use(plugin)
    end

    for _, plugin in ipairs(require'config.plugins_editor') do
      use(plugin)
    end

    for _, plugin in ipairs(require'config.plugins_tool') do
      use(plugin)
    end

    for _, plugin in ipairs(require'config.plugins_ide') do
      use(plugin)
    end

    if MUtils.packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = packer_config
}

-- nvim-lua/completion-nvim (unused) {{{
--cmd('autocmd FileType '..
--  'haskell,python,vim,cpp,c,javascript,lua,markdown '..
--  'lua require"completion".on_attach()')

--map('i', '<C-space>', '<Plug>(completion_trigger)', {noremap = false})

--opt('completeopt', 'menuone,noinsert,noselect')
----cmd [[set shortmess+=c]]

----g.completion_enable_auto_popup = 1
--g.completion_enable_snippet = 'vim-vsnip'
----g.completion_timer_cycle = 80

--g.completion_trigger_keyword_length = 2
--g.completion_trigger_on_delete = 1
----g.completion_enable_server_trigger = 1

---- sumneko uses triggerCharacters ['\n', '\t', ' ', ...], it will cause
---- completion to trigger on space in VSCode, triggerCharacters are processed
---- differently, so it will not popup on space
--autocmd('CompletionTriggerCharacter', {
--  'BufEnter *.c,*.cpp let g:completion_enable_server_trigger = 1',
--  'BufEnter *.lua let g:completion_trigger_character = [".", ":"]'..
--    '|let g:completion_enable_server_trigger = 0'
--})

--g.completion_chain_complete_list = {
--  default = {
--    default = {
--      {complete_items = {'lsp'}},
--      {complete_items = {'snippet'}},
--      {complete_items = {'path'}, triggered_only = {'/'}},
--      {mode = 'keyn'}
--    },
--    comment = {
--      {mode = 'keyn'}
--    }
--  }
--}
----g.completion_auto_change_source = 0

--map('i', '<c-j>', '<Plug>(completion_next_source)', {noremap = false})
--map('i', '<c-k>', '<Plug>(completion_prev_source)', {noremap = false})
-- }}}
-- mhinz/vim-startify (unused) {{{
--g.startify_fortune_use_unicode = 1
--g.startify_files_number = 15
--g.startify_change_to_vcs_root = 0
---- g.startify_enable_unsafe = 1
--g.startify_lists = {
--  { type = 'bookmarks', header = {'   Bookmarks'}      },
--  { type = 'files'    , header = {'   MRU'}            },
--  { type = 'commands' , header = {'   Commands'}       },
--}
--g.startify_bookmarks = {}
--g.startify_commands = {
--  ':help startify',
--}
-- {'Vim Reference', 'h ref'},
-- {h = 'h ref'},
-- {m = {'My magical function', 'call Magic()'}},
-- }}}
-- tmsvg/pear-tree (unused) {{{
-- Default rules for matching:
--g.pear_tree_pairs = {
--  ['('] = {closer = ')'},
--  ['['] = {closer = ']'},
--  ['{'] = {closer = '}'},
--  ["'"] = {closer = "'"},
--  ['"'] = {closer = '"'},
--}
--cmd("au FileType markdown let b:pear_tree_pairs = {"..
--  "'(': {'closer': ')', 'not_at': ['lr']},"..
--  "'[': {'closer': ']', 'not_at': ['lr']},"..
--  "'{': {'closer': '}', 'not_at': ['lr']},"..
--  [["'": {'closer': "'"},]]..
--  [['"': {'closer': '"'},]]..
--  "}")

---- Pear Tree is enabled for all filetypes by default:
--g.pear_tree_ft_disabled = {}

---- Pair expansion is dot-repeatable by default:
--g.pear_tree_repeatable_expand = 0

---- Smart pairs are disabled by default:
--g.pear_tree_smart_openers = 1
--g.pear_tree_smart_closers = 1
--g.pear_tree_smart_backspace = 1

---- If enabled, smart pair functions timeout after 60ms:
--g.pear_tree_timeout = 60

---- Automatically map <BS>, <CR>, and <Esc>
--g.pear_tree_map_special_keys = 0
--map('i', '<BS>', '<Plug>(PearTreeBackspace)',{noremap=false})
--map('i', '<CR>', '<Plug>(PearTreeExpand)',{noremap=false})
--map('i', '<Space>', '<Plug>(PearTreeSpace)',{noremap=false})
--map('i', '<C-j>', '<Plug>(PearTreeJump)',{noremap=false})
-- remap of <ESC> will cause some conflicts with other plugins, so it will be
-- integrated in my `easy_jk` plugin.

-- Default mappings:
--imap <BS> <Plug>(PearTreeBackspace)
--imap <CR> <Plug>(PearTreeExpand)
--imap <Esc> <Plug>(PearTreeFinishExpansion)
-- Pear Tree also makes <Plug> mappings for each opening and closing string.
--     :help <Plug>(PearTreeOpener)
--     :help <Plug>(PearTreeCloser)

-- Not mapped by default:
-- <Plug>(PearTreeSpace)
-- <Plug>(PearTreeJump)
-- <Plug>(PearTreeExpandOne)
-- <Plug>(PearTreeJNR)
-- }}}
-- jose-elias-alvarez/buftabline.nvim (unused) {{{
--require("buftabline").setup {
--  modifier = ":t",
--  index_format = "%d: ",
--  buffer_id_index = false,
--  padding = 1,
--  icons = true,
--  icon_colors = 'normal',
--  start_hidden = false,
--  auto_hide = true,
--  disable_commands = false,
--  go_to_maps = true,
--  kill_maps = false,
--  next_indicator = ">",
--  custom_command = nil,
--  custom_map_prefix = nil,
--  hlgroup_current = "TabLineSel",
--  hlgroup_normal = "TabLineFill",
--}
-- }}}

vim.cmd [[
" or if you would like to use right click
nnoremap <RightMouse> <Nop>
nnoremap <silent> <RightDrag> <Cmd>lua require("gesture").draw()<CR>
nnoremap <silent> <RightRelease> <Cmd>lua require("gesture").finish()<CR>
]]

return M
