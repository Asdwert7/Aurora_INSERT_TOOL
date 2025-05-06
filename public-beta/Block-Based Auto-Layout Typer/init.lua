-- Импорт модулей
local eventtap = hs.eventtap
local keycodes = hs.keycodes
local utf8 = utf8
local timer = hs.timer

-- Конфигурационные параметры (вынесены в отдельный блок)
local CONFIG = {
    BLOCK_SIZE = 10000,           -- размер блока символов
    LAYOUT_SWITCH_DELAY = 100000,  -- задержка после смены раскладки (мкс)
    BETWEEN_CHARS_DELAY = 1000,    -- задержка между символами (мкс)
    BETWEEN_BLOCKS_DELAY = 200000, -- задержка между блоками (мкс)
    
    -- Идентификаторы раскладок (для удобства изменений)
    LAYOUTS = {
        RUSSIAN = "com.apple.keylayout.RussianWin",
        ENGLISH = "com.apple.keylayout.US"
    },
    
    -- Горячие клавиши
    HOTKEY = {
        MODIFIERS = {"ctrl", "shift"},
        KEY = "v"
    }
}

--[[
 Проверяет, является ли символ русским
 @param char - символ для проверки
 @return boolean - true если символ русский
--]]
local function isRussianChar(char)
    local codepoint = utf8.codepoint(char)
    local isCyrillic = (codepoint >= 0x0410 and codepoint <= 0x044F)
    local isYo = (codepoint == 0x0401 or codepoint == 0x0451)
    
    return isCyrillic or isYo
end

--[[
 Основная функция вставки текста с автоматическим переключением раскладки
--]]
local function pasteWithAutoLayout()
    -- Получаем текст из буфера обмена
    local text = hs.pasteboard.getContents()
    if not text or #text == 0 then return end

    -- Запоминаем текущую раскладку
    local originalLayout = keycodes.currentSourceID()

    -- Обрабатываем текст блоками
    for startPos = 1, #text, CONFIG.BLOCK_SIZE do
        local blockEndPos = startPos + CONFIG.BLOCK_SIZE - 1
        local textBlock = text:sub(startPos, blockEndPos)
        
        -- Обрабатываем каждый символ в блоке
        for _, codepoint in utf8.codes(textBlock) do
            local char = utf8.char(codepoint)
            
            -- Определяем нужную раскладку для текущего символа
            local targetLayout = isRussianChar(char) 
                and CONFIG.LAYOUTS.RUSSIAN 
                or CONFIG.LAYOUTS.ENGLISH
            
            -- Переключаем раскладку при необходимости
            keycodes.currentSourceID(targetLayout)
            timer.usleep(CONFIG.LAYOUT_SWITCH_DELAY)
            
            -- Печатаем символ
            eventtap.keyStrokes(char)
            timer.usleep(CONFIG.BETWEEN_CHARS_DELAY)
        end
        
        -- Пауза между блоками
        timer.usleep(CONFIG.BETWEEN_BLOCKS_DELAY)
    end

    -- Восстанавливаем исходную раскладку
    keycodes.currentSourceID(originalLayout)
end

-- Назначаем горячую клавишу
hs.hotkey.bind(CONFIG.HOTKEY.MODIFIERS, CONFIG.HOTKEY.KEY, pasteWithAutoLayout)

-- Уведомление о успешной загрузке
hs.alert.show("Auto Layout Paste initialized\nShortcut: Ctrl+Shift+V", 2)