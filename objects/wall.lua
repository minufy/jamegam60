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

function Wall:draw()
    if CONSOLE then
        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        Color.reset()
    end
end

return Wall