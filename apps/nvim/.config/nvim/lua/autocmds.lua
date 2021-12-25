vim.cmd[[
augroup nxtcoder17
    autocmd!
    autocmd BufWrite * mkview
    autocmd BufRead * silent! loadview
    autocmd BufEnter *.tpl set ft=helm
augroup END
]]
