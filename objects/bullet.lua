Bullet = {}
Bullet.__index = Bullet

local dists = {
    enemy = TILE_SIZE,
    player = TILE_SIZE*0.8,
}

function Bullet.new(x, y, dir, speed, damage, enemy_bullet)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.dir = dir
    self.speed = speed
    self.radius = 3
    self.w = self.radius
    self.h = self.radius
    self.damage = damage
    self.enemy_bullet = enemy_bullet or false
    self.cbs = {
        hit = function (other)
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
        self:die()
    end
    if self.enemy_bullet then
        if Game.pause_summon then
            self:die()
        end
        Game:dist(self, FILTERS.player, self.cbs.hit, dists.player)
    else
        if Game.player_dead then
            self:die()
        end
        Game:dist(self, FILTERS.enemy, self.cbs.hit, dists.enemy)
    end
end

function Bullet:die()
    self.remove = true
    for _ = 1, 2 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12)))
    end
end

function Bullet:draw()
    if self.enemy_bullet then
        love.graphics.setColor(Color.red)
    else
        love.graphics.setColor(Color.fg)
    end
    love.graphics.circle("fill", self.x, self.y, self.radius)
    Color.reset()
end

return Bullet