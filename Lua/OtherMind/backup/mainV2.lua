platform = {}
player = {}
chunk = {}
seed = 12345

maxSlot = 3

player = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getWidth() / 2,
    mvsp = 0,
    speed = 200,
    vsp = 0,
    gravity = -500,
    img = love.graphics.newImage('assets/white.png'),
    isOnGround = false,
    jump_height = -120,
    
}

local debug = false
local mouseX, mouseY = love.mouse.getPosition()

local RightInput = {"d", "right"}
local LeftInput = {"a", "left", "q"}
local UpInput = {"z", "up"}
local DownInput = {"s", "down"}
local JumpInput = {"space"}

function love.load() --add libraries camera
    --debug = require "debug"
    --item = require "item"
    --item.load()
    camera = require "libraries/camera"
    cam = camera()
end

local chunkMatrix = {} -- Matrice pour stocker les blocs des chunks

-- Fonction pour charger les chunks dans la matrice
function loadChunksAroundPlayer()
    local playerChunkX = math.floor(player.x / 64)
    local playerChunkY = math.floor(player.y / 64)

    chunkMatrix = {} -- Réinitialiser la matrice

    for offsetX = -1, 1 do
        for offsetY = -1, 1 do
            local chunkX = playerChunkX + offsetX
            local chunkY = playerChunkY + offsetY

            local chunkData = {}
            for y = 0, 7 do -- 8 blocs en hauteur
                chunkData[y] = {}
                for x = 0, 7 do -- 8 blocs en largeur
                    local blockX = chunkX * 64 + x * 8
                    local blockY = chunkY * 64 + y * 8
                    local noise = love.math.noise(blockX * 0.1, blockY * 0.1)
                    chunkData[y][x] = noise > 0.5 -- `true` si le bloc est solide, sinon `false`
                end
            end
            chunkMatrix[#chunkMatrix + 1] = {chunkX, chunkY, chunkData}
        end
    end
end

-- Fonction pour vérifier les collisions avec la matrice
function checkCollisionsWithMatrix(nextX, nextY)
    local collidedX, collidedY = false, false

    for _, chunk in ipairs(chunkMatrix) do
        local chunkX, chunkY, chunkData = chunk[1], chunk[2], chunk[3]

        for y = 0, 7 do
            for x = 0, 7 do
                if chunkData[y][x] then -- Si le bloc est solide
                    local blockX = chunkX * 64 + x * 8
                    local blockY = chunkY * 64 + y * 8
                    local blockSize = 8

                    -- Vérifier collision horizontale
                    if checkCollision(nextX, player.y, 8, 8, blockX, blockY, blockSize, blockSize) then
                        collidedX = true
                    end

                    -- Vérifier collision verticale
                    if checkCollision(player.x, nextY, 8, 8, blockX, blockY, blockSize, blockSize) then
                        if player.vsp > 0 then -- Collision par le bas
                            player.y = blockY - 8
                            player.vsp = 0
                            player.isOnGround = true
                        elseif player.vsp < 0 then -- Collision par le haut
                            player.y = blockY + blockSize
                            player.vsp = 0
                        end
                        collidedY = true
                    end
                end
            end
        end
    end

    return collidedX, collidedY
end

-- Modifier la fonction playerMovement pour utiliser la matrice
function playerMovement(dt)
    -- Déplacement horizontal
    local inputLeft = love.keyboard.isDown("a") and 1 or 0
    local inputRight = love.keyboard.isDown("d") and 1 or 0
    player.mvsp = inputRight - inputLeft

    -- Saut
    if love.keyboard.isDown("space") and player.isOnGround then
        player.vsp = player.jump_height
        player.isOnGround = false
    end

    -- Appliquer la gravité
    player.vsp = player.vsp - player.gravity * dt

    -- Calculer la position future
    local nextX = player.x + player.mvsp * player.speed * dt
    local nextY = player.y + player.vsp * dt

    -- Vérifier les collisions avec la matrice
    local collidedX, collidedY = checkCollisionsWithMatrix(nextX, nextY)

    -- Mettre à jour la position si pas de collision
    if not collidedX then
        player.x = nextX
    end
    if not collidedY then
        player.y = nextY
    end
end

-- Appeler loadChunksAroundPlayer dans love.update
function love.update(dt)
    loadChunksAroundPlayer() -- Charger les chunks autour du joueur
    playerMovement(dt) -- Gérer le mouvement du joueur
    cam:lookAt(player.x, player.y)
end

function love.keypressed(key) --debug
    if key == "f3" then
        debug = not debug
    end
end

function love.draw()
    --debug.draw()
    --item.draw()
    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Debug Mode", 10, 10, 0, 1)
        love.graphics.print("Seed: " .. seed, 10, 30, 0, 1)
        love.graphics.print("Player Position: (" .. player.x .. ", " .. player.y .. ")", 10, 50, 0, 1)
        love.graphics.print("Player Velocity: (" .. player.mvsp .. ", " .. player.vsp .. ")", 10, 70, 0, 1)
        love.graphics.print("collision: (" .. math.floor(0.5+love.math.noise(math.floor(player.x + player.mvsp*8) * 0.1, math.floor(player.y) * 0.1)).. ")", 10, 90, 0, 1)
    end
    cam:attach()
        if debug then
            love.graphics.setColor(1, 0, 0) -- Rouge pour le mode debug
            love.graphics.rectangle("line", player.x, player.y, 8, 8)
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("line", math.floor(player.x + player.mvsp*8), math.floor(player.y), 8,8)
        end
        love.graphics.setColor(1, 1, 1)
        -- Centrer l'image du joueur sur un carré de 8x8 pixels
        love.graphics.draw(player.img, player.x+4, player.y+4, 0, 1, 1, 4, 4)
        
        -- Dessiner les chunks et les blocs solides
        for i = 1, #chunkMatrix do
            local chunkX, chunkY, chunkData = chunkMatrix[i][1], chunkMatrix[i][2], chunkMatrix[i][3]

            for y = 0, 7 do -- 8 blocs en hauteur
                love.graphics.setColor(0.5, 0.5, 0.5) -- Gris pour les blocs solides
                for x = 0, 7 do -- 8 blocs en largeur
                    if chunkData[y][x] then
                        local worldX = chunkX * 8 + x
                        local worldY = chunkY * 8 + y
                        love.graphics.rectangle('fill', worldX * 8, worldY * 8, 8, 8)
                    end
                end
            end
            love.graphics.setColor(1, 0, 0) -- Rouge pour le contour
            love.graphics.rectangle('line', chunkMatrix[i][1]*64, chunkMatrix[i][2]*64, 64, 64)
        end
    cam:detach()
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function addChunkIfNotExists(chunkX, chunkY)
    for _, c in ipairs(chunk) do
        if c[1] == chunkX and c[2] == chunkY then
            return -- Le chunk existe déjà
        end
    end
    table.insert(chunk, {chunkX, chunkY}) -- Ajouter un nouveau chunk
end