require("data/debug")

require "globals"

local love = require "love"

local lume = require "data/lume"

local Player = require "objects/player"
local Game = require "screens/game"
local Menu = require "screens/menu"
local resetComplete = false -- if game needs to be reset
local SFX = require "assets/sfx"

math.randomseed(os.time())

local function reset()
    --local save_data = readJSON("save")

    -- create the soundeffects
    sfx = SFX()

    -- added sfx here and into below objects
    player = Player(3, sfx)
    game = Game(sfx) --save_data,
    menu = Menu(game, player, sfx)

    destroy_enemy = false
end

function love.load()
    love.mouse.setVisible(false)

    mouse_x, mouse_y = 0, 0

    reset() -- reset now takes in sfx

    -- will play bgm, does not have to be inside reset(), since
    -- it doesn't have to restart or anything when game over
    sfx.playBGM()
end

-- KEYBINDINGS --
function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player:shootBullet()
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shootBullet()
        else
            clickedMouse = true
        end
    end
end

-- KEYBINDINGS --

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer(dt)

        for ast_index, enemy in pairs(enemies) do
            if not player.exploading and not player.invincible then
                if calculateDistance(player.x, player.y, enemy.x, enemy.y) < player.radius + enemy.radius then
                    player:expload()
                    destroy_enemy = true
                end
            else
                player.expload_time = player.expload_time - 1

                if player.expload_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    -- add sfx to this player as well
                    player = Player(player.lives - 1, sfx)
                end
            end

            for _, bullet in pairs(player.bullets) do
                if calculateDistance(bullet.x, bullet.y, enemy.x, enemy.y) < enemy.radius then
                    bullet:expload()
                    enemy:destroy(enemies, ast_index, game)
                end
            end

            if destroy_enemy then
                if player.lives - 1 <= 0 then
                    if player.expload_time == 0 then
                        destroy_enemy = false
                        enemy:destroy(enemies, ast_index, game)
                    end
                else
                    destroy_enemy = false
                    enemy:destroy(enemies, ast_index, game)
                end
            end

            enemy:move(dt, player.x, player.y)
        end

        if #enemies == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end
    elseif game.state.menu then
        menu:run(clickedMouse)
        clickedMouse = false

        -- this will reset everything to original state
        if not resetComplete then
            reset()
            resetComplete = true
        end
    elseif game.state.ended then
        -- we should reset the game
        resetComplete = false
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        for _, enemy in pairs(enemies) do
            enemy:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    end


    love.graphics.setColor(1, 1, 1, 1)

    if not game.state.running then
        love.graphics.circle("fill", mouse_x, mouse_y, 10)
    end

    love.graphics.print(love.timer.getFPS(), 10, 10)
end
