function! utils#EscapeRegister(reg) abort
  let lhs = '<sid>(_tmp)'
  call nvim_set_keymap('n', lhs, getreg(a:reg), {})
  let res = maparg(lhs)
  call nvim_del_keymap('n', lhs)
  return res
endfunction

nnoremap <silent> \p "=utils#EscapeRegister(nr2char(getchar()))<cr>p
