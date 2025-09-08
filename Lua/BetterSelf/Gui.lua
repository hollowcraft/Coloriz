local width, height = love.window.getDesktopDimensions()
love.graphics.setDefaultFilter("nearest", "nearest")
--require("Boutton")

Boutton = {}
GuiLoaded = false

function GuiLoad()
    Boutton = {}
    GuiInsideDraw(Gui, 0, 0)
    GuiLoaded = true
end
function GuiDraw()
    GuiInsideDraw(Gui, 0, 0)
    BouttonHover()
end

function GuiInsideDraw(container, offsetX, offsetY)
    for _, element in pairs(container) do
        if element.x and element.y and element.width and element.height then
            if element.color then love.graphics.setColor(element.color) end
            if element.texture then
                love.graphics.draw(element.texture, element.x + offsetX, element.y + offsetY, 0, element.size, element.size)
            else
                love.graphics.rectangle("fill", element.x + offsetX, element.y + offsetY, element.width, element.height or element.width, element.curve or 0)
            end
            love.graphics.setColor(1, 1, 1, 1) -- Reset color

            if element.func and GuiLoaded == false then
                BouttonNew(element.x + offsetX, element.y + offsetY, element.width, element.height, element.func)
            end

            if element.inside then
                GuiInsideDraw(element.inside, element.x, element.y)
            end
        end
    end
end

function BouttonNew(x, y, w, h, func, hover)
    local button = {
        x = x,
        y = y,
        width = w,
        height = h,
        func = func,
        hover = hover or nil
    }
    table.insert(Boutton, button)
end

function BouttonCollition()
    local mouseX, mouseY = love.mouse.getPosition()
    for _, button in ipairs(Boutton) do
        if mouseX >= button.x and mouseX <= button.x + button.width and
           mouseY >= button.y and mouseY <= button.y + button.height then
            return true, button.func
        end
    end
    return false, nil, nil
end

function BouttonHover()
    local mouseX, mouseY = love.mouse.getPosition()
    for _, button in ipairs(Boutton) do
        if mouseX >= button.x and mouseX <= button.x + button.width and
           mouseY >= button.y and mouseY <= button.y + button.height then
            love.graphics.setColor(1, 1, 1, 1)
            if button.hover then
                local imageWidth = button.hover:getWidth()
                local imageHeight = button.hover:getHeight()
                love.graphics.draw(button.hover, button.x, button.y, 0, button.width/imageWidth, button.height/imageHeight)
            else
                love.graphics.rectangle("line", button.x, button.y, button.width, button.height, button.curve or 0)
                love.graphics.setColor(1, 1, 1, 0.2) -- Change color for hover effect
                love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, button.curve or 0)
            end
        end
    end
end

function MoveGui(block, vX, vY, type)
    if type == nil then
        block.x = block.x + vX
        block.y = block.y + vY
    end
    GuiLoaded = false
    GuiLoad()
end

function ListDraw(list, value)
    for i, item in ipairs(list) do
        if value then
            love.graphics.print(item, 10, 10 + (i - 1) * 20)
        end
    end
end