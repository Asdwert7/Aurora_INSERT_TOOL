local eventtap   = hs.eventtap
local keycodes   = hs.keycodes
local utf8       = utf8

-- Параметры (можешь подкорректировать)
local blockSize          = 10000        -- печатать блоками по 5 символов
local layoutSwitchDelay  = 100000   -- 100 мс после переключения раскладки
local betweenCharsDelay  = 1000    -- 1 мс между символами
local betweenBlocksDelay = 200000   -- 200 мс между блоками

-- Проверка, русский ли символ
local function isRussianChar(char)
    local cp = utf8.codepoint(char)
    return (cp >= 0x0410 and cp <= 0x044F) or cp == 0x0401 or cp == 0x0451
end

hs.hotkey.bind({"ctrl", "shift"}, "v", function()
    local text = hs.pasteboard.getContents()
    if not text or #text == 0 then return end

    local originalLayout = keycodes.currentSourceID()

    for start = 1, #text, blockSize do
        local block = text:sub(start, start + blockSize - 1)
        for _, cp in utf8.codes(block) do
            local char = utf8.char(cp)

            -- 1) переключаем раскладку
            if isRussianChar(char) then
                keycodes.currentSourceID("com.apple.keylayout.RussianWin")
            else
                keycodes.currentSourceID("com.apple.keylayout.US")
            end
            hs.timer.usleep(layoutSwitchDelay)

            -- 2) печатаем символ через keyStrokes
            eventtap.keyStrokes(char)
            hs.timer.usleep(betweenCharsDelay)
        end

        -- пауза после каждого блока
        hs.timer.usleep(betweenBlocksDelay)
    end

    -- возвращаем прежнюю раскладку
    keycodes.currentSourceID(originalLayout)
end)