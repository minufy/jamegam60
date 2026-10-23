Upgrade = {}
Upgrade.__index = Upgrade

local margin = 6
function Upgrade.new(x, y, upgrade)
    local self = setmetatable({}, Upgrade)
    self.w = 130
    self.h = Font:getHeight()*4.5+margin*2
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.upgrade = upgrade
    for _ = 1, 4 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
    end
    return self
end

function Upgrade:col_player(other)
    self:select(other)
end

function Upgrade:update(dt)
    if Game.pause_summon then
        Game:col(self, FILTERS.player, self.col_player)
    else
        self:die()
    end
end

function Upgrade:select(player)
    self.upgrade.cb(player)
    Game:upgrade_ended()
    Game:add_upgrades(self.upgrade.title)
    Audio.play("select")
end

function Upgrade:draw()
    love.graphics.setColor(Color.alpha(Color.upgrade, 0.8))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 2, 2)
    Color.reset()

    love.graphics.setFont(Font)
    local x = self.x+margin
    local y = self.y+margin
    love.graphics.setColor(Color.fg)
    love.graphics.print(self.upgrade.title, x, y)
    Color.reset()

    y = y+Font:getHeight()*1.5
    for i, desc in ipairs(self.upgrade.desc) do
        love.graphics.setColor(desc.color)
        love.graphics.print(desc.text, x, y)
        Color.reset()
        y = y+Font:getHeight()
    end
end

function Upgrade:die()
    for _ = 1, 4 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
    end
    self.remove = true
    Camera:shake(2)
end

return Upgrade
