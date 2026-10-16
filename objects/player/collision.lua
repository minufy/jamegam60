local filters = {

}

local dists = {

}

return function (Player)
    function Player:init_collision()
        self.collision_cbs = {
            
        }
    end
    
    function Player:update_collision(dt)
        
    end
    
    function Player:die()
        for _ = 1, 4 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12)))
        end
        self.remove = true
        Camera:shake(3)
        -- Audio.play("die")
    end
end