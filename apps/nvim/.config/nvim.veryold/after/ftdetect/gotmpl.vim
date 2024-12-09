augroup filetypedetect
autocmd BufNewFile,BufRead *.yml.tpl, if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
augroup END
