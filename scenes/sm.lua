SM = {}

function SM:init()
    self.fade_in = 0
    self.fading_in = false
    self.fade_out = 0
    self.fading_out = false
    self.fade_cb = nil
end

function SM:load(name, ...)
    self.current = require("scenes."..name)
    self.current:init(...)
end

FADE_TIME = 20
function SM:update(dt)
    self.current:update(dt)
    
    if self.fading_in then
        self.fade_in = self.fade_in+dt
        if self.fade_in > FADE_TIME then
            self:fade_cb()
            self.fade_cb = nil
            self.fading_in = false
            self.fading_out = true
            -- Audio.play("fade")
        end
    end
    if self.fading_out then
        self.fade_out = self.fade_out+dt
        if self.fade_out > FADE_TIME then
            self.fading_out = false
        end
    end
end

function SM:draw()
    self.current:draw()
    
    if self.fading_in then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", Res.w*(Ease.out(self.fade_in/FADE_TIME)-1), 0, Res.w, Res.h)
        Color.reset()
    end
    if self.fading_out then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", Res.w*Ease.out(self.fade_out/FADE_TIME), 0, Res.w, Res.h)
        Color.reset()
    end
end

function SM:reset_fade()
    self.fade_in = 0
    self.fade_out = 0
    self.fading_in = true
    self.fading_out = false
    -- Audio.play("fade")
end

function SM:set_fade(func)
    if self.fading_in then
        return
    end
    self.fade_cb = func
    self:reset_fade()
end

SM:init()