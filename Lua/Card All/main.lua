--cardList = {} ; require("cardList")
local width, height = love.window.getDesktopDimensions()
cardList = {
    [1] = {name = "Rock", texturePath = "assets/Rock.png"},
    [2] = {name = "Paper", texturePath ="assets/Paper.png"},
    [3] = {name = "Scissors", texturePath ="assets/Scissors.png"},
    [4] = {name = "+4", texturePath ="assets/plus4.png"},
    [5] = {name = "Reverse", texturePath ="assets/bReverse.png"},
}

Deck = {1,2,3,4,5}

RemainCard = Deck
Hand = {}

HPosition = 1
HPositionY = 0
HSelected = 0

cHeight, cWidth = 140, 100

function love.load()
    love.window.setTitle("Card Game")
    love.window.setMode(width/2, width*0.35, {resizable = true, vsync = true})
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    for i, card in ipairs(cardList) do
        card.texture = love.graphics.newImage(card.texturePath)
    end
    playButtonImage = love.graphics.newImage("assets/play.png")
    selectedImage = love.graphics.newImage("assets/selected.png")
    DrawCard(3)
end

function love.keypressed(key)
    if key == "q" then
        MvHPosition(-1)
    end
    if key == "d" then
        MvHPosition(1)
    end
    if key == "space" or key == "j" or key == "e" then
        HSelected = HPosition
    end
    if key == "z" or key == "s" then
        HPositionY = HPositionY * -1 + 1
    end
end

function MvHPosition(value)
    if value < 0 and HPosition > 1 then
        HPosition = HPosition + value
    elseif value > 0 and HPosition < #Hand then
        HPosition = HPosition + value
    elseif value < 0 and HPosition == 1 then
        HPosition = #Hand
    elseif value > 0 and HPosition == #Hand then
        HPosition = 1
    end
end

function DrawCard(value)
    if value == #RemainCard and #Hand == 0 then
        Hand = RemainCard
        RemainCard = {}
        return
    end

    for i = 1, value do
        if #RemainCard > 0 then
            local index = math.random(1, #RemainCard)
            table.insert(Hand, RemainCard[index])
            table.remove(RemainCard, index)
        end
    end
end


function love.draw()
    love.graphics.print(HPosition, 0, 500)
    love.graphics.print(HSelected, 0, 510)
    love.graphics.print(HPositionY, 0, 520)
    if HPositionY == 1 then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.rectangle("fill", (HPosition - 1) * cWidth * 1.2, 0, cWidth * 1.2, cHeight * 16/14)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.rectangle("fill", 0, cHeight + 20, 210, 110)
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(playButtonImage, 10, cHeight + 30, 0, 10, 10)
    for i, v in ipairs(Hand) do
        love.graphics.draw(cardList[v].texture, (2*i - 2) * cWidth * 0.6 + 10, 10, 0, 10, 10)
    end
end