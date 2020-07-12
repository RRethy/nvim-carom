fun! carom#macro#async(reg) abort
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if fail == -1
        call carom#echo#on_create_file_err()
        return
    endif
    call carom#shada#write()
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
    keepjumps exe '%!cat '.self.fname
    keepjumps call cursor(l, c)
    echohl MoreMsg | echo 'Done executing the macro' | echohl None
endf
