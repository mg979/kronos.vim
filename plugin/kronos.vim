let s:root_dir = expand('<sfile>:h:h')
let s:sync_config = resolve(s:root_dir . '/.sync')

function! kronos#sync_config()
  return s:sync_config
endfunction

" ------------------------------------------------------------ # Configuration #

let g:kronos_sync      = get(g:, 'kronos_sync'     , 0)
let g:kronos_sync_host = get(g:, 'kronos_sync_host', 'localhost:5000')
let g:kronos_context   = get(g:, 'kronos_context'  , [])
let g:kronos_hide_done = get(g:, 'kronos_hide_done', 1)
let g:kronos_database  = get(
  \g:, 'kronos_database',
  \resolve(s:root_dir . '/.database'),
\)

" ------------------------------------------------------------------ # Command #

command! -nargs=* K      call kronos#EntryPoint(<q-args>)
command! -nargs=* Kronos call kronos#EntryPoint(<q-args>)

if g:kronos_sync
  augroup kronos
    autocmd VimEnter * call kronos#sync#common#init()
  augroup END
endif
