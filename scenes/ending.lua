Ending = {}

function Ending:init()

end

function Ending:update(dt)
    if Input.restart.pressed then
        SM:set_fade(function ()
            SM:load("game", true)
        end)
    end
end

local margin = 20
function Ending:draw()
    love.graphics.draw(Image.bg)
    love.graphics.setFont(Font)
    local x = margin
    local y = margin
    love.graphics.setColor(Color.fg)
    love.graphics.print("you win! GG", x, y)
    y = y+Font:getHeight()*1.5
    love.graphics.print("your build: ", x, y)
    y = y+Font:getHeight()
    for i, title in ipairs(Game.upgrades) do
        love.graphics.print(" - "..title, x, y)
        y = y+Font:getHeight()
    end
    love.graphics.print("press [r] to restart", x, Res.h-margin-Font:getHeight()*2)
    love.graphics.print("made by minufy", x, Res.h-margin-Font:getHeight())
    Color.reset()
end

return Ending
