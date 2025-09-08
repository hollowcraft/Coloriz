-- filepath: MindMap/src/mindmap.lua

local utils = require("src.utils")

local MindMap = {}
MindMap.__index = MindMap

function MindMap.new()
    local self = setmetatable({}, MindMap)
    -- Initialisation des données du mindmap
    self.nodes = {}
    self.connections = {}
    self.zoom = 1
    self.offset = {x = 0, y = 0}
    return self
end

function MindMap:load(filename)
    local ok, data = pcall(utils.loadFromFile, filename)
    if ok and data then
        self.nodes = data.nodes or {}
        self.connections = data.connections or {}
        self.zoom = data.zoom or 1
        self.offset = data.offset or {x = 0, y = 0}
    end
end

function MindMap:save(filename)
    local data = {
        nodes = self.nodes,
        connections = self.connections,
        zoom = self.zoom,
        offset = self.offset
    }
    utils.saveToFile(filename, data)
end

function MindMap:update(dt) end
function MindMap:draw() end
function MindMap:zoomIn() self.zoom = self.zoom * 1.1 end
function MindMap:zoomOut() self.zoom = self.zoom / 1.1 end
function MindMap:pan(dx, dy)
    self.offset.x = self.offset.x + dx
    self.offset.y = self.offset.y + dy
end

function MindMap:addNode(x, y, name)
    local node = {
        x = (x - self.offset.x) / self.zoom,
        y = (y - self.offset.y) / self.zoom,
        name = name or "Node " .. tostring(#self.nodes + 1),
        id = #self.nodes + 1
    }
    table.insert(self.nodes, node)
end

function MindMap:getNodeAt(x, y)
    for i, node in ipairs(self.nodes) do
        local nx = node.x * self.zoom + self.offset.x
        local ny = node.y * self.zoom + self.offset.y
        if (x - nx)^2 + (y - ny)^2 < 20^2 then -- rayon de sélection 20px
            return node
        end
    end
    return nil
end

function MindMap:draw()
    love.graphics.push()
    love.graphics.translate(self.offset.x, self.offset.y)
    love.graphics.scale(self.zoom)
    -- Draw connections
    for _, conn in ipairs(self.connections) do
        local n1 = self.nodes[conn[1]]
        local n2 = self.nodes[conn[2]]
        if n1 and n2 then
            love.graphics.setColor(0.7,0.7,0.7)
            love.graphics.line(n1.x, n1.y, n2.x, n2.y)
        end
    end
    -- Draw nodes
    for i, node in ipairs(self.nodes) do
        love.graphics.setColor(1,1,1)
        love.graphics.circle("fill", node.x, node.y, 20)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line", node.x, node.y, 20)
        love.graphics.printf(node.name, node.x-30, node.y-7, 60, "center")
    end
    love.graphics.pop()
end

return MindMap