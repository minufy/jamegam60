Warning = {}
Warning.__index = Warning

Image.new("warning")

local time = 120

function Warning.new(x, y, cb)
    local self = setmetatable({}, Warning)
    self.w = Image.warning:getWidth()
    self.h = Image.warning:getHeight()
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.timer = 0
    self.cb = cb
    return self
end

function Warning:update(dt)
    self.timer = self.timer+dt
    if self.timer > time then
        self.cb()
        self.remove = true
    end
    if Game.choosing_upgrade or Game.player_dead then
        self.remove = true
    end
end

function Warning:draw()
    love.graphics.setColor(1, 1, 1, self.timer/time)
    CleanEdge:start(self.w, self.h)
    love.graphics.draw(Image.warning, self.x+self.w/2, self.y+self.h/2, Ease.out_elastic(self.timer/time*0.5)*math.pi, 1, 1, self.w/2, self.h/2)
    CleanEdge:stop()
    Color.reset()
end

return Warning