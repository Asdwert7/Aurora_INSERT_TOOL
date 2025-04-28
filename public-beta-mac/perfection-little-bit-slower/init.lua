---------------------------------------------------------------------
--  Auto-typing с прогресс-баром для Hammerspoon
---------------------------------------------------------------------
local eventtap  = hs.eventtap
local keycodes  = hs.keycodes
local utf8      = utf8
local math      = math
local timer     = hs.timer
local drawing   = hs.drawing
local geometry  = hs.geometry
local screen    = hs.screen.primaryScreen()
local frame     = screen:frame()

-- ⚙️  НАСТРОЙКИ (в микросекундах: 1000 µs = 1 ms)
local settings = {
    minDelay          = 30000,    -- 30 мс
    maxDelay          = 250000,   -- 250 мс
    lineEndDelay      = 300000,   -- 300 мс после Enter
    layoutSwitchDelay = 100000,   -- 100 мс на переключение раскладки
}

---------------------------------------------------------------------
--  Глобальные переменные
---------------------------------------------------------------------
local printCoroutine  = nil
local stopPrinting    = false
local progressBar     = nil
local progressText    = nil
local progressBG      = nil
local startTime       = nil
local totalChars      = 0
local typedChars      = 0
local mainTimer       = nil

---------------------------------------------------------------------
--  Прогресс-бар
---------------------------------------------------------------------
local function removeProgressBar()
    if progressBar then progressBar:delete(); progressBar = nil end
    if progressText then progressText:delete(); progressText = nil end
    if progressBG   then progressBG:delete();   progressBG   = nil end
end

local function createProgressBar()
    removeProgressBar()

    -- фон
    progressBG = drawing.rectangle(geometry.rect(
        frame.w/4, frame.h - 100, frame.w/2, 30
    ))
    progressBG:setRoundedRectRadii(5,5)
    progressBG:setFillColor {red=0.2, green=0.2, blue=0.2, alpha=0.7}
    progressBG:setStroke(false)

    -- полоска
    progressBar = drawing.rectangle(geometry.rect(
        frame.w/4 + 2, frame.h - 98, 0, 26
    ))
    progressBar:setRoundedRectRadii(5,5)
    progressBar:setFillColor {red=0.1, green=0.6, blue=0.9, alpha=0.9}
    progressBar:setStroke(false)

    -- текст
    progressText = drawing.text(geometry.rect(
        frame.w/4, frame.h - 130, frame.w/2, 30
    ), "")
    progressText:setTextColor {red=1, green=1, blue=1, alpha=1}
    progressText:setTextSize(16)
    progressText:setTextStyle {alignment="center"}

    progressBG:show(); progressBar:show(); progressText:show()
end

local function updateProgress()
    if not progressBar or not progressText then return end

    local percent = totalChars > 0 and (typedChars / totalChars) * 100 or 0
    if percent > 100 then percent = 100 end

    local width = (frame.w/2 - 4) * (percent / 100)
    progressBar:setFrame(geometry.rect(
        frame.w/4 + 2, frame.h - 98, width, 26
    ))

    if percent > 0 then
        local elapsed   = timer.secondsSinceEpoch() - startTime
        local remaining = (elapsed / percent) * (100 - percent)
        local timeText  = string.format("%.1f сек", remaining)
        if remaining > 60 then
            timeText = string.format("%d мин %.1f сек",
                        math.floor(remaining/60), remaining % 60)
        end
        progressText:setText(
            string.format("Прогресс: %.1f%% | Осталось: %s", percent, timeText)
        )
    else
        progressText:setText("Прогресс: 0 %")
    end
end

---------------------------------------------------------------------
--  Утилиты
---------------------------------------------------------------------
local function isRussianChar(ch)
    local cp = utf8.codepoint(ch)
    return (cp >= 0x0410 and cp <= 0x044F) or cp == 0x0401 or cp == 0x0451
end

local function countTotalChars(text)
    local n = 0; for _ in text:gmatch(".") do n = n + 1 end
    return n
end

local function humanTypeChar(ch)
    if stopPrinting then return false end
    eventtap.keyStrokes(ch)
    hs.timer.usleep(math.random(settings.minDelay, settings.maxDelay))
    typedChars = typedChars + 1
    updateProgress()
    return not stopPrinting
end

---------------------------------------------------------------------
--  Корутин-печать
---------------------------------------------------------------------
local function typingCoroutine(text)
    local originalLayout = keycodes.currentSourceID()
    local isRussian = false

    for line in text:gmatch("[^\r\n]*") do
        if stopPrinting then break end

        local indent  = line:match("^(%s*)") or ""
        local content = line:sub(#indent + 1)

        if line ~= text:match("^[^\r\n]*") then
            eventtap.keyStroke({}, "return")
            hs.timer.usleep(settings.lineEndDelay)
            eventtap.keyStroke({}, "home")
            hs.timer.usleep(5000)
        end

        for _, cp in utf8.codes(indent) do
            if not humanTypeChar(utf8.char(cp)) then break end
            coroutine.yield()
        end

        for _, cp in utf8.codes(content) do
            local ch = utf8.char(cp)
            local needRu = isRussianChar(ch)
            if needRu ~= isRussian then
                keycodes.currentSourceID(
                    needRu and "com.apple.keylayout.RussianWin"
                           or "com.apple.keylayout.US"
                )
                hs.timer.usleep(settings.layoutSwitchDelay)
                isRussian = needRu
            end
            if not humanTypeChar(ch) then break end
            coroutine.yield()
        end
    end

    if not stopPrinting then keycodes.currentSourceID(originalLayout) end
end

---------------------------------------------------------------------
--  ОСТАНОВКА (forward-declared)
---------------------------------------------------------------------
local stopTyping -- объявляем имя вперёд

stopTyping = function()
    stopPrinting = true
    if mainTimer then mainTimer:stop(); mainTimer = nil end
    printCoroutine = nil
    removeProgressBar()
end

---------------------------------------------------------------------
--  ЗАПУСК
---------------------------------------------------------------------
local function startTyping(text)
    stopTyping()  -- останавливаем предыдущую попытку

    stopPrinting = false
    typedChars   = 0
    totalChars   = countTotalChars(text)
    startTime    = timer.secondsSinceEpoch()

    createProgressBar()

    printCoroutine = coroutine.create(function()
        local ok, err = pcall(function() typingCoroutine(text) end)
        if not ok then hs.alert.show("Ошибка: " .. tostring(err)) end
        printCoroutine = nil
        removeProgressBar()
    end)

    mainTimer = hs.timer.new(0.001, function()
        if printCoroutine and coroutine.status(printCoroutine) == "suspended" then
            local ok, err = coroutine.resume(printCoroutine)
            if not ok then
                hs.alert.show("Ошибка: " .. tostring(err))
                stopTyping()
            end
        else
            stopTyping()
        end
    end)
    mainTimer:start()
end

---------------------------------------------------------------------
--  ГОРЯЧИЕ КЛАВИШИ
---------------------------------------------------------------------
hs.hotkey.bind({"ctrl","shift"}, "v", function()
    if printCoroutine then
        stopTyping()
        hs.alert.show("Печать остановлена")
    else
        local txt = hs.pasteboard.getContents()
        if txt and #txt > 0 then startTyping(txt) end
    end
end)

hs.hotkey.bind({"ctrl","shift"}, "s", stopTyping)
