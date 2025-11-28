if not notify_if_not_installed({
  "html-lsp",
  "emmet-language-server",
}) then
  vim.notify_error("[HTML] failed to start LSP server")
  return
end

vim.lsp.config("html", {
  filetypes = { "gohtmltmpl", "html", "htmljinja", "svelte", "vue" },
})

vim.lsp.config("emmet_language_server", {
  filetypes = { "gohtmltmpl", "html", "htmljinja", "svelte", "vue" },
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})

vim.lsp.enable({ "html", "emmet_language_server" })
require("languages.css.lsp")
