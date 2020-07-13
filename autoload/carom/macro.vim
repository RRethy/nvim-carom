fun! carom#macro#async(reg) abort
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if fail == -1
        call carom#echo#on_create_file_err()
        return
    endif
    let shadatmpfile = carom#shada#write()
    set nomodifiable
    call jobstart(['nvim',
                \     '-i', shadatmpfile,
                \     '--cmd', 'let g:Carom_restrictedMode = 1',
                \     '-c', 'call cursor('.line('.').','.col('.').')',
                \     '-c', 'norm! '.v:count1.'@'.a:reg,
                \     '-c', 'wq', tmpname
                \ ], {
                \   'on_exit': function('s:on_exit'),
                \   'tmpname': tmpname,
                \   'bufnr': bufnr('%'),
                \   'buffname': nvim_buf_get_name(0),
                \   'changetick': nvim_buf_get_changedtick(0),
                \   'reg': a:reg,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    let @* = self.tmpname
    if !bufexists(self.bufnr)
        if filewritable(self.buffname)
            let action = inputlist([
                        \   'carom.nvim: bufnr('..self.bufnr..') no longer exists but the file still exists. How would you like to recover?',
                        \   '1. Overwrite the file with the results of the macro',
                        \   '2. Discard the results of the macro (press any key)',
                        \ ])
            if action == 1
                exe '!cp -f '..self.tmpname..' '..self.buffname
            endif
        else
            call carom#echo#on_file_not_exists(self.buffname)
        endif
        return
    endif
    call nvim_buf_set_option(self.bufnr, 'modifiable', v:true)

    if self.changetick != nvim_buf_get_changedtick(self.bufnr)
        let action = inputlist([
                    \   'carom.nvim: bufnr('..self.bufnr..') has been modified since the macro was started. How would you like to continue?',
                    \   '1. Overwrite any changes with the results of the macro',
                    \   '2. Discard the results of the macro (press any key)',
                    \ ])
        if action != 1
            return
        endif
    endif

    call nvim_buf_set_lines(self.bufnr, 0, -1, 0, readfile(self.tmpname))
    call carom#echo#on_finished(0, self.reg, self.bufnr)
endf
