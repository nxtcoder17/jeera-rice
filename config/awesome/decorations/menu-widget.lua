local beautiful = require("beautiful");
local awful = require("awful");
local userVars = require("main.user-variables");
local hotkeys_popup = require("awful.hotkeys_popup")

local awMenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", userVars.terminal .. " -e man awesome" },
   { "edit config", userVars.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local M = {}

M.menu = awful.menu({
     items = {
        { "awesome", awMenu, beautiful.awesome_icon },
        { "open terminal", terminal }
      }
})

M.launcher = awful.widget.launcher({
     image = beautiful.awesome_icon,
     menu = menu
})

return M;
