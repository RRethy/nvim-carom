fun! carom#utils#valid_register(reg) abort
    return a:reg =~# '["0-9a-za-Z]'
endfun

fun! carom#utils#on_invalid_reg(reg) abort
    echoerr 'Invalid register '.a:reg
endfun

fun! carom#utils#on_create_file_err() abort
    echoerr 'Unabled to execute the macro'
endfun

" We need to remove < and " from 'shada' so the register being executed
" gets written to the shada file. Technically this can occur with s as well,
" but for now I'm ignoring this. I may wish to simply make 'shada' omnipotent,
" for now I'm fine with not everything being remembered.
fun! carom#utils#write_shada() abort
    let save_shada = &shada
    let &shada = join(filter(split(&shada, ','), 'v:val[0] !=# "<" && v:val[0] !=# "\""'), ',')
    wshada
    let &shada = save_shada
    unlet save_shada
endfun
