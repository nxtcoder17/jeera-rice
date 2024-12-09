local M = {}

M.fileTypes = {
  javscript = { "javascript", "typescript" },
  react = { "javascriptreact", "typescriptreact" },
  javascriptreact = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
}

M.events = {
  BufReadPost = "BufReadPost",
  BufReadPre = "BufReadPre",
  BufEnter = "BufEnter",
  InsertEnter = "InsertEnter",
  VimEnter = "VimEnter",
}

return M
