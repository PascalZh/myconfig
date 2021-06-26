let s:fst_string=""
let s:snd_string=""
let s:fst_loc=[]
let s:snd_loc=[]
let s:fst_buf=0
let s:snd_buf=0
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

    let s:fst_loc = getpos("'<")  " -> [bufnum, lnum, col, off]

    let s:fst_buf = nvim_get_current_buf()

    normal! gvxmX
    let s:fst_string=@"
    let s:is_exchange_pending = v:true

  else
    let tmp=@z " save @z

    call timer_stop(s:timer_id)

    let s:snd_loc = getpos("'<")

    let s:snd_buf = nvim_get_current_buf()

    let @z=s:fst_string
    normal! gv"zp
    let s:snd_string = @"

    " this fix the bug when snd_string precede fst_string in the same line: the mark
    " will not move when the preceding text are deleted, thus mark `X` is no
    " longer the position of fst_string.
    if s:snd_loc[1] == s:fst_loc[1] && s:snd_loc[2] < s:fst_loc[2]
      let offset = strdisplaywidth(s:fst_string) - strdisplaywidth(s:snd_string)
      let move = "0" . string(s:fst_loc[2] + offset - 1) . "l"

      exe "normal! " . move . "P"
    else
      normal! `XP
    endif

    call s:ShowTheDifference()

    let s:is_exchange_pending = v:false

    let @z=tmp " restore @z
  endif
endf

func! s:ShowTheDifference()

  call nvim_buf_add_highlight(s:fst_buf, s:ns, 'IncSearch', s:fst_loc[1] - 1,
        \ s:fst_loc[2] - 1, s:fst_loc[2] + strdisplaywidth(s:snd_string) - 1)

  call nvim_buf_add_highlight(s:snd_buf, s:ns, 'IncSearch', s:snd_loc[1] - 1,
        \ s:snd_loc[2] - 1, s:snd_loc[2] + strdisplaywidth(s:fst_string) - 1)

  call timer_start(5000, {-> nvim_buf_clear_namespace(s:fst_buf, s:ns,
        \ s:fst_loc[1] -1, s:fst_loc[1])})

  call timer_start(5000, {-> nvim_buf_clear_namespace(s:snd_buf, s:ns,
        \ s:snd_loc[1] -1, s:snd_loc[1])})

endf
