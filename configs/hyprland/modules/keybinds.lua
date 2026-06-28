local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more


--------------------
--- APPLICATIONS ---
--------------------

hl.bind(mainMod.." + Q", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod.." + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod.." + V", hl.dsp.exec_cmd("code --disable-gpu-compositing"))
hl.bind(mainMod.." + N", hl.dsp.exec_cmd("ghostty -e nvim ~"))
hl.bind(mainMod.." + S", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod.." + Z", hl.dsp.exec_cmd("prime-run zen-browser"))
hl.bind(mainMod.." + D", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod.." + W", hl.dsp.exec_cmd("iwgtk"))

hl.bind(mainMod.." + A", hl.dsp.exec_cmd("xdg-open https://chatgpt.com/?temporary-chat=true"))
hl.bind(mainMod.." + G", hl.dsp.exec_cmd("xdg-open https://gmail.com"))
hl.bind(mainMod.." + Y", hl.dsp.exec_cmd("xdg-open https://youtube.com"))
hl.bind(mainMod.." + M", hl.dsp.exec_cmd("xdg-open https://music.youtube.com"))

hl.bind(mainMod.." + R", hl.dsp.exec_cmd("$HOME/dev/runs/sync-configs.sh"))

-- ROFI --
hl.bind(mainMod.." + SUPER_L", hl.dsp.exec_cmd("$HOME/dev/runs/rofi-menu.sh"))
-- hl.bind("ALT + space", hl.dsp.exec_cmd("rofi -show drun"))
--hl.bind("ALT + space", hl.dsp.exec_cmd("$HOME/dev/runs/rofi-dmenu.sh"))


-- VICINAE --
-- hl.bind("ALT + space", hl.dsp.exec_cmd("vicinae toggle"))
-- hl.bind(mainMod.." + space", hl.dsp.exec_cmd("vicinae deeplink vicinae://extensions/vicinae/wm/switch-windows"))
hl.bind(mainMod.." + period", hl.dsp.exec_cmd("vicinae deeplink vicinae://extensions/vicinae/core/search-emojis"))


--------------------
----- HYPR ECO -----
--------------------

hl.bind(mainMod.." + B", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod.." + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind("Print",  hl.dsp.exec_cmd("hyprshot -m region -c -s -z --clipboard-only --freeze"), { locked = true })
hl.bind(mainMod.." + Print",  hl.dsp.exec_cmd("hyprshot -m window --clipboard-only --freeze"), { locked = true })
hl.bind(mainMod.." + SHIFT + Print",  hl.dsp.exec_cmd("hyprshot -m output --clipboard-only --freeze"), { locked = true })

--------------------
----- WINDOWS ------
--------------------

hl.bind(mainMod.." + C", hl.dsp.window.close())
hl.bind(mainMod.." + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod.." + J", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind(mainMod.." + BackSpace", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod.." + SHIFT + BackSpace", hl.dsp.exec_cmd("shutdown -f now"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod.." + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod.." + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod.." + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod.." + down",  hl.dsp.focus({ direction = "down" }))

--------------------
---- WORKSPACES ----
--------------------

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod.." + "..key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod.." + SHIFT + "..key,     hl.dsp.window.move({ workspace = i }))
end

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod.." + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod.." + mouse:273", hl.dsp.window.resize(), { mouse = true })

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

-- Toggle Brightness
hl.bind(mainMod.." + F1",  hl.dsp.exec_cmd("brightnessctl set 0%"),{ locked = true })
hl.bind(mainMod.." + F2",  hl.dsp.exec_cmd("brightnessctl set 100%"),{ locked = true })

-- Custom playerctl
hl.bind(mainMod.." + mouse_down",  hl.dsp.exec_cmd("playerctl next"))
hl.bind(mainMod.." + mouse_up",  hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod.." + mouse:274",  hl.dsp.exec_cmd("playerctl play-pause"))
