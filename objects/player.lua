Player = {}
Player.__index = Player

local cam_margin = 1.2

require("objects.player.movement")(Player)
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
    
    self:update_camera()
    Camera:snap_back()
    return self
end

function Player:update_camera()
    local x = self.x+self.w/2-WALL_WIDTH/2
    local box_w = Game.box.w
    local y = self.y+self.h/2-WALL_WIDTH/2
    local box_h = Game.box.h
    Camera:set(x/box_w*(box_w-Res.w)+WALL_WIDTH/2, y/box_h*(box_h-Res.h)+WALL_WIDTH/2)
end

function Player:update(dt)
    self:update_collision(dt)
    self:update_draw(dt)
    self:update_movement(dt)
    self:update_camera()
end

function Player:draw()
    self:draw_draw()
end

return Player