-- Vim AutoCommands

local cmd = vim.cmd

cmd [[augroup nxtcoder17]]
  cmd [[autocmd!]]
  cmd [[autocmd BufWritePost *.lua silent! :luafile %]]

  -- Restore Folds
  cmd [[ autocmd! BufWinEnter <buffer> silent! loadview ]]
  cmd [[ autocmd! BufWinLeave <buffer> silent! mkview ]]

  -- Code Actions
  vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb() ]]

  vim.cmd [[ autocmd BufWritePost *.js,*.jsx :silent! eslint_d --fix % ]]
cmd [[augroup end]]

