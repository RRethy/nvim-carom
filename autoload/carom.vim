fun! carom#at() abort
    let reg = nr2char(getchar())
    if !carom#utils#validate_register(reg)
        return
    endif
    call carom#macro#async(bufnr(), reg, v:count1)
endfun

fun! carom#macro(...) abort
    if a:0 == 1
        if !carom#utils#validate_register(a:1)
            return
        endif
        call carom#macro#async(bufnr(), a:1, 1)
    else
        if !carom#utils#validate_register(a:1)
            return
        endif
        if !carom#utils#validate_count(a:2)
            return
        endif
        call carom#macro#async(bufnr(), a:1, a:2)
    endif
endfun
