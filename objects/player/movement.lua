local acc_damp = 0.2
local dec_damp = 0.1
local base_speed = 1.5
local base_bullet_time = 27
local min_bullet_time = 8
local base_damage = 3
local base_bullet_speed = 5.5
local min_bullet_speed = 0.5
local base_bullet_life = 100

return function (Player)
    function Player:init_movement()
        self.mx = 0
        self.my = 0
        self.dir = 0
        self.speed = base_speed

        self.bullet_timer = 0
        self.bullet_time = base_bullet_time
        self.bullet_speed = base_bullet_speed
        self.bullet_life = base_bullet_life
        self.damage = base_damage

        self.rocket = false
        self.shotgun = false

        self.draw_bounce = 0

        self.movement_cbs = {
            x = function (other)
                self:cb_x(other)
            end,
            y = function (other)
                self:cb_y(other)
            end,
        }
    end

    function Player:cb_x(other)
        Physics.solve_x(self, self.mx, other)
    end

    function Player:cb_y(other)
        Physics.solve_y(self, self.my, other)
    end

    function Player:move(dt)
        local ix = 0
        if Input.right.down then
            ix = ix+1
        end
        if Input.left.down then
            ix = ix-1
        end
        if ix == 0 then
            self.mx = self.mx+(self.speed*ix-self.mx)*dec_damp*dt
        else
            self.mx = self.mx+(self.speed*ix-self.mx)*acc_damp*dt
        end
        self.x = self.x+self.mx*dt
        Game:col(self, FILTERS.wall, self.movement_cbs.x)
        
        local iy = 0
        if Input.down.down then
            iy = iy+1
        end
        if Input.up.down then
            iy = iy-1
        end
        if iy == 0 then
            self.my = self.my+(self.speed*iy-self.my)*dec_damp*dt
        else
            self.my = self.my+(self.speed*iy-self.my)*acc_damp*dt
        end
        self.y = self.y+self.my*dt
        Game:col(self, FILTERS.wall, self.movement_cbs.y)
    end

    function Player:aim_and_attack(dt)
        local mouse_x = Input:get_x()+Camera.x
        local mouse_y = Input:get_y()+Camera.y
        self.dir = math.atan2(mouse_y-(self.y+self.h/2), mouse_x-(self.x+self.w/2))
        if self.bullet_timer <= 0 then
            if Input.mb[1].down then
                self:fire()
            end
        else
            self.bullet_timer = self.bullet_timer-dt
        end
    end
    
    function Player:summon_bullet(dir)
        local cos = math.cos(dir)
        local sin = math.sin(dir)
        local x = self.x+self.w/2+cos*0.9*self.w
        local y = self.y+self.h/2+sin*0.9*self.h
        Game:add(Bullet.new(x, y, dir, self.bullet_speed, self.damage, false, self.rocket, self.bullet_life))
    end

    function Player:fire()
        Game:end_tutorial()

        if self.shotgun then
            for i = -1, 1 do
                self:summon_bullet(self.dir+i*0.2)
            end
        else
            self:summon_bullet(self.dir)
        end

        local cos = math.cos(self.dir)
        local sin = math.sin(self.dir)
        self.mx = self.mx-cos*self.damage*0.5
        self.my = self.my-sin*self.damage*0.5
        local x = self.x+self.w/2+cos*self.w
        local y = self.y+self.h/2+sin*self.h

        self.bullet_timer = self.bullet_time
        Camera:shake(2)
        for _ = 1, 3 do
            Game:add(SparkParticle.new(x, y, self.dir+math.random(-10, 10)*0.05, math.random(2, 4), math.random(2, 4)))
        end

        Audio.play("shoot", RandomPitch())
    end

    function Player:update_movement(dt)
        if self.bullet_time < min_bullet_time then
            self.bullet_time = min_bullet_time
        end
        if self.bullet_speed < min_bullet_speed then
            self.bullet_speed = min_bullet_speed
        end
        self:move(dt)
        self:aim_and_attack(dt)
    end
end