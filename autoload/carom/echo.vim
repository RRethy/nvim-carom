fun! s:kecho(hl, msg) abort
    exe 'echohl '.a:hl
    echo a:msg
    echohl None
endfun

fun! s:err(msg) abort
    call s:kecho('Error', a:msg)
endfun

fun! s:info(msg) abort
    call s:kecho('MoreMsg', a:msg)
endfun

fun! carom#echo#on_invalid_reg(reg) abort
    call s:err('Invalid register '.a:reg)
endfun

fun! carom#echo#on_create_file_err() abort
    call s:err('Unabled to execute the macro')
endfun

fun! carom#echo#on_finished(exitcode, reg, bufname) abort
    if a:exitcode == 0
        call s:info(printf('@%s successfully completed on %s', a:reg, a:bufname))
    else
        " TODO print error msg
    endif
endfun
