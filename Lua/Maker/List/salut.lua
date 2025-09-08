white = {
    height = 0.5*height,
    width = 0.1*height,
}

black = {
    height = 0.5*height,
    width = 0.1*height,
    padding = 0.005*height,
}

function salut.draw()
    loev.graphics.setColor(1, 1, 1)
    for i = 0, 7 do
        rectangle(white.x + i * white.width, white.y, white.width, white.height)
    end