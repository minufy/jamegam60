local lume = require("modules.lume")

Upgrade = {}
Upgrade.__index = Upgrade

local upgrades = {
    {
        title = "RAM boost",
        desc = {
            {text = "more RAM", color = Color.blue},
            {text = "reduced HEALTH", color = Color.red},
        },
        cb = function (player)
            Game.max_ram = Game.max_ram+4
            player.max_health = player.max_health-3
            player.health = player.max_health
        end
    },
    {
        title = "sniper",
        desc = {
            {text = "faster bullets", color = Color.blue},
            {text = "slightly reduced HEALTH", color = Color.red},
        },
        cb = function (player)
            player.bullet_speed = player.bullet_speed+12
            player.max_health = player.max_health-2
            player.health = player.max_health
        end
    },
    {
        title = "healty",
        desc = {
            {text = "more HEALTH", color = Color.blue},
        },
        cb = function (player)
            player.max_health = player.max_health+4
            player.health = player.max_health
        end
    },
    {
        title = "machinegun",
        desc = {
            {text = "less shoot delay", color = Color.blue},
            {text = "less DAMAGE", color = Color.red},
        },
        cb = function (player)
            player.bullet_time = player.bullet_time-20
            player.damage = player.damage-2
        end
    },
}
upgrades = lume.shuffle(upgrades)

local margin = 6
function Upgrade.new(x, y, index)
    local self = setmetatable({}, Upgrade)
    self.w = 120
    self.h = Font:getHeight()*3.5+margin*2
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.upgrade = upgrades[index]
    self.cbs = {
        player = function (other)
            self:select(other)
        end,
    }
    self.selected = false
    for _ = 1, 4 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
    end
    return self
end

function Upgrade:update(dt)
    if not self.selected then
        Game:col(self, FILTERS.player, self.cbs.player)
    end
    if not Game.choosing_upgrade then
        self:die()
    end
end

function Upgrade:select(player)
    self.upgrade.cb(player)
    self.selected = true
    Game:upgrade_ended()
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