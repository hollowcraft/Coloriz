Boutton = {}

function BouttonNew(x, y, w, h, func)
    local button = {
        x = x,
        y = y,
        width = w,
        height = h,
        func = func
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