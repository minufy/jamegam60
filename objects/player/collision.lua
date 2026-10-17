local dists = {
    enemy = TILE_SIZE*0.7
}

return function (Player)
    function Player:init_collision()
        self.collision_cbs = {
            enemy = function (other)
                if self.hit_timer > 0 then
                    return
                end
                self:hurt(1, other)
                other:hurt(3, self.mx*0.5, self.my*0.5, 2)
            end
        }
    end
    
    function Player:update_collision(dt)
        Game:dist(self, FILTERS.enemy, self.collision_cbs.enemy, dists.enemy)
    end
end