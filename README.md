## 🎁 Поддержать проект  
<p align="left">
  <a href="https://boosty.to/asdwert7?share=ios_blog_link" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Купи мне кофе))" height="40">
  </a>
</p>

<a href="https://t.me/Asdwert7" target="_blank">
  <img src="https://img.shields.io/badge/Telegram-💬_Личная_связь-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Contact">
</a>

# 🚀 Auto Typing Script (Paste With Layout)
Автоматический интеллектуальный набор текста с имитацией живого человека, эмоциями, опечатками и красивым прогресс-баром.  
Поддержка двух платформ: **Windows (AutoHotKey)** и **macOS (Hammerspoon)**.

---

## 📸 Демонстрация работы

![Demo GIF](./demo.gif)

---

## 🗿 Что нового(простыми словами)

- **«Человеческая» печать**  
  - Текст печатается не мгновенно, а с небольшими задержками, как будто вы сами нажимаете клавиши.  
  - Иногда программа специально «ошибается», потом быстро исправляет опечатки.

- **Автоматические паузы**  
  - Нажмите Ctrl + Shift + P, чтобы поставить печать на паузу или возобновить.  
  - Если вы переключитесь в другое окно, печать остановится до возвращения.

- **Прогресс-бар**  
  - Внизу экрана видно полоску, которая показывает, сколько текста уже напечатано и сколько осталось.  
  - Когда всё готово, появляется «🚀 Готово!».

- **Подсветка окна**  
  - Окно, в котором идёт печать, обводится рамкой, чтобы вы точно знали, где печатается.

- **Смена раскладки**  
  - Если в тексте появляются русские буквы, раскладка автоматически переключается на русскую (и обратно на английскую).

- **Настройки «под себя»**  
  - Можно менять скорость печати, шанс опечаток и другие параметры в отдельных файлах.  
  - Если файлы настроек не найдены, используется разумный набор параметров по умолчанию.

- **Забавные сообщения**  
  - Иногда во время печати всплывают маленькие подсказки и смешные комментарии, чтобы процесс стал живее.

- **Надёжная работа**  
  - Если что-то пойдёт не так, ошибки запишутся в лог, а вы получите предупреждение.


---


## ✨ Возможности

| Платформа        | Возможности                                                              |
|:-----------------|:-------------------------------------------------------------------------|
| **Windows (AutoHotKey)** | - Быстрая автоматическая вставка текста<br>- Сохранение отступов и переносов строк<br>- Удобные горячие клавиши |
| **macOS (Hammerspoon)**  | - Реалистичная имитация набора символ за символом<br>- Опечатки и автоматические исправления<br>- Эмоции над курсором<br>- Пасхалки и шутки во время печати<br>- Плавный прогресс-бар<br>- Переключение раскладки 🇷🇺 ↔ 🇺🇸<br>- Пауза/продолжение (`Ctrl+Shift+P`)<br>- Смена цвета прогресс-бара (`Ctrl+Shift+C`) <br>- Парсинг таблиц и автоматическое определение раскладки клавиатуры<br>- Подсветка активного окна<br>- Авто-пауза/возобновление при смене фокуса активного окна<br>- Логирование ошибок<br> |

---
## 😛Версии конфигов и их оссобенности

| Версия | Название                           | Основные особенности                                                                                                      |
|--------|------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| 1      | Full-Featured Auto-Typer<br>(Пока только на бусти)           | • Загрузка внешних конфигов (`keyboard_layouts.lua`, `typing_settings.lua`)<br>• Опечатки + исправления<br>• Эмоции, Easter Eggs и Funny Comments<br>• Динамический прогресс-бар с анимацией и цветами<br>• Подсветка активного окна<br>• Авто-пауза/возобновление при смене фокуса<br>• Логирование ошибок<br>• Расширенные горячие клавиши (цвет, раскладка, пауза, стоп) |
| 2      | Enhanced Progress Bar Typer<br>(public-beta)        | • Упрощённая настройка задержек<br>• Статичный прогресс-бар без анимации<br>• Плавное отображение оставшегося времени<br>• Базовые функции печати без опечаток и эмоций                                  |
| 3      | Block-Based Auto-Layout Typer<br>(public-beta)      | • Построчная разбивка на блоки фиксированного размера<br>• Настройки вынесены в `CONFIG`<br>• Чёткие параметры задержек и раскладок<br>• Нет прогресс-бара, нет обратной связи пользователю             |
| 4      | Basic Block Paste<br>(Легкая версия)                  | • Минимальный функционал: переключение раскладки и печать блоками<br>• Жёстко заданные параметры в коде<br>• Без прогресс-бара и без настроек                       |


---

## ⚙️ Установка и использование

### 🖥️ Windows (AutoHotKey)

1. 📥 Установите [AutoHotKey](https://www.autohotkey.com/).
2. 📂 Откройте файл `PasteWithLayout.ahk`.
3. ⌨️ Нажмите `Ctrl + Shift + V` — начнется автоматическая вставка текста.

> В AutoHotKey реализована **чистая и быстрая вставка текста** с сохранением отступов и переносов.  
> Идеально подходит для простых задач копирования больших текстов без потери структуры.

---

### 🍎 macOS (Hammerspoon)

1. 📥 Установите [Hammerspoon](https://www.hammerspoon.org/).
2. 🛠️ Откройте конфигурацию (`Open Config`).
3. 📋 Вставьте содержимое файла `init.lua`.
4. 🔄 Перезагрузите конфигурацию (`Reload Config`).
5. 🛡️ Дайте доступ в `System Settings → Privacy → Accessibility`.
6. ⌨️ Нажмите `Ctrl + Shift + V` для запуска автоматической печати текста.

> В Hammerspoon реализован **реалистичный живой набор текста**, где печатается каждый символ отдельно,  
> с задержками, опечатками, эмоциями и эффектами — как будто набирает настоящий человек!

---

## 🎛️ Горячие клавиши (macOS)

| Клавиши                | Действие                           |
|:------------------------|:-----------------------------------|
| `Ctrl + Shift + V`       | Начать / Остановить автоматическую печать |
| `Ctrl + Shift + S`       | Экстренная остановка               |
| `Ctrl + Shift + P`       | Пауза / Продолжение печати         |
| `Ctrl + Shift + C`       | Сменить цвет прогресс-бара         |
| `Ctrl + Shift + T`       | Показать раскладку клавиатуры      |

---

## 🪟 Горячие клавиши (Windows)

| Комбинация клавиш | Действие |
|-------------------|----------|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> | Старт автоматической печати |
| <kbd>ESC</kbd> | Экстренная остановка |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>↓</kbd> | Стандартная скорость |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>→</kbd> | Увеличить скорость |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>←</kbd> | Уменьшить скорость |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> | Пауза/продолжить |

---

## 🎯 Основные особенности новой версии (macOS)

- Набор текста максимально похожий на человека
- Случайные задержки между символами
- Автоматические опечатки с последующим исправлением
- Прогресс-бар с динамическим изменением ширины и времени оставшейся печати
- Эмоции (`🤔`, `😐`, `😴`, `🤯`) появляются прямо **над курсором**
- Пасхалки (`// 🛸 Тут были инопланетяне`) всплывают во время набора
- Возможность смены цвета прогресс-бара одним нажатием
---
## 📜 История изменений  
Последние обновления включают:  
- Умные ошибки с настройкой под ваш стиль печати.  
- Полную защиту от античитов (рандомизация, паузы, логи).  
- Подробнее см. [CHANGELOG.md](CHANGELOG.md).
---

## ❓ Часто задаваемые вопросы

**Q:** Почему на macOS не работает вставка?  
**A:** Убедитесь:
- Что Hammerspoon имеет доступ к управлению системой (`System Settings → Privacy & Security → Accessibility`)
- Конфигурация Hammerspoon перезагружена после вставки кода
- Горячие клавиши активны (`Ctrl + Shift + V`)

**Q:** Можно ли использовать другие раскладки кроме EN/RU?  
**A:** Могут возникнуть ошибки при использовании программы, лучше заранее отредактировать раскладку под себя.

**Q:** Можно ли добавить свои эмоции или пасхалки?  
**A:** Конечно! Просто отредактируйте массивы `EMOTIONS` и `EASTER_EGGS` в `init.lua`.

---

## 📜 Лицензия

Этот проект использует **модифицированную лицензию MIT** со следующими условиями:

### 🟢 Что разрешено:
- Свободное использование для **личных, образовательных и некоммерческих целей**
- Возможность **модификации** кода под свои нужды
- **Распространение** кода с сохранением оригинальной лицензии
- Использование в **открытых проектах** (с обязательным указанием авторства)

### 🔴 Что запрещено:
- **Коммерческое использование** без письменного разрешения автора
- Удаление или сокрытие информации об авторстве
- Перелицензирование под более строгими лицензиями (GPL, AGPL и т.д.)

### ℹ️ Ваши обязательства:
- Должны сохраняться:
  - Оригинальный файл `LICENSE`
  - Уведомление об авторских правах
  - Ссылка на исходный репозиторий

```text
## 🌟 Благодарности

Спасибо за использование скрипта!  
Печатайте живо, печатайте весело! 🚀

Если проект вам понравился, ⭐️ поставьте звезду на GitHub!
---
Copyright (c) 2024 [Asdwert7]
Подробности в файле [LICENSE]
