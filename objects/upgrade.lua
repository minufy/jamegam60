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
            Game.max_ram = Game.max_ram+6
        end
    },
    {
        title = "sniper",
        desc = {
            {text = "way faster bullets", color = Color.blue},
            {text = "slightly more DAMAGE", color = Color.blue},
            {text = "slightly lower SPEED", color = Color.red},
        },
        cb = function (player)
            player.bullet_speed = player.bullet_speed+10
            player.damage = player.damage+1
            player.speed = player.speed-0.2
        end
    },
    {
        title = "healthy",
        desc = {
            {text = "more HEALTH", color = Color.blue},
            {text = "explode at collision", color = Color.blue},
        },
        cb = function (player)
            player.max_health = player.max_health+4
            player.health = player.max_health
            player.explode = true
        end
    },
    {
        title = "machinegun",
        desc = {
            {text = "way lower shoot delay", color = Color.blue},
            {text = "lower DAMAGE", color = Color.red},
            {text = "shorter bullets", color = Color.red},
        },
        cb = function (player)
            player.bullet_time = player.bullet_time-17
            player.damage = player.damage-1.5
            player.bullet_life = player.bullet_life*0.5
        end
    },
    {
        title = "damaged",
        desc = {
            {text = "more DAMAGE", color = Color.blue},
        },
        cb = function (player)
            player.damage = player.damage+2
        end
    },
    {
        title = "fast",
        desc = {
            {text = "more SPEED", color = Color.blue},
            {text = "lower shoot delay", color = Color.blue},
            {text = "slightly shorter bullets", color = Color.red}
        },
        cb = function (player)
            player.speed = player.speed+0.8
            player.bullet_time = player.bullet_time-10
            player.bullet_life = player.bullet_life*0.6
        end
    },
    {
        title = "rocket",
        desc = {
            {text = "bullets follow cursor", color = Color.blue},
            {text = "slightly lower shoot delay", color = Color.blue},
            {text = "slower bullets", color = Color.red},
        },
        cb = function (player)
            player.rocket = true
            player.bullet_time = player.bullet_time-2
            player.bullet_speed = player.bullet_speed-2
        end
    },
    {
        title = "shotgun",
        desc = {
            {text = "fire multiple bullets", color = Color.blue},
            {text = "shorter bullets", color = Color.red},
            {text = "longer shoot delay", color = Color.red},
        },
        cb = function (player)
            player.shotgun = true
            player.bullet_life = player.bullet_life*0.35
            player.bullet_time = player.bullet_time+7
        end
    },
}
upgrades = lume.shuffle(upgrades)

local margin = 6
function Upgrade.new(x, y, index)
    local self = setmetatable({}, Upgrade)
    self.w = 130
    self.h = Font:getHeight()*4.5+margin*2
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