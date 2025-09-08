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

    for i = 1, sampleRate * duration do
        local t = i / sampleRate
        samples[i] = math.sin(2 * math.pi * freq * t)
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

function love.update(dt)
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
