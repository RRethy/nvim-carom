fun! s:kecho(hl, msg) abort
    exe 'echohl '.a:hl
    echo printf('carom.vim: %s', a:msg)
    echohl None
endfun

fun! carom#echo#err(msg) abort
    call s:kecho('Error', a:msg)
endfun

fun! carom#echo#info(msg) abort
    call s:kecho('MoreMsg', a:msg)
endfun
