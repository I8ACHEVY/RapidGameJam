Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "images/player.png")
    self.moveSpeed = 200
    self.strength = 10
end

function Player:update(dt)
    Player.super.update(self, dt)

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.moveSpeed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.moveSpeed * dt
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.y = self.y - self.moveSpeed * dt
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.y = self.y + self.moveSpeed * dt
    end
end
