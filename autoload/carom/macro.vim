fun! carom#macro#async(bufnr, reg, count) abort
    let tmpname = tempname()
    let fail = writefile(getbufline(a:bufnr, 1, '$'), tmpname)
    if fail == -1
        call carom#echo#err('Unable to execute the macro for bufnr('.a:bufnr.')')
        return
    endif
    let shadatmpfile = carom#shada#write()
    call nvim_buf_set_option(a:bufnr, 'modifiable', v:false)
    call jobstart(['nvim',
                \     '-i', shadatmpfile,
                \     '--cmd', 'let g:Carom_restrictedMode = 1',
                \     '-c', 'call cursor('.line('.').','.col('.').')',
                \     '-c', 'set filetype='.&ft,
                \     '-c', 'norm! '.a:count.'@'.a:reg,
                \     '-c', 'call carom#restricted#stop(0)', tmpname,
                \ ], {
                \   'on_exit': function('s:on_exit'),
                \   'tmpname': tmpname,
                \   'bufnr': a:bufnr,
                \   'buffname': nvim_buf_get_name(0),
                \   'changetick': nvim_buf_get_changedtick(0),
                \   'reg': a:reg,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    if a:exitcode != 0
        call carom#echo#err('bufnr('..self.bufnr..') failed to execute the macro. Make sure you are not editing other files inside the macro.')
        return
    endif

    let @* = self.tmpname

    if !bufexists(self.bufnr)
        if filewritable(self.buffname)
            let action = inputlist([
                        \   'carom.nvim: bufnr('..self.bufnr..') no longer exists but the file still exists. How would you like to continue?',
                        \   '1. Overwrite the file with the results of the macro',
                        \   '2. Discard the results of the macro (press any key)',
                        \ ])
            if action == 1
                exe '!cp -f '..self.tmpname..' '..self.buffname
            endif
        elseif empty(self.buffname)
            call carom#echo#err('Finished executing a macro on an unsaved buffer but this buffer no longer exists...')
        else
            call carom#echo#err('Buffer being worked on does not exists and file is deleted: '.self.buffname)
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
    call carom#echo#info('macro @'..self.reg..' successfully completed on bufnr('.self.bufnr.')')

    " Not sure why but ":lfdo Macro a" and alikes caused syntax highlighting
    " to get fucked up. This is a hack to fix that.
    call nvim_buf_set_option(self.bufnr, 'filetype', nvim_buf_get_option(self.bufnr, 'filetype'))
endf
