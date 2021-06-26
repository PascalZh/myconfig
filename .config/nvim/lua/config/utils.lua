local M = {}
local cmd = vim.cmd
local o_s = vim.o
local map_key = vim.api.nvim_set_keymap

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

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == 'string' then modes = {modes} end

  for _, mode in ipairs(modes) do
    map_key(mode, lhs, rhs, opts)
  end
end

function M.imap(lhs, rhs, opts)
  M.map('i', lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  M.map('n', lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  M.map('v', lhs, rhs, opts)
end

function M.omap(lhs, rhs, opts)
  M.map('o', lhs, rhs, opts)
end

function M.nvmap(lhs, rhs, opts)
  M.map({'n', 'v'}, lhs, rhs, opts)
end

function M.nvomap(lhs, rhs, opts)
  M.map({'n', 'v', 'o'}, lhs, rhs, opts)
end

function M.isNvimQt()
  return vim.fn.exists(':GuiFont') == 2
end

return M
