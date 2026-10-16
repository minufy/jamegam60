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

    Camera:stop()
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

local box_w, box_h = 340, 240
local enemy_spawn_time = 100
function Game:reset()
    self.objects = {}
    self.box = self:add(Box.new(box_w, box_h))
    self:add(Player.new(box_w/2, box_h/2))
    self.enemy_spawn_timer = 0
    self.enemy_spawn_time = enemy_spawn_time
end

function Game:update_timers(dt)
    self.enemy_spawn_timer = self.enemy_spawn_timer+dt
    if self.enemy_spawn_timer > self.enemy_spawn_time then
        self.enemy_spawn_timer = 0
        self:spawn_enemy(StaticEnemy)
    end
end

function Game:spawn_enemy(enmemy_type)
    local spawn_x = math.random(WALL_WIDTH, self.box.w-WALL_WIDTH)
    local spawn_y = math.random(WALL_WIDTH, self.box.h-WALL_WIDTH)
    self:add(Warning.new(spawn_x, spawn_y, function ()
        self:add(enmemy_type.new(spawn_x, spawn_y))
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

function Game:draw_objects()
    for _, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.draw then
                object:draw()
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