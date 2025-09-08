local Dwidth, Dheight = love.window.getDesktopDimensions()
local Fwidth, Fheight =  800, 600

Quests = {}
require("save")
require("Gui")

function saveDate()
    return os.date("%d-%m-%Y")
end

Gui = { PointTab = {x=0,y=0,h=20,w=Dwidth,color={1,1,1,1},curve=10}, QuestTab = {} }

QuestPreset = {
    x = 10,
    y = 10,
    width = Fwidth - 20,
    height = Fheight - 20,
    color = {0.2, 0.2, 0.3, 1}
}

QuestTabOffsetY = 20

function love.load()
    LoadPoints() -- Ajoute ceci pour charger les points au démarrage
    Gui.QuestTab = {} -- Réinitialise la liste à chaque chargement
    local y = QuestPreset.y
    for _, quest in pairs(Quests) do
        local questElement = {
            x = QuestPreset.x,
            y = y,
            width = QuestPreset.width,
            height = 60,
            color = {0.5, 0.5, 0.5, 1},
            -- Ajoute une fonction de dessin personnalisée pour chaque quête
            draw = function(self)
                love.graphics.setColor(self.color)
                love.graphics.rectangle("fill", self.x, self.y + QuestTabOffsetY, self.width, self.height, 8)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.print("Nom : " .. self.name, self.x + 10, self.y + 5 + QuestTabOffsetY)
                love.graphics.print("Description : " .. self.description, self.x + 10, self.y + 20 + QuestTabOffsetY)
                love.graphics.print("Progression : " .. self.progress .. "/" .. self.maxProgress, self.x + 10, self.y + 35 + QuestTabOffsetY)
                -- Dessine le bouton
                love.graphics.setColor(0.2, 0.7, 0.2, 1)
                love.graphics.rectangle("fill", self.x + self.width - 90, self.y + 15 + QuestTabOffsetY, 80, 30, 6)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.print("Finir", self.x + self.width - 75, self.y + 22 + QuestTabOffsetY)
            end,
            name = quest.name,
            description = quest.description,
            progress = quest.progress,
            maxProgress = quest.maxProgress,
            tier = quest.tier,
            isComplete = quest.isComplete,
            whenLastComplete = quest.whenLastComplete
        }
        -- Ajoute le bouton à la liste des boutons du GUI
        BouttonNew(
            questElement.x + questElement.width - 90,
            questElement.y + 15,
            80,
            30,
            function()
                QuestComplete(questElement.name)
            end
        )
        table.insert(Gui.QuestTab, questElement)
        y = y + 70 -- espace entre les quêtes
    end
end

function love.update(dt)
end

function love.draw()
    -- Affiche chaque quête via le GUI
    for _, quest in ipairs(Gui.QuestTab) do
        if quest.draw then
            quest:draw()
        end
    end
    -- Affiche les points ◈ en haut à gauche
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Points ◈ : " .. tostring(◈), 10, 10)
end

function QuestComplete(questName)
    local quest = Quests[questName]
    if quest and not quest.isComplete then
        table.insert(quest.DateComplete, saveDate())
        quest.isComplete = true
        quest.whenLastComplete = saveDate()
        AddPoints(2*quest.reward * 10) -- Donne 10 points pour chaque quête complétée (ajuste selon tes besoins)
        SavePoints()
    end
end

function AddPoints(amount)
    ◈ = ◈ + amount
    SavePoints() -- Ajoute ceci pour sauvegarder après modification
end

function SavePoints()
    local file = love.filesystem.newFile("points.save", "w")
    file:write(tostring(◈))
    file:close()
end

function LoadPoints()
    if love.filesystem.getInfo("points.save") then
        local file = love.filesystem.newFile("points.save", "r")
        file:open("r")
        local content = file:read()
        file:close()
        ◈ = tonumber(content) or 0
    else
        ◈ = 0
    end
end

function love.wheelmoved(x, y)
    if QuestTabOffsetY + y * 20 > 20 then
        QuestTabOffsetY = QuestTabOffsetY + y * 20 -- défilement fluide
    else
        QuestTabOffsetY = 20
    end
end


