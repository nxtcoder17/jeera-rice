--[[
Config files by MrJakeSir
--]]

local gears = require("gears")
local lain  = require("lain")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Nord theme colorscheme
local colors                                    = {}
local fontspr                                   = 1.0
--
---- Aurora Nord Scheme
colors.green                                    = "#D8EFCFFA"
colors.alpha_zero                               = "#00000000"
colors.red                                      = "#FFB9af"
colors.orange                                   = "#F3cbb8"
colors.yellow                                   = "#fefecf"
colors.pink                                     = "#fedfef"

---- Frost
colors.frost                                    = {}
colors.frost.darkest                            = "#222529"
colors.frost.lightest                           = "#b4d9e3"
colors.frost.aqua                               = "#41464c"
colors.frost.light_green                        = "#8FBCBB"

---- Snow Storm
colors.light                                    = {}
colors.light.lighter                            = "#ECEFF4"
colors.light.darker                             = "#D8DEE9"
colors.light.medium                             = "#E5E9F0"
--
---- Polar night
colors.polar                                    = {}
colors.polar.darkest                            = "#2E3440"
colors.polar.lightest                           = "#35383f"
colors.polar.darker                             = "#3f434c"
colors.polar.lighter                            = "#434C5E"

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/nordish"

-- Sets up the wallpaper
theme.wallpaper                                 = theme.dir .. "/wallpaper.jpg"

-- Font
theme.font                                      = "Hack Nerd Font Mono 10"
theme.taglist_font                              = "Hack Nerd Font Mono 12"

-- Gaps between windows
-- Otherwise you can change them by using:
--      altkey + ctrl + j           = Increment gaps
--      altkey + ctrl + h           = Decrement gaps
theme.useless_gap                               = 0

--  Foreground variables  --
theme.fg_normal                                 = "#ffffff" -- White
theme.fg_focus                                  = colors.green
theme.fg_urgent                                 = "#000000" -- Black
--  Background variables  --
theme.bg_normal                                 = colors.polar.lightest
theme.bg_focus                                  = theme.bg_normal
theme.bg_urgent                                 = colors.red

-- Systray background color
theme.bg_systray                				= colors.polar.darker

-- Systray icon spacing
theme.systray_icon_spacing		            	= 10

-- Taglist configuration --
theme.taglist_bg_occupied                       = colors.orange
theme.taglist_fg_occupied                       = colors.orange
theme.taglist_bg_empty                          = colors.green
theme.taglist_fg_empty                          = colors.green
theme.taglist_bg_urgent                         = colors.pink
theme.taglist_fg_urgent                         = colors.pink
theme.taglist_fg_volatile                       = colors.frost.lightest
theme.taglist_bg_volatile                       = colors.frost.lightest
-- Colors
theme.taglist_fg_focus                          = colors.light.lighter
theme.taglist_bg_focus                          = colors.light.lighter

-- Taglist shape, refer to awesome wm documentation if you have
-- any doubt about this!
theme.taglist_shape                             = gears.shape.rounded_rect

-- Icon spacing between workspace icons
theme.taglist_spacing				            = 8

--[[
--
-- Tasklist Configuration,
-- NOTE: If you want a tasklist in your wibar,
-- UNCOMMENT THESE LINES!
theme.tasklist_bg_focus                         = "#00000000"
theme.tasklist_fg_focus                         = "#00000000"
theme.tasklist_fg_normal                        = "#00000000"
--]]

-- Sets the border to zero
theme.border_width                              = 0

-- If the border is not zero, it'll show
-- These colors
theme.border_normal                             = colors.orange
theme.border_focus                              = colors.green
theme.border_marked                             = colors.green

-- Titlebar variables, dont care about theme,
-- In this configuration file we wont use it!
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

-- Menu variables
theme.menu_height                               = dpi(25)
theme.menu_width                                = dpi(260)

-- Icons
--theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
--theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"

-- Tiling
-- theme.layout_tile                                 = theme.dir .. "/icons/tile.png"
--theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
--theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
--theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
--theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
--theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
--theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
--theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
--theme.layout_max                                = theme.dir .. "/icons/max.png"
--theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
--theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
--theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"

local markup = lain.util.markup
local separators = lain.util.separators


-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
        "date +' %R'", 60,
        function(widget, stdout)
            widget:set_markup(" " .. markup.font(theme.font, stdout))
        end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Comic Mono 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})


-- Memory lain widget
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        -- You can change its format here
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end

})



-- CPU lain widget
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)))


    -- Custom rounded background widget
    -- You can modify however you want
    -- Syntax:
    --  round_bg_widget(widget, background_colour)
    function round_bg_widget(widget, bg, fg)
        local widget = wibox.widget {

            -- Set up
            {
                widget,
                -- Margin
                left   = 10,
                spacing = 20,
                top    = 3,
                bottom = 3,
                right  = 10,
                widget = wibox.container.margin,
            },
            bg         = bg,
            fg         = fg,

            -- Sets the shape
            shape      = gears.shape.rounded_rect,
            shape_clip = true,
            widget     = wibox.container.background,
        }

        return widget
    end
    -- The function ends

    function add_app(app, text, fg, bg)
        -- Set up
        local widget = wibox.widget {
            {
                {
                    text = text,
                    font = string.format("Hack Nerd Font Mono %s", 20*fontspr),
                    widget = wibox.widget.textbox
                },
                -- Margin
                left   = 10,
                spacing = 20,
                top    = 3,
                bottom = 3,
                right  = 10,
                widget = wibox.container.margin,
            },

            bg         = bg,
            fg         = fg,

            -- Sets the shape
            shape      = gears.shape.rounded_rect,
            shape_clip = true,
            widget     = wibox.container.background,
        }
        widget:connect_signal("button::press",
                function()
                    widget.fg = colors.frost.lightest
                    awful.spawn.with_shell(app)
                end
        )
        widget:connect_signal("button::release",
                function()
                    widget.fg = fg
                end
        )
        widget:connect_signal("mouse::enter",
                function()
                    widget.fg = colors.green
                end
        )

        widget:connect_signal("mouse::leave",
                function()
                    widget.fg = fg
                end
        )
        return widget
    end
    ---------- Simple widget separator ----------
    local sep   = wibox.widget.textbox("  ")

    ---------- If you want to change the size of the spacing,
    --         change the font size, instead of 5. Just play with it!
    sep.font    = string.format("Comic Mono %s", 10*fontspr)


    local appsep= wibox.widget.textbox("  ")
    appsep.font = string.format("Comic Mono %s", 5*fontspr)

    local systray = wibox.widget.textbox("")
    local aditional_widgets = {}
    local minus = 0
    local volwidg = {

        layout=wibox.layout.fixed.horizontal,
        {
            volume_widget{widget_type='icon'},
            widget = wibox.container.margin,
        },

        {
            volume_widget{
                main_color=colors.frost.lightest,
                widget_type = 'horizontal_bar',
                bg_color=colors.polar.lighter
            },
            widget = wibox.container.margin,
        },
        widget = wibox.container.background
    }
    vol = {

        -- Set up
        {
            volwidg,
            -- Margin
            left   = 10,
            spacing = 20,
            top    = 0,
            bottom = 0,
            right  = 10,
            widget = wibox.container.margin,
        },
        bg         = colors.polar.darker,
        fg         = colors.green,

        -- Sets the shape
        shape      = gears.shape.rounded_rect,
        shape_clip = true,
        widget     = wibox.container.background,
    }


    if s.workarea.width > 1366 then
        ---------- Systray ----------
        systray = round_bg_widget(wibox.widget {
            layout=wibox.layout.fixed.horizontal,
            {
                {
                    text="♥",
                    font="Hack Nerd Font Mono 15",
                    widget=wibox.widget.textbox
                },
                widget=wibox.container.margin
            },
            {
                -- Margin
                wibox.widget.systray(),
                left   = 10,
                top    = 2,
                bottom = 2,
                right  = 10,
                widget = wibox.container.margin,
            },
            bg         = colors.polar.darker,

            -- Sets a rounded shape
            shape      = gears.shape.rounded_rect,
            shape_clip = true,
            widget     = wibox.container.background,
        }, colors.polar.darker, colors.yellow)

        minus = s.dpi-550

        aditional_widgets = {
            layout=wibox.layout.fixed.horizontal,
            -- Systray
            systray,
            -- round_bg_widget(
            --     wibox.widget
            --     {
            --         volume_widget{widget_type='icon'},
            --         widget = wibox.container.margin,
            --     },

            --     colors.polar.darker,
            --     colors.green
            -- ),
            --
            -- volume_widget{
            --     main_color=colors.frost.lightest,
            --     widget_type = 'horizontal_bar',
            --     bg_color=colors.polar.lighter
            -- },
            sep,
            round_bg_widget(
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            wibox.widget{
                                text="",
                                font="Hack Nerd Font Mono 15",
                                widget=wibox.widget.textbox
                            },
                            top    = 2,
                            bottom = 2,
                            widget = wibox.container.margin
                        },
                        {
                            awful.widget.keyboardlayout(),
                            top    = 2,
                            bottom = 2,
                            widget = wibox.container.margin
                        },
                        widget = wibox.container.background
                    },
            --awful.widget.keyboardlayout(),
                    colors.polar.darker,
                    colors.green
            ),sep,
            -- This widget displays the current  layout



            round_bg_widget(
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            wibox.widget{
                                text="类",
                                font="Hack Nerd Font Mono 15",
                                widget=wibox.widget.textbox
                            },
                            top    = 2,
                            bottom = 2,
                            right=10,
                            widget = wibox.container.margin
                        },
                        {
                            s.mylayoutbox,
                            top    = 2,
                            bottom = 2,
                            widget = wibox.container.margin
                        },
                        widget = wibox.container.background
                    },
                    colors.polar.darker,
                    colors.pink
            ),
            sep,
            vol
        }
    else
        fontspr = 0.55
        aditional_widgets = {text="", widget=wibox.widget.textbox}
        minus = minus - 100
    end

    -- Creates the wibox
    s.mywibox = awful.wibar(
            {
                position = "top",
                align='center',
                screen = s,
                height = dpi(25),
                --width = (s.workarea.width//2)-minus,
                shape  = gears.shape.rounded_rect,

                -- Sets an invisible background but the
                -- widgets keep showing
                bg = string.format("%s00", theme.bg_normal),
                fg = theme.fg_normal,
                opacity = 1.0,
            })

    -- Separates the wibox from the top a little bit,
    -- it you want it in the top, comment this line,
    -- or if you want to change its position, change
    -- its value
    s.mywibox.y = 8
    s.mywibox.x = s.mywibox.x + (s.workarea.width//2)//3.5

    ----------------------------------------
    --                                    --
    --            Widget setup            --
    --                                    --
    ----------------------------------------

    s.mywibox:setup {


        layout = wibox.layout.fixed.horizontal,
        { -- Left widgets
            {
                {
                    awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons),
                    left   = 10,
                    top    = 8,
                    bottom = 8,
                    right  = 10,
                    widget = wibox.container.margin
                },
                shape = gears.shape.rounded_bar,
                bg = colors.polar.darker,
                shape_clip = true,
                shape_border_width = 1,
                shape_border_color = theme.bg_normal,
                widget = wibox.container.background
            },
            {
                text="    ",
                font=string.format("Comic Mono %s", 10*fontspr),
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.horizontal,
            add_app("kitty",
                    "",
                    colors.red,
                    colors.polar.darker),
            appsep,
            add_app(
                    "kitty -e nvim",
                    "",
                    colors.pink,
                    colors.polar.darker
            ),

            appsep,
            add_app(
                    "dolphin",
                    "",

                    colors.pink,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "chromium",
                    "",
                    colors.frost.light_green,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "discord",
                    "ﭮ",
                    colors.frost.lightest,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "telegram-desktop",
                    "",
                    colors.light.medium,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "teams",
                    "",
                    colors.frost.light_green,
                    colors.polar.darker
            ),
            appsep,appsep,appsep,
            add_app(
                    "chromium https://reddit.com",
                    "",
                    colors.frost.light_green,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "chromium https://twitter.com",
                    "",
                    colors.frost.lightest,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "chromium https://youtube.com",
                    "",
                    colors.red,
                    colors.polar.darker
            ),


            {
                text="    ",
                font="Comic Mono 10",
                widget = wibox.widget.textbox
            }
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            -- Keyboard layout widget
            -- You can comment this widget
            -- if you dont want it, in my
            -- case i need this because
            -- i use two different keyboard
            -- distributions

            --  sep,

            -- Sets the system memory widget
            --  round_bg_widget(
            --
            --    -- Margin widget to add spacing
            --    wibox.container.margin(wibox.widget {
            --      memicon,
            --      mem.widget,
            --      layout = wibox.layout.align.horizontal
            --    },
            --    dpi(2),
            --    dpi(3)
            --    ),

            --    -- Sets the color
            --    colors.orange
            --  ),

            --   sep,

            -- CPU usage widget
            --    round_bg_widget(
            --		wibox.container.margin(wibox.widget {
            --          cpuicon,
            --          cpu.widget,
            --          layout = wibox.layout.align.horizontal },
            --          dpi(3),
            --          dpi(4)),

            --        -- Sets the color
            --		colors.yellow
            --	),
            -- Tasklist configuration

            -- s.mytaglist,
            --s.mypromptbox,
            --spr,



            aditional_widgets,
            --round_bg_widget(
            --    wibox.widget
            --    {
            --        volume_widget{widget_type='icon'},
            --        widget = wibox.container.margin,
            --    },

            --    colors.polar.darker,
            --    colors.green
            --),
            --
            --volume_widget{
            --    main_color=colors.frost.lightest,
            --    widget_type = 'horizontal_bar',
            --    bg_color=colors.polar.lighter
            --},
            --sep,
            --round_bg_widget(
            --  awful.widget.keyboardlayout(),
            --  colors.polar.darker,
            --  colors.green
            --),sep,
            ---- This widget displays the current  layout
            --
            --
            --
            --round_bg_widget(
            --	s.mylayoutbox,
            --	colors.polar.darker,
            --    colors.pink
            --),
            --sep,

            ---- Systray
            --systray,
            -- System time
            sep,
            round_bg_widget(wibox.container.margin(clock,
                    dpi(4),
                    dpi(8)),
                    colors.polar.darker,
                    colors.orange),

            appsep, appsep, appsep,
            add_app(
                    "kitty -e nmtui",
                    "",
                    colors.yellow,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "kitty -e htop",
                    "",
                    colors.green,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "shutdown now",
                    "",
                    colors.red,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "reboot",
                    "",
                    colors.red,
                    colors.polar.darker
            ),
            appsep,
            add_app(
                    "systemctl suspend",
                    "鈴",
                    colors.red,
                    colors.polar.darker
            )

        },
    }
    awful.screen.padding(screen[s], {top = 20, left = 20,
                                     right = 20, bottom = 20})
end

-- Returns the theme
return theme
