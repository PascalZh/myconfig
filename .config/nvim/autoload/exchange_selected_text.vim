" Many variables are list of length 2, the first is the variable of first
" selection, the second is the variable of second selection.
let s:selected_string=["", ""]
let s:xloc=[1, 1]  " base index of 1, column location
let s:yloc=[1, 1]  " see |line()|, line location
let s:buf=[0, 0]
let s:timer_id=0
let s:is_exchange_pending = v:false
let s:ns=nvim_create_namespace('exchange_selected_text')

func! s:ClearSavedText(timer)
  let s:is_exchange_pending = v:false
  echo "exchange_selected_text: saved text cleared."
endf

func! exchange_selected_text#delete()
  if !s:is_exchange_pending

    let s:timer_id = timer_start(10 * 1000, expand("<SID>")."ClearSavedText")

    let pos = getpos("'<")  " -> [bufnum, lnum, col, off]
    let s:yloc[0] = pos[1]
    let s:xloc[0] = pos[2]

    let s:buf[0] = nvim_get_current_buf()

    normal! gvxmX
    let s:selected_string[0]=@"
    let s:is_exchange_pending = v:true

  else
    let tmp=@z " save @z

    try
      call timer_stop(s:timer_id)

      let pos = getpos("'<")  " -> [bufnum, lnum, col, off]
      let s:yloc[1] = pos[1]
      let s:xloc[1] = pos[2]

      let s:buf[1] = nvim_get_current_buf()

      let @z=s:selected_string[0]
      normal! gv"zp
      let s:selected_string[1] = @"

      " this fix the bug when snd_string precede fst_string in the same line: the mark
      " will not move when the preceding text are deleted, thus mark `X` is no
      " longer the position of fst_string.
      if s:yloc[0] == s:yloc[1] && s:xloc[1] < s:xloc[0]
        let offset = strdisplaywidth(s:selected_string[0]) - strdisplaywidth(s:selected_string[1])
        let move = "0" . string(s:xloc[0] + offset - 1) . "l"

        exe "normal! " . move . "P"
      else
        normal! `XP
      endif

    finally
      let s:is_exchange_pending = v:false
      let @z=tmp " restore @z
      call s:ShowTheDifference()
    endtry
  endif
endf

func! s:ShowTheDifference()

  let start_loc = [0, 0]
  let end_loc = [0, 0]
  let width = [strdisplaywidth(s:selected_string[0]), strdisplaywidth(s:selected_string[1])]
  if s:yloc[0] == s:yloc[1]
    if s:xloc[0] < s:xloc[1]
      let start_loc[0] = s:xloc[0]
      let end_loc[0] = s:xloc[0] + width[1]
      let start_loc[1] = s:xloc[1] + width[1]
      let end_loc[1] = s:xloc[1] + width[1] + width[0]
    else
      let start_loc[0] = s:xloc[0] + width[0] - width[1]
      let end_loc[0] = s:xloc[0] + width[0]
      let start_loc[1] = s:xloc[1]
      let end_loc[1] = s:xloc[1] + width[0]
    endif
  else
    let start_loc[0] = s:xloc[0]
    let end_loc[0] = s:xloc[0] + width[1]
    let start_loc[1] = s:xloc[1]
    let end_loc[1] = s:xloc[1] + width[0]
  endif

  call nvim_buf_add_highlight(s:buf[0], s:ns, 'IncSearch', s:yloc[0] - 1,
        \ start_loc[0] - 1, end_loc[0] - 1)

  call nvim_buf_add_highlight(s:buf[1], s:ns, 'IncSearch', s:yloc[1] - 1,
        \ start_loc[1] - 1, end_loc[1] - 1)

  call timer_start(5000, {-> nvim_buf_clear_namespace(s:buf[0], s:ns,
        \ s:yloc[0] -1, s:yloc[0])})

  call timer_start(5000, {-> nvim_buf_clear_namespace(s:buf[1], s:ns,
        \ s:yloc[1] -1, s:yloc[1])})

endf
