import Foundation
import AppKit
import Carbon

// === Глобальные параметры ===
let blockSize = 10000              // Печатать блоками по 10000 символов
let layoutSwitchDelay = 0.1         // 100 мс после переключения раскладки
let betweenCharsDelay = 0.001       // 1 мс между символами
let betweenBlocksDelay = 0.2        // 200 мс между блоками

// === Вспомогательные функции ===

func isRussianChar(_ char: Character) -> Bool {
    guard let code = char.unicodeScalars.first?.value else { return false }
    return (0x0410...0x044F).contains(code) || code == 0x0401 || code == 0x0451
}

func getCurrentKeyboardLayout() -> String {
    guard let inputSource = TISCopyCurrentKeyboardInputSource()?.takeUnretainedValue(),
          let sourceID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else {
        return "com.apple.keylayout.US"
    }
    return sourceID as! String
}

func setKeyboardLayout(_ layoutID: String) {
    guard let list = TISCreateInputSourceList(nil, false).takeRetainedValue() as? [TISInputSource] else { return }
    for source in list {
        if let id = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) as? String, id == layoutID {
            TISSelectInputSource(source)
            usleep(useconds_t(layoutSwitchDelay * 1_000_000)) // sleep после смены раскладки
            break
        }
    }
}

func typeCharacter(_ char: Character) {
    let source = CGEventSource(stateID: .hidSystemState)

    for scalar in String(char).unicodeScalars {
        if let keyCode = keyCodeMap[Int(scalar.value)] {
            let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
            let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        } else {
            let textEvent = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)
            let charString = String(char)
            let utf16Chars = Array(charString.utf16)
            textEvent?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            textEvent?.post(tap: .cghidEventTap)
        }
    }
}


// Минимальная мапа кодов клавиш для базовых символов
let keyCodeMap: [Int: CGKeyCode] = [
    0x20: 49, // Пробел
    0x30: 29, // 0
    0x31: 18, // 1
    0x32: 19, // 2
    0x33: 20, // 3
    0x34: 21, // 4
    0x35: 23, // 5
    0x36: 22, // 6
    0x37: 26, // 7
    0x38: 28, // 8
    0x39: 25, // 9
    0x41: 0,  // A
    0x42: 11, // B
    0x43: 8,  // C
    0x44: 2,  // D
    0x45: 14, // E
    0x46: 3,  // F
    0x47: 5,  // G
    0x48: 4,  // H
    0x49: 34, // I
    0x4A: 38, // J
    0x4B: 40, // K
    0x4C: 37, // L
    0x4D: 46, // M
    0x4E: 45, // N
    0x4F: 31, // O
    0x50: 35, // P
    0x51: 12, // Q
    0x52: 15, // R
    0x53: 1,  // S
    0x54: 17, // T
    0x55: 32, // U
    0x56: 9,  // V
    0x57: 13, // W
    0x58: 7,  // X
    0x59: 16, // Y
    0x5A: 6   // Z
]

// === Основная функция ===

func pasteWithLayoutControl() {
    guard let clipboard = NSPasteboard.general.string(forType: .string) else {
        print("Буфер обмена пуст.")
        return
    }

    let originalLayout = getCurrentKeyboardLayout()

    for start in stride(from: 0, to: clipboard.count, by: blockSize) {
        let startIdx = clipboard.index(clipboard.startIndex, offsetBy: start)
        let endIdx = clipboard.index(startIdx, offsetBy: min(blockSize, clipboard.count - start), limitedBy: clipboard.endIndex) ?? clipboard.endIndex
        let block = String(clipboard[startIdx..<endIdx])

        for char in block {
            if isRussianChar(char) {
                setKeyboardLayout("com.apple.keylayout.RussianWin")
            } else {
                setKeyboardLayout("com.apple.keylayout.US")
            }

            typeCharacter(char)
            usleep(useconds_t(betweenCharsDelay * 1000000))
        }

        usleep(useconds_t(betweenBlocksDelay * 1000000))
    }

    // Восстановление начальной раскладки
    setKeyboardLayout(originalLayout)
}

// === Точка входа ===

print("Нажмите Enter для вставки текста с управлением раскладкой...")
_ = readLine()
pasteWithLayoutControl()
