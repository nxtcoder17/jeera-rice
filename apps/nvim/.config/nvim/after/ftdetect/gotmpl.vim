augroup filetypedetect
" autocmd BufNewFile,BufRead *.yml.tpl, if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
autocmd BufNewFile,BufRead *.yml.tpl setlocal filetype=gotmpl
" autocmd BufNewFile,BufRead *.html.tpl setlocal filetype=gotmpl
autocmd BufNewFile,BufRead *.yml.tpl lua indent_with_spaces()
autocmd BufNewFile,BufRead *.tpl setlocal filetype=gotmpl
augroup END

