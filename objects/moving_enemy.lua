MovingEnemy = {}
MovingEnemy.__index = MovingEnemy

Image.new("moving_enemy")
Image.moving_enemy:setWrap("repeat", "repeat")

local speed = 4.6

require("objects.enemy.base")(MovingEnemy)

function MovingEnemy.new(x, y)
    local self = setmetatable({}, MovingEnemy)
    self.w = Image.moving_enemy:getWidth()
    self.h = Image.moving_enemy:getHeight()
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.health = 6
    self:base_init()
    return self
end

local move_damp = 0.05
function MovingEnemy:update(dt)
    if not Game.player_dead then
        local dir = math.atan2(Game.player.y-self.y, Game.player.x-self.x)
        self.mx = self.mx+(math.cos(dir)*speed-self.mx)*move_damp*dt
        self.my = self.my+(math.sin(dir)*speed-self.my)*move_damp*dt
    end
    self:base_update(dt)
end

function MovingEnemy:draw()
    Glitch:start(self.time_offset)
    love.graphics.draw(Image.moving_enemy, self.x, self.y)
    Glitch:stop()
end

return MovingEnemy