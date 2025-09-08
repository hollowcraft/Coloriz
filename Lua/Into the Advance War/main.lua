

Entity = {{5,4,1,1},{6,4,2,1}}
Enemy = {{1,4,1,1},{8,4,2,1}}

Boutton = {}

local w, h = 240,160

gridScale = 20

EntityAttribute = {}
local data = require("data")

canSelect = true
selectedEntity = nil
NumberMove = 0
NumberJour = 0

OffsetX = 0
OffsetY = 0

GridOffsetX = 0
GridOffsetY = 0

function love.load()
    love.window.setTitle("Into the Advance War")
    love.window.setMode(240, 160, {resizable = false, vsync = true})
end

function love.mousepressed(x, y, button)
    if canSelect == true then
        selectEntity()
    end
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    --gridScale = love.graphics.getWidth() / 10
end

function love.draw()
    love.graphics.clear(0.2, 0.2, 0.2)
    drawGrid()
    drawMove()
    drawEntity(Entity)
    drawEnemy()
    --drawInfo()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", mouseX-5, mouseY-5, 10, 10)
    love.graphics.print(gridScale, 0, 0)
end

function drawGrid()
    local width, height = love.graphics.getDimensions()
    love.graphics.setColor(0.5, 0.5, 0.5)
    for x = 0, width, gridScale do
        love.graphics.line(x, 0, x, height)
    end
    for y = 0, height, gridScale do
        love.graphics.line(0, y, width, y)
    end
end

function drawEntity(entity)
    for _, pos in ipairs(entity) do
        local x, y = pos[1] * gridScale, pos[2] * gridScale
        local color = EntityAttribute[pos[3]].color
        if pos[4] == 0 then
            color = {0.5, 0.5, 0.5}
        end
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x, y, gridScale, gridScale)
    end
end

function drawInfo()
    if selectedEntity then
        local attr = EntityAttribute[selectedEntity[3]]
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Health: " .. attr.health, 10, 30)
        love.graphics.print("Attack: " .. attr.attack, 10, 50)
        love.graphics.print("Move: " .. attr.move, 10, 70)
        love.graphics.print("Range: " .. attr.range, 10, 90)
    end
end

function selectEntity()
    local gridX = math.floor(mouseX / gridScale)
    local gridY = math.floor(mouseY / gridScale)
    for _, pos in ipairs(Entity) do
        if pos[1] == gridX and pos[2] == gridY then
            selectedEntity = pos
            return
        end
    end
    -- If no entity is selected, try to move the currently selected entity if possible
    if selectedEntity then
        local attr = EntityAttribute[selectedEntity[3]]
        local dist = math.abs(gridX - selectedEntity[1]) + math.abs(gridY - selectedEntity[2])
        if dist <= attr.move then
            moveEntity(gridX - selectedEntity[1], gridY - selectedEntity[2])
        end
        selectedEntity = nil -- Deselect after move attempt
    end
end

function drawMove()
    if selectedEntity then
        local attr = EntityAttribute[selectedEntity[3]]
        local x, y = selectedEntity[1] * gridScale, selectedEntity[2] * gridScale
        love.graphics.setColor(0, 0, 1, 0.5) -- Green with transparency
        for dx = -attr.move, attr.move do
            for dy = -attr.move, attr.move do
                if math.abs(dx) + math.abs(dy) <= attr.move and not(dx==0 and dy==0) and selectedEntity[4]==1 then
                    love.graphics.rectangle("fill", x + dx * gridScale, y + dy * gridScale, gridScale, gridScale)
                end
            end
        end
    end
end

function moveEntity(dx, dy)
    if selectedEntity then
        local newX = selectedEntity[1] + dx
        local newY = selectedEntity[2] + dy
        if selectedEntity[4]==1 then
            selectedEntity[1] = newX
            selectedEntity[2] = newY
            selectedEntity[4] = 0
            NumberMove = NumberMove + 1
        end
        if NumberMove == #Entity then
            selectedEntity = nil
            NumberMove = 0
            NumberJour = NumberJour + 1
            for _, pos in ipairs(Entity) do
                pos[4] = 1
            end
            canSelect = false
            EnemyTurn()
        end
    end
end

function drawEnemy()
    for _, pos in ipairs(Enemy) do
        local x, y = pos[1] * gridScale, pos[2] * gridScale
        local color = {1, 0.8, 0.8}
        if pos[4] == 0 then
            color = {0.8, 0.5, 0.5}
        end
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x, y, gridScale, gridScale)
    end
end

function EnemyTurn()
    for _, pos in ipairs(Enemy) do
        if pos[4] == 1 then
            local targetX = Entity[1][1] -- Target the first entity for simplicity
            local targetY = Entity[1][2]
            local dx = targetX - pos[1]
            local dy = targetY - pos[2]
            if math.abs(dx) + math.abs(dy) <= 1 then
                -- Attack logic can be added here
                pos[4] = 0 -- Mark as used
            else
                -- Move towards the target
                if math.abs(dx) > math.abs(dy) then
                    pos[1] = pos[1] + (dx > 0 and 1 or -1)
                else
                    pos[2] = pos[2] + (dy > 0 and 1 or -1)
                end
            end
        end
    end
    canSelect = true
end