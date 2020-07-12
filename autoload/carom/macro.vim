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
                \   'tmpname': tmpname,
                \   'bufnr': bufnr('%'),
                \   'buffname': nvim_buf_get_name(bufnr('%')),
                \   'changenr': changenr(),
                \   'reg': a:reg,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    if !bufexists(self.bufnr)
        if filewritable(self.buffname)
            " TODO prompt for action
            " let action = inputlist([...])
        else
            " TODO cannot do anything
        endif
        return
    endif
    call nvim_buf_set_option(self.bufnr, 'modifiable', 1)

    " TODO:
    "  check if buffer is in an open window for the cucrent tab
    "  if it is, then go to that window
    "  else, :sp and open it
    if changenr() != self.changenr
        " TODO the user dun goofed
    endif
    let l = line('.')
    let c = col('.')
    keepjumps exe '%!cat '.self.tmpname
    keepjumps call cursor(l, c)
    call carom#echo#on_finished(0, self.reg, self.bufnr)
endf
