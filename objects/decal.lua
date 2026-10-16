Decal = {}
Decal.__index = Decal

function Decal.new(data)
    local self = setmetatable({}, Decal)
    self.texture = data.texture:sub(1, #data.texture-4)
    self.x = data.x
    self.y = data.y
    self.r = data.rotation
    self.w = Image[self.texture]:getWidth()
    self.h = Image[self.texture]:getHeight()
    return self
end

function Decal:draw()
    love.graphics.draw(Image[self.texture], self.x, self.y, self.r, 1, 1, self.w/2, self.h/2)
end

return Decal