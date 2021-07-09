-- Vim AutoCommands

vim.cmd [[ augroup nxtcoder17 ]]
  vim.cmd [[ autocmd! ]]
  vim.cmd [[ autocmd BufWinEnter <buffer> silent! loadview ]]
  vim.cmd [[ autocmd BufWinLeave <buffer> silent! mkview ]]
  vim.cmd [[ autocmd CursorHold * lua require'nvim-lightbulb'.update_lightbulb() ]]
  vim.cmd [[ autocmd! CursorHold <buffer> silent! lua vim.lsp.buf.document_highlight() ]]
  vim.cmd [[ autocmd! CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight() ]]
  vim.cmd [[ autocmd! CursorMoved <buffer> silent! lua vim.lsp.buf.clear_references() ]]
vim.cmd [[ augroup end ]]
