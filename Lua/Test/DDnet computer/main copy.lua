E = {
    {1, 1, 2, 1}, -- {X, Y, EntityId, OnOrOff} → démarre allumé
    {2, 0, 0, 0}
}
nE = 0

↕ = 50
↨ = 5
☼ = 1
░ = {1,0,0} -- rouge = off
▒ = {0,0,1} -- bleu = on
█ = {1,1,1} -- blanc = contour

function love.load()
end

function love.update(dt)
    
end

function love.draw()
    -- dessiner les entités
    for i, e in ipairs(E) do
        local x, y, id, onOrOff = e[1], e[2], e[3], e[4]
        DrawEntity(x, y, id, onOrOff)
    end
end


function DrawEntity(x, y, id, onOrOff)
    love.graphics.setColor(█)
    love.graphics.rectangle("fill", x*↕, y*↕, ↕, ↕)

    if onOrOff == 1 then
        love.graphics.setColor(▒) -- bleu si ON
    else
        love.graphics.setColor(░) -- rouge si OFF
    end

    love.graphics.rectangle("fill", x*↕+↨, y*↕+↨, ↕-2*↨, ↕-2*↨)
end