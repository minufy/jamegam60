StaticEnemy = {}
StaticEnemy.__index = StaticEnemy

Image.new("static_enemy")
Image.static_enemy:setWrap("repeat", "repeat")

require("objects.enemy.base")(StaticEnemy)

function StaticEnemy.new(x, y)
    local self = setmetatable({}, StaticEnemy)
    self.w = Image.static_enemy:getWidth()
    self.h = Image.static_enemy:getHeight()
    self.x = x-self.w/2
    self.y = y-self.h/2
    for _ = 1, 3 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(10, 15)))
    end
    self.health = 5
    self.time_offset = math.random(1, 100)*10
    self:base_init()
    return self
end

function StaticEnemy:update(dt)
    self:base_update(dt)
end

function StaticEnemy:draw()
    Glitch:start(self.time_offset)
    love.graphics.draw(Image.static_enemy, self.x, self.y)
    Glitch:stop()
end

return StaticEnemy