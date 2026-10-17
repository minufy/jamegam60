return function ()
    math.randomseed(love.timer.getTime())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)

    Input.refresh = Input.new({"f5"})
    Input.fullscreen = Input.new({"f11"})
    
    Input.right = Input.new({"right", "d"})
    Input.left = Input.new({"left", "a"})
    Input.up = Input.new({"up", "w"})
    Input.down = Input.new({"down", "s"})
    
    Audio.new("jump")
    
    Camera.x_damp = 0.2
    Camera.y_damp = 0.2
    Camera.shake_damp = 0.3
    
    SMOOTH_DAMP = 0.15

    Color.fg = rgb(237, 231, 249)
    Color.box = rgb(37, 36, 41)
    Color.ram = rgb(128, 87, 240)
    Color.health = rgb(236, 83, 96)
    Color.wave = rgb(83, 180, 236)

    FILTERS = {
        wall = {"wall"},
        enemy = {"static_enemy", "moving_enemy"},
    }

    TILE_SIZE = 16
    WALL_WIDTH = 100
    TILE_NAMES = {
        "tile",
    }
    
    DECAL_NAMES = {
        
    }
end
