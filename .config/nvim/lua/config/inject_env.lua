local M = {}

M.utils = require('config.utils')
M.map_key = M.utils.map_key
M.remap_key = M.utils.remap_key
M.opt = M.utils.opt
M.autocmd = M.utils.autocmd

function M.imap_key(lhs, rhs, opts) M.map_key('i', lhs, rhs, opts) end
function M.nmap_key(lhs, rhs, opts) M.map_key('n', lhs, rhs, opts) end
function M.vmap_key(lhs, rhs, opts) M.map_key('v', lhs, rhs, opts) end
function M.xmap_key(lhs, rhs, opts) M.map_key('v', lhs, rhs, opts) end
function M.omap_key(lhs, rhs, opts) M.map_key('o', lhs, rhs, opts) end
function M.nvmap_key(lhs, rhs, opts) M.map_key({'n', 'v'}, lhs, rhs, opts) end
function M.nvomap_key(lhs, rhs, opts) M.map_key({'n', 'v', 'o'}, lhs, rhs, opts) end
function M.lmap_key(lhs, rhs, opts) M.map_key('l', lhs, rhs, opts) end

function M.iremap_key(lhs, rhs, opts) M.remap_key('i', lhs, rhs, opts) end
function M.nremap_key(lhs, rhs, opts) M.remap_key('n', lhs, rhs, opts) end
function M.vremap_key(lhs, rhs, opts) M.remap_key('v', lhs, rhs, opts) end
function M.xremap_key(lhs, rhs, opts) M.remap_key('v', lhs, rhs, opts) end
function M.oremap_key(lhs, rhs, opts) M.remap_key('o', lhs, rhs, opts) end
function M.nvremap_key(lhs, rhs, opts) M.remap_key({'n', 'v'}, lhs, rhs, opts) end
function M.nvoremap_key(lhs, rhs, opts) M.remap_key({'n', 'v', 'o'}, lhs, rhs, opts) end
function M.lremap_key(lhs, rhs, opts) M.remap_key('l', lhs, rhs, opts) end

M.g = vim.g
M.cmd = vim.cmd
M.o, M.wo, M.bo = vim.o, vim.wo, vim.bo
M.execute = vim.api.nvim_command
M.fn = vim.fn

return M

