local eventtap = hs.eventtap
local utf8 = utf8

local printer = {
    config = {
        blockSize = 10000,
        betweenCharsDelay = 1000,
        betweenBlocksDelay = 200000
    }
}

function printer.setConfig(newConfig)
    for k, v in pairs(newConfig) do
        printer.config[k] = v
    end
end

function printer.printText(text, layoutMaps, detector)
    if not text or #text == 0 then return end

    local originalLayout = hs.keycodes.currentSourceID()

    for start = 1, #text, printer.config.blockSize do
        local block = text:sub(start, start + printer.config.blockSize - 1)
        for _, cp in utf8.codes(block) do
            local char = utf8.char(cp)
            printer.printChar(char, layoutMaps, detector)
            hs.timer.usleep(printer.config.betweenCharsDelay)
        end
        hs.timer.usleep(printer.config.betweenBlocksDelay)
    end

    hs.keycodes.currentSourceID(originalLayout)
end

function printer.printChar(char, layoutMaps, detector)
    local currentLayout = detector.detectCurrentLayout()
    
    -- Для русских символов
    if detector.isRussianChar(char) then
        local layout = layoutMaps.getLayout('ru')
        if layout then
            local keyMap = char == char:upper() and layout.upper or layout.lower
            local engKey = keyMap[char]
            if engKey then
                if char == char:upper() then
                    eventtap.keyStroke({'shift'}, engKey)
                else
                    eventtap.keyStroke({}, engKey)
                end
                return
            end
        end
    end
    
    -- Для альтернативных английских раскладок
    if currentLayout ~= 'en' then
        local layout = layoutMaps.getLayout(currentLayout)
        if layout then
            local keyMap = char == char:upper() and layout.upper or layout.lower
            local qwertyKey = keyMap[char]
            if qwertyKey then
                eventtap.keyStroke({}, qwertyKey)
                return
            end
        end
    end
    
    -- Стандартная печать
    eventtap.keyStrokes(char)
end

return printer