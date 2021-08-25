local M = {}

M.utils = require('config.utils')
M.map = M.utils.map
M.opt = M.utils.opt
M.autocmd = M.utils.autocmd

function M.imap(lhs, rhs, opts) M.map('i', lhs, rhs, opts) end
function M.nmap(lhs, rhs, opts) M.map('n', lhs, rhs, opts) end
function M.vmap(lhs, rhs, opts) M.map('v', lhs, rhs, opts) end
function M.xmap(lhs, rhs, opts) M.map('v', lhs, rhs, opts) end
function M.omap(lhs, rhs, opts) M.map('o', lhs, rhs, opts) end
function M.nvmap(lhs, rhs, opts) M.map({'n', 'v'}, lhs, rhs, opts) end
function M.nvomap(lhs, rhs, opts) M.map({'n', 'v', 'o'}, lhs, rhs, opts) end
function M.lmap(lhs, rhs, opts) M.map('l', lhs, rhs, opts) end

M.g = vim.g
M.cmd = vim.cmd
M.o, M.wo, M.bo = vim.o, vim.wo, vim.bo
M.execute = vim.api.nvim_command
M.fn = vim.fn

return M

