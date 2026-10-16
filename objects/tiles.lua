Tiles = {}
Tiles.__index = Tiles
SetType(Tiles, "tiles")

local around_offsets

function Tiles.new(data)
    local self = setmetatable({}, Tiles)
    self.tiles = data.data
    self.cells_x = data.gridCellsX
    self.cells_y = data.gridCellsY
    around_offsets = {
        0,
        -1,
        1,
        -self.cells_x,
        self.cells_x,
        -self.cells_x+1,
        self.cells_x-1,
        -self.cells_x-1,
        self.cells_x+1,
    }
    return self
end

function Tiles:around(x, y)
    local i = x+y*self.cells_x+1
    local found = {}
    for _, o in ipairs(around_offsets) do
        local j = i+o
        if 1 <= j and j <= #self.tiles then
            if self.tiles[j] ~= -1 then
                local ax = (j-1)%self.cells_x
                local ay = math.floor((j-1)/self.cells_x)
                table.insert(found, {x = ax*TILE_SIZE, y = ay*TILE_SIZE, w = TILE_SIZE, h = TILE_SIZE})
            end
        end
    end
    return found
end

function Tiles:draw()
    for i, tile in ipairs(self.tiles) do
        if tile ~= -1 then
            local x = (i-1)%self.cells_x
            local y = math.floor((i-1)/self.cells_x)
            local tx = x*TILE_SIZE
            local ty = y*TILE_SIZE
            love.graphics.draw(Image[TILE_NAMES[tile+1]], tx, ty)
        end
    end
end

return Tiles