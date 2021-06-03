function! quickfix_toggle#QuickfixToggle(flag)
  if a:flag != "qf" && a:flag != "ll"
    echom "QuickfixToggle(flag): a:flag not valid!"
    return
  endif

  if a:flag == "qf"
    if getqflist({'winid' : 0}).winid
      cclose
      wincmd p
    else
      botright copen
    endif
  elseif a:flag == "ll"
    if getloclist(winnr(), {'winid' : 0}).winid
      lclose
      wincmd p
    else
      lopen
    endif
  endif
endfunction
