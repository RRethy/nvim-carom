" carom.nvim - Neovim plugin for executing a macro asynchronously
" Maintainer:	Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>

" if exists('g:loaded_carom')
"   finish
" endif
" let g:loaded_carom = 1

nnoremap <silent> <leader>q :<C-U>call AsyncMacro()<CR>

if get(g:, 'Carom_restrictedMode', 0)
    call carom#restrictedmode()
endif

" We need to remove < and " from 'shada' so the register being executed
" gets written to the shada file. Technically this can occur with s as well,
" but for now I'm ignoring this. I may wish to simply make 'shada' omnipotent,
" for now I'm fine with not everything being remembered.
fun! s:write_shada() abort
    let save_shada = &shada
    let &shada = join(filter(split(&shada, ','), 'v:val[0] !=# "<" && v:val[0] !=# "\""'), ',')
    wshada
    let &shada = save_shada
    unlet save_shada
endfun

fun! AsyncMacro() abort
    set nomodifiable
    let reg = nr2char(getchar())
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    call s:write_shada()
    call jobstart(['nvim',
                \     '--cmd', 'let g:Carom_restrictedMode = 1',
                \     '-c', 'call cursor('.line('.').','.col('.').')',
                \     '-c', 'norm! @'.reg,
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
    exe '%!cat '.self.fname
    call cursor(l, c)
    echohl MoreMsg | echo 'Done executing the macro' | echohl None
endf
