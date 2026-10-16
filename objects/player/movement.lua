local speed = 2.4
local acc_damp = 0.2
local dec_damp = 0.1
local dir_damp = 0.4

return function (Player)
    function Player:init_movement()
        self.mx = 0
        self.my = 0
        self.dir = 0
        self.speed = speed

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
        Physics.solve_x(self, self.mx*self.speed, other)
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

    function Player:update_movement(dt)
        self:move(dt)
        self.dir = math.atan2(Input:get_y()-self.y, Input:get_x()-self.x)
    end
end