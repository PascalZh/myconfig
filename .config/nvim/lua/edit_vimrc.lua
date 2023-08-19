local animation = require('animation')

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')
-- The sequence of this table is hardcoded in the following codes, so don't
-- change the sequence, only appending the table is allowed.
local files = {
  'init.lua', 'lua/config/plugins.lua', 'lua/config/utils.lua', 'lua/config/plugins_ui.lua',
  'lua/config/plugins_editor.lua', 'lua/config/plugins_ide.lua', 'lua/config/plugins_tool.lua',
  'lua/edit_vimrc.lua'
}
for i, _ in ipairs(files) do files[i] = globpath(p, files[i]) end

local edit_all_cmd = ''
for _, key in ipairs(files) do edit_all_cmd = edit_all_cmd .. 'silent e ' .. key .. '\n' end

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

-- Lessons:
-- 1. don't run tabedit and 0split in just one cmd, seperate them into two cmds.
-- 2. use redraw to increase stability

local function edit_vimrc()

  local duration = 200
  animation.run(function()
    vim.cmd('tabedit ' .. files[1])
    animation.co.vsplit(0.5, files[2], '', { duration = duration })
    animation.co.split(0.5, files[3], '', { duration = duration })
    vim.cmd('tabedit ' .. files[4])
    animation.co.vsplit(0.5, files[5], '', { duration = duration * 2 / 3 })
    animation.co.split(0.5, files[6], '', { duration = duration * 2 / 3 })
    vim.cmd('wincmd h')
    animation.co.split(0.5, files[7], '', { duration = duration * 2 / 3 })
  end)

end

return { start = edit_vimrc }

