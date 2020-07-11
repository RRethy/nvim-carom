" carom.nvim - Neovim plugin for executing a macro asynchronously
" Last Change:	2020 July 10
" Maintainer:	Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Version: 0.1

" if exists('g:loaded_carom')
"   finish
" endif
" let g:loaded_carom = 1

nnoremap <silent> <leader>q :call AsyncMacro()<CR>

fun! AsyncMacro() abort
    let reg = input('')
    let tmpname = tempname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    call jobstart(['nvim', '-c', '":normal! @'.reg.'"'], {
                \   'on_exit': function('s:on_exit'),
                \   'fname': tmpname,
                \ })
endfun

fun! s:on_exit(id, exitcode, eventtype) dict abort
    echo self.fname
endf
