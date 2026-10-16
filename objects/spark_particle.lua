SparkParticle = {}
SparkParticle.__index = SparkParticle

local speed_damp = 0.1
local size_damp = 0.07
local size_thresh = 0.5
local front = 2
local back = 4

function SparkParticle.new(x, y, angle, speed, size, color)
    local self = setmetatable({}, SparkParticle)
    self.x = x
    self.y = y
    self.w = size
    self.h = size
    
    self.angle = angle
    self.speed = speed
    self.size = size

    self.color = color or {1, 1, 1}
    return self
end

function SparkParticle:draw()
    love.graphics.setColor(self.color)
    local x = math.cos(self.angle)*self.size*self.speed
    local y = math.sin(self.angle)*self.size*self.speed
    local xr = math.cos(self.angle+math.pi/2)*self.size
    local yr = math.sin(self.angle+math.pi/2)*self.size
    love.graphics.polygon("fill",
        self.x+x*front, self.y+y*front,
        self.x+xr, self.y+yr,
        self.x-x*back, self.y-y*back,
        self.x-xr, self.y-yr
    )
    Color.reset()
end

function SparkParticle:update(dt)
    self.x = self.x+math.cos(self.angle)*self.speed*dt
    self.y = self.y+math.sin(self.angle)*self.speed*dt

    self.speed = self.speed-self.speed*speed_damp*dt
    self.size = self.size-self.size*size_damp*dt
    if self.size < size_thresh then
        self.remove = true
    end
end

return SparkParticle