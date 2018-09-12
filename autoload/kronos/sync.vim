" --------------------------------------------------------------------- # Init #

function! kronos#sync#init()
  let s:socket = sockconnect(
    \'tcp',
    \g:kronos_sync_host,
    \{'on_data': function('s:on_data')}
  \)

  if s:socket == 0
    return kronos#tool#log#Error('Kronos sync: init failed')
  endif

  if filereadable(kronos#sync_config())
    let [s:user_id, s:device_id] = readfile(kronos#sync_config())
  else
    let [s:user_id, s:device_id] = ['', '']

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
  call kronos#sync#send({'type': 'login'})
endfunction

" ------------------------------------------------------------------ # On data #

function! s:on_data(id, data, event) dict
  let data = json_decode(a:data)

  if ! data.success
    return kronos#tool#log#Error('Kronos sync: ' . data.error)
  endif

  if data.type == "login"
    let s:user_id = data.user_id
    let s:device_id = data.device_id

    try
      call writefile([s:user_id, s:device_id], kronos#sync_config(), 's')
      call kronos#tool#log#Info('Kronos sync: login succeed')
    catch
      call kronos#tool#log#Error('Kronos sync: login failed')
    endtry
  endif
endfunction

" --------------------------------------------------------------------- # Send #

function! kronos#sync#send(data)
  if ! s:socket | call kronos#sync#init() | endif

  let data = copy(a:data)
  let data.user_id = s:user_id
  let data.device_id = s:device_id

  call chansend(s:socket, json_encode(data))
endfunction
