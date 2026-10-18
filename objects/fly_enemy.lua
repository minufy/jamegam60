FlyEnemy = {}
FlyEnemy.__index = FlyEnemy

Image.new("fly_enemy")
Image.fly_enemy:setWrap("repeat", "repeat")

local speed = 20

require("objects.enemy.base")(FlyEnemy)

function FlyEnemy.new(x, y)
    local self = setmetatable({}, FlyEnemy)
    self.w = Image.fly_enemy:getWidth()
    self.h = Image.fly_enemy:getHeight()
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.health = 5
    self:base_init()
    return self
end

local move_damp = 0.1
function FlyEnemy:update(dt)
    local dir = math.random(1, 360)
    self.mx = self.mx+(math.cos(dir)*speed-self.mx)*move_damp*dt
    self.my = self.my+(math.sin(dir)*speed-self.my)*move_damp*dt
    self:base_update(dt)
end

function FlyEnemy:draw()
    Shaders.glitch:start(self.time_offset)
    love.graphics.draw(Image.fly_enemy, self.x, self.y)
    Shaders.glitch:stop()
end

return FlyEnemy