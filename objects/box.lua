Box = {}
Box.__index = Box

local move_damp = 0.2

function Box.new(w, h)
    local self = setmetatable({}, Box)
    self.x = 0
    self.y = 0
    self.w = w
    self.h = h
    self.target_x = self.x
    self.target_y = self.y
    self.target_w = w
    self.target_h = h

    self.walls = {
        up = Game:add(Wall.new(self.x, self.y, self.w, WALL_WIDTH)),
        down = Game:add(Wall.new(self.x, self.y+self.h, self.w, WALL_WIDTH)),
        left = Game:add(Wall.new(self.x, self.y, WALL_WIDTH, self.h)),
        right = Game:add(Wall.new(self.x+self.w, self.y, WALL_WIDTH, self.h)),
    }

    return self
end

function Box:update(dt)
    self.walls.up.x = self.target_x
    self.walls.up.y = self.target_y
    self.walls.up.w = self.target_w
    
    self.walls.down.x = self.target_x
    self.walls.down.y = self.target_y+self.target_h
    self.walls.down.w = self.target_w
    
    self.walls.left.x = self.target_x
    self.walls.left.y = self.target_y
    self.walls.left.h = self.target_h
    
    self.walls.right.x = self.target_x+self.target_w
    self.walls.right.y = self.target_y
    self.walls.right.h = self.target_h

    self.w = self.w+(self.target_w-self.w)*move_damp*dt
    self.h = self.h+(self.target_h-self.h)*move_damp*dt
    self.x = self.x+(self.target_x-self.x)*move_damp*dt
    self.y = self.y+(self.target_y-self.y)*move_damp*dt
end

function Box:draw()
    love.graphics.setColor(Color.box)
    love.graphics.setLineWidth(WALL_WIDTH)
    love.graphics.rectangle("line", self.x+WALL_WIDTH/2, self.y+WALL_WIDTH/2, self.w, self.h)
    Color.reset()
end

function Box:set_size(w, h)
    self.target_w = w
    self.target_h = h
end

return Box