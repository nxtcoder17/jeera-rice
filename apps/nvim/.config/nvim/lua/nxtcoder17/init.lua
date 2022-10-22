_G.R = function(pkg)
	package.loaded[pkg or "nxtcoder17.functions.dev"] = nil
	return require(pkg or "nxtcoder17.functions.dev")
end

_G.Fn = function()
	return R("nxtcoder17.functions")
end

pcall(require, "nxtcoder17.settings")
pcall(require, "nxtcoder17.plugins")
pcall(require, "nxtcoder17.keymaps")

