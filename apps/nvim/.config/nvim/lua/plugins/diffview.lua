require("diffview").setup({
  default_args = {
    DiffViewOpen = { "--imply-local" },
  },
  keymaps = {
    file_panel = {
      -- {
      -- 	"n",
      -- 	"sca",
      -- 	"<Cmd>Git commit --amend <bar> wincmd J<CR>",
      -- 	{ desc = "Commit staged changes, with --amend flag" },
      -- },
      -- {
      -- 	"n",
      -- 	"sc",
      -- 	"<Cmd>Git commit <bar> wincmd J<CR>",
      -- 	{ desc = "Commit staged changes" },
      -- },
    },
  },
})
