local Entity = {
    {id = 1, x = 0, y = 0, scale = 1, slots = {}},
    {id = 2, x = 200, y = 0, scale = 1, slots = {}},
    {id = 3, x = 0, y = 200, scale = 1, slots = {}},
    {id = 4, x = 200, y = 200, scale = 1, slots = {}}
}

local selectedBlock = nil
local offsetX, offsetY = 0, 0
local blockScale = 128
local slotSize = blockScale / 2
local nextId = 5 -- ID pour le prochain bloc
local buttonX, buttonY, buttonWidth, buttonHeight = 700, 550, 80, 40 -- Position et taille du bouton

-- Fonction récursive pour mettre à jour la scale de tous les enfants
local function updateScaleRecursively(block, parentScale, visited)
    visited = visited or {} -- Initialise la table des blocs visités
    if visited[block] then return end -- Arrête si le bloc a déjà été visité
    visited[block] = true -- Marque le bloc comme visité

    for _, child in pairs(block.slots) do
        if child then
            child.scale = parentScale + 1 -- Met à jour la scale de l'enfant
            updateScaleRecursively(child, child.scale, visited) -- Appelle récursivement pour les enfants des enfants
        end
    end
end

-- Fonction récursive pour dupliquer un bloc et ses enfants
local function duplicateBlock(block, idMap)
    local newBlock = {
        id = nextId,
        x = block.x + 20, -- Décalage pour éviter de superposer les blocs
        y = block.y + 20,
        scale = block.scale,
        slots = {} -- Initialise les slots pour le nouveau bloc
    }
    idMap[block.id] = newBlock.id -- Associe l'ancien ID au nouveau ID
    nextId = nextId + 1

    -- Duplique les enfants récursivement
    for slotIndex, child in pairs(block.slots) do
        if child then
            newBlock.slots[slotIndex] = duplicateBlock(child, idMap) -- Copie récursive des enfants
        end
    end

    return newBlock
end

function love.load()
    love.window.setMode(800, 600, {resizable = true, vsync = true})
    love.window.setTitle("OtherMind")
    love.graphics.setDefaultFilter("nearest", "nearest") -- Appliquer le filtre par défaut
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()

    if love.mouse.isDown(1) and selectedBlock then
        -- Si le bloc est déplacé, il sort de son parent
        for _, block in ipairs(Entity) do
            for slotIndex, child in pairs(block.slots) do
                if child == selectedBlock then
                    block.slots[slotIndex] = nil -- Retire le bloc du slot
                    selectedBlock.scale = 1 -- Restaure la taille normale pour le bloc déplacé
                    updateScaleRecursively(selectedBlock, selectedBlock.scale) -- Met à jour la scale des enfants
                    break
                end
            end
        end

        -- Met à jour la position du bloc sélectionné
        selectedBlock.x = mouseX - offsetX
        selectedBlock.y = mouseY - offsetY
    end

    -- Met à jour les positions des blocs enfants pour qu'ils suivent leur parent
    for _, block in ipairs(Entity) do
        local blockSize = blockScale / 2^(block.scale - 1)
        for slotIndex, child in pairs(block.slots) do
            if child and child ~= selectedBlock then -- Ne pas mettre à jour si l'enfant est sélectionné
                local slotX = (slotIndex - 1) % 2
                local slotY = math.floor((slotIndex - 1) / 2)
                child.x = block.x + slotX * (blockSize / 2)
                child.y = block.y + slotY * (blockSize / 2)
            end
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Vérifie si le bouton est cliqué
        if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
            -- Crée un nouveau bloc
            table.insert(Entity, {id = nextId, x = 100, y = 100, scale = 1, slots = {}})
            nextId = nextId + 1
            return
        end

        local highestIdBlock = nil
        for _, block in ipairs(Entity) do
            local blockSize = blockScale / 2^(block.scale - 1)
            if x >= block.x and x <= block.x + blockSize and y >= block.y and y <= block.y + blockSize then
                -- Vérifie si ce bloc a un ID plus grand que le bloc actuellement sélectionné
                if not highestIdBlock or block.id > highestIdBlock.id then
                    highestIdBlock = block
                end
            end
        end

        -- Sélectionne le bloc avec le plus grand ID
        if highestIdBlock then
            selectedBlock = highestIdBlock
            offsetX = x - selectedBlock.x
            offsetY = y - selectedBlock.y
        end
    elseif button == 2 then -- Clic droit pour supprimer un bloc
        for i, block in ipairs(Entity) do
            local blockSize = blockScale / 2^(block.scale - 1)
            if x >= block.x and x <= block.x + blockSize and y >= block.y and y <= block.y + blockSize then
                table.remove(Entity, i) -- Supprime le bloc
                return
            end
        end
    elseif button == 3 then -- Clic molette pour dupliquer un bloc
        for _, block in ipairs(Entity) do
            local blockSize = blockScale / 2^(block.scale - 1)
            if x >= block.x and x <= block.x + blockSize and y >= block.y and y <= block.y + blockSize then
                -- Duplique le bloc et ses enfants
                local idMap = {}
                local newBlock = duplicateBlock(block, idMap)
                table.insert(Entity, newBlock)
                return
            end
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 and selectedBlock then
        for _, block in ipairs(Entity) do
            if block ~= selectedBlock then
                local blockSize = blockScale / 2^(block.scale - 1)
                if x >= block.x and x <= block.x + blockSize and y >= block.y and y <= block.y + blockSize then
                    -- Vérifie si le bloc peut être placé dans un slot
                    local slotX = math.floor((x - block.x) / (blockSize / 2))
                    local slotY = math.floor((y - block.y) / (blockSize / 2))
                    local slotIndex = slotY * 2 + slotX + 1

                    -- Vérifie que le scale du bloc sélectionné est plus petit ou égal au scale du parent
                    if selectedBlock.scale > block.scale then
                        print("Impossible de placer un bloc avec un scale plus grand dans un bloc avec un scale plus petit.")
                        selectedBlock = nil
                        return
                    end

                    if not block.slots[slotIndex] then
                        -- Place le bloc dans le slot
                        block.slots[slotIndex] = selectedBlock
                        selectedBlock.x = block.x + slotX * (blockSize / 2)
                        selectedBlock.y = block.y + slotY * (blockSize / 2)
                        selectedBlock.scale = block.scale + 1 -- Augmente l'échelle du bloc enfant
                        updateScaleRecursively(selectedBlock, selectedBlock.scale) -- Met à jour la scale des enfants
                        selectedBlock = nil
                        return
                    end
                end
            end
        end
        selectedBlock = nil
    end
end

function love.draw()
    for _, block in ipairs(Entity) do
        local blockSize = blockScale / 2^(block.scale - 1)

        -- Dessine le bloc principal
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", block.x, block.y, blockSize, blockSize)
        love.graphics.print("ID: " .. block.id, block.x + 5, block.y + 5)

        -- Dessine les slots du bloc
        for i = 0, 1 do
            for j = 0, 1 do
                local slotX = block.x + i * (blockSize / 2)
                local slotY = block.y + j * (blockSize / 2)
                love.graphics.rectangle("line", slotX, slotY, blockSize / 2, blockSize / 2)

                -- Si un bloc est dans le slot, dessine-le
                local slotIndex = j * 2 + i + 1
                if block.slots[slotIndex] then
                    local containedBlock = block.slots[slotIndex]
                    local containedSize = blockScale / 2^(containedBlock.scale - 1)
                    love.graphics.setColor(0.5, 0.5, 1, 0.5)
                    love.graphics.rectangle("fill", containedBlock.x, containedBlock.y, containedSize, containedSize)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.print("ID: " .. containedBlock.id, containedBlock.x + 5, containedBlock.y + 5)
                end
            end
        end
    end

    -- Dessine le bouton pour créer un nouveau bloc
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.print("New Block", buttonX + 10, buttonY + 10)
end