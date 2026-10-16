StaticEnemy = {}
StaticEnemy.__index = StaticEnemy

Image.new("static_enemy")

require("objects.enemy.base")(StaticEnemy)

function StaticEnemy.new(x, y)
    local self = setmetatable({}, StaticEnemy)
    self.x = x
    self.y = y
    self.w = Image.static_enemy:getWidth()
    self.h = Image.static_enemy:getHeight()
    for _ = 1, 3 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(10, 15)))
    end
    self.health = 5
    self:base_init()
    return self
end

function StaticEnemy:update(dt)
    self:base_update(dt)
end

function StaticEnemy:draw()
    love.graphics.draw(Image.static_enemy, self.x, self.y)
end

return StaticEnemy