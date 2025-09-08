-- filepath: MindMap/main.lua


local MindMap = require("src.mindmap")
local json = require("src.utils")
local utils = require("src.utils")

local mindMap
local running = true
local selectedNode = nil
local renaming = false
local renameBuffer = ""

function love.load()
    mindMap = MindMap.new()
    mindMap:load("data/mindmap_save.json")
end

function love.update(dt)
    mindMap:update(dt)
end

function love.keypressed(key)
    if renaming then
        if key == "return" then
            if selectedNode then selectedNode.name = renameBuffer end
            renaming = false
        elseif key == "backspace" then
            renameBuffer = renameBuffer:sub(1, -2)
        end
        return
    end

    if key == "escape" then
        running = false
    elseif key == "s" then
        mindMap:save("data/mindmap_save.json")
    elseif key == "z" then
        mindMap:zoomIn()
    elseif key == "x" then
        mindMap:zoomOut()
    elseif key == "left" then
        mindMap:pan(-10, 0)
    elseif key == "right" then
        mindMap:pan(10, 0)
    elseif key == "up" then
        mindMap:pan(0, -10)
    elseif key == "down" then
        mindMap:pan(0, 10)
    elseif key == "a" then
        local mx, my = love.mouse.getPosition()
        mindMap:addNode(mx, my)
    elseif key == "r" and selectedNode then
        renaming = true
        renameBuffer = selectedNode.name
    end
end

function love.textinput(t)
    if renaming then
        renameBuffer = renameBuffer .. t
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        selectedNode = mindMap:getNodeAt(x, y)
    end
end

function love.draw()
    mindMap:draw()
    if selectedNode then
        love.graphics.setColor(1,0,0)
        love.graphics.circle("line",
            selectedNode.x * mindMap.zoom + mindMap.offset.x,
            selectedNode.y * mindMap.zoom + mindMap.offset.y,
            24, 32)
        love.graphics.setColor(1,1,1)
    end
    if renaming then
        love.graphics.setColor(0,0,0,0.7)
        love.graphics.rectangle("fill", 100, 100, 300, 40)
        love.graphics.setColor(1,1,1)
        love.graphics.print("Renommer: " .. renameBuffer, 110, 110)
    end
end

function love.quit()
    mindMap:save("data/mindmap_save.json")
end