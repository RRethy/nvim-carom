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
                \     '-c', 'norm! '.v:count1.'@'.a:reg,
                \     '-c', 'wq', tmpname
                \ ], {
                \   'on_exit': function('s:on_exit'),
                \   'tmpname': tmpname,
                \   'bufnr': bufnr('%'),
                \   'buffname': nvim_buf_get_name(bufnr('%')),
                \   'changetick': nvim_buf_get_changedtick(0),
                \   'reg': a:reg,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    let @* = self.tmpname
    if !bufexists(self.bufnr)
        if filewritable(self.buffname)
            echom "TODO: Buffer doesn't exist. File writable."
            " TODO prompt for next action
            " let action = inputlist([...])
        else
            echom "TODO: Buffer doesn't exist. File not writable."
            " TODO cannot do anything
        endif
        return
    endif
    call nvim_buf_set_option(self.bufnr, 'modifiable', v:true)

    if self.changetick != nvim_buf_get_changedtick(self.bufnr)
        " TODO the user dun goofed
        " inputlist for next action
        return
    endif

    call nvim_buf_set_lines(self.bufnr, 0, -1, 0, readfile(self.tmpname))
    call carom#echo#on_finished(0, self.reg, self.bufnr)
endf
