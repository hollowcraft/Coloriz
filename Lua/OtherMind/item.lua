local item = {}
local itemList = {
    {id=1, name="Crystal", image="crystal00.png"},
    {id=2, name="Yellow Crystal", image="crystalYellow00.png"}
}

local itemSlot = {1,2}

function item.load()
    for i = 1, #itemList do
        local itemData = itemList[i]
        itemSlot[itemData.id] = {
            id = itemData.id,
            name = itemData.name,
            image = love.graphics.newImage(itemData.image),
        }
    end
end

function item.draw()
    for i = 1, #itemSlot do
        local itemData = itemSlot[i]
        love.graphics.draw(itemData.image, 10 + (i - 1) * 50, 10)
    end
end