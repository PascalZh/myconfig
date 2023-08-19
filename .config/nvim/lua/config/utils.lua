local M = {}
_G.MUtils = MUtils == nil and {} or MUtils

MUtils.not_vscode = function() return not vim.g.vscode end

M.prefix = {
  autocmd = 'MyAutocmd',
  statusline_func = 'MyStatusLineFunc_',
  func = 'MyFunc',
  notify_title = 'nvim-config'
}

-- By default noremap
function M.map_key(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true

  modes = type(modes) == 'string' and { modes } or modes
  for _, mode in ipairs(modes) do vim.api.nvim_set_keymap(mode, lhs, rhs, opts) end
end

function M.remap_key(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = false

  modes = type(modes) == 'string' and { modes } or modes
  for _, mode in ipairs(modes) do vim.api.nvim_set_keymap(mode, lhs, rhs, opts) end
end

M.map_helpers = { map_key = M.map_key, remap_key = M.remap_key }

function M.map_helpers.imap_key(lhs, rhs, opts) M.map_key('i', lhs, rhs, opts) end
function M.map_helpers.nmap_key(lhs, rhs, opts) M.map_key('n', lhs, rhs, opts) end
function M.map_helpers.vmap_key(lhs, rhs, opts) M.map_key('v', lhs, rhs, opts) end
function M.map_helpers.xmap_key(lhs, rhs, opts) M.map_key('v', lhs, rhs, opts) end
function M.map_helpers.omap_key(lhs, rhs, opts) M.map_key('o', lhs, rhs, opts) end
function M.map_helpers.nvmap_key(lhs, rhs, opts) M.map_key({ 'n', 'v' }, lhs, rhs, opts) end
function M.map_helpers.nvomap_key(lhs, rhs, opts) M.map_key({ 'n', 'v', 'o' }, lhs, rhs, opts) end
function M.map_helpers.lmap_key(lhs, rhs, opts) M.map_key('l', lhs, rhs, opts) end
function M.map_helpers.iremap_key(lhs, rhs, opts) M.remap_key('i', lhs, rhs, opts) end
function M.map_helpers.nremap_key(lhs, rhs, opts) M.remap_key('n', lhs, rhs, opts) end
function M.map_helpers.vremap_key(lhs, rhs, opts) M.remap_key('v', lhs, rhs, opts) end
function M.map_helpers.xremap_key(lhs, rhs, opts) M.remap_key('v', lhs, rhs, opts) end
function M.map_helpers.oremap_key(lhs, rhs, opts) M.remap_key('o', lhs, rhs, opts) end
function M.map_helpers.nvremap_key(lhs, rhs, opts) M.remap_key({ 'n', 'v' }, lhs, rhs, opts) end
function M.map_helpers.nvoremap_key(lhs, rhs, opts) M.remap_key({ 'n', 'v', 'o' }, lhs, rhs, opts) end
function M.map_helpers.lremap_key(lhs, rhs, opts) M.remap_key('l', lhs, rhs, opts) end

M.toggle_background = function()
  if vim.opt.background:get() == 'dark' then
    vim.opt.background = 'light'
  else
    vim.opt.background = 'dark'
  end
end

-- im_select: A module to switch input method in normal mode {{{
local shell = vim.opt.shell:get()
local shellcmdflag = vim.opt.shellcmdflag:get()

M.im_select = { opts = { normal_imkey = '1033' } }

M.im_select.insert_leave_pre = function()
  local Job = require 'plenary.job'

  M.im_select.is_insert_mode = false

  Job:new({
    command = shell,
    args = { shellcmdflag, 'im-select.exe' },
    on_stdout = function(j, return_val)

      M.im_select.last_imkey = return_val

      -- If one leave the insert mode and quickly reenter the insert mode, then
      -- it is unneccessary to switch to normal_imkey input method.
      if not M.im_select.is_insert_mode then
        Job:new({
          command = shell,
          args = { shellcmdflag, 'im-select.exe ' .. M.im_select.opts.normal_imkey }
        }):start()
      end

    end
  }):start()
end

M.im_select.insert_enter = function()
  local Job = require 'plenary.job'

  M.im_select.is_insert_mode = true

  Job:new({
    command = shell,
    args = {
      shellcmdflag, 'im-select.exe ' .. (M.im_select.last_imkey or M.im_select.opts.normal_imkey)
    }
  }):start()
end
-- }}}

M.highlight = {}

function M.highlight.on_yank(args)
  if (vim.b.visual_multi == nil) then vim.highlight.on_yank(args) end
end

function M.show_loaded_plugins()
  for name, v in pairs(packer_plugins) do if (v.loaded) then print(name) end end
end

return M
