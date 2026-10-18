return {
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
            {text = "slower bullets", color = Color.red},
        },
        cb = function (player)
            player.rocket = true
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
            player.bullet_life = player.bullet_life*0.4
            player.bullet_time = player.bullet_time+9
        end
    },
}