Game = {}

Image.new("bg")

function Game:init(level)
    self.current_level = level or 1
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
end

function Game:draw()
    love.graphics.draw(Image.bg)
    self:draw_bg()
    
    Shadow:start()
    Camera:start()

    self:draw_objects()
    self:draw_tutorial()

    Camera:stop()

    self:draw_hud()

    Shadow:stop()
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

local parallax = 0.7
function Game:draw_bg()
    local grid_unit = 30
    local offset_x = (Camera.x*parallax-Camera.shake_x)%grid_unit
    local offset_y = (Camera.y*parallax-Camera.shake_y)%grid_unit
    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.setLineWidth(1)
    for x = 0, Res.w/grid_unit+1 do
        local px = x*grid_unit-offset_x
        love.graphics.line(px, 0, px, Res.h)
    end
    for y = 0, Res.h/grid_unit do
        local py = y*grid_unit-offset_y
        love.graphics.line(0, py, Res.w, py)
    end
    Color.reset()
end

local box_w, box_h = 400, 300
local enemy_spawn_time = 85
local base_ram = 4
local max_waves = 5
local base_kills_per_wave = 7
function Game:reset()
    self.objects = {}
    self.box = self:add(Box.new(box_w, box_h))
    self.player = self:add(Player.new(self.box.w/2+WALL_WIDTH/2, self.box.h/2+WALL_WIDTH/2))
    self.enemy_spawn_time = enemy_spawn_time
    self.enemy_spawn_timer = self.enemy_spawn_time
    self.max_ram = base_ram
    self.current_ram = 0
    self.smooth_current_ram = 0
    self.smooth_health = self.player.health
    self.wave = 1
    self.kills = 0
    self.choosing_upgrade = false
    self.tutorial = true
    self.upgrade_index = 1
    self.player_dead = false
    self.kills_per_wave = base_kills_per_wave
end

function Game:add_kill()
    self.kills = self.kills+1
    if self.kills >= self.kills_per_wave then
        self:next_wave()
        self.kills = 0
    end
end

function Game:next_wave()
    local cx = self.box.w/2+WALL_WIDTH/2
    local cy = self.box.h/2+WALL_WIDTH/2
    self.wave = self.wave+1
    self.choosing_upgrade = true
    local player = self.player
    player.health = player.max_health
    player.x = cx
    player.y = cy
    for _ = 1, 4 do
        Game:add(Particle.new(player.x+player.w/2, player.y+player.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
    end
    Game:add(Upgrade.new(cx-140, cy, self.upgrade_index))
    Game:add(Upgrade.new(cx+140, cy, self.upgrade_index+1))
    self.upgrade_index = self.upgrade_index+2
    self.kills_per_wave = self.kills_per_wave+3
end

function Game:upgrade_ended()
    self.choosing_upgrade = false
end

function Game:pick_enemy(wave)
    local r = math.random(0, 100)
    if wave == 1 then
        return StaticEnemy
    elseif wave == 2 then
        if r >= 70 then
            return StaticEnemy
        else
            return MovingEnemy
        end
    elseif wave == 3 then
        if r >= 70 then
            return StaticEnemy
        elseif r >= 50 then
            return MovingEnemy
        else
            return ShootingEnemy
        end
    end
end

local death_thresh = 0.05
function Game:update_timers(dt)
    if not self.player_dead and not self.choosing_upgrade and not self.tutorial then
        self.enemy_spawn_timer = self.enemy_spawn_timer+dt
        if self.enemy_spawn_timer > self.enemy_spawn_time then
            self.enemy_spawn_timer = 0
            self:spawn_enemy(self:pick_enemy(self.wave))
        end
    end
    self.smooth_current_ram = self.smooth_current_ram+(self.current_ram-self.smooth_current_ram)*SMOOTH_DAMP*dt
    self.smooth_health = self.smooth_health+(self.player.health-self.smooth_health)*SMOOTH_DAMP*dt
    if self.max_ram-self.smooth_current_ram < death_thresh then
        self.player:die()
    end
end

local spawn_margin = 20
function Game:spawn_enemy(enemy_type)
    local spawn_x = math.random(WALL_WIDTH+spawn_margin, self.box.w-spawn_margin)
    local spawn_y = math.random(WALL_WIDTH+spawn_margin, self.box.h-spawn_margin)
    self:add(Warning.new(spawn_x, spawn_y, function ()
        self:add(enemy_type.new(spawn_x, spawn_y))
    end))
end

function Game:update_objects(dt)
    self.group_names = {}
    for group_name, _ in pairs(self.objects) do
        table.insert(self.group_names, group_name)
    end
    for _, group_name in ipairs(self.group_names) do
        local i = #self.objects[group_name]
        while i > 0 do
            local object = self.objects[group_name][i]
            if object.update then
                object:update(dt)
            end
            if object.remove then
                self.objects[group_name][i] = self.objects[group_name][#self.objects[group_name]]
                self.objects[group_name][#self.objects[group_name]] = nil
            end
            i = i-1
        end
    end
end

local ui_margin = 10
local bar_h = ui_margin*10
function Game:draw_bar(y, color, max, current_max, current, name)
    love.graphics.setColor(Color.alpha(Color.fg, 0.8))
    love.graphics.setFont(Font)
    love.graphics.print(name, ui_margin, y)
    love.graphics.print(tostring(math.round(current/current_max*100)).."%", ui_margin*1.4+Font:getWidth(name), y)
    Color.reset()

    love.graphics.setColor(Color.alpha(Color.bg, 0.6))
    local max_w = current_max/max*bar_h
    love.graphics.rectangle("fill", ui_margin, y+Font:getHeight(), max_w, ui_margin, 2, 2)
    Color.reset()

    love.graphics.setColor(Color.alpha(color, 0.8))
    local w = math.max(0.5, math.round(current/max*bar_h))
    love.graphics.rectangle("fill", ui_margin, y+Font:getHeight(), w, ui_margin, 2, 2)
    Color.reset()
end

local tutorial_text = "wasd to move\nclick to shoot"
function Game:draw_tutorial()
    if self.tutorial then
        love.graphics.setFont(Font)
        love.graphics.setColor(Color.fg)
        love.graphics.print(tutorial_text, self.player.x+ui_margin*2, self.player.y)
        Color.reset()
    end
end

function Game:end_tutorial()
    self.tutorial = false
end

local wave_radius = 4
function Game:draw_hud()
    self:draw_bar(ui_margin, Color.ram, base_ram, self.max_ram, self.smooth_current_ram, "RAM")
    self:draw_bar(ui_margin*4, Color.health, MAX_HEALTH, self.player.max_health, self.smooth_health, "HEALTH")
    local s = "WAVE"
    love.graphics.setColor(Color.alpha(Color.fg, 0.8))
    love.graphics.print(s, Res.w-Font:getWidth(s)-ui_margin, ui_margin)
    Color.reset()
    love.graphics.setColor(Color.alpha(Color.wave, 0.8))
    for i = 1, max_waves do
        local r = wave_radius
        if i > self.wave then
            r = r*0.5
        end
        love.graphics.circle("fill", Res.w-ui_margin*(max_waves-(i-1))-wave_radius, ui_margin+Font:getHeight()+wave_radius, r)
    end
    Color.reset()
end

function Game:add_ram(v)
    self.current_ram = self.current_ram+v
end

local draw_order = {
    "box",
    "moving_enemy",
    "static_enemy",
    "shooting_enemy",
    "bullet",
    "warning",
    "upgrade",
    "player",
    "particle",
    "spark_particle",
}
function Game:draw_objects()
    for _, group_name in ipairs(draw_order) do
        if self.objects[group_name] ~= nil then
            for _, object in ipairs(self.objects[group_name]) do
                if object.draw then
                    object:draw()
                end
            end
        end
    end
end

function Game:col(object, group_names, cb)
    for _, group_name in ipairs(group_names) do
        local group = self.objects[group_name]
        if group ~= nil then
            local result = Physics.col(object, group, cb)
            if result then
                return result
            end
        end
    end
    return false
end

function Game:dist(object, group_names, cb, radius)
    for _, group_name in ipairs(group_names) do
        local group = self.objects[group_name]
        if group ~= nil then
            local result = Physics.dist(object, group, cb, radius)
            if result then
                return result
            end
        end
    end
    return false
end

function Game:col_tiles(object, cb, layer)
    layer = layer or 1
    local around = self.objects.tiles[layer]:around(math.round(object.x, TILE_SIZE), math.round(object.y, TILE_SIZE))
    if Physics.col(object, around, cb) then
        return true
    end
    return false
end

return Game