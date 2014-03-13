" vim script to generate include guards from namespaces and filename
function! s:GetNamespace(str)
  return toupper(matchstr(a:str,'namespace \zs\w\+'))
endfunction

function! s:GenerateIncludeGuards()
  let save_cursor = getpos(".")
  let l:filename = toupper(substitute(expand("%:t"),"\\.","_","g"))
  normal gg0
  let l:namespaces = []
  if expand("<cword>") == "namespace"
    call add(l:namespaces, s:GetNamespace(getline(".")))
  endif
  while search('namespace','W') > 0
    call add(l:namespaces, s:GetNamespace(getline(".")))
  endwhile
  let l:guard = join(l:namespaces+[l:filename],"_")
  normal gg0O
  put ='#ifndef ' . l:guard
  put ='#define ' . l:guard
  put =''
  normal gg0ddGo
  put ='#endif // ' . l:guard
  call setpos('.',save_cursor)
  normal 3j
endfunction

command! IncludeGuards call s:GenerateIncludeGuards()
