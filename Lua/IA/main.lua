local neurons = {}
local links = {}
local dragging = false
local dragFrom = nil
local dragTo = nil
local doubleClickTime = 0.3
local lastClick = 0
local lastLinkClicked = nil

local function distance(x1, y1, x2, y2)
    return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

function love.load()
    love.window.setTitle("Visualisation de Neurones")
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Vérifie si on clique sur un lien
        for i, link in ipairs(links) do
            local n1 = neurons[link[1]]
            local n2 = neurons[link[2]]
            -- Distance point-segment
            local dx, dy = n2.x - n1.x, n2.y - n1.y
            local t = ((x-n1.x)*dx + (y-n1.y)*dy) / (dx*dx + dy*dy)
            t = math.max(0, math.min(1, t))
            local px, py = n1.x + t*dx, n1.y + t*dy
            if distance(x, y, px, py) < 10 then
                local now = love.timer.getTime()
                if lastLinkClicked == i and now - lastClick < doubleClickTime then
                    table.remove(links, i)
                    lastLinkClicked = nil
                    return
                else
                    lastLinkClicked = i
                    lastClick = now
                    return
                end
            end
        end

        -- Vérifie si on clique sur un neurone
        for i, n in ipairs(neurons) do
            if distance(x, y, n.x, n.y) < 20 then
                dragging = true
                dragFrom = i
                return
            end
        end

        -- Sinon, crée un neurone
        table.insert(neurons, {x=x, y=y})
    end
end

function love.mousereleased(x, y, button)
    if button == 1 and dragging then
        for i, n in ipairs(neurons) do
            if i ~= dragFrom and distance(x, y, n.x, n.y) < 20 then
                -- Crée un lien si pas déjà existant
                for _, link in ipairs(links) do
                    if (link[1]==dragFrom and link[2]==i) or (link[1]==i and link[2]==dragFrom) then
                        dragging = false
                        dragFrom = nil
                        return
                    end
                end
                table.insert(links, {dragFrom, i})
            end
        end
        dragging = false
        dragFrom = nil
    end
end

function love.draw()
    -- Liens
    --love.graphics.print(dragging, 10, 10)
    --love.graphics.print(dragFrom, 10, 30)
    --love.graphics.print(dragTo, 10, 50)
    for _, link in ipairs(links) do
        local n1, n2 = neurons[link[1]], neurons[link[2]]
        love.graphics.setColor(0.2, 0.6, 1)
        love.graphics.setLineWidth(3)
        love.graphics.line(n1.x, n1.y, n2.x, n2.y)
    end

    -- Drag visuel
    if dragging and dragFrom then
        local n = neurons[dragFrom]
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.setLineWidth(2)
        local mx, my = love.mouse.getPosition()
        love.graphics.line(n.x, n.y, mx, my)
    end

    -- Neurones
    for i, n in ipairs(neurons) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", n.x, n.y, 20)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", n.x, n.y, 20)
        love.graphics.print(i, n.x-5, n.y-7)
    end
end

-- Sauvegarde/Chargement
function saveNetwork()
    local data = {neurons=neurons, links=links}
    love.filesystem.write("network.lua", "return " .. table.serialize(data))
end

function loadNetwork()
    if love.filesystem.getInfo("network.lua") then
        local chunk = love.filesystem.load("network.lua")
        local data = chunk()
        neurons = data.neurons
        links = data.links
    end
end

-- Sérialisation simple
function table.serialize(tbl)
    local function ser(t)
        if type(t) == "table" then
            local s = "{"
            for k,v in pairs(t) do
                s = s .. "[" .. ser(k) .. "]=" .. ser(v) .. ","
            end
            return s .. "}"
        elseif type(t) == "number" then
            return tostring(t)
        else
            return string.format("%q", t)
        end
    end
    return ser(tbl)
end

function love.keypressed(key)
    if key == "s" then saveNetwork() end
    if key == "l" then loadNetwork() end
end