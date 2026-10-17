local dists = {
    enemy = TILE_SIZE*0.7
}

return function (Player)
    function Player:init_collision()
        self.collision_cbs = {
            enemy = function (other)
                self:hurt(1)
            end
        }
    end
    
    function Player:update_collision(dt)
        Game:dist(self, FILTERS.enemy, self.collision_cbs.enemy, dists.enemy)
    end
end