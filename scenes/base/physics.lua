return function (Scene)
    function Scene:col(object, group_names, cb)
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

    function Scene:dist(object, group_names, cb, radius)
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

    function Scene:col_tiles(object, cb, layer)
        layer = layer or 1
        local around = self.objects.tiles[layer]:around(math.round(object.x, TILE_SIZE), math.round(object.y, TILE_SIZE))
        if Physics.col(object, around, cb) then
            return true
        end
        return false
    end
end