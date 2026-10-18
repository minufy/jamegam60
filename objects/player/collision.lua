local dists = {
    enemy = TILE_SIZE*0.7,
    explode = TILE_SIZE*3
}

return function (Player)
    function Player:init_collision()
        self.explode = false
        self.collision_cbs = {
            explode = function (other)
                other:hurt(100, self.mx*0.5, self.my*0.5, 2)
            end,
            enemy = function (other)
                if self.hit_timer <= 0 then 
                    other:hurt(4.5, self.mx*0.5, self.my*0.5, 2)
                end
                self:hurt(1, other)
            end
        }
    end

    function Player:explosion()
        Game:dist(self, FILTERS.enemy, self.collision_cbs.explode, dists.explode)
    end
    
    function Player:update_collision(dt)
        Game:dist(self, FILTERS.enemy, self.collision_cbs.enemy, dists.enemy)
    end
end