return function ()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    Font = love.graphics.newFont("assets/fonts/Galmuri7.ttf", 8)

    Input.refresh = Input.new({"f5"})
    Input.fullscreen = Input.new({"f11"})

    Input.right = Input.new({"right", "d"})
    Input.left = Input.new({"left", "a"})
    Input.up = Input.new({"up", "w"})
    Input.down = Input.new({"down", "s"})
    Input.restart = Input.new({"r"})

    Audio.new("fade", 0.3)
    Audio.new("die", 0.3)
    Audio.new("kill", 0.2)
    Audio.new("hurt", 0.3)
    Audio.new("shoot", 0.2)
    Audio.new("bounce", 0.4)
    Audio.new("upgrade", 0.3)
    Audio.new("summon", 0.2)
    Audio.new("select", 0.2)
    Audio.new("music", 0.15, {
        type = "stream",
        channel = "music",
        loop = "true",
    })

    Camera.x_damp = 0.2
    Camera.y_damp = 0.2
    Camera.shake_damp = 0.3

    SMOOTH_DAMP = 0.15

    Color.fg = rgb(237, 231, 249)
    Color.bg = rgb(37, 36, 41)
    Color.upgrade = rgb(55, 54, 61)
    Color.ram = rgb(128, 87, 240)
    Color.health = rgb(236, 83, 96)
    Color.wave = rgb(83, 180, 236)
    Color.blue = rgb(83, 180, 236)
    Color.red = rgb(236, 83, 96)

    FILTERS = {
        player = {"player"},
        wall = {"wall"},
        enemy = {"static_enemy", "moving_enemy", "shooting_enemy", "fly_enemy"},
    }

    TILE_SIZE = 16
    WALL_WIDTH = 100
    TILE_NAMES = {
        "tile",
    }

    DECAL_NAMES = {

    }
end
