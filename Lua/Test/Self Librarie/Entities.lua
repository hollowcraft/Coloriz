entities = {}

selectedEntity = nil

function love.mousepressed(x, y, button)
    if button == 1 then  -- Left mouse button
        for _, entity in pairs(entities) do
            if x >= entity.x and x <= entity.x + entity.width and
               y >= entity.y and y <= entity.y + (entity.height or entity.width) then
                selectedEntity = entity
                break
            end
        end
    end
end

function entityDraw()
    for _, entity in pairs(entities) do
        if entity.type == nil then
            love.graphics.setColor(0, 0.5, 0.5, 1)
            love.graphics.rectangle("line", entity.x, entity.y, entity.width/2, entity.height/2 or entity.width/2, entity.curve or 0, entity.curve or 0)
            love.graphics.rectangle("line", entity.x+entity.width/2, entity.y+entity.height/2, entity.width/2, entity.height/2 or entity.width/2, entity.curve or 0, entity.curve or 0)
            love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
            love.graphics.rectangle("line", entity.x+entity.width/2, entity.y, entity.width/2, entity.height/2 or entity.width/2, entity.curve or 0, entity.curve or 0)
            love.graphics.rectangle("line", entity.x, entity.y+entity.height/2, entity.width/2, entity.height/2 or entity.width/2, entity.curve or 0, entity.curve or 0)
        end
        if entity.type == "rectangle" then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", entity.x, entity.y, entity.width, entity.height or entity.width, entity.curve or 0, entity.curve or 0)
        end
    end
end