vim.cmd([[
" hi! TabLineSel gui=bold guifg=#000000 guibg=#ffffff
" hi! TabLineSel gui=bold guifg=#000000 guibg=#b5a68a
hi! TabLineSel gui=bold guifg=#000000 guibg=#698e91
" hi! TabLine gui=bold guifg=#000000 guibg=#3f5557
hi! TabLine gui=bold guifg=#000000 guibg=#4c6669
" hi! TabLine gui=bold guifg=#000000 guibg=#857a66
" contrsting to tablinesel
" hi! TabLine gui=bold guifg=#ffffff guibg=#000000
]])
require("tabby").setup()
