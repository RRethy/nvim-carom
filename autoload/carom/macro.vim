fun! carom#macro#async(reg) abort
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if fail == -1
        call carom#utils#on_create_file_err()
        return
    endif
    call carom#utils#write_shada()
    set nomodifiable
    call jobstart(['nvim',
                \     '--cmd', 'let g:Carom_restrictedMode = 1',
                \     '-c', 'call cursor('.line('.').','.col('.').')',
                \     '-c', 'norm! @'.a:reg,
                \     '-c', 'wq', tmpname
                \ ], {
                \   'on_exit': function('s:on_exit'),
                \   'fname': tmpname,
                \   'bufnr': bufnr('%'),
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    let l = line('.')
    let c = col('.')
    set modifiable
    " TODO check if the buffer has been changed under our noses
    exe '%!cat '.self.fname
    call cursor(l, c)
    echohl MoreMsg | echo 'Done executing the macro' | echohl None
endf
