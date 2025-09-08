local width, height = love.window.getDesktopDimensions()
love.graphics.setDefaultFilter("nearest", "nearest")
local MinecraftFont = love.graphics.newFont("fonts/Minecraft-Font.otf", 20) -- 20 = taille en pixels


local assets = {
    Hover = love.graphics.newImage('assets/Hover.png'),
    selected = love.graphics.newImage('assets/selected.png')
}
local iconAssets = {
    love.graphics.newImage('assets/add.png'),
    love.graphics.newImage('assets/open.png'),
}
local colorTheme = {
    background = {0.1, 0.1, 0.2},
    tab = {0.2, 0.2, 0.3},
    text = {1, 1, 1},
    button = {0.3, 0.3, 0.4},
    buttonHover = {0.4, 0.4, 0.5},
}

--local file = {
--    "test",
--    "test2",
--    "test3",
--    "salut"
--} 

local FileText = {
    padding = 0.03*height,
    font = 12
}

function function1()
    print("Function 1 executed")
end
function function2()
    print("Function 2 executed")
end

local actionFile = {
    {label = "Execute", action = function1},
    {label = "Modify", action = function2},
}

local actionBox = {
    visible = false,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    color = colorTheme.button,
}


local ApHeight = 0.8*height

function love.load()
    love.window.setMode(200, ApHeight)
    love.window.setTitle("Self Maker")
    love.graphics.setFont(MinecraftFont)
    file = RepertoryFile()
end

function love.update(dt)
end

function love.mousepressed(x, y, button)
    if button == 2 then
        for i = 1, #file do
            local scaleX = 200
            local scaleY = 0.0125*height
            if x > 0.005*height and x < 0.005*height + scaleX and y > 0.05*height + FileText.padding * (i-0.8) and y < 0.05*height + FileText.padding * (i-0.8) + scaleY then
                OpenActionFile()
            end
        end
    else
        if actionBox.visible then
            for i = 1, #actionFile do
                local scaleX = actionBox.width
                local scaleY = actionBox.height / #actionFile
                if x > actionBox.x and x < actionBox.x + scaleX and y > actionBox.y + scaleY * (i-0.8) and y < actionBox.y + scaleY * (i-0.8) + scaleY then
                    actionFile[i].action()
                end
            end
        end
        actionBox.visible = false
    end
end


function love.draw()
    love.graphics.setColor(colorTheme.background) -- Set color to background
    love.graphics.rectangle("fill", 0, 0, 200, ApHeight) -- background
    love.graphics.setColor(colorTheme.tab) -- Set color to tab
    love.graphics.rectangle("fill", 0, 0, 200, 0.05*height) -- tab
    love.graphics.rectangle("fill", 0, ApHeight - 0.025*height, 200, 0.025*height) -- bottom tab
    love.graphics.setColor(colorTheme.text) -- Set color to text
    love.graphics.print("height: " .. height, 0.005*height, ApHeight - 0.02*height)-- height debug
    
    for i = 1, #file do
        if actionBox.visible==false then
            HoverFile()
        end
        love.graphics.print(file[i], 0.005*height, 0.05*height + FileText.padding * (i-0.8))
    end
    for i = 1, #iconAssets do
        x = 0.04625 * height * i - 0.04 * height
        y = 0.00625 * height
        love.graphics.draw(iconAssets[i], x, y, 0, 0.005*height)
        Hover(x, y, iconAssets[i])
    end
    if actionBox.visible then
        love.graphics.setColor(actionBox.color)
        love.graphics.rectangle("fill", actionBox.x, actionBox.y, actionBox.width, actionBox.height)
        love.graphics.setColor(colorTheme.text)
        for i = 1, #actionFile do
            love.graphics.print(actionFile[i].label, actionBox.x + 0.005*height, actionBox.y + FileText.padding * (i-0.8))
        end
        hoverAction()
    end
end

function Hover(x, y, icon)
    local mouseX, mouseY = love.mouse.getPosition()
    local scaleX = icon:getWidth() * 0.005 * height
    local scaleY = icon:getHeight() * 0.005 * height
    if mouseX > x and mouseX < x + scaleX and mouseY > y and mouseY < y + scaleY then
        love.graphics.draw(assets.Hover, x, y, 0, 0.005*height)
    end
end

function HoverFile()
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > 0 and mouseX < 200 and mouseY > 0.05*height and mouseY < ApHeight then
        for i = 1, #file do
            local scaleX = 200
            local scaleY = FileText.padding
            if mouseX > 0.005*height and mouseX < 0.005*height + scaleX and mouseY > 0.05*height + FileText.padding * (i-0.8) and mouseY < 0.05*height + FileText.padding * (i-0.8) + scaleY then
                love.graphics.draw(assets.selected, -0.005*height, 0.05*height + FileText.padding * (i-0.8), 0, 0.0025*height)
                love.graphics.setColor(1, 1, 1, 0.1)
                love.graphics.rectangle("line", 0, 0.05*height + FileText.padding * (i-0.8), scaleX, scaleY)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end

function OpenActionFile()
    local mouseX, mouseY = love.mouse.getPosition()
    local scaleX = 200
    local scaleY = -0.025*height
    if mouseX > 0.005*height and mouseX < 0.005*height + scaleX and mouseY > 0.05*height and mouseY < ApHeight then
        actionBox.visible = true
        actionBox.x = 0
        actionBox.y = mouseY - FileText.padding * (1-0.8)
        actionBox.width = scaleX
        actionBox.height = #actionFile * FileText.padding
    end
end

function hoverAction()
    local mouseX, mouseY = love.mouse.getPosition()
    for i = 1, #actionFile do
        local scaleX = actionBox.width
        local scaleY = actionBox.height / #actionFile
        if mouseX > actionBox.x and mouseX < actionBox.x + scaleX and mouseY > actionBox.y + scaleY * (i-0.8) and mouseY < actionBox.y + scaleY * (i-0.8) + scaleY then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.rectangle("line", actionBox.x, actionBox.y + scaleY * (i-0.8), scaleX, scaleY)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

function function1()
    print("Function 1 executed")
end
function function2()
    print("Function 2 executed")
end

function RepertoryFile()
    local directory = "List" -- Relative to the LOVE project directory
    local files = {}
    for _, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
        if file ~= "." and file ~= ".." then
            table.insert(files, file)
        end
    end
    return files
end