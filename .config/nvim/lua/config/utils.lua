_G.MUtils = MUtils == nil and {} or MUtils
local M = {}
local cmd = vim.cmd
local _map_key = vim.api.nvim_set_keymap

local shell = vim.o.shell
local shellcmdflag = vim.o.shellcmdflag

M.prefix = {
  autocmd = 'My',
  statusline_func = 'MyStatusLineFunc_',
  func = 'My'
}

function M.autocmd(group, cmds, clear)
  clear = clear == nil and false or clear
  if type(cmds) == 'string' then cmds = {cmds} end
  cmd('augroup ' .. M.prefix.autocmd .. group)
  if clear then
    cmd 'au!'
  end
  for _, c in ipairs(cmds) do
    cmd('autocmd ' .. c)
  end
  cmd 'augroup END'
end

-- By default noremap
function M.map_key(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true

  modes = type(modes) == 'string' and {modes} or modes
  for _, mode in ipairs(modes) do
    _map_key(mode, lhs, rhs, opts)
  end
end

function M.remap_key(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = false

  modes = type(modes) == 'string' and {modes} or modes
  for _, mode in ipairs(modes) do
    _map_key(mode, lhs, rhs, opts)
  end
end

---------------------------------- MUtils --------------------------------------

MUtils.toggle_background = function ()
  if vim.opt.background == 'dark' then
    vim.opt.background = 'light'
  else
    vim.opt.background = 'dark'
  end
end

-- im_select {{{
-- A module to switch input method in normal mode
MUtils.im_select = {
  opt = {normal_imkey = '1033'}
}

MUtils.im_select.insert_leave_pre = function ()
  local Job = require'plenary.job'

  MUtils.im_select.cancel_switch_to_normal_imkey_job = false

  Job:new({
    command = shell,
    args = {shellcmdflag, 'im-select.exe'},
    on_stdout = function (j, return_val)

      MUtils.im_select.last_imkey = return_val

      if not MUtils.im_select.cancel_switch_to_normal_imkey_job then
        Job:new({
          command = shell,
          args = {shellcmdflag, 'im-select.exe '..MUtils.im_select.opt.normal_imkey}
        }):start()
      end

    end
  }):start()
end

MUtils.im_select.insert_enter = function ()
  local Job = require'plenary.job'

  MUtils.im_select.cancel_switch_to_normal_imkey_job = true

  Job:new({
    command = shell,
    args = {shellcmdflag, 'im-select.exe '..
      (MUtils.im_select.last_imkey or MUtils.im_select.opt.normal_imkey)}
  }):start()
end
-- }}}

MUtils.highlight = {}

function MUtils.highlight.on_yank(args)
  if (vim.b.visual_multi == nil) then
    vim.highlight.on_yank(args)
  end
end

return M

