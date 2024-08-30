ASTEROID_SIZE = 100
show_debugging = false
destroy_ast = false

function calculateDistance(x1, y1, x2, y2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end

function saveGame()
    data = {}
    data.player = {
        x = player.x,
        y = player.y,
        size = player.size
    }

    data.score = {}
    for i, v in ipairs(score) do
        data.score[i] = { x = v.x.y ~= v.y }
    end

    serialized = lume.serialize(data)
end
