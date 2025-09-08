local Fwidth, Fheight =  800, 600
require("Boutton")
require("Gui")

OffsetKey = 1

function changeColor()
    Gui.left.color = {math.random(), math.random(), math.random(), 1}
end

Gui = {
    left = {
        x = 10, y = 10,
        width = 50, height = 50,
        color = {0.5, 0.5, 0.8, 1},
        curve = 10,
        func = changeColor, --function() OffsetKey = OffsetKey - 1 end,
    },
    right = {
        x = 70, y = 10,
        width = 50, height = 50,
        color = {0.5, 0.5, 0.8, 1},
        curve = 10,
        func = changeColor, -- function() OffsetKey = OffsetKey + 1 end,
    }
}

notes = {} -- Table to hold note sources
noteVolumes = {} -- Table to hold current volumes
noteTargets = {} -- Table to hold target volumes (for fade)
fadeSpeed = 20 -- Volume change per second

-- Map keys to white note frequencies (C D E F G A B C)
local whiteNotes = {
    q = 261.63,  -- C4
    z = 277.18,  -- C#4
    s = 293.66,  -- D4
    e = 311.13,  -- D#4
    d = 329.63,  -- E4
    f = 349.23,  -- F4
    t = 369.99,  -- F#4
    g = 392.00,  -- G4
    y = 415.30,  -- G#4
    h = 440.00,  -- A4
    u = 466.16,  -- A#4
    j = 493.88,  -- B4
    k = 523.25,  -- C5
    o = 554.37,  -- C#5
    l = 587.33,  -- D5
    p = 622.25,  -- D#5
    m = 659.25,  -- E5
}

function playNote(key, freq, sampleRate)
    local duration = 1
    local samples = {}
    local attack = 0.01      -- seconds
    local decay = 0.15       -- seconds
    local sustain = 0.7      -- sustain level
    local release = 0.2      -- seconds

    for i = 1, sampleRate * duration do
        local t = i / sampleRate

        -- Envelope (ADSR simplified)
        local env
        if t < attack then
            env = t / attack
        elseif t < attack + decay then
            env = 1 - (1 - sustain) * ((t - attack) / decay)
        elseif t < duration - release then
            env = sustain
        else
            env = sustain * (1 - (t - (duration - release)) / release)
        end

        -- Add harmonics for piano timbre
        local sample =
            1.0 * math.sin(2 * math.pi * freq * t) +         -- Fundamental
            0.5 * math.sin(2 * math.pi * freq * 2 * t) +     -- 2nd harmonic
            0.3 * math.sin(2 * math.pi * freq * 3 * t) +     -- 3rd harmonic
            0.15 * math.sin(2 * math.pi * freq * 4 * t)      -- 4th harmonic

        sample = sample * env * 0.5 -- Lower overall volume to avoid clipping
        samples[i] = sample
    end

    local soundData = love.sound.newSoundData(#samples, sampleRate, 16, 1)
    for i = 0, #samples - 1 do
        soundData:setSample(i, samples[i + 1])
    end

    local source = love.audio.newSource(soundData, "static")
    source:setLooping(true)
    source:setVolume(0) -- Start silent for fade-in
    source:play()
    notes[key] = source
    noteVolumes[key] = 0
    noteTargets[key] = 1 -- Fade in to full volume
end

function stopNote(key)
    if notes[key] then
        noteTargets[key] = 0 -- Start fade out
    end
end

local old_update = love.update
function love.update(dt)
    -- Piano note fade logic
    for key, source in pairs(notes) do
        local vol = noteVolumes[key] or 0
        local target = noteTargets[key] or 1
        if vol < target then
            vol = math.min(vol + fadeSpeed * dt, target)
        elseif vol > target then
            vol = math.max(vol - fadeSpeed * dt, target)
        end
        source:setVolume(vol)
        noteVolumes[key] = vol

        -- If faded out, stop and remove
        if vol == 0 and target == 0 then
            source:stop()
            notes[key] = nil
            noteVolumes[key] = nil
            noteTargets[key] = nil
        end
    end
    -- Call previous update logic if any
    if old_update then old_update(dt) end
end

function love.load()
    love.window.setMode(800, 600, {resizable = true, vsync = true})
    love.window.setTitle("Piano Virtuel")
    love.graphics.setBackgroundColor(0.2, 0.2, 0.4, 1)
end

function love.draw()
    GuiDraw()
    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    for i = 1, 14 do
        love.graphics.rectangle("fill", 50 + (i - 1) * 50, 300, 40, 200, 5)
    end
    love.graphics.setColor(0, 0, 0, 1) -- Set color to black for the black keys
    for i = 1, 10 do
        love.graphics.rectangle("fill", 50 + (i - OffsetKey + math.floor(0.2 * i + 0.5) + math.floor(0.2 * i - 0.2)) * 50 + 30, 250, 30, 200 ,5)
    end
    love.graphics.print("Offset: " .. OffsetKey, 10, 70)
end

function love.keypressed(key)
    if whiteNotes[key] and not notes[key] then
        playNote(key, whiteNotes[key], 44100)
    end
end

function love.keyreleased(key)
    if whiteNotes[key] then
        stopNote(key)
    end
end