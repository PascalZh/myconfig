local Animate = require('animation').Animate

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')

local anim = Animate:new()
  :cmd('tabedit '..globpath(p, 'init.lua')..
    '\n0vsplit '..globpath(p, 'lua/config/plugins.lua'))
  :resize_vertically_delta(function () return math.floor(vim.o.columns/2) end,
    { delay = 200 })
  :cmd('0split '..globpath(p, 'lua/config/ui.lua'))
  :resize_delta(function () return math.floor((vim.o.lines-4)/2) end, { delay = 200 })

local function edit_vimrc()
  anim:start()
end

return {
  start = edit_vimrc
}

