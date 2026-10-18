local lume = require("modules.lume")

Game = {}

require("scenes.base.draw")(Game)
require("scenes.base.update")(Game)
require("scenes.base.physics")(Game)

BOX_W, BOX_H = 400, 300
ENEMY_SPAWN_TIME = 75
SHORT_ENEMY_SPAWN_TIME = 65
BASE_RAM = 5
BASE_KILLS_PER_WAVE = 7
MAX_WAVES = 5
ENDING_TIME = 100

Image.new("bg")

function Game:init(skip_tutorial)
    math.randomseed(love.timer.getTime())
    self.skip_tutorial = skip_tutorial
    if skip_tutorial then
        Audio.resume("music")
        self.music_playing = true
    end
    Level:init()
    self:reset()
end

function Game:update(dt)
    if CONSOLE and Input.refresh.pressed then
        Level:refresh()
        self:reset()
    end

    Camera:update(dt)

    self:update_objects(dt)
    self:update_timers(dt)
    if self.player_dead then
        self.dead_anim = self.dead_anim-self.dead_anim*SMOOTH_DAMP*dt
        if Input.restart.pressed then
            SM:set_fade(function ()
                SM:load("game", true)
            end)
        end
    end
end

function Game:draw()
    love.graphics.draw(Image.bg)
    self:draw_bg()
    
    Shaders.shadow:start()
    Camera:start()

    self:draw_objects()
    self:draw_tutorial()
    self:draw_new_enemy()

    Camera:stop()

    if self.player_dead then
        love.graphics.setColor(0, 0, 0, (1-self.dead_anim)*0.5)
        love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
        Color.reset()
    end
    if self.ending then
        self:draw_ending()
    end

    self:draw_hud()

    Shaders.shadow:stop()
end

---@generic T
---@param o T
---@return T
function Game:add(o)
    local group_name = tostring(o)
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:reset()
    self.upgrades_list = lume.shuffle(require("scenes.base.upgrades"))
    self.objects = {}
    self.box = self:add(Box.new(BOX_W, BOX_H))
    self.player = self:add(Player.new(self.box.w/2+WALL_WIDTH/2, self.box.h/2+WALL_WIDTH/2))
    self.enemy_spawn_time = ENEMY_SPAWN_TIME
    self.enemy_spawn_timer = self.enemy_spawn_time
    self.max_ram = BASE_RAM
    self.current_ram = 0
    self.smooth_current_ram = 0
    self.smooth_health = self.player.health
    self.smooth_kills = 0
    self.wave = 1
    self.kills = 0
    self.pause_summon = false
    self.tutorial = not self.skip_tutorial
    self.upgrade_index = 1
    self.player_dead = false
    self.kills_per_wave = BASE_KILLS_PER_WAVE
    self.dead_anim = 1
    self.ending_timer = 0
    self.ending = false
    self.upgrades = {}
    self.ram_full = false
end

function Game:focus(f)
    if not self.music_playing then
        return
    end
    if not f then
        Audio.pause("music")
    else
        Audio.resume("music")
    end
end

return Game