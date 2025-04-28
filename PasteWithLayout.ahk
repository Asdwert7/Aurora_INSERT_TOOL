#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

^+v:: ; Горячая клавиша Ctrl+Shift+V
    ; Получаем и очищаем текст из буфера
    clipboardText := Clipboard
    if (clipboardText = "") {
        MsgBox Буфер обмена пуст!
        return
    }

    ; Сохраняем текущую раскладку
    originalLayout := GetCurrentKeyboardLayout()
    
    ; Параметры задержек
    layoutSwitchDelay := 100  ; 100мс после смены раскладки
    charDelay := 100          ; 10мс между символами
    BlocksDelay = 20;
    ; Обработка каждого символа
    Loop, Parse, clipboardText
    {
        char := A_LoopField
        ascii := Asc(char)
        
        ; Обработка спецсимволов
        if (ascii = 13) {       ; Enter (CR)
            SendInput {Enter}
            continue
        }
        else if (ascii = 10) {  ; Newline (LF)
            continue            ; Игнорируем LF, т.к. уже обработали CR
        }
        else if (ascii = 9) {   ; Tab
            SendInput {Tab}
            continue
        }
        else if (ascii = 32) {  ; Space
            SendInput {Space}
            continue
        }
        else if (ascii < 32) { ; Другие управляющие символы
            continue
        }

        ; Определение раскладки для печати
        if (RegExMatch(char, "[А-Яа-яЁё]")) {
            SetKeyboardLayout("ru")
        } else {
            SetKeyboardLayout("en")
        }
        Sleep %layoutSwitchDelay%
        
        ; Печать символа
        SendInput {%char%}
        Sleep %charDelay%
    }

    ; Восстановление раскладки
    SetKeyboardLayout(originalLayout)
return

; Функции для работы с раскладкой
GetCurrentKeyboardLayout() {
    WinGet, activeHwnd, ID, A
    threadId := DllCall("GetWindowThreadProcessId", "UInt", activeHwnd, "UInt", 0)
    return DllCall("GetKeyboardLayout", "UInt", threadId, "UInt")
}

SetKeyboardLayout(layout) {
    if (layout = "ru") {
        PostMessage, 0x50, 0, 0x4190419,, A  ; Русская
    } else if (layout = "en") {
        PostMessage, 0x50, 0, 0x4090409,, A  ; Английская
    } else {
        PostMessage, 0x50, 0, %layout%,, A   ; Кастомный ID
    }
}