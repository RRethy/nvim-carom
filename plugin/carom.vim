" carom.nvim - Neovim plugin for executing a macro asynchronously
" Maintainer:	Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>

" if exists('g:loaded_carom')
"   finish
" endif
" let g:loaded_carom = 1

nnoremap <silent> <leader>q :<C-U>call AsyncMacro()<CR>
command! -bar -nargs=? ArgdoMacroAsync call carom#argdo_macro(<f-args>)

if get(g:, 'Carom_restrictedMode', 0)
    call carom#restricted#start()
endif
