local Animate = require('animation').Animate

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')

local anim = Animate:new()
anim:cmd('tabedit '..globpath(p, 'init.lua'))
anim:cmd('0vsplit '..globpath(p, 'lua/plugins.lua'), 150)
anim:resize_vertically_delta(function () return math.floor(vim.go.columns/2) end)

local function edit_vimrc()
  anim:start()
end

return edit_vimrc
