local speed = 2.4
local air_speed = 2.6
local gravity = 0.45
local jump_force = 5
local max_vy = 6
local acc_damp = 0.4
local dec_damp = 0.25
local falling = 5
local jump_buffer = 10
local draw_bounce = 0.4

return function (Player)
    function Player:init_movement()
        self.mx = 0
        self.vy = 0
        self.falling = 999
        self.jump_buffer = 999
        self.gravity = gravity
        self.speed = speed

        self.draw_bounce = 0
        self.walk_timer = Timer.new(8)

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
        Physics.solve_x(self, self.mx*self.speed, other)
    end

    function Player:cb_y(other)
        Physics.solve_y(self, self.vy, other)
        if self.vy > 0 then
            if self.falling > falling then
                self.draw_bounce = -draw_bounce
                for _ = 0, 4 do
                    Game:add(Particle.new(self.x+self.w/2, self.y+self.h, math.random(-12, 12), math.random(-5, 0), math.random(2, 4)))
                end
                -- Audio.play("land")
            end
            self.falling = 0
            self.air_jump = false
        end
        self.vy = 0
    end

    function Player:move_x(dt)
        local ix = 0
        if Input.right.down then
            ix = ix+1
        end
        if Input.left.down then
            ix = ix-1
        end

        if self.falling < falling and Input.down.down then
            self.draw_bounce = -draw_bounce
            ix = 0
            self.mx = 0
        end

        self.speed = speed
        if self.falling > falling then
            self.speed = air_speed
        end

        if ix == 0 then
            self.mx = self.mx+(self.speed*ix-self.mx)*dec_damp*dt
        else
            self.mx = self.mx+(self.speed*ix-self.mx)*acc_damp*dt
        end

        self.x = self.x+self.mx*dt
        local col_x = Game:col_tiles(self, self.movement_cbs.x)
        
        if col_x then
            self.mx = 0
        end

        if ix ~= 0 and self.falling <= falling and col_x == false then
            if self.walk_timer:run(dt) then
                Game:add(Particle.new(self.x+self.w/2, self.y+self.h, ix*math.random(0, 10), math.random(-5, 0), math.random(2, 4)))
                -- Audio.play("walk")
            end
        end
    end

    function Player:move_y(dt)
        self.vy = self.vy+self.gravity*dt
        if self.vy >= max_vy then
            self.vy = max_vy
        end
        self.y = self.y+self.vy*dt
        Game:col_tiles(self, self.movement_cbs.y)
        self.falling = self.falling+dt
        self.jump_buffer = self.jump_buffer+dt

        if Input.jump.pressed then
            self.jump_buffer = 0
        end
        if self.jump_buffer <= jump_buffer then
            self:jump()
        end
        if Input.jump.down then
            self.gravity = gravity/2
        else
            self.gravity = gravity
        end
    end

    function Player:update_anim_state()
        if self.falling > falling then
            self.anim_state = "jump"
        elseif math.abs(self.mx) > 1 then
            self.anim_state = "walk"
        else
            self.anim_state = "idle"
        end
    end

    function Player:update_movement(dt)
        self:move_x(dt)
        self:move_y(dt)
        self:update_anim_state()
    end

    function Player:jump()
        if self.falling <= falling then
            self.vy = -jump_force
            Audio.play("jump")
            self.draw_bounce = draw_bounce
            self.falling = 999
            self.jump_buffer = 999
            for _ = 0, 4 do
                Game:add(Particle.new(self.x+self.w/2, self.y+self.h, math.random(-15, 15), math.random(-10, 0), math.random(2, 6)))
            end
        end
    end
end