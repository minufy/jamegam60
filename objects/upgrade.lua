local lume = require("modules.lume")

Upgrade = {}
Upgrade.__index = Upgrade

local upgrades = {
    {
        title = "RAM boost",
        desc = {
            {text = "more RAM", color = Color.blue},
        },
        cb = function (player)
            Game.max_ram = Game.max_ram+5
        end
    },
    {
        title = "sniper",
        desc = {
            {text = "faster bullets", color = Color.blue},
            {text = "slightly more DAMAGE", color = Color.blue},
        },
        cb = function (player)
            player.bullet_speed = player.bullet_speed+10
            player.damage = player.damage+0.4
        end
    },
    {
        title = "healthy",
        desc = {
            {text = "more HEALTH", color = Color.blue},
            {text = "explode at collision", color = Color.blue},
        },
        cb = function (player)
            player.max_health = player.max_health+3
            player.health = player.max_health
            player.explode = true
        end
    },
    {
        title = "machinegun",
        desc = {
            {text = "lower shoot delay", color = Color.blue},
            {text = "way lower DAMAGE", color = Color.red},
        },
        cb = function (player)
            player.bullet_time = player.bullet_time-18
            player.damage = player.damage-2
        end
    },
    {
        title = "damaged",
        desc = {
            {text = "more DAMAGE", color = Color.blue},
        },
        cb = function (player)
            player.damage = player.damage+0.5
        end
    },
    {
        title = "fast",
        desc = {
            {text = "more SPEED", color = Color.blue},
            {text = "slightly lower shoot delay", color = Color.blue},
        },
        cb = function (player)
            player.speed = player.speed+0.8
            player.bullet_time = player.bullet_time-9
        end
    },
}
upgrades = lume.shuffle(upgrades)

local margin = 6
function Upgrade.new(x, y, index)
    local self = setmetatable({}, Upgrade)
    self.w = 125
    self.h = Font:getHeight()*3.5+margin*2
    self.x = x-self.w/2
    self.y = y-self.h/2
    self.upgrade = upgrades[index]
    self.cbs = {
        player = function (other)
            self:select(other)
        end,
    }
    for _ = 1, 4 do
        Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
    end
    return self
end

function Upgrade:update(dt)
    if Game.pause_summon then
        Game:col(self, FILTERS.player, self.cbs.player)
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