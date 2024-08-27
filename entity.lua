Entity = Object:extend()

function Entity:new(x, y, image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    self.strength = 0
    self.tempStrength = 0
end

function Entity:update()
    self.last.x = self.x
    self.last.y = self.y
    self.tempStrength = self.strength
end

function Entity:wasVerticallyAlligned(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAlligned(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

function Entity:resolveCollision(e)
    if self.tempStrength > e.tempStrength then
        return e:resolveCollision(self)
    end

    if self:checkCollision(e) then
        self.tempStrength = e.tempStrength

        if self:wasVerticallyAlligned(e) then
            if self.x + self.width / 2 < e.x + e.width / 2 then
                local pushback = self.x + self.width - e.x
                self.x = self.x - pushback
            else
                local pushback = e.x + e.width - self.x
                self.x = self.x + pushback
            end
        elseif self:wasHorizontallyAlligned(e) then
            if self.y + self.height / 2 < e.y + e.height / 2 then
                local pushback = self.y + self.height - e.y
                self.y = self.y - pushback
            else
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
            end
        end

        return true
    end
    return false
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Entity:checkCollision(otherEntity)
    return self.x + self.width > otherEntity.x
        and self.x < otherEntity.x + otherEntity.width
        and self.y + self.height > otherEntity.y
        and self.y < otherEntity.y + otherEntity.height
end
