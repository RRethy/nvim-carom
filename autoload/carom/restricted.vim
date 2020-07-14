fun! s:try_bufread() abort
    if len(bufname()) > 0 && v:argv[-1] !=# bufname()
        call carom#restricted#stop(1)
    endif
endfun

fun! carom#restricted#start() abort
    augroup autocmds_carom_restricted
        autocmd!
        autocmd BufRead * call s:try_bufread()
    augroup END
endfun

fun! carom#restricted#stop(err) abort
    write
    exe string(a:err).'cquit'
endfun
