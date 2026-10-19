Bullet = {}
Bullet.__index = Bullet

local dists = {
    enemy = TILE_SIZE,
    player = TILE_SIZE*0.8,
}

function Bullet.new(x, y, dir, speed, damage, enemy_bullet, rocket, life)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.dir = dir
    self.speed = speed
    self.radius = 3
    self.w = self.radius
    self.h = self.radius
    self.damage = damage
    self.rocket = rocket or false
    self.life = life or 45
    self.enemy_bullet = enemy_bullet or false
    return self
end

function Bullet:col_hit(other)
    other:hurt(self.damage, math.cos(self.dir), math.sin(self.dir))
    self.remove = true
end

local dir_damp = 0.2
function Bullet:update(dt)
    self.life = self.life-dt
    if self.life < 0 then
        self:die()
    end
    local mouse_x = Input:get_x()+Camera.x
    local mouse_y = Input:get_y()+Camera.y
    if self.rocket then
        local dir = math.atan2(mouse_y-self.y, mouse_x-self.x)
        local diff = (dir - self.dir+math.pi)%(2*math.pi)-math.pi
        self.dir = self.dir+diff*dir_damp*dt
    end
    self.x = self.x+math.cos(self.dir)*self.speed*dt
    self.y = self.y+math.sin(self.dir)*self.speed*dt
    if Game:col(self, FILTERS.wall) then
        self:die()
    end
    if self.enemy_bullet then
        if Game.pause_summon then
            self:die()
        end
        Game:dist(self, FILTERS.player, self.col_hit, dists.player)
    else
        if Game.player_dead then
            self:die()
        end
        Game:dist(self, FILTERS.enemy, self.col_hit, dists.enemy)
    end
end

function Bullet:die()
    self.remove = true
    for _ = 1, 2 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12)))
    end
    Audio.play("bounce", RandomPitch())
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