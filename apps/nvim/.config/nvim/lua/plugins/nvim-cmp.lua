local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
luasnip.config.set_config({
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
})

local log = require("plenary.log").new({ plugin = "cmp", level = "debug" })

cmp.register_source("goimports", require("plugins.cmp-sources.go-imports"))

cmp.setup({
  performance = {
    debounce = 50,
    throttle = 10,
  },

  preselect = cmp.PreselectMode.None,

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        local lineText = table.concat(vim.api.nvim_buf_get_text(0, line - 1, col - 1, line - 1, col, {}), ",")
        if cmp.visible() then
          if lineText == "{" or lineText == "(" or lineText == "[" then
            fallback()
            return
          end
        end
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          return
        end
        fallback()
      end,
    }),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
        return
      end

      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
        return
      end

      if cmp.visible() then
        return
      end

      if has_words_before() then
        cmp.complete()
        return
      end

      fallback()
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
        return
      end

      if cmp.visible then
        cmp.select_prev_item()
      end

      fallback()
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 80, group_index = 1 },
    { name = "nvim_lua", priority = 80, group_index = 1 },
    { name = "path",     priority = 40, group_index = 5 },
    { name = "luasnip" },
    {
      name = "buffer",
      priority = 5,
      keyword_length = 3,
      group_index = 5,
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    {
      name = "rg",
      keyword_length = 3,
      priority = 5,
      group_index = 5,
      option = {
        additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/scripts/rgignore",
      },
    },
    { name = "goimports", max_item_count = 5, keyword_length = 3 },
  }),
  -- sorting = {
  -- 	priority_weight = 2,
  -- 	comparators = {
  -- 		cmp.config.compare.order,
  -- 		cmp.config.compare.locality,
  -- 		cmp.config.compare.recently_used,
  -- 		cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
  -- 		cmp.config.compare.offset,
  -- 		-- require("cmp_tabnine.compare"),
  -- 	},
  -- },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local menu = ({
        buffer = "buffer",
        nvim_lsp = "lsp",
        luasnip = "luaSnip",
        nvim_lua = "lua",
        latex_symbols = "laTeX",

        codeium = "⚡",
        rg = "rg",

        fuzzy_buffer = "fzf",
        cmp_tabnine = "⚡",
        treesitter = "treesitter",
        nvim_lsp_signature_help = "lsp signature",
        path = "path",
        tmux = "tmux",
        goimports = "🖅  Go-Imports",
        copilot = "CoPilot",
      })[entry.source.name]

      local kind = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "Ω") .. " "

      if entry.source.name == "cmdline" then
        kind.kind = " ❯⚊ "
      end

      -- kind.menu = "    (" .. (strings[2] or "") .. ")"
      kind.menu = "    (" .. (menu or "Ω") .. ")"

      local item = entry:get_completion_item()
      if item.detail then
        kind.menu = kind.menu .. " 👉 " .. item.detail
      end

      return kind
    end,
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.setup.cmdline({ ":" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "cmdline" },
  }),
})
