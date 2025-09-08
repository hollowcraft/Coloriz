-- main.lua

local gridSizeX, gridSizeY = 7, 3 -- nombre de points en X et Y
local pointRadius = 20
local spacing = 100
local offsetX, offsetY = 100, 100

local points = {}
local selected = {}
local dragging = false
local lastPoint = nil

-- Initialisation des points
for y = 1, gridSizeY do
    for x = 1, gridSizeX do
        table.insert(points, {
            x = offsetX + (x - 1) * spacing,
            y = offsetY + (y - 1) * spacing,
            selected = false
        })
    end
end

function love.draw()
    -- Dessiner les lignes entre les points sélectionnés
    love.graphics.setColor(0, 0.6, 1)
    for i = 1, #selected - 1 do
        local p1 = points[selected[i]]
        local p2 = points[selected[i + 1]]
        love.graphics.setLineWidth(5)
        love.graphics.line(p1.x, p1.y, p2.x, p2.y)
    end

    -- Si on est en train de drag, dessiner la ligne vers la souris
    if dragging and lastPoint then
        local p = points[lastPoint]
        local mx, my = love.mouse.getPosition()
        love.graphics.line(p.x, p.y, mx, my)
    end

    -- Dessiner les points
    for i, p in ipairs(points) do
        if p.selected then
            love.graphics.setColor(0, 0.6, 1)
        else
            love.graphics.setColor(0.8, 0.8, 0.8)
        end
        love.graphics.circle("fill", p.x, p.y, pointRadius)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", p.x, p.y, pointRadius)
    end
end

local function getPointAt(x, y)
    for i, p in ipairs(points) do
        if not p.selected then
            local dx, dy = x - p.x, y - p.y
            if dx * dx + dy * dy <= pointRadius * pointRadius then
                return i
            end
        end
    end
    return nil
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local idx = getPointAt(x, y)
        if idx then
            dragging = true
            points[idx].selected = true
            table.insert(selected, idx)
            lastPoint = idx
        end
    end
end

function love.mousemoved(x, y, dx, dy)
    if dragging then
        local idx = getPointAt(x, y)
        if idx and not points[idx].selected then
            points[idx].selected = true
            table.insert(selected, idx)
            lastPoint = idx
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 and dragging then
        dragging = false
        lastPoint = nil
        -- Pour recommencer, décommenter la ligne suivante :
        -- for i, p in ipairs(points) do p.selected = false end selected = {}
    end
end

function love.keypressed(key)
    if key == "escape" then
        for i, p in ipairs(points) do
            p.selected = false
        end
        selected = {}
        dragging = false
        lastPoint = nil
    end
end