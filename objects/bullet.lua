Bullet = {}
Bullet.__index = Bullet

function Bullet.new(x, y, dir, speed)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.dir = dir
    self.speed = speed
    self.radius = 3
    self.w = self.radius
    self.h = self.radius
    return self
end

function Bullet:update(dt)
    self.x = self.x+math.cos(self.dir)*self.speed*dt
    self.y = self.y+math.sin(self.dir)*self.speed*dt
    if Game:col(self, FILTERS.wall) then
        self.remove = true
        for _ = 1, 2 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12)))
        end
    end
end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Bullet