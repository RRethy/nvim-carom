" We need to remove < and " from 'shada' so the register being executed
" gets written to the shada file. Technically this can occur with s as well,
" but for now I'm ignoring this. I may wish to simply make 'shada' omnipotent,
" for now I'm fine with not everything being remembered.
fun! carom#shada#write() abort
    let save_shada = &shada
    let &shada = join(filter(split(&shada, ','), 'v:val[0] !=# "<" && v:val[0] !=# "\""'), ',')
    wshada
    let &shada = save_shada
    unlet save_shada
endfun
