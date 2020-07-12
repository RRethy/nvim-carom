fun! s:kecho(hl, msg) abort
    exe 'echohl '.a:hl
    echo printf('carom.vim: %s', a:msg)
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
    call s:err('Unabled to execute the macro for bufnr '.bufnr('%'))
endfun

fun! carom#echo#on_finished(exitcode, reg, bufnr) abort
    if a:exitcode == 0
        call s:info(printf('@%s successfully completed on buffer #%s', a:reg, a:bufnr))
    else
        " TODO print error msg
    endif
endfun

fun! carom#echo#on_file_not_exists(fname) abort
    if empty(a:fname)
        " was never a file, only a buffer
        call s:err('Finished executing a macro on a buffer but this buffer no longer exists...')
    else
        call s:err('Buffer being worked on does not exists and file is deleted: '.a:fname)
    endif
endfun
