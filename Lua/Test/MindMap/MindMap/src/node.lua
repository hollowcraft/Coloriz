-- filepath: MindMap/src/node.lua

local Node = {}
Node.__index = Node

function Node:new(name, x, y)
    local instance = setmetatable({}, Node)
    instance.name = name or "Untitled"
    instance.position = {x = x or 0, y = y or 0}
    instance.connections = {}
    return instance
end

function Node:updateName(newName)
    self.name = newName
end

function Node:updatePosition(newX, newY)
    self.position.x = newX
    self.position.y = newY
end

function Node:addConnection(node)
    table.insert(self.connections, node)
end

function Node:removeConnection(node)
    for i, connectedNode in ipairs(self.connections) do
        if connectedNode == node then
            table.remove(self.connections, i)
            break
        end
    end
end

function Node:getConnections()
    return self.connections
end

return Node