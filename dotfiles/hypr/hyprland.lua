-- ~/.config/hypr/hyprland.lua
-- Migrated from hyprlang (0.56, configType = "hyprlang") to Lua (0.57+ ready)
-- Ref: https://wiki.hypr.land/Configuring/Start/

---------------------
---- MY PROGRAMS ----
---------------------
local mainMod = "SUPER"
local terminal = "foot"
local browser = "brave"
local files = "nautilus"
local ide = "codium"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- Force Electron/Chromium/Qt apps (Brave, VSCodium, Discord) to render
-- natively on Wayland instead of falling back to blurry XWayland.
hl.env("NIXOS_OZONE_WL", "1")
hl.env("QT_QPA_PLATFORM", "wayland")

------------------
---- MONITORS ----
------------------
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1.2,
})

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("caelestia shell -d")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
	decoration = {
		rounding = 10,
		rounding_power = 2,
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
		},
		shadow = {
			enabled = true,
			range = 15,
			render_power = 3,
		},
	},
})


---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(ide))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("CTRL + ALT + delete", hl.dsp.global("caelestia:session"))
hl.bind(mainMod .. " + V", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

	local win = hl.get_active_window()
	if win ~= nil and win.floating then
		local mon = hl.get_active_monitor()
		hl.dispatch(hl.dsp.window.resize({
			exact = true,
			x = math.floor(mon.width * 0.5),
			y = math.floor(mon.height * 0.5),
		}))
		hl.dispatch(hl.dsp.window.center())
	end
end)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D", hl.dsp.global("caelestia:launcher"))
hl.bind(mainMod .. " + L", hl.dsp.global("caelestia:lock"))

-- Workspaces 1-4, mainMod+SHIFT to move window
for i = 1, 4 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Move focus (arrow keys)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Mouse move / resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media / brightness keys (old bindel = locked + repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("caelestia shell brightness set +5%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("caelestia shell brightness set 5%-"),
	{ locked = true, repeating = true }
)
