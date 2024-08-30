local love = require "love"

function Bullet(x, y, angle)
    local Bullet_speed = 500
    local Explode_duration = 0.2

    return {
        x = x,
        y = y,
        x_vel = Bullet_speed * math.cos(angle) / love.timer.getFPS(),
        y_vel = -Bullet_speed * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        -- exploading: 0 = safe; 1 = exploading; 2 = done exploading
        exploading = 0,
        expload_time = 0, -- how long has been exploading

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            -- if bullet is not exploading
            if self.exploading < 1 then
                love.graphics.setColor(255, 0, 0, opacity)
                -- set size of points in px (or dpi, idk)
                love.graphics.setPointSize(3)
                -- put point on screen
                love.graphics.points(self.x, self.y)
            else -- if bullet exploaded
                love.graphics.setColor(1, 104 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1.5)

                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1)
            end
        end,

        move = function(self)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            -- basically set the bullet to exploading state
            if self.expload_time > 0 then
                self.exploading = 1
            end

            if self.x < 0 then
                self.x = love.graphics.getWidth()
            elseif self.x > love.graphics.getWidth() then
                self.x = 0
            end

            if self.y < 0 then
                self.y = love.graphics.getHeight()
            elseif self.y > love.graphics.getHeight() then
                self.y = 0
            end

            self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))
        end,

        -- function to make the bullet expload on impact
        expload = function(self)
            self.expload_time = math.ceil(Explode_duration * (love.timer.getFPS() / 100))

            if self.expload_time > Explode_duration then
                self.exploading = 2
            end
        end
    }
end

return Bullet
