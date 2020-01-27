setlocal buftype=nofile bufhidden=wipe
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

if exists('g:loaded_xtabline')
  let opts = {'name': 'Kronos Info', 'special': 1,
        \     'icon': g:xtabline_settings.icons.arrow}
  call xtabline#buffer#set(bufnr(''), opts)
endif

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

