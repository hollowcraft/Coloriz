local level = {}

function level.load(room)
    level.w = room[1][1]
    level.h = room[1][2]
    level.tile = room[1][3]
end

function level.draw()
    for y = 1, level.h do
        if level.tile[y] then
            for x = 1, level.w do
                if level.tile[y][x] == 1 then
                    love.graphics.rectangle("fill", (x - 1) * 32, (y - 1) * 32, 32, 32)
                end
            end
        end
    end
end

return level