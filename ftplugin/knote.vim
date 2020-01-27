setlocal buftype=nofile bufhidden=wipe
setlocal cursorline
setlocal modifiable
setlocal nowrap
setlocal startofline

if exists('g:loaded_xtabline')
  let opts = {'name': 'Kronos Note', 'special': 1,
        \     'icon': g:xtabline_settings.icons.arrow}
  call xtabline#buffer#set(bufnr(''), opts)
endif

nnoremap <silent> <buffer> <esc><esc>     <esc>
nnoremap <silent> <buffer> <nowait> <esc> :call <sid>save_note() <cr>


nnoremap <silent> <buffer> q             :call <sid>save_note()  <cr>
nnoremap <silent> <buffer> <leader>q     :call <sid>save_note()  <cr>
nnoremap <silent> <buffer> <leader>w     :call <sid>save_note()  <cr>
nnoremap <silent> <buffer> dn            :call <sid>del_note()   <cr>

function! s:save_note()
  let note = []
  for line in range(2, line("$"))
    call add(note, getline(line))
  endfor
  let from_info_view = b:from_info_view
  bdelete! KronosNote
  if from_info_view
    buffer KronosInfo
  endif
  let b:task.note = match(note, '\w') >= 0 ? note : []
  call kronos#core#task#Update(g:kronos_database, b:task.id, b:task)
  if from_info_view
    setlocal modifiable
    silent! execute '10,$d'
    call PrintNote(b:task)
    setlocal nomodifiable
  endif
endfunction

function! s:del_note()
  execute '2,$d'
  call s:save_note()
endfunction
