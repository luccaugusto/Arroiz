-- {{{ Required libraries
local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local mytable       = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

naughty.config.defaults.position = "top_middle"
beautiful.notification_width = 300
beautiful.notification_margin = 10


-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

local chosen_theme = "powerarrow-dark"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal = os.getenv("TERMINAL")
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor
local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "nvim"
local browser      = os.getenv("BROWSER") or "firefox"

awful.util.terminal = terminal
awful.util.tagnames = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
	awful.layout.suit.floating,
    awful.layout.suit.fair,
    lain.layout.centerwork,
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

awful.util.taglist_buttons = mytable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = mytable.join(
     awful.button({ }, 1, function(c)
         if c == client.focus then
             c.minimized = true
         else
             c:emit_signal("request::activate", "tasklist", { raise = true })
         end
     end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        -- if only_one and not c.floating or c.maximized or c.fullscreen then
        --     c.border_width = 0
        -- else
            c.border_width = beautiful.border_width
        -- end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
	--awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(
    -- Show help
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ altkey, "Shift" }, "j", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ altkey, "Shift" }, "k", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
	awful.key({ modkey,           }, "c",
	function ()
		awful.client.focus.byidx( 1)
	end,
	{description = "focus next by index", group = "client"}
	),
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By-direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Menu

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --[[ awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}), ]]
    awful.key({ modkey,           }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}),

    -- -- Show/hide wibox
    -- awful.key({ modkey, "Shift" }, "b", function ()
    --         for s in screen do
    --             s.mywibox.visible = not s.mywibox.visible
    --             if s.mybottomwibox then
    --                 s.mybottomwibox.visible = not s.mybottomwibox.visible
    --             end
    --         end
    --     end,
    --     {description = "toggle wibox", group = "awesome"}),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    -- awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
    --           {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    -- awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    --           {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, altkey    }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, altkey    }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, ";", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ";", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- Dropdown application
    awful.key({ modkey, }, "u", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"})

    -- Screen brightness
    --[[ awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
              {description = "-10%", group = "hotkeys"}), ]]

    -- Copy primary to clipboard (terminals to gtk)
    -- awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
    --           {description = "copy terminal to gtk", group = "hotkeys"}),
    -- -- Copy clipboard to primary (gtk to terminals)
    -- awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
    --           {description = "copy gtk to terminal", group = "hotkeys"})
    --
    -- User programs
    -- awful.key({ modkey }, "w", function () awful.spawn(browser) end,
    --           {description = "run browser", group = "launcher"})

    -- Default
    -- Menubar
    -- awful.key({ modkey }, "space", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}),
    --dmenu
    --[[ awful.key({ modkey }, "space", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}), ]]
    --
    -- alternatively use rofi, a dmenu-like application with more features
    -- check https://github.com/DaveDavenport/rofi for more details
    -- rofi
    -- awful.key({ modkey }, "space", function ()
    --         os.execute("rofi -show drun -show-icons")
    --     end,
    --     {description = "show rofi", group = "launcher"}),
    -- awful.key({ modkey, "Shift" }, "space", function ()
    --         os.execute("rofi -show run -show-icons")
    --     end,
    --     {description = "run anny executable with rofi", group = "launcher"}),
    -- awful.key({ modkey }, "f", function ()
    --         os.execute("rofi -show window -show-icons")
    --     end,
    --     {description = "find window", group = "launcher"})
    -- Prompt
    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = mytable.join(
    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
     awful.key({ modkey, "Shift"   }, "o",      function () os.execute("move_all_windows_to_other_screen") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end, {description = "restore minimized", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"})
    -- awful.key({ modkey, "Shift"   }, "m",
    --     function (c)
    --         c.maximized_horizontal = not c.maximized_horizontal
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = mytable.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = mytable.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     callback = awful.client.setslave,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
		  "Floating",
		  "Tasklist",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
		  "zoom"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

	{ rule = { class = "firefox" },
		properties = { tag = "二" } },
	{ rule = { class = "Brave-browser" },
		properties = { tag = "二" } },
	{ rule = { class = "krita" },
		properties = { tag = "三" } },
	{ rule = { class = "Mail" },
		properties = { tag = "四" } },
	{ rule = { class = "thunderbird" },
		properties = { tag = "四" } },
	{ rule = { class = "ferdium" },
		properties = { tag = "四" } },
	{ rule = { class = "Ferdium" },
		properties = { tag = "四" } },
	{ rule = { class = "Postman" },
		properties = { tag = "五" } },
	{ rule = { class = "httpie" },
		properties = { tag = "五" } },
	{ rule = { class = "HTTPie" },
		properties = { tag = "五" } },
	{ rule = { class = "zoom" },
		properties = { tag = "五" } },
	{ rule = { class = "Slack" },
		properties = { tag = "六" } },
	{ rule = { class = "slack" },
		properties = { tag = "六" } },
	{ rule = { class = "transmission" },
		properties = { tag = "八" } },
	{ rule = { class = "beekeeper-studio" },
		properties = { tag = "九" } },
	{ rule = { class = "DBeaver" },
		properties = { tag = "九" } },
	{ rule = { class = "elisa" },
		properties = { tag = "十" } },
	{ rule = { class = "spotify" },
		properties = { tag = "十" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 16 }) : setup {
        { -- Left
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}
run_once({ "startup_progs" }) -- comma-separated entries
