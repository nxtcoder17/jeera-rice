local function fold_settings()
	vim.o.foldlevel = 99
	vim.o.foldenable = true
	vim.o.foldlevelstart = 99
	-- vim.opt.foldminlines = 10
	-- vim.opt.fillchars = "fold: "
	vim.opt.foldnestmax = 0
end

local function my_config()
	-- -- vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99
	vim.o.foldenable = true
	vim.o.foldlevelstart = 99
	-- vim.opt.foldminlines = 10
	-- vim.opt.fillchars = "fold: "
	vim.opt.foldnestmax = 4
	vim.opt.foldtext = ""

	-- TREESITTER based folding
	-- [snippet source](https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/)
	-- vim.opt.foldmethod = "expr"
	-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- vim.opt.foldcolumn = "0"
	-- vim.opt.foldtext = ""
	-- vim.opt.foldlevel = 99
	-- vim.opt.foldlevelstart = 1
	-- vim.opt.foldnestmax = 4

	local ufo = Require("ufo")

	ufo.setup({
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter" }
		end,
		enable_get_fold_virt_text = true,
		enable_fold_end_virt_text = true,
	})

	vim.keymap.set("n", "zr", function()
		ufo.openFoldsExceptKinds({ "comment" })
	end, { desc = " 󱃄 Open All Folds except comments" })

	vim.keymap.set("n", "<C-M-j>", function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zA", true, false, true), "m", true)
	end, { desc = " 󱃄 Open All Folds except comments" })

	-- vim.keymap.set("n", "zm", ufo.closeAllFolds, { desc = " 󱃄 Close All Folds" })
	vim.keymap.set("n", "zm", function()
		ufo.closeAllFolds()
	end, { desc = " 󱃄 Close All Folds" })

	vim.keymap.set("n", "<C-M-k>", function()
		vim.cmd("foldc")
	end, { desc = " 󱃄 Close All Folds" })

	vim.keymap.set("n", "zR", function()
		ufo.openFoldsExceptKinds({ "comment" })
	end, { desc = " Open All Folds except comments" })

	vim.cmd([[
hi! link UfoFoldedEllipsis @comment
]])
end

local function new_config()
	local function peekOrHover()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
		for _, k in ipairs(keys) do
			-- Add a prefix key to fire `trace` action,
			-- if Neovim is 0.8.0 before, remap yourself
			vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = bufnr })
		end
	end

	-- virtual fold text handler
	local handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end

	-- provider indent method for specific filetypes
	local ftMap = {
		vim = "indent",
		python = "indent",
		git = "",
	}
	-- provider selector by chain lsp->treesitter->indent
	---@param bufnr number
	---@return Promise
	local function customizeSelector(bufnr)
		local function handleFallbackException(err, providerName)
			if type(err) == "string" and err:match("UfoFallbackException") then
				return require("ufo").getFolds(bufnr, providerName)
			else
				return require("promise").reject(err)
			end
		end

		return require("ufo")
			.getFolds(bufnr, "lsp")
			:catch(function(err)
				return handleFallbackException(err, "treesitter")
			end)
			:catch(function(err)
				return handleFallbackException(err, "indent")
			end)
	end

	require("ufo").setup({
		open_fold_hl_timeout = 0,
		fold_virt_text_handler = handler,
		provider_selector = function(bufnr, filetype, buftype)
			return ftMap[filetype] or customizeSelector
		end,
	})
end

fold_settings()
new_config()
