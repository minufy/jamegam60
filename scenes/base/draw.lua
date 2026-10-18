local wave_radius = 4
local ui_margin = 10
local gap = Font:getHeight()*2+ui_margin*0.5
local parallax = 0.7
local draw_order = {
    "box",
    "moving_enemy",
    "static_enemy",
    "shooting_enemy",
    "fly_enemy",
    "bullet",
    "warning",
    "upgrade",
    "player",
    "particle",
    "spark_particle",
}
local new_enemies = {
    nil,
    "moving_enemy",
    "shooting_enemy",
    "fly_enemy"
}

return function (Scene)
    function Scene:draw_hud()
        self:draw_bar(ui_margin, Color.ram, BASE_RAM, self.max_ram, self.smooth_current_ram, "RAM")
        self:draw_bar(ui_margin+gap, Color.health, MAX_HEALTH, self.player.max_health, self.smooth_health, "HEALTH")
        self:draw_bar(ui_margin+gap*2, Color.wave, self.kills_per_wave, self.kills_per_wave, self.smooth_kills, "CURRENT WAVE")
        local s = "WAVE"
        love.graphics.setColor(Color.alpha(Color.fg, 0.8))
        love.graphics.print(s, Res.w-Font:getWidth(s)-ui_margin, ui_margin)
        Color.reset()
        love.graphics.setColor(Color.alpha(Color.wave, 0.8))
        for i = 1, MAX_WAVES do
            local r = wave_radius
            if i > self.wave then
                r = r*0.5
            end
            love.graphics.circle("fill", Res.w-ui_margin*(MAX_WAVES-(i-1))-wave_radius, ui_margin+Font:getHeight()+wave_radius, r)
        end
        Color.reset()

        if self.player_dead then
            self:draw_dead()
        end
    end

    function Scene:draw_dead()
        love.graphics.setColor(Color.fg)
        local s

        s = "you died!"
        local y = 110+self.dead_anim*20
        love.graphics.print(s, Res.w/2-Font:getWidth(s)/2, y)
        
        y = y+Font:getHeight()
        s = "press [r] to restart"
        love.graphics.print(s, Res.w/2-Font:getWidth(s)/2, y)

        Color.reset()
        
        y = y+Font:getHeight()*2
        if self.player.health == 0 then
            love.graphics.setColor(Color.health)
            s = "ERR_NO_HEALTH"
        else
            love.graphics.setColor(Color.ram)
            s = "ERR_RAM_FULL"
        end
        love.graphics.print(s, Res.w/2-Font:getWidth(s)/2, y)
        Color.reset()
    end

    function Scene:draw_objects()
        for _, group_name in ipairs(draw_order) do
            if self.objects[group_name] ~= nil then
                for _, object in ipairs(self.objects[group_name]) do
                    if object.draw then
                        object:draw()
                    end
                end
            end
        end
    end

    function Scene:draw_new_enemy()
        if self.pause_summon then
            local new_enemy = new_enemies[self.wave+1]
            if new_enemy then
                love.graphics.setColor(Color.alpha(Color.fg, 0.7))
                love.graphics.setFont(Font)
                local s = "new enemy incoming: "
                local x = self.box.w/2+WALL_WIDTH/2-(Font:getWidth(s)+Image[new_enemy]:getWidth())/2
                local y = self.box.h-40
                love.graphics.print(s, x, y-Font:getHeight()/2)
                love.graphics.draw(Image[new_enemy], x+Font:getWidth(s), y-Image[new_enemy]:getHeight()/2)
                Color.reset()
            end
        end
    end

    function Scene:draw_ending()
        love.graphics.setColor(1, 1, 1, self.ending_timer/ENDING_TIME)
        love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
        Color.reset()
    end

    local ui_margin = 10
    local bar_h = ui_margin*10
    function Scene:draw_bar(y, color, max, current_max, current, name)
        love.graphics.setColor(Color.alpha(Color.fg, 0.8))
        love.graphics.setFont(Font)
        love.graphics.print(name, ui_margin, y)
        love.graphics.print(tostring(math.round(current/current_max*100)).."%", ui_margin*1.4+Font:getWidth(name), y)
        Color.reset()

        love.graphics.setColor(Color.alpha(Color.bg, 0.6))
        local max_w = current_max/max*bar_h
        love.graphics.rectangle("fill", ui_margin, y+Font:getHeight(), max_w, ui_margin, 2, 2)
        Color.reset()

        love.graphics.setColor(Color.alpha(color, 0.8))
        local w = math.max(0.5, math.round(current/max*bar_h))
        love.graphics.rectangle("fill", ui_margin, y+Font:getHeight(), w, ui_margin, 2, 2)
        Color.reset()
    end

    local tutorial_text = "wasd to move\nclick to shoot"
    function Scene:draw_tutorial()
        if self.tutorial then
            love.graphics.setFont(Font)
            love.graphics.setColor(Color.alpha(Color.fg, 0.7))
            love.graphics.print(tutorial_text, self.player.x+ui_margin*2, self.player.y)
            Color.reset()
        end
    end

    function Scene:draw_bg()
        local grid_unit = 30
        local offset_x = (Camera.x*parallax-Camera.shake_x)%grid_unit
        local offset_y = (Camera.y*parallax-Camera.shake_y)%grid_unit
        love.graphics.setColor(1, 1, 1, 0.05)
        love.graphics.setLineWidth(1)
        for x = 0, Res.w/grid_unit+1 do
            local px = x*grid_unit-offset_x
            love.graphics.line(px, 0, px, Res.h)
        end
        for y = 0, Res.h/grid_unit do
            local py = y*grid_unit-offset_y
            love.graphics.line(0, py, Res.w, py)
        end
        Color.reset()
    end
end