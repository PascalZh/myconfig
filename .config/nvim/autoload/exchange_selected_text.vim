let s:text1=""
let s:text2=""
let s:location1=[]
let s:location2=[]
let s:timer_id = 0
function! ClearSavedText(timer)
  let s:text1=""
  echo "vmap x: saved text cleared."
endfunction

" TODO highlight exchanged text and clear hi after 'timeout' milliseconds.
function! exchange_selected_text#ExchangeSelectedText()
  if len(s:text1) == 0
    let s:timer_id = timer_start(10 * 1000, 'ClearSavedText')
    let s:location1 = getpos("'<")
    normal! gvxmZ
    let s:text1=@"
  else
    call timer_stop(s:timer_id)
    let s:location2 = getpos("'<")

    let tmp=@z
    let @z=s:text1

    normal! gv"zp
    let s:text2 = @"

    " this fix the bug when text2 precede text1 in the same line: the mark
    " will not move when the preceding text are deleted, thus mark `Z` is no
    " longer the position of text1.
    if s:location2[1] == s:location1[1] && s:location2[2] < s:location1[2]
      let offset = strdisplaywidth(s:text1) - strdisplaywidth(s:text2)
      let move = "0" . string(s:location1[2] + offset - 1) . "l"

      exe "normal! " . move . "P"
    else
      normal! `ZP
    endif

    let @z=tmp
    let s:text1=""
  endif
endfunction
