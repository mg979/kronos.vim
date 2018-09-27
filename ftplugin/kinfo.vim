setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

nnoremap <silent> <buffer> i     :call kronos#gui#quit()  <cr>
nnoremap <silent> <buffer> q     :call kronos#gui#quit()  <cr>
nnoremap <silent> <buffer> <esc> :call kronos#gui#quit()  <cr>

