import time
import subprocess
import pyperclip

# === Глобальные параметры ===
block_size = 10000        # Печатать блоками по 10000 символов
layout_switch_delay = 0.1 # 100 мс после переключения раскладки
between_chars_delay = 0.001 # 1 мс между символами
between_blocks_delay = 0.2 # 200 мс между блоками

# === Вспомогательные функции ===

def is_russian_char(char):
    code = ord(char)
    return (0x0410 <= code <= 0x044F) or code in (0x0401, 0x0451)

def get_current_layout_linux():
    """Определить текущую раскладку на Linux через setxkbmap"""
    try:
        output = subprocess.check_output(['setxkbmap', '-query']).decode()
        for line in output.splitlines():
            if line.startswith('layout:'):
                layout = line.split(':')[1].strip()
                return layout
    except Exception as e:
        print(f"Ошибка определения раскладки: {e}")
    return "us"

def set_layout_linux(target_layout):
    """Установить раскладку на Linux"""
    current_layout = get_current_layout_linux()
    if current_layout != target_layout:
        subprocess.run(['setxkbmap', target_layout])
        time.sleep(layout_switch_delay)  # задержка только при реальном переключении

def type_text_xdotool(char):
    """Печать символа через xdotool"""
    subprocess.run(['xdotool', 'type', '--delay', '0', char])

# === Основная функция ===

def paste_with_layout_control():
    text = pyperclip.paste()
    if not text:
        print("Буфер обмена пуст.")
        return

    original_layout = get_current_layout_linux()

    for start in range(0, len(text), block_size):
        block = text[start:start + block_size]
        for char in block:
            if is_russian_char(char):
                set_layout_linux('ru')
            else:
                set_layout_linux('us')

            type_text_xdotool(char)
            time.sleep(between_chars_delay)

        time.sleep(between_blocks_delay)

    # Восстановить оригинальную раскладку
    set_layout_linux(original_layout)

# === Запуск ===

if __name__ == "__main__":
    print("Нажмите Enter для вставки текста с управлением раскладкой...")
    input()
    paste_with_layout_control()

