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
                \   'changenr': changenr(),
                \   'reg': a:reg,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    set modifiable
    if changenr() != self.changenr
        " TODO the user dun goofed
    endif
    let l = line('.')
    let c = col('.')
    keepjumps exe '%!cat '.self.fname
    keepjumps call cursor(l, c)
    call carom#echo#on_finished(0, self.reg, self.bufnr)
endf
