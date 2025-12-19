augroup filetypedetect
autocmd BufNewFile,BufRead *.yml.tpl setlocal filetype=gotmpl
" autocmd BufNewFile,BufRead *.yml.tpl setlocal filetype=gotexttmpl
autocmd BufNewFile,BufRead *.yml.tpl lua indent_with_spaces()
autocmd BufNewFile,BufRead *.tpl setlocal filetype=gotmpl
" autocmd BufNewFile,BufRead *.tpl.html setlocal filetype=gohtmltmpl
autocmd BufNewFile,BufRead *.tpl.html setlocal filetype=gotmpl
augroup END
