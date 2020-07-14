fun! carom#utils#valid_register(reg) abort
    return type(a:reg) == 1 && a:reg =~# '["0-9a-zA-Z]'
endfun

fun! carom#utils#validate_register(reg) abort
    if !carom#utils#valid_register(a:reg)
        call carom#echo#err('Invalid register '.a:reg)
        return 0
    endif
    return 1
endfun

fun! carom#utils#validate_count(count) abort
    if str2nr(a:count) <= 0
        call carom#echo#err('Invalid count '.a:count)
        return 0
    endif
    return 1
endfun
