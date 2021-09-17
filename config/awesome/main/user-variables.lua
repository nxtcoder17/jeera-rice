local editor = os.getenv("EDITOR") or "vim"
local terminal = "konsole"

local M = {
    home = os.getenv("HOME"),
    modKey = "Mod4",

    terminal = terminal,
    editor = editor,
    editor_cmd = terminal .. "-e" .. editor,
}

return M
