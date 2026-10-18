local move_damp = 0.1

return function (Enemy)
    function Enemy:base_init()
        self.mx = 0
        self.my = 0
        
        self.cbs = {
            x = function (other)
                Physics.solve_x(self, self.mx, other)
            end,
            y = function (other)
                Physics.solve_y(self, self.my, other)
            end,
        }

        for _ = 1, 3 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(10, 15)))
        end
        self.time_offset = math.random(1, 100)*10
        
        Game:add_ram(1)
    end

    function Enemy:base_update(dt)
        self.x = self.x+self.mx*dt
        Game:col(self, FILTERS.wall, self.cbs.x)
        self.y = self.y+self.my*dt
        Game:col(self, FILTERS.wall, self.cbs.y)

        self.mx = self.mx-self.mx*move_damp*dt
        self.my = self.my-self.my*move_damp*dt

        if Game.pause_summon and not self.remove then
            self:die()
        end
    end

    function Enemy:hurt(damage, x, y)
        self.mx = self.mx+x*damage
        self.my = self.my+y*damage
        self.health = self.health-damage
        Camera:shake(1.5)
        for _ = 1, 3 do
            Game:add(SparkParticle.new(self.x +self.w/2, self.y+self.h/2, math.rad(math.random(1, 360)), math.random(2, 4), math.random(2, 4)))
        end
        if self.health <= 0 then
            self:die()
        end
        
        Audio.play("hurt", RandomPitch())
    end

    function Enemy:die()
        self.remove = true
        for _ = 1, 4 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
        end
        Game:add_ram(-1)
        Game:add_kill()
        Audio.play("kill", RandomPitch())
    end
end