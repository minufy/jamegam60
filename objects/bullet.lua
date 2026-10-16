Bullet = {}
Bullet.__index = Bullet

local dists = {
    enemy = TILE_SIZE
}

function Bullet.new(x, y, dir, speed, damage)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.dir = dir
    self.speed = speed
    self.radius = 3
    self.w = self.radius
    self.h = self.radius
    self.damage = damage
    self.cbs = {
        enemy = function (other)
            other:hurt(self.damage, math.cos(self.dir), math.sin(self.dir))
            self.remove = true
        end
    }
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
    Game:dist(self, FILTERS.enemy, self.cbs.enemy, dists.enemy)
end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Bullet