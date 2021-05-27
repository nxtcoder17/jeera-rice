-- Vim AutoCommands

local cmd = vim.cmd

cmd [[augroup nxtcoder17]]
  cmd [[autocmd!]]
  cmd [[autocmd BufWritePost *.lua silent! :luafile %]]

  -- Restore Folds
  cmd [[ autocmd! BufWinEnter <buffer> silent! loadview ]]
  cmd [[ autocmd! BufWinLeave <buffer> silent! mkview ]]
cmd [[augroup end]]
