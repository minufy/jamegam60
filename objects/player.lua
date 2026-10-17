Player = {}
Player.__index = Player

local cam_mult = 0.2

require("objects.player.movement")(Player)
require("objects.player.health")(Player)
require("objects.player.draw")(Player)
require("objects.player.collision")(Player)

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.w = Image.player:getWidth()
    self.h = Image.player:getHeight()
    self.x = x
    self.y = y

    self:init_collision()
    self:init_draw()
    self:init_movement()
    self:init_health()
    
    self:update_camera()
    Camera:snap_back()
    return self
end

function Player:update_camera(dt)
    local x = self.x+self.w/2-(Game.box.x+Game.box.w/2+WALL_WIDTH/2)
    local y = self.y+self.h/2-(Game.box.y+Game.box.h/2+WALL_WIDTH/2)
    local ox = Res.w/2-Game.box.w/2-WALL_WIDTH/2
    local oy = Res.h/2-Game.box.h/2-WALL_WIDTH/2
    Camera:set(x*cam_mult-ox, y*cam_mult-oy)
end

function Player:update(dt)
    self:update_collision(dt)
    self:update_draw(dt)
    self:update_movement(dt)
    self:update_health(dt)
    self:update_camera(dt)
end

function Player:draw()
    self:draw_draw()
end

return Player