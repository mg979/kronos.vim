setlocal buftype=nofile bufhidden=wipe
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

nnoremap <silent> <buffer> <esc><esc>     <esc>
nnoremap <silent> <buffer> <nowait> <esc> :bwipeout!<cr>

nnoremap <silent> <buffer> i     :bwipeout!<cr>
nnoremap <silent> <buffer> q     :bwipeout!<cr>
nnoremap <silent> <buffer> n     :call kronos#gui#Note(1)<cr>
nnoremap <silent> <buffer> dn    :call <sid>del_note()<cr>

function! s:del_note()
  setlocal modifiable
  silent! execute '10,$d'
  normal! gg
  setlocal nomodifiable
  let b:task.note = []
  call kronos#core#task#Update(g:kronos_database, b:task.id, b:task)
endfunction

