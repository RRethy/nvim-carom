" carom.nvim - Neovim plugin for executing a macro asynchronously
" Maintainer:	Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>

" if exists('g:loaded_carom')
"   finish
" endif
" let g:loaded_carom = 1

nnoremap <silent> <leader>2 :<C-U>call carom#at()<CR>
command! -nargs=+ Macro call carom#macro(<f-args>)

if get(g:, 'Carom_restrictedMode', 0)
    call carom#restricted#start()
endif
