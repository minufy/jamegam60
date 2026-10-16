Player = {}
Player.__index = Player

require("objects.player.movement")(Player)
require("objects.player.draw")(Player)
require("objects.player.collision")(Player)

function Player.new()
    local self = setmetatable({}, Player)
    self.w = Image.player:getWidth()
    self.h = Image.player:getHeight()
    self.x = Res.w/2-self.w/2
    self.y = Res.h/2-self.h/2

    self:init_collision()
    self:init_draw()
    self:init_movement()
    
    return self
end

function Player:update(dt)
    self:update_collision(dt)
    self:update_draw(dt)
    self:update_movement(dt)
end

function Player:draw()
    self:draw_draw()
end

return Player