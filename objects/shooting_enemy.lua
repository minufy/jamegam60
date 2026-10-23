ShootingEnemy = {}
ShootingEnemy.__index = ShootingEnemy

Image.new("shooting_enemy")
Image.shooting_enemy:setWrap("repeat", "repeat")

require("objects.enemy.base")(ShootingEnemy)

local shoot_time = 65
local damage = 1
local bullet_speed = 1.6

function ShootingEnemy.new(x, y)
    local self = setmetatable({}, ShootingEnemy)
    self.w = Image.shooting_enemy:getWidth()
    self.h = Image.shooting_enemy:getHeight()
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.health = 10
    self:base_init()
    self.shoot_timer = Timer.new(shoot_time)
    return self
end

function ShootingEnemy:update(dt)
    self:base_update(dt)
    if not Game.player_dead and self.shoot_timer:run(dt) then
        self:fire()
    end
end

function ShootingEnemy:fire()
    self.dir = math.atan2(Game.player.y-self.y, Game.player.x-self.x)
    local cos = math.cos(self.dir)
    local sin = math.sin(self.dir)
    self.mx = self.mx-cos*damage*0.5
    self.my = self.my-sin*damage*0.5
    local x = self.x+self.w/2+cos*self.w
    local y = self.y+self.h/2+sin*self.h
    Game:add(Bullet.new(x, y, self.dir, bullet_speed, damage, true, false, 200))
    for _ = 1, 3 do
        Game:add(SparkParticle.new(x, y, self.dir+math.random(-10, 10)*0.05, math.random(2, 4), math.random(2, 4)))
    end
    Audio.play("shoot", RandomPitch())
end

function ShootingEnemy:draw()
    Shaders.glitch:start(self.time_offset)
    love.graphics.draw(Image.shooting_enemy, self.x, self.y)
    Shaders.glitch:stop()
end

return ShootingEnemy
