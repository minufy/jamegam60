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
    self.health = 3.5
    self:base_init(1.5)
    return self
end

function StaticEnemy:update(dt)
    self:base_update(dt)
end

function StaticEnemy:draw()
    Shaders.glitch:start(self.time_offset)
    love.graphics.draw(Image.static_enemy, self.x, self.y)
    Shaders.glitch:stop()
end

return StaticEnemy