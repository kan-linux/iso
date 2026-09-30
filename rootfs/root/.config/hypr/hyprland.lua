-- kan-linux Hyprland 配置 (Lua 格式)

hl.config({
    misc = {
        disable_hyprland_guiutils_check = true,
        disable_watchdog_warning = true,
        force_default_wallpaper = 0,
    },
})

hl.monitor({
    output   = "",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})

hl.config({
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
    },
})

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size   = 3,
            passes = 1,
        },
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },
})

hl.curve("ease", { type = "bezier", points = { {0.25, 0.1}, {0.25, 1.0} } })

hl.animation({ leaf = "global",     enabled = true, speed = 10, bezier = "ease" })
hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "ease" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "ease", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "ease" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "ease" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "ease" })

local mainMod = "SUPER"

-- 启动音频服务（exec-once）
os.execute("bash /root/.config/hypr/autostart.sh &")

-- Omarchy 风格复刻，mainMod 就是 Super(Win键)
-- 1. Super + Return 启动 foot（终端，omarchy标准）
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("foot"))
-- 2. Super + Alt + Return 带tmux的终端（omarchy原版附带）
hl.bind(mainMod .. " + ALT + Return",  hl.dsp.exec_cmd("foot -- tmux new"))

hl.bind("CTRL + T",             hl.dsp.exec_cmd("foot"))
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd("foot"))

hl.bind("CTRL + F",             hl.dsp.exec_cmd("/opt/firefox/firefox"))
-- 3. Super + Shift + Return 启动浏览器
hl.bind(mainMod .. " + SHIFT + Return",hl.dsp.exec_cmd("/opt/firefox/firefox"))

hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())

hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())

for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
