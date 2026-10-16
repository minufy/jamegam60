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
require("rebase.shader")
require("rebase.timer")
require("rebase.utils")

require("scenes.sm")

function love.load()
    require("init")()
    Log:init()
    Res:init()
    Shadow:init()
    SM:load("game")
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    Input:update()
    SM:update(dt)
    Input:reset_wheel()
    Log:update(dt)
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
        love.graphics.print(tostring(love.timer.getFPS()))
    end
end

function love.wheelmoved(dx, dy)
    Input:wheelmoved(dx, dy)
end

function love.resize(w, h)
    Res:resize(w, h)
end