lua require'init'


set ttimeoutlen=100
set ttyfast
set lazyredraw

set autoread 

command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
command! -nargs=0 Fix execute ':silent !eslint_d --fix %' | execute ':redraw!'


nnoremap Q <NOP>
nnoremap cc <NOP>
nnoremap ;  :
nnoremap <BS> :nohlsearch<CR>

let mapleader = ' '

nnoremap Y "+y
vnoremap Y "+y

cnoremap wqa wq \| qa

" The sexy [s]
nnoremap s <NOP>

" [S]exy commenting
nmap s<space> gcc
vmap s<space> gc


" [S]exy Save
nnoremap ss :w<CR>

" [S]exy Buffer Delete
nnoremap sd :bdelete<CR>

" [S]exy splits
nnoremap si :vsplit<CR>
nnoremap sm :split<CR>

" [S]exy split navigation
nnoremap sh <C-w>h
nnoremap sl <C-w>l
nnoremap sk <C-w>k
nnoremap sj <C-w>j

" [S]exy Telescope
nnoremap sf :lua require'telescope.builtin'.find_files{hidden = true, follow = true}<CR>
nnoremap <S-f> :lua require'telescope.builtin'.live_grep{}<CR>

" Vim Tmux Navigator
nnoremap <M-h> :TmuxNavigateLeft<CR>
nnoremap <M-l> :TmuxNavigateRight<CR>
nnoremap <M-j> :TmuxNavigateDown<CR>
nnoremap <M-k> :TmuxNavigateUp<CR>

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


augroup nxtcoder17
  autocmd!
  au BufWritePost *.lua silent! :luafile %

  " Restore Folds
  autocmd! BufWinEnter <buffer> silent! loadview
  autocmd! BufWinLeave <buffer> silent! mkview

  " Code Actions
  au CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

  au BufWritePost *.js,*.jsx silent Neoformat
augroup end

" highlight symbol under cursor
autocmd CursorHold  <buffer> silent! lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight()
autocmd CursorMoved <buffer> silent! lua vim.lsp.buf.clear_references()

let g:neoformat_enabled_javascript = ['eslint_d']
