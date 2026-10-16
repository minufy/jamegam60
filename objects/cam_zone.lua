CamZone = {}
CamZone.__index = CamZone

function CamZone.new(data)
    local self = setmetatable({}, CamZone)
    self.x = data.x
    self.y = data.y
    self.w = data.width or TILE_SIZE
    self.h = data.height or TILE_SIZE
    return self
end

function CamZone:draw()
    if CONSOLE then
        love.graphics.setColor(0, 1, 1, 0.1)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        Color.reset()
    end
end

return CamZone