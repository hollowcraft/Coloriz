Boutton = {}

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
            love.graphics.setColor(1, 1, 1, 0.5)
            if button.hover then
                local imageWidth = button.hover:getWidth()
                local imageHeight = button.hover:getHeight()
                love.graphics.draw(button.hover, button.x, button.y, 0, button.width/imageWidth, button.height/imageHeight)
            else
                love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
            end
        end
    end
end