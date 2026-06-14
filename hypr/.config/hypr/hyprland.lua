
-- Hyprland config (Lua format). Reference: https://wiki.hypr.land/


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "alacritty"
local fileManager = "thunar"
local menu        = "wofi --show drun"  -- primary launcher (Super+R)
local browser     = "flatpak run app.zen_browser.zen"  -- web browser (Super+B)


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart lives in the single nesting-aware hl.on("hyprland.start", ...)
-- handler further down (near the window rules). Keep it in ONE place to avoid
-- double-launching waybar/hyprpaper.


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")   -- consistent cursor across Wayland + XWayland apps

-- Qt apps follow qt6ct/qt5ct (dark Fusion). Needs qt6ct/qt5ct installed.
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Ensure apps Hyprland launches can reach the D-Bus session bus.
-- Without this, GTK/Xfce apps (e.g. Thunar) fail to reach xfconfd and
-- report "Failed to initialize Xfconf" / can't load or save their config.
-- The user session bus always lives at $XDG_RUNTIME_DIR/bus (uid 1000 here).
hl.env("DBUS_SESSION_BUS_ADDRESS", "unix:path=/run/user/1000/bus")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled           = true,
            size              = 2,
            passes            = 1,
            new_optimizations = true,  -- cheaper blur, fewer dropped frames in motion
            ignore_opacity    = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("snappy",         { type = "bezier", points = { {0.05, 0.9},  {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 6,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 3.2,  bezier = "snappy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 2.8,  bezier = "snappy",       style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.8,  bezier = "snappy",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.5,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.3,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 2,    bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 2.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 2.5,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.5,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.3,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.7,  bezier = "snappy",       style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.1,  bezier = "snappy",       style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.7,  bezier = "snappy",       style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "gb",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,   -- content follows fingers; flip to false for traditional
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exit())   -- exit Hyprland (native dispatcher; no shell-out)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))  -- clipboard history
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))                     -- launcher (wofi)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("walker"))             -- launcher (walker, once installed)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("rofi -show drun")) -- launcher (rofi)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))                  -- web browser (firefox)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"))               -- wallpaper picker
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd("$HOME/.local/scripts/hypr-keys")) -- keybind cheatsheet
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))   -- lock screen (hyprlock via hypridle)
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("wlogout -b 3"))        -- power menu (lock/logout/suspend/...)
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("night-toggle"))     -- toggle night light (hyprsunset 4000K)

-- Move the focused window with mainMod + SHIFT + arrows
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))   -- move window left
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))  -- move window right
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))     -- move window up
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))   -- move window down

-- Resize the focused window with mainMod + CTRL + arrows
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0 }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40 }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40 }))

-- Screenshots (requires grim, slurp, wl-clipboard)
hl.bind("PRINT",                hl.dsp.exec_cmd("grim - | wl-copy"))                  -- full screen -> clipboard
hl.bind(mainMod .. " + PRINT",  hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))  -- region -> clipboard
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))  -- region -> annotate (swappy)
hl.bind("SHIFT + PRINT",        hl.dsp.exec_cmd("grim \"$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png\"")) -- full screen -> file

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Float common utility/dialog windows (settings panels, pickers, etc.)
hl.window_rule({
    name  = "float-utilities",
    match = { class = "(pavucontrol|blueman-manager|nm-connection-editor|galculator|org.gnome.Calculator|file-roller|nwg-look|qt6ct|qt5ct)" },
    float = true,
})

-- Float GTK/portal file-chooser dialogs
hl.window_rule({
    name  = "float-filechooser",
    match = { title = "(Open Files?|Save Files?|Save As|All Files|Choose .*)" },
    float = true,
})

-- Picture-in-Picture: floating, pinned across workspaces, small
hl.window_rule({
    name  = "pip-float",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin   = true,
    size  = "480 270",
    move  = "monitor_w-500 monitor_h-300",
})

hl.on("hyprland.start", function ()
    -- Status bar and wallpaper (safe in both nested and standalone sessions)
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")

    -- Clipboard history watchers — safe nested or standalone
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- The portal/env/daemon setup below is ONLY correct for a STANDALONE
    -- Hyprland session. When Hyprland is nested inside another desktop
    -- (e.g. GNOME), that outer session already owns the per-user portal,
    -- the notification service, and XDG_CURRENT_DESKTOP -- so touching them
    -- breaks both sessions and makes apps report "portal missing".
    -- We detect nesting by checking whether gnome-shell is running.
    hl.exec_cmd([[sh -c '
        if pgrep -x gnome-shell >/dev/null 2>&1; then
            echo "[hypr-autostart] nested in GNOME: skipping portal/env/dunst setup"
        else
            # Standalone session: bring up the Hyprland ecosystem properly.
            dunst &
            systemctl --user start hyprpolkitagent
            hypridle &   # idle/lock — ONLY standalone (nested it would lock GNOME / suspend the laptop)

            # Share display env with the systemd user + dbus activation context
            dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland

            # Restart portals so they pick up the Hyprland environment
            systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland
            systemctl --user start xdg-desktop-portal
        fi
    ']])
end)
