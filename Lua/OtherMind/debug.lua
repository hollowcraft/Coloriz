local debug = {}

debug.active = false

function debug.keypressed(key)
    if key == "f3" then
        debug.active = not debug.active
    end
end

function debug.draw()
    if debug.active then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Debug Mode", 10, 10, 0, 1)
    end
end

return debug
