let s:rootdir = expand('<sfile>:h:h')
let s:gistconf = resolve(s:rootdir . '/gist.conf')

function! kronos#GistConf()
  return s:gistconf
endfunction

" ------------------------------------------------------------ # Configuration #

let g:kronos_context   = get(g:, 'kronos_context', [])
let g:kronos_hide_done = get(g:, 'kronos_hide_done', 1)
let g:kronos_gist_sync = get(g:, 'kronos_gist_sync', 0)
let g:kronos_database  = get(
  \g:, 'kronos_database',
  \resolve(s:rootdir . '/kronos.db'),
\)

" ------------------------------------------------------------------ # Command #

command! -nargs=* -complete=custom,<sid>kronos_cmd_complete
      \ Kronos call kronos#EntryPoint(<q-args>)
command! -nargs=* -complete=custom,<sid>kronos_cmd_complete
      \ K      call kronos#EntryPoint(<q-args>)

fun! <sid>kronos_cmd_complete(A, L, P)
  return "list\ninfo\ndelete\nadd\nupdate\nstart\nstop".
        \"\ntoggle\ndone\nundone\nworktime\ncontext"
endfun

if g:kronos_gist_sync
  augroup kronos
    autocmd VimEnter * call kronos#hook#gist#Init()
  augroup END
endif

