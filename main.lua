-- load rebase modules
require("rebase.animation")
require("rebase.audio")
require("rebase.camera")
require("rebase.image")
require("rebase.input")
require("rebase.level")
require("rebase.log")
require("rebase.physics")
require("rebase.res")
require("rebase.shaders")
require("rebase.timer")
require("rebase.utils")

require("scenes.sm")

local debug_font

function love.load()
    debug_font = love.graphics.newFont(20)
    require("init")()
    Log:init()
    Res:init()
    Shaders.shadow:init({x = 3, y = 3}, 0.65)
    Shaders.cleanedge:init()
    Shaders.glitch:init()
    SM:load("game")
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    Input:update()
    SM:update(dt)
    Log:update(dt)
    Input:reset_wheel()
    if Input.fullscreen.pressed then
        Res:toggle_fullscreen()
    end
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
    Log:draw()
    if CONSOLE then
        love.graphics.setFont(debug_font)
        love.graphics.print(tostring(love.timer.getFPS()), 0, Log.smooth_h)
    end
end

function love.wheelmoved(dx, dy)
    Input:wheelmoved(dx, dy)
end

function love.resize(w, h)
    Res:resize(w, h)
end

function love.focus(f)
    SM:focus(f)
end
