Particle = {}
Particle.__index = Particle

local move_damp = 0.1
local size_damp = 0.07
local size_thresh = 0.5

function Particle.new(x, y, mx, my, size, color)
    local self = setmetatable({}, Particle)
    self.x = x
    self.y = y
    self.w = size
    self.h = size
    
    self.mx = mx*0.1
    self.my = my*0.1
    
    self.size = size
    self.color = color or {1, 1, 1}
    return self
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    Color.reset()
end

function Particle:update(dt)
    self.x = self.x+self.mx*dt
    self.y = self.y+self.my*dt

    self.mx = self.mx-self.mx*move_damp*dt
    self.my = self.my-self.my*move_damp*dt
    
    self.size = self.size-self.size*size_damp*dt
    if self.size < size_thresh then
        self.remove = true
    end
end

return Particle