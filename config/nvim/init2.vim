lua require'init'

set ttimeoutlen=100
set ttyfast
set lazyredraw

set autoread 

command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
command! -nargs=0 Fix execute ':silent !eslint_d --fix %' | execute ':redraw!'

let mapleader = ' '

cnoremap wqa wq \| qa

" RnVimR
nnoremap <M-o> :RnvimrToggle<CR>
tnoremap <M-o> <C-\><C-n>:RnvimrToggle<CR>


" Nvim
inoremap <expr> <Tab> v:lua.tab_complete()
snoremap <expr> <Tab> v:lua.tab_complete()
inoremap <expr> <S-Tab> v:lua.s_tab_complete()
inoremap <expr> <Tab> v:lua.s_tab_complete()

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


nnoremap <silent><leader>clf :Lspsaga lsp_finder<CR>
nnoremap <silent><leader>cca :Lspsaga code_action<CR>
vnoremap <silent><leader>cca :<C-U>Lspsaga range_code_action<CR>nnoremap <silent><leader>chd :Lspsaga hover_doc<CR>
nnoremap <silent><C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent><C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent><leader>csh :Lspsaga signature_help<CR>
nnoremap <silent><leader>crn :Lspsaga rename<CR>
nnoremap <silent><leader>cpd:Lspsaga preview_definition<CR>
nnoremap <silent> <leader>cld :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <leader>cot :Lspsaga open_floaterm<CR>
tnoremap <silent> <leader>cct <C-\><C-n>:Lspsaga close_floaterm<CR>
