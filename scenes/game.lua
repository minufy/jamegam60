Game = {}

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
end

function Game:draw()
    love.graphics.setColor(rgb(60, 93, 141))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    
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

function Game:reset()
    self.objects = {}
    Level:load_level(tostring(self.current_level), self)
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