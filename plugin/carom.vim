" carom.nvim - Neovim plugin for executing a macro asynchronously
" Last Change:	2020 July 10
" Maintainer:	Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Version: 0.1

" if exists('g:loaded_carom')
"   finish
" endif
" let g:loaded_carom = 1

nnoremap <silent> <leader>q :<C-U>call AsyncMacro()<CR>

if get(g:, 'CaromSandbox', 0)
    call carom#restrictedmode()
endif

fun! AsyncMacro() abort
    set nomodifiable
    let reg = nr2char(getchar())
    wshada
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    call jobstart(['nvim', '-c', 'call cursor('.line('.').','.col('.').')', '-c', 'norm! @'.reg, '-c', 'wq', tmpname], {
                \   'on_exit': function('s:on_exit'),
                \   'fname': tmpname,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    let l = line('.')
    let c = col('.')
    set modifiable
    exe '%!cat '.self.fname
    call cursor(l, c)
    echohl MoreMsg | echo 'Done executing the macro' | echohl None
endf
