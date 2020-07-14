fun! carom#at() abort
    let reg = nr2char(getchar())
    if !carom#utils#valid_register(reg)
        call carom#echo#err('Invalid register '.a:1)
        return
    endif
    call carom#macro#async(reg)
endfun

fun! carom#argdo_macro(...) abort
    if a:0 == 0
        " TODO query the user for a register
    else
        if !carom#utils#valid_register(a:1)
            call carom#echo#err('Invalid register '.a:1)
            return
        endif

        " TODO execute the register a:1 on each file in args
    endif
endfun
