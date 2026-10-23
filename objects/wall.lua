Wall = {}
Wall.__index = Wall

function Wall.new(x, y, w, h)
    local self = setmetatable({}, Wall)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    return self
end

return Wall
