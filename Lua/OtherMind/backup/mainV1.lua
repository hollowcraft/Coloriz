local player = {
    x = 400, y = 0,
    mvsp = 0,
    hsp = 50,
    vsp = 0,
    grv = 64,
    sprite = nil,
    direction = 1,
    scale = 1,
    canJump = true,
    jumpHeight = 64,
}

local debug = false
local camera = {x = 0, y = 0}
local zoom = 1 -- Zoom de la caméra

local seed = math.random(1, 100)

local RightInput = {"d", "right"}
local LeftInput = {"a", "left", "q"}
local UpInput = {"z", "up"}
local DownInput = {"s", "down"}
local JumpInput = {"space"}

local tileSize = 8 -- Taille des blocs (8x8 pixels)
local whiteTexture -- Texture pour les blocs

local mouseX, mouseY = love.mouse.getPosition()
local terrain = {}

function love.load()
    player.sprites = {
        idle = love.graphics.newImage("assets/idle00.png"),
        jump = love.graphics.newImage("assets/jump00.png"),
        fall = love.graphics.newImage("assets/fall00.png")
    }

    player.sprite = player.sprites.idle
    player.sprite:setFilter("nearest", "nearest")
    
    love.math.setRandomSeed(seed)

    -- Charger la texture blanche pour les blocs
    whiteTexture = love.graphics.newImage("assets/white.png")
    whiteTexture:setFilter("nearest", "nearest")

    -- Générer le terrain
    generateTerrain()
end

local function generateTerrain()
    -- Paramètres de bruit pour la surface et les grottes
    local surfaceNoiseScale = 0.005
    local caveNoiseScale = 0.03
    local baseSurfaceHeight = 200
    local groundThickness = 20

    -- Générer le terrain
    for y = 0, 600, tileSize do
        terrain[y / tileSize] = {} -- Initialiser une ligne dans la grille
        for x = 0, 800, tileSize do
            local surfaceNoise = love.math.noise(x * surfaceNoiseScale / tileSize)
            local caveNoise = love.math.noise(x * caveNoiseScale / tileSize, y * caveNoiseScale / tileSize)

            local surfaceHeight = baseSurfaceHeight + surfaceNoise * 10

            if y >= surfaceHeight and y < surfaceHeight + groundThickness then
                terrain[y / tileSize][x / tileSize] = "surface" -- Bloc solide (surface)
            elseif y >= surfaceHeight + groundThickness and caveNoise > 0.5 then
                terrain[y / tileSize][x / tileSize] = "cave" -- Bloc solide (grotte)
            else
                terrain[y / tileSize][x / tileSize] = nil -- Bloc vide (air)
            end
        end
    end
end

local function drawTerrain()
    for y, row in pairs(terrain) do
        for x, block in pairs(row) do
            if block == "surface" then
                love.graphics.setColor(1, 1, 1) -- Blanc pour la surface
            elseif block == "cave" then
                love.graphics.setColor(0.66, 0.66, 0.66) -- Gris pour les grottes
            end
            if block then
                love.graphics.draw(whiteTexture, x * tileSize, y * tileSize, 0, tileSize / whiteTexture:getWidth(), tileSize / whiteTexture:getHeight())
            end
        end
    end
end

function love.update(dt)
    if not zoom or zoom <= 0 then
        zoom = 1
    end

    camera.x = player.x - love.graphics.getWidth() / 2 / zoom
    camera.y = player.y - love.graphics.getHeight() / 2 / zoom
    
    if player.vsp > 30 then
        player.sprite = player.sprites.fall
    elseif player.vsp < -30 then
        player.sprite = player.sprites.jump
    else
        player.sprite = player.sprites.idle
    end

    if love.keyboard.isDown(UpInput) then
        player.vsp = -player.hsp
    end
    if love.keyboard.isDown(DownInput) then
        player.vsp = player.hsp
    end


    InputLeft = love.keyboard.isDown(LeftInput) and 1 or 0
    InputRight = love.keyboard.isDown(RightInput) and 1 or 0
    player.mvsp = InputRight - InputLeft
    if player.mvsp ~= 0 then
        player.direction = player.mvsp
    end

    player.vsp = player.vsp + player.grv * dt
    player.x = player.x + player.mvsp * player.hsp * dt
    player.y = player.y + player.vsp * dt
end

function love.keypressed(key)
    if key == "f3" then
        debug = not debug
    end
    if key == "space" then
        player.vsp = -player.jumpHeight * player.scale
    end
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    -- Appliquer la transformation de la caméra
    love.graphics.push()
    love.graphics.scale(zoom, zoom)
    love.graphics.translate(-camera.x, -camera.y)

    -- Dessiner le terrain et le joueur
    drawTerrain()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        player.sprite, player.x, player.y, 0, player.direction * player.scale, 
        player.scale, player.sprite:getWidth() / 2, player.sprite:getHeight() / 2
    )

    -- Réinitialiser la transformation
    love.graphics.pop()

    -- Affichage du mode debug si activé
    if debug then
        love.graphics.setColor(1, 0, 0) -- Rouge pour le mode debug
        love.graphics.rectangle(
            "line", player.x - 4 * player.scale, player.y - 3 * player.scale, 
            0.5 * 16 * player.scale, 
            11 / 16 * 16 * player.scale
        )
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Debug Mode", 10, 10, 0, 1)
        love.graphics.print("Seed: " .. seed, 10, 30, 0, 1)
        love.graphics.print("Player Position: (" .. player.x .. ", " .. player.y .. ")", 10, 50, 0, 1)
        love.graphics.print("Player Velocity: (" .. player.mvsp .. ", " .. player.vsp .. ")", 10, 70, 0, 1)
    end
end

local function checkCollision(x, y)
    local gridX = math.floor(x / tileSize)
    local gridY = math.floor(y / tileSize)
    return terrain[gridY] and terrain[gridY][gridX] ~= nil
end