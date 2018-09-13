let s:version   = 0
let s:user_id   = ''
let s:device_id = ''
let s:provider = has('nvim') ? 'neovim' : 'vim8'

" --------------------------------------------------------------------- # Init #

function! kronos#sync#common#init()
  try
    execute 'call kronos#sync#' . s:provider . '#init()'
  catch 'channel'
    call kronos#tool#log#Error('Kronos sync: missing option +channel')
  catch 'job'
    call kronos#tool#log#Error('Kronos sync: missing option +channel')
  catch 'version'
    call kronos#tool#log#Error('Kronos sync: missing vim8+')
  catch
    call kronos#tool#log#Error('Kronos sync: init failed')
  endtry

  if filereadable(kronos#sync_config())
    let [s:user_id, s:device_id, s:version] = readfile(kronos#sync_config())
    let s:version = +s:version
  else
    echo 'Kronos sync is not configured yet. Do you have a token? (y/N) ? '
    let user_has_token = (tolower(nr2char(getchar())) == 'y')

    if user_has_token
      let s:user_id = inputsecret(
        \'Enter your Kronos sync token:' .
        \"\n> "
      \)
    endif
  endif

  redraw
  call kronos#sync#common#send({'type': 'login'})
endfunction

" ------------------------------------------------------------------ # On data #

function! kronos#sync#common#on_data(raw_data)
  if empty(a:raw_data) | continue | endif
  let data = json_decode(a:raw_data)

  if ! data.success
    return kronos#tool#log#Error('Kronos sync: ' . data.error)
  endif

  if data.type == 'login'
    let s:user_id = data.user_id
    let s:device_id = data.device_id

    if data.version > s:version
      let s:version = data.version
      call kronos#sync#common#send({'type': 'read-all'})

    elseif data.version < s:version
      let tasks = kronos#core#database#Read(g:kronos_database)
      call kronos#sync#common#send({
        \'type': 'write-all',
        \'tasks': tasks,
        \'version': s:version,
      \})
    endif

    call kronos#tool#log#Info('Kronos sync: login succeed')

  elseif data.type == 'read-all'
    call kronos#core#database#Write(g:kronos_database, data.tasks)

  else
    let s:version = data.version

    try
      if data.type == 'create'
        call kronos#core#task#Create(g:kronos_database, data.task)
      elseif data.type == 'update'
        call kronos#core#task#Update(g:kronos_database, data.task.id, data.task)
      elseif data.type == 'delete'
        call kronos#core#task#Delete(g:kronos_database, data.task_id)
      endif
    catch
    endtry

    if &filetype == 'klist' | call kronos#gui#List() | endif
  endif

  let config = [s:user_id, s:device_id, s:version]
  call writefile(config, kronos#sync_config(), 's')
endfunction

" --------------------------------------------------------------------- # Send #

function! kronos#sync#common#send(data)
  let data = copy(a:data)
  let data.user_id = s:user_id
  let data.device_id = s:device_id
  let data.version = s:version

  execute 'call kronos#sync#' . s:provider . '#send(data)'
endfunction

" ------------------------------------------------------------- # Bump version #

function! kronos#sync#common#bump_version()
  let s:version = localtime() * 1000
  let config = [s:user_id, s:device_id, s:version]
  call writefile(config, kronos#sync_config(), 's')
endfunction
