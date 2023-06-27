_G.R = function(pkg)
  package.loaded[pkg or "nxtcoder17.functions.dev"] = nil
  return require(pkg or "nxtcoder17.functions.dev")
end

_G.Fn = function()
  return R("nxtcoder17.functions")
end

-- _G.OffLoad = function(pkg)
--   if pkg ~= "" then
--     package.loaded[pkg] = nil
--     _G[pkg] = nil
--     print(string.format("pkg %s offload", pkg))
--   end
-- end
