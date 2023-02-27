-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local numpad_map = {87, 88, 89, 83, 84, 85, 79, 80, 81}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify(
      {
	 preset = naughty.config.presets.critical,
	 title = "Oops, there were errors during startup!",
	 text = awesome.startup_errors
      }
   )
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal(
      "debug::error", function(err)
	 -- Make sure we don't go into an endless error loop
	 if in_error then return end
	 in_error = true

	 naughty.notify(
	    {
	       preset = naughty.config.presets.critical,
	       title = "Oops, an error happened!",
	       text = tostring(err)
	    }
	 )
	 in_error = false
      end
   )
end
-- }}}

--################################################################################
--################################### globals ####################################
--################################################################################
terminal = "alacritty"
editor = "vim" or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

--################################################################################
--############################### custom functions ###############################
--################################################################################

function snap_edge(c, where, geom)
   c.floating = true
   c.maximized = false
   local sg = screen[c.screen].geometry -- screen geometry
   local sw = screen[c.screen].workarea -- screen workarea
   local workarea = {
      x_min = sw.x,
      x_max = sw.x + sw.width,
      y_min = sw.y,
      y_max = sw.y + sw.height
   }
   local cg = geom or c:geometry()
   local border = c.border_width
   local cs = c:struts()
   cs['left'] = 0
   cs['top'] = 0
   cs['bottom'] = 0
   cs['right'] = 0
   if where ~= nil then
      c:struts(cs) -- cancel struts when snapping to edge
   end
   if where == 'right' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height
      cg.x = workarea.x_max - cg.width
      cg.y = workarea.y_min
   elseif where == 'left' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height
      cg.x = workarea.x_min
      cg.y = workarea.y_min
   elseif where == 'bottom' then
      cg.width = sw.width
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_min
      cg.y = workarea.y_max - cg.height
      awful.placement.center_horizontal(c)
   elseif where == 'top' then
      cg.width = sw.width
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_min
      cg.y = workarea.y_min
      awful.placement.center_horizontal(c)
   elseif where == 'topright' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_max - cg.width
      cg.y = workarea.y_min
   elseif where == 'topleft' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_min
      cg.y = workarea.y_min
   elseif where == 'bottomright' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_max - cg.width
      cg.y = workarea.y_max - cg.height
   elseif where == 'bottomleft' then
      cg.width = sw.width / 2 - 2 * border
      cg.height = sw.height / 2 - 2 * border
      cg.x = workarea.x_min
      cg.y = workarea.y_max - cg.height
   elseif where == 'center' then
      awful.placement.centered(c)
      return
   elseif where == nil then
      c:struts(cs)
      c:geometry(cg)
      return
   end
   c:geometry(cg)
   awful.placement.no_offscreen(c)
   return
end

function max(c)
    -- we need to reset the maximized properties for them to take effect. 
    c.maximized_horizontal = false
    c.maximized_vertical = false
    c.maximized_horizontal = true
    c.maximized_vertical = true
   awful.placement.no_offscreen(c)
   return
end


local function create_wibox(s) 

    -- Create a launcher widget and a main menu
    myawesomemenu = {
       {
          "hotkeys",
          function() hotkeys_popup.show_help(nil, awful.screen.focused()) end
       },
       {"manual", terminal .. " -e man awesome"},
       {"edit config", editor_cmd .. " " .. awesome.conffile},
       {"restart", awesome.restart},
       {"quit", function() awesome.quit() end}
    }
    
    mymainmenu = awful.menu(
       {
          items = {
    	 {"awesome", myawesomemenu, beautiful.awesome_icon},
    	 {"open terminal", terminal}
          }
       }
    )
    

    mylauncher = awful.widget.launcher(
       {image = beautiful.awesome_icon, menu = mymainmenu}
    )
    
    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}
    
    -- Keyboard map indicator and switcher
    mykeyboardlayout = awful.widget.keyboardlayout()

    -- Create a textclock widget
    local calendar_widget = require("calendar")
    mytextclock = wibox.widget.textclock()
    local cw = calendar_widget({
        placement = 'top_right',
        previous_month_button = 1,
        next_month_button = 3,
    })
    mytextclock:connect_signal("button::press",
        function(_, _, _, button)
            if button == 1 then cw.toggle() end
        end)

    -- Create a wibox for each screen and add it
    local taglist_buttons = gears.table.join(
                        awful.button({ }, 1, function(t) t:view_only() end),
                        awful.button({ modkey }, 1, function(t)
                                                  if client.focus then
                                                      client.focus:move_to_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ modkey }, 3, function(t)
                                                  if client.focus then
                                                      client.focus:toggle_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 5, function(t) 
                            
                            awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                    )
    
    local tasklist_buttons = gears.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      c:emit_signal(
                                                          "request::activate",
                                                          "tasklist",
                                                          {raise = true}
                                                      )
                                                  end
                                              end),
                         awful.button({ }, 3, function()
                                                  awful.menu.client_list({ theme = { width = 500 } })
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(1)
                                              end),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(-1)
                                              end))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = {
       awful.layout.suit.floating,
       awful.layout.suit.tile
    }
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create the wibox
    s.mywibox = awful.wibar({
		position = beautiful.wibar_position,
		screen = s,
		height = beautiful.wibar_height,
		bg = "#00000000"
	})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }

end

local function set_wallpaper()
   -- Wallpaper
   awful.spawn("nitrogen --restore &")
end

--################################################################################
--#################################### theme #####################################
--################################################################################

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

--################################################################################
--################################## per screen ##################################
--################################################################################

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
   function(s)
      -- Wallpaper
      set_wallpaper()

      -- create wibox
      create_wibox(s)

      -- Each screen has its own tag table.
      awful.tag(
 	 {"1: Music", "2: Env",  "3: Chill", "4: CybSec", "5: AI", "6: Code", "7: Work", "", ""}, s,
 	 awful.layout.layouts[1]
      )
   end
)

--################################################################################
--################################### bindings ###################################
--################################################################################

-- {{{ Mouse bindings
root.buttons(
   gears.table.join(
      awful.button(
	 {}, 3, function() mymainmenu:toggle() end
      ), awful.button({}, 4, awful.tag.viewprev),
      awful.button({}, 5, awful.tag.viewnext)
   )
)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -D pulse sset Master 2%+", false) end),
awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -D pulse sset Master 2%-", false) end),
awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -D pulse sset Master toggle", false) end), 
   awful.key(

      {modkey, "Shift"}, "/", hotkeys_popup.show_help,
      {description = "show help", group = "awesome"}
   ),
   awful.key(
      {modkey}, "s", function() awful.client.focus.byidx(1) end,
      {description = "focus next by index", group = "client"}
   ),
   awful.key(
      {modkey, "Alt_L"}, "s", function() awful.client.focus.byidx(-1) end,
      {description = "focus previous by index", group = "client"}
   ),
   awful.key(
      {modkey}, "Return", function() awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}
   ),
   awful.key(
      {modkey}, "0", awesome.restart,
      {description = "reload awesome", group = "awesome"}
   ),
   awful.key(
      {modkey, "Shift"}, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}
   ),
   awful.key(
      {modkey}, "o", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"}
   ),
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
   awful.key({ modkey1, modkey }, "Down",
      function()
	 awful.client.focus.global_bydirection("down")
	 if client.focus then client.focus:raise() end
      end,
      {description = "focus down", group = "client"}),
   awful.key({ modkey1, modkey }, "Up",
      function()
	 awful.client.focus.global_bydirection("up")
	 if client.focus then client.focus:raise() end
      end,
      {description = "focus up", group = "client"}),
   awful.key({ modkey1, modkey }, "Left",
      function()
	 awful.client.focus.global_bydirection("left")
	 if client.focus then client.focus:raise() end
      end,
      {description = "focus left", group = "client"}),
   awful.key({ modkey1, modkey }, "Right",
      function()
	 awful.client.focus.global_bydirection("right")
	 if client.focus then client.focus:raise() end
      end,
      {description = "focus right", group = "client"})
)

clientkeys = gears.table.join(
   awful.key({modkey}, "x", function(c) snap_edge(c, 'bottom') end),
   awful.key({modkey}, "a", function(c) snap_edge(c, 'left') end),
   awful.key({modkey}, "d", function(c) snap_edge(c, 'right') end),
   awful.key({modkey}, "w", function(c) snap_edge(c, 'top') end),
   awful.key({modkey}, "z", function(c) snap_edge(c, 'bottomleft') end),
   awful.key({modkey}, "c", function(c) snap_edge(c, 'bottomright') end),
   awful.key({modkey}, "q", function(c) snap_edge(c, 'topleft') end),
   awful.key({modkey}, "e", function(c) snap_edge(c, 'topright') end),

   awful.key(
      {modkey}, "g", function(c) c:kill() end,
      {description = "close", group = "client"}
   ),
   awful.key(
      {modkey}, "s", function(c) c:move_to_screen() end,
      {description = "move to screen", group = "client"}
   ),
   awful.key({modkey}, "f", function(c) max(c) end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   globalkeys = gears.table.join(
      globalkeys, -- View tag only.
      awful.key(
	 {modkey}, "#" .. i + 9, function()
        for s in screen do
            local tag = s.tags[i]
            if tag then tag:view_only() end
        end
	 end, {description = "view tag #" .. i, group = "tag"}
      ), -- Toggle tag display.
      awful.key(
	 {modkey, "Control"}, "#" .. i + 9, function()
	    local screen = awful.screen.focused()
	    local tag = screen.tags[i]
	    if tag then awful.tag.viewtoggle(tag) end
	 end, {description = "toggle tag #" .. i, group = "tag"}
      ), -- Move client to tag.
      awful.key(
	 {modkey}, "F" .. i, function()
	    if client.focus then
	       local tag = client.focus.screen.tags[i]
	       if tag then client.focus:move_to_tag(tag) end
	    end
	 end, {
	    description = "move focused client to tag #" .. i,
	    group = "tag"
	      }
      ), -- Toggle tag on focused client.
      awful.key(
	 {modkey, "Control", "Shift"}, "#" .. i + 9, function()
	    if client.focus then
	       local tag = client.focus.screen.tags[i]
	       if tag then client.focus:toggle_tag(tag) end
	    end
	 end, {
	    description = "toggle focused client on tag #" .. i,
	    group = "tag"
	      }
      )
   )
end
root.keys(globalkeys)

clientbuttons = gears.table.join(

   awful.button(
      {}, 1, function(c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
      end
   ), awful.button(
      {modkey}, 1, function(c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.move(c)
      end
		  ), awful.button(
      {modkey}, 3, function(c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.resize(c)
      end
				 )
)

--################################################################################
--#################################### rules #####################################
--################################################################################

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   {
      rule = {},
      properties = {
	 border_width = beautiful.border_width,
	 border_color = beautiful.border_normal,
	 focus = awful.client.focus.filter,
	 raise = true,
	 keys = clientkeys,
	 buttons = clientbuttons,
	 screen = awful.screen.preferred,
	 placement = awful.placement.no_overlap +
	    awful.placement.no_offscreen
      }
   }, -- Floating clients.
   {
      rule_any = {
	 instance = {
	    "DTA", -- Firefox addon DownThemAll.
	    "copyq", -- Includes session name in class.
	    "pinentry"
	 },
	 class = {
	    "Arandr",
	    "Blueman-manager",
	    "Gpick",
	    "Kruler",
	    "MessageWin", -- kalarm.
	    "Sxiv",
	    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
	    "Wpa_gui",
	    "veromix",
	    "xtightvncviewer"
	 },

	 -- Note that the name property shown in xprop might be set slightly after creation of the client
	 -- and the name shown there might not match defined rules here.
	 name = {
	    "Event Tester" -- xev.
	 },
	 role = {
	    "AlarmWindow", -- Thunderbird's calendar.
	    "ConfigManager", -- Thunderbird's about:config.
	    "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
	 }
      },
      properties = {floating = true}
   }, -- Add titlebars to normal clients and dialogs
   {
      rule_any = {type = {"normal", "dialog"}},
      properties = {titlebars_enabled = true}
   }

}
-- }}}

--################################################################################
--################################### signals ####################################
--################################################################################

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
   "manage", function(c)
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      -- if not awesome.startup then awful.client.setslave(c) end

      if awesome.startup and not c.size_hints.user_position and
	 not c.size_hints.program_position then
	 -- Prevent clients from being unreachable after screen count changes.
	 awful.placement.no_offscreen(c)
      end
   end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
   "request::titlebars", function(c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
	 awful.button(
	    {}, 1, function()
	       c:emit_signal(
		  "request::activate", "titlebar", {raise = true}
	       )
	       awful.mouse.client.move(c)
	    end
	 ), awful.button(
	    {}, 3, function()
	       c:emit_signal(
		  "request::activate", "titlebar", {raise = true}
	       )
	       awful.mouse.client.resize(c)
	    end
			)
      )

      awful.titlebar(c):setup{
	 { -- Left
	    awful.titlebar.widget.iconwidget(c),
	    buttons = buttons,
	    layout = wibox.layout.fixed.horizontal
	 },
	 { -- Middle
	    { -- Title
	       align = "center",
	       widget = awful.titlebar.widget.titlewidget(c)
	    },
	    buttons = buttons,
	    layout = wibox.layout.flex.horizontal
	 },
	 { -- Right
	    awful.titlebar.widget.ontopbutton(c),
	    awful.titlebar.widget.stickybutton(c),
	    awful.titlebar.widget.minimizebutton(c),
	    awful.titlebar.widget.maximizedbutton(c),
	    awful.titlebar.widget.closebutton(c),
	    layout = wibox.layout.fixed.horizontal()
	 },
	 layout = wibox.layout.align.horizontal
			     }
   end
)

client.connect_signal(
   "requests_no_titlebar", function(c)
      awful.titlebar.titlebar.hide(c) end )


client.connect_signal(
   "focus", function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal(
   "unfocus", function(c) c.border_color = beautiful.border_normal end
)
-- }}}

--awful.spawn.with_shell("/home/dotconfig/.config/polybar/launch.sh")
--awful.spwan.with_shell("xrandr --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --primary --mode 2560x1440 --pos 0x370 --rotate normal --output HDMI-A-0 --mode 2560x1440 --pos 2560x0 --rotate left")



