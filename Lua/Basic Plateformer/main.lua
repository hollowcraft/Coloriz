inputJump = 0

StartX = 3 
StartY = 3
hsp = 0
vsp = 0
grv = 0.04
speed = 0.2
jumpSpeed = 0.42
canJump = true
scl = 32*2

level = {
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,1},
    {1,0,0,0,1},
    {1,1,1,1,1}
}

function love.load()
    love.window.setMode(#level*scl, #level[1]*scl, {resizable = true, vsync = true})
    love.graphics.setDefaultFilter("nearest", "nearest")
    x = StartX
    y = StartY

    --level.load("level/level1.lua")
end

function love.keypressed(key)
    if key == "space" then inputJump = 10 end
    if key == "F5" then
        levelReset()
    end
end

function love.update(dt)
    local width, height = love.graphics.getDimensions()
    if width < height then
        scl = width/5
    else
        scl = height/5
    end

    local inputLeft = love.keyboard.isDown("a")
    local inputRight = love.keyboard.isDown("d")

    if inputLeft and not inputRight then
        hsp = -speed
    elseif inputRight and not inputLeft then
        hsp = speed
    else
        hsp = 0
    end

    if inputJump ~= 0 and canJump then
        vsp = -jumpSpeed
        canJump = false
    elseif inputJump ~= 0 then
        inputJump = inputJump - 1
    end

    vsp = vsp + grv

    if y >=20 then
        levelReset()
    end

    collition()
    x = x + hsp
    y = y + vsp
    if canJump then 
        y = math.floor(y+0.5)
    end
end

function love.draw()
    --level.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", math.floor(StartX * scl-scl) + 1, math.floor(StartY * scl-scl) + 1, scl, scl)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", (x - 1) * scl, (y - 1+1/32) * scl, scl, scl)
    for i = 1, #level do
        for j = 1, #level[i] do
            if level[i][j] == 1 then
                love.graphics.rectangle("fill", (j - 1) * scl, (i - 1) * scl, scl, scl)
            end
        end
    end

    --Debug
    love.graphics.print("X: " .. x .. " Y: " .. y, 10, 10)
    love.graphics.print(inputJump, 10, 30)
end

function levelReset()
    x = 3
    y = 3
    hsp = 0
    vsp = 0
end

function collition()
    local newX = x + hsp
    local newY = y + vsp

    -- Calculate the tile position for the player's feet
    local side = -1
    if hsp > 0 then
        side = 1
    end
    local feetX = math.floor(newX)
    local feetY = math.floor(newY + side)

    -- Check horizontal collision
    local tileX = math.max(1, math.min(math.floor(newX), #level[1]))
    local tileY = math.max(1, math.min(math.floor(y), #level))
    if level[tileY][tileX] == 1 then
        hsp = 0
        newX = x
    end

    -- Check vertical collision (ground)
    tileX = math.floor(x)
    tileY = math.floor(newY + 1)
    if tileX >= 1 and tileX <= #level[1] and tileY >= 1 and tileY <= #level then
        if level[tileY][tileX] == 1 then
            vsp = 0
            canJump = true
            newY = tileY - 1
        else
            canJump = false
        end
    else
        canJump = false
    end
end