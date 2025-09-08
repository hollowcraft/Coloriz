local json = require("src.json")

local utils = {}

function utils.serialize(data)
    return json.encode(data)
end

function utils.deserialize(data)
    return json.decode(data)
end

function utils.saveToFile(filename, data)
    local file = io.open(filename, "w")
    if file then
        file:write(utils.serialize(data))
        file:close()
    else
        error("Could not open file for writing: " .. filename)
    end
end

function utils.loadFromFile(filename)
    local file = io.open(filename, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return utils.deserialize(data)
    else
        error("Could not open file for reading: " .. filename)
    end
end

function utils.zoomIn(currentZoom)
    return currentZoom * 1.1
end

function utils.zoomOut(currentZoom)
    return currentZoom / 1.1
end

function utils.pan(currentPosition, deltaX, deltaY)
    return { x = currentPosition.x + deltaX, y = currentPosition.y + deltaY }
end

return utils