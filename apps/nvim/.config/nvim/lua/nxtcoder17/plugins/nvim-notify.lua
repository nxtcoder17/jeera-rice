local notify = require("notify")

notify.setup({
  background_colour = "#33647a",
})

local function show_message(lang, msg)
  if not msg then
    notify.notify("Language server: " .. lang .. " is ready!", "info", {
      title = "Lsp Start Notification",
    })
  end
  notify.notify(msg, "info", { title = "Lsp Notification" })
end

local notified = {}

group = vim.api.nvim_create_augroup("Lsp Notify", {})

-- vim.api.nvim_create_autocmd("LspProgressUpdate", {
--   callback = function(arg)
--     local name = vim.lsp.get_client_by_id(arg.data.client_id).name
--     show_message(name, vim.lsp.util.get_progress_messages())
--   end,
--   group = group,
-- })
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(arg)
--     local name = vim.lsp.get_client_by_id(arg.data.client_id).name
--
--     if not notified[name] then
--       show_message(name)
--     end
--
--     notified[name] = true
--   end,
--   group = group,
-- })
