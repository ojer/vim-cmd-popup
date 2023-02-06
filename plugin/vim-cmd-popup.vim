
if !has('popupwin')
  finish
endif

if !has('g:vim_cmd_popup_types')
  let g:vim_cmd_popup_types=[':','/','?']
endif

function! s:cmd_type(timer)
  let g:cmdtype = getcmdtype()
  if index(g:vim_cmd_popup_types,g:cmdtype) == -1
    return
  endif

  let g:winid = popup_create(g:cmdtype..'_', #{
        \line: float2nr(winheight(0) * 0.23),
        \minwidth: float2nr(winwidth(0) * 0.618),
        \padding: [1,2,1,2]
        \})
endfunction

function! s:cmd_echo(timer)
  let cmdline = getcmdline()
  if exists('g:winid')
    try
      call popup_settext(g:winid,g:cmdtype..cmdline..'_')	
      if has('textprop')
        call prop_type_add('number', {'highlight': 'Constant'})
        call prop_type_change('number', {'highlight': 'Constant'})
      endif
    catch /^Vim\%((\a\+)\)\=:E/
      echo "error"
    endtry
  endif
endfunction

function! s:cmd_leave(timer)
  if exists('g:winid')
    try
      call popup_close(g:winid)
    catch /^Vim\%((\a\+)\)\=:E/
      echo "error"
    endtry
  endif
endfunction

"||		光标移到命令行后
:autocmd CmdlineEnter * call timer_start(1, function('s:cmd_type'))
"命令行文本改变
:autocmd CmdlineChanged * call timer_start(1, function('s:cmd_echo'))
"||		光标离开命令行前
:autocmd CmdlineLeave * call timer_start(1, function('s:cmd_leave')) 
