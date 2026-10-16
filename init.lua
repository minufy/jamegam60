return function ()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)

    Input.refresh = Input.new({"f5"})
    Input.fullscreen = Input.new({"f11"})
    
    Input.right = Input.new({"right", "d"})
    Input.left = Input.new({"left", "a"})
    -- Input.up = Input.new({"up", "w"})
    Input.down = Input.new({"down", "s"})
    Input.jump = Input.new({"space", "up", "w"})
    
    Audio.new("jump")
    
    Camera.x_damp = 0.1
    Camera.y_damp = 0.1
    Camera.shake_damp = 0.3
    
    TILE_SIZE = 16
    TILE_NAMES = {
        "tile",
    }
    
    DECAL_NAMES = {
        
    }
end
