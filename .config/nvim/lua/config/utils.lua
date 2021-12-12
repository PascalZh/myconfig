_G.MUtils = MUtils == nil and {} or MUtils
local M = {}
local cmd = vim.cmd
local o_s = vim.o
local _map_key = vim.api.nvim_set_keymap

local Job = require'plenary.job'
local shell = vim.o.shell
local shellcmdflag = vim.o.shellcmdflag

M.prefix = {
  autocmd = 'My',
  statusline_func = 'MyStatusLineFunc_',
  func = 'My'
}

function M.opt(o, v, scopes)
  scopes = scopes or {o_s}
  for _, s in ipairs(scopes) do
    s[o] = v
  end
end

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
  opts.noremap = flase

  modes = type(modes) == 'string' and {modes} or modes
  for _, mode in ipairs(modes) do
    _map_key(mode, lhs, rhs, opts)
  end
end

---------------------------------- MUtils --------------------------------------

MUtils.toggle_background = function ()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end

-- im_select {{{
MUtils.im_select = {
  opt = {normal_imkey = '1033'}
}

MUtils.im_select.insert_leave_pre = function ()

  MUtils.im_select.cancel_switch_to_normal_imkey_job = false

  Job:new({
    command = shell,
    args = {shellcmdflag, 'im-select.exe'},
    on_stdout = function (j, return_val)

      MUtils.im_select.last_imkey = return_val

      if not MUtils.im_select.cancel_switch_to_normal_imkey_job then
        Job:new({command = shell,
          args = {shellcmdflag, 'im-select.exe '..MUtils.im_select.opt.normal_imkey}}):start()
      end

    end
  }):start()
end

MUtils.im_select.insert_enter = function ()

  MUtils.im_select.cancel_switch_to_normal_imkey_job = true

  Job:new({command = shell,
    args = {shellcmdflag, 'im-select.exe '..
    (MUtils.im_select.last_imkey or MUtils.im_select.opt.normal_imkey)}}):start()
end
-- }}}

MUtils.highlight = {}

function MUtils.highlight.on_yank(args)
  if (vim.b.visual_multi == nil) then
    vim.highlight.on_yank(args)
  end
end

return M

