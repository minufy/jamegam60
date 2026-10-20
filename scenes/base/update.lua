local death_thresh = 0.05
local spawn_margin = 20

return function (Scene)
    function Scene:update_timers(dt)
        if not self.player_dead and not self.pause_summon and not self.tutorial and not self.ending then
            self.enemy_spawn_timer = self.enemy_spawn_timer+dt
            if self.enemy_spawn_timer > self.enemy_spawn_time then
                self.enemy_spawn_timer = 0
                self:spawn_enemy(self:pick_enemy(self.wave))
            end
        end
        self.smooth_current_ram = self.smooth_current_ram+(self.current_ram-self.smooth_current_ram)*SMOOTH_DAMP*dt
        self.smooth_health = self.smooth_health+(self.player.health-self.smooth_health)*SMOOTH_DAMP*dt
        self.smooth_kills = self.smooth_kills+(self.kills-self.smooth_kills)*SMOOTH_DAMP*dt
        self.ram_full = self.max_ram-self.smooth_current_ram < death_thresh
        if self.ram_full then
            self.player:die()
        end
        if self.ending then
            self.ending_timer = self.ending_timer+dt
            if self.ending_timer > ENDING_TIME then
                SM:set_fade(function ()
                    SM:load("ending")
                end)
            end
        end
    end

    function Scene:spawn_enemy(enemy_type)
        local spawn_x = math.random(WALL_WIDTH+spawn_margin, self.box.w-spawn_margin)
        local spawn_y = math.random(WALL_WIDTH+spawn_margin, self.box.h-spawn_margin)
        self:add(Warning.new(spawn_x, spawn_y, function ()
            self:add(enemy_type.new(spawn_x, spawn_y))
        end))
    end

    function Scene:update_objects(dt)
        for group_name, _ in pairs(self.objects) do
            local i = #self.objects[group_name]
            while i > 0 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    self.objects[group_name][i] = self.objects[group_name][#self.objects[group_name]]
                    self.objects[group_name][#self.objects[group_name]] = nil
                end
                i = i-1
            end
        end
    end

    function Scene:player_die()
        self.player_dead = true
        self.music_playing = false
        Audio.pause("music")
    end

    function Scene:add_kill()
        if self.pause_summon then
            return
        end
        self.kills = self.kills+1
        if self.kills >= self.kills_per_wave then
            self:next_wave()
            self.kills = 0
        end
    end

    function Scene:add_upgrades(title)
        table.insert(self.upgrades, title)
    end

    function Scene:next_wave()
        self.pause_summon = true
        if self.wave == MAX_WAVES then
            self.ending = true
            Camera:shake(5)
            Audio.stop("music")
            self.music_playing = false
            return
        end
        Audio.play("upgrade")
        local cx = self.box.w/2+WALL_WIDTH/2
        local cy = self.box.h/2+WALL_WIDTH/2
        local player = self.player
        player.health = player.max_health
        player.x = cx
        player.y = cy
        for _ = 1, 4 do
            Scene:add(Particle.new(player.x+player.w/2, player.y+player.h/2, math.random(-20, 20), math.random(-20, 20), math.random(15, 20)))
        end
        Scene:add(Upgrade.new(cx-150, cy, self.upgrades_list[self.upgrade_index]))
        Scene:add(Upgrade.new(cx+150, cy, self.upgrades_list[self.upgrade_index+1]))
        self.upgrade_index = self.upgrade_index+2
        self.kills_per_wave = self.kills_per_wave+4
    end

    function Scene:upgrade_ended()
        self.pause_summon = false
        self.wave = self.wave+1
        if self.wave == 5 then
            self.enemy_spawn_time = SHORT_ENEMY_SPAWN_TIME
        end
        self.player.health = self.player.max_health
    end

    function Scene:pick_enemy(wave)
        local r = math.random(0, 100)
        if wave == 1 then
            return StaticEnemy
        elseif wave == 2 then
            if r >= 70 then
                return StaticEnemy
            else
                return MovingEnemy
            end
        elseif wave == 3 then
            if r >= 70 then
                return StaticEnemy
            elseif r >= 50 then
                return MovingEnemy
            else
                return ShootingEnemy
            end
        elseif wave >= 4 then
            if r >= 60 then
                return FlyEnemy
            elseif r >= 40 then
                return MovingEnemy
            else
                return ShootingEnemy
            end
        end
    end

    function Scene:add_ram(v)
        self.current_ram = self.current_ram+v
    end

    function Scene:end_tutorial()
        if self.tutorial then
            Audio.resume("music")
            self.music_playing = true
        end
        self.tutorial = false
    end
end
