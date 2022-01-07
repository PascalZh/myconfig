local Animate = require('animation').Animate

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')
-- The sequence of this table is hardcoded in the following codes, so don't
-- change the sequence, only appending the table is allowed.
local files = {
  'init.lua', 'lua/config/plugins.lua', 'lua/config/utils.lua',

  'lua/config/plugins_ui.lua', 'lua/config/plugins_editor.lua',
  'lua/config/plugins_ide.lua', 'lua/config/plugins_tool.lua',
  'lua/edit_vimrc.lua',
}
for i, _ in ipairs(files) do
  files[i] = globpath(p, files[i])
end

local edit_all_cmd = ''
for _, key in ipairs(files) do
  edit_all_cmd = edit_all_cmd..'silent e '..key..'\n'
end

-- vim.cmd[[
-- function MyFoldExpr(lnum)
--   if getline(a:lnum) =~ "config = function ()" 
--     return 'a1'
--   elseif getline(a:lnum-1) =~ "end})"
--     return 's1
--   else
--     return '='
-- endfunction
-- ]]

-- local set_fold_cmd = [[setlocal foldexpr=MyFoldExpr(v:lnum)
-- setlocal foldmethod=expr
-- ]]
local set_fold_cmd = ""

-- Lessons:
-- 1. don't run tabedit and 0split in just one cmd, seperate them into two cmds.
-- 2. use redraw to increase stability

local anim = Animate:new()
  :cmd('e '..files[8])

  :cmd('tabedit '..files[1])
  :vsplit(0.5, files[2])
  :split(0.5, files[3])

  :cmd('tabedit '..files[4]):cmd(set_fold_cmd)
  :vsplit(0.5, files[5]):cmd(set_fold_cmd)
  :split(0.5, files[6]):cmd(set_fold_cmd)
  :cmd('wincmd h')
  :split(0.5, files[7]):cmd(set_fold_cmd)

local function edit_vimrc()
  anim:start()
end

return {
  start = edit_vimrc
}

