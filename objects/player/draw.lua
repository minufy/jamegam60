local bounce_damp = 0.2

Image.new("player")

return function (Player)
    function Player:init_draw()
        
    end

    function Player:update_draw(dt)
        self.draw_bounce = self.draw_bounce-self.draw_bounce*bounce_damp*dt
    end

    function Player:draw_draw()
        CleanEdge:start(self.w, self.h)
        local sx = (1-self.draw_bounce)
        local sy = (1+self.draw_bounce)
        love.graphics.draw(Image.player, math.round(self.x+self.w/2), math.round(self.y+self.h/2), self.dir, sx, sy, self.w/2, self.h/2)
        CleanEdge:stop()
    end
end