local eventtap = hs.eventtap
local keycodes = hs.keycodes
local utf8 = utf8
local math = math

-- ⚙️ НАСТРОЙКИ СКОРОСТИ (меняйте эти значения!)
local settings = {
    -- Основные задержки (в микросекундах! 1000 мкс = 1 мс)
    minDelay = 30000,     -- 30 мс (минимальная пауза между символами)
    maxDelay = 250000,    -- 250 мс (максимальная пауза)
    
    -- Дополнительные параметры
    lineEndDelay = 300000, -- 300 мс после Enter
    layoutSwitchDelay = 100000, -- 100 мс на переключение раскладки
    mistakeDelay = 150000, -- 150 мс при "ошибке"
}

-- Проверка, русский ли символ (без изменений)
local function isRussianChar(char)
    local cp = utf8.codepoint(char)
    return (cp >= 0x0410 and cp <= 0x044F) or cp == 0x0401 or cp == 0x0451
end

-- Функция ввода символа с задержкой
local function humanTypeChar(char)
    eventtap.keyStrokes(char)
    hs.timer.usleep(math.random(settings.minDelay, settings.maxDelay))
end

-- Основная функция
hs.hotkey.bind({"ctrl", "shift"}, "v", function()
    local text = hs.pasteboard.getContents()
    if not text or #text == 0 then return end
    
    local originalLayout = keycodes.currentSourceID()
    local isRussian = false
    
    for line in text:gmatch("[^\r\n]+") do
        for _, cp in utf8.codes(line) do
            local char = utf8.char(cp)
            local needRussian = isRussianChar(char)
            
            -- Переключение раскладки (с задержкой)
            if needRussian ~= isRussian then
                keycodes.currentSourceID(needRussian and "com.apple.keylayout.RussianWin" or "com.apple.keylayout.US")
                hs.timer.usleep(settings.layoutSwitchDelay)
                isRussian = needRussian
            end
            
            humanTypeChar(char) -- Печать символа
        end
        
        -- Перенос строки (кроме последней)
        if line ~= "" then
            eventtap.keyStroke({}, "return")
            hs.timer.usleep(settings.lineEndDelay)
        end
    end
    
    keycodes.currentSourceID(originalLayout) -- Возврат раскладки
end)