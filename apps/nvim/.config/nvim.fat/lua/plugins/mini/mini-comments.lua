local lang_comments = {
  gotmpl = "{{- /* %s */}}",
  gowork = "// %s",
  terraform = "# %s",
  proto = "// %s",
  go = "// %s",
  scheme = "; %s",
  kdl = "// %s",
  gotexttmpl = "{{- /* %s */}}",
  gohtmltmpl = "{{- /* %s */}}",
  jsonc = "// %s",
  hyprlang = "# %s",
}

Require("mini.comment").setup({
  options = {
    custom_commentstring = function()
      -- return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      local v = lang_comments[vim.bo.filetype]
      if v ~= nil then
        return v
      end

      local ok, ts_ctx_comment = pcall(require, "ts_context_commentstring")
      if ok then
        return ts_ctx_comment.calculate_commentstring()
      end

      return vim.bo.commentstring
    end,
  },
  mappings = {
    comment = "s;",
    comment_visual = "s;",
    comment_line = "s;",
  },
})
