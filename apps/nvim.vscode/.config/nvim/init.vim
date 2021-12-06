" to make new lines not commented after a comment
au! BufEnter * set fo-=c fo-=r fo-=o

nnoremap s <nop>
nnoremap q <nop>

nnoremap ; :
nnoremap Y "+y
nnoremap cc "+y

nnoremap ss :call VSCodeCall('workbench.action.files.save')<CR>
nnoremap <silent> si :call VSCodeNotify('workbench.action.splitEditorRight')<CR>
nnoremap <silent> sm :call VSCodeNotify('workbench.action.splitEditorDown')<CR>

nnoremap <silent> sh :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> sl :call VSCodeNotify('workbench.action.navigateRight')<CR>
nnoremap <silent> sj :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> sk :call VSCodeNotify('workbench.action.navigateUp')<CR>

nnoremap <silent> sx :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <silent> za :call VSCodeNotify('editor.toggleFold')<CR>

nnoremap <silent> gd :call VSCodeNotify('editor.action.revealDefinitionAside')<CR>

nnoremap <silent> <C-w> :call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>

"vscode mapping to jump to next error
nnoremap <silent> sn :call VSCodeNotify('editor.action.nextError')<CR>

"vscode mapping to jump to previous error
nnoremap <silent> sp :call VSCodeNotify('editor.action.previousError')<CR>

"vscode mapping to toggle sidecar
nnoremap <silent> qf :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

" vscode mapping to describe the current error
nnoremap <silent> se :call VSCodeNotify('editor.action.showHover')<CR>

" mapping to toggle current line comment
nnoremap <silent> s; :call VSCodeNotify('editor.action.commentLine')<CR>

nnoremap <silent> sf :call VSCodeNotify('workbench.action.quickOpen')<CR>

" mapping to incremental visual selection
nnoremap <silent> <C-k> :call VSCodeNotify('editor.action.smartSelect.expand')<CR>

" mapping to behave exactly like vim-surround
nnoremap <silent> cs :call VSCodeNotify('editor.action.surroundSelection')<CR>
