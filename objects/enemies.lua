require "data.globals"

local love = require "love"

-- asteroids require sfx
function Enemies(x, y, enemy_size, level, sfx)
    local Enemy_vert = 10
    local Enemy_jag = 0.4
    local Enemy_speed = math.random(50) + (level * 2)

    local vert = math.floor(math.random(Enemy_vert + 1) + Enemy_vert / 2)
    local offset = {}
    for i = 1, vert + 1 do
        table.insert(offset, math.random() * Enemy_jag * 2 + 1 - Enemy_jag)
    end

    local vel = -1
    if math.random() < 0.5 then
        vel = 1
    end

    return {
        x = x,
        y = y,
        x_vel = math.random() * Enemy_speed * vel,
        y_vel = math.random() * Enemy_speed * vel,
        radius = math.ceil(enemy_size / 2),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            love.graphics.setColor(186 / 255, 189 / 255, 182 / 255, opacity)

            local points = { self.x + self.radius * self.offset[1] * math.cos(self.angle), self.y +
            self.radius * self.offset[1] * math.sin(self.angle) }

            for i = 1, self.vert - 1 do
                table.insert(points,
                    self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2 / self.vert))
                table.insert(points,
                    self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2 / self.vert))
            end

            love.graphics.polygon(
                "line",
                points
            )

            if show_debugging then
                love.graphics.setColor(1, 0, 0)

                love.graphics.circle("line", self.x, self.y, self.radius)
            end
        end,

        move = function(self, dt)
            self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

            if self.x + self.radius < 0 then
                self.x = love.graphics.getWidth() + self.radius
            elseif self.x - self.radius > love.graphics.getWidth() then
                self.x = -self.radius
            end

            if self.y + self.radius < 0 then
                self.y = love.graphics.getHeight() + self.radius
            elseif self.y - self.radius > love.graphics.getHeight() then
                self.y = -self.radius
            end
        end,

        destroy = function(self, enemies_table, index, game)
            local Min_enemy_size = math.ceil(Enemy_size / 8)

            if self.radius > Min_enemy_size then
                -- pass in sfx to asteroids
                table.insert(enemies_table, Enemies(self.x, self.y, self.radius, game.level, sfx))
                table.insert(enemies_table, Enemies(self.x, self.y, self.radius, game.level, sfx))
            end

            if self.radius >= Enemy_size / 2 then
                game.score = game.score + 20
            elseif self.radius <= Min_enemy_size then
                game.score = game.score + 100
            else
                game.score = game.score + 50
            end

            if game.score > game.high_score then
                game.high_score = game.score
            end

            -- play asteroid destroy sfx
            --sfx:playFX("asteroid_explosion")
            table.remove(enemies_table, index)
        end
    }
end

return Enemies
