local Dwidth, Dheight = love.window.getDesktopDimensions()
local Fwidth, Fheight =  800, 600

require("Entities")
require("Gui")

function changeColor()
    love.graphics.setBackgroundColor(math.random(), math.random(), math.random(), 1)
    Gui.tab.inside[1].color = {math.random(), math.random(), math.random(), 1}
    MoveGui(Gui.tab.inside[1], 5, 0)
end

entities = {
    block = {type = "rectangle", x = 10, y = 120, width = 45, height = 45, curve = 10},
    unknown = {x = 65, y = 120, width = 45, height = 45},
}

local assets = {
    Add = love.graphics.newImage('add.png')
}

Gui = {
    tab = {
        x = 0,
        y = 0,
        width = Fwidth/2,
        height = Fheight,
        color = {0.2, 0.2, 0.2, 1},
        inside = {
            {x = 10, y = 10, width = 100, height = 100, color = {0.5, 0.5, 0.5, 1}, func = changeColor, curve = 10, hover = 1},
            {x = 130, y = 10, width = 100, height = 100, color = {0.5, 0.5, 0.5, 1}, texture = assets.Add, size = 5},
        }
    }
}

function love.load()
    love.window.setTitle("Test Self Libraries")
    love.window.setMode(Fwidth, Fheight, {resizable = false, vsync = true})
    GuiDraw()
    GuiLoaded = true
end

function love.update(dt)
    --BouttonCollition()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local collides, func = BouttonCollition()
        if collides and func then
            func()
        end
    end
end

function love.draw()
    GuiDraw()
    entityDraw()
    love.graphics.print(Dwidth, 10, 10)
    love.graphics.print(Dheight, 10, 30)
    selectedEntity = selectedEntity or "None"
    love.graphics.print(selectedEntity, 10, 50)
end