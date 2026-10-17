local hit_time = 80
local regen_time = 500
MAX_HEALTH = 3

return function (Player)
    function Player:init_health()
        self.max_health = MAX_HEALTH
        self.health = self.max_health
        self.smooth_health = self.health
        self.hit_timer = 0
        self.regen_timer = Timer.new(regen_time)
    end
    
    function Player:update_health(dt)
        self.hit_timer = self.hit_timer-dt
        if self.health < self.max_health and self.regen_timer:run(dt) then
            if self.health < self.max_health then
                self.health = self.health+1
            end
        end
    end
    
    function Player:die()
        if Game.player_dead then
            return
        end
        for _ = 1, 4 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20), Color.red))
        end
        self.remove = true
        Game.player_dead = true
        Camera:shake(3)
        -- Audio.play("die")
    end

    function Player:hurt(damage)
        if self.hit_timer > 0 then
            return
        end
        self.hit_timer = hit_time
        self.health = self.health-damage
        Camera:shake(3)
        for _ = 1, 3 do
            Game:add(SparkParticle.new(self.x +self.w/2, self.y+self.h/2, math.rad(math.random(1, 360)), math.random(2, 4), math.random(4, 6), Color.red))
        end
        if self.health <= 0 then
            self.health = 0
            self:die()
        end
    end
end