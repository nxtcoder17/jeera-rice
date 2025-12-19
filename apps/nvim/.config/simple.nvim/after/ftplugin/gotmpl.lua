vim.b.match_words = table.concat({
  vim.b.match_words or "",
  -- [[<%(if)>:<%(else|end)>]],
  [[\<if\>:\<\%(else|end\)\>]],
  -- [[\<\%(return\|else\|elseif\)\>:]],
}, ",")

-- vim.b.match_words = vim.fn.escape(table.concat({
--   [[<%(begin|function|%(else\s+)\@<!if|switch|while|for)>]], [[<else\s\+if|case>]], [[<else>]],
--   [[<end>]],
-- }, ':'), '+<>%|)'
-- )
--
-- -- vim.b.match_words =
-- vim.b.match_words =
-- [[\<if\>:\<elseif\>:\<else\>:\<endif\>,\<for\>:\<endfor\>,\<while\>:\<endwhile\>,\<try\>:\<catch\>:\<finally\>:\<endtry\>,\<func\(tion\)\?\>:\<endfunc\(tion\)\?\>,\<augroup [^E]\w*\>:\<augroup END\>]]
