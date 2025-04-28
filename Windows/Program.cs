using System;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using WindowsInput;
using WindowsInput.Native;
using System.Windows.Forms;

class Program
{
    // === Глобальные параметры ===
    const int blockSize = 10000;
    const int layoutSwitchDelay = 100; // в миллисекундах
    const int betweenCharsDelay = 1;   // в миллисекундах
    const int betweenBlocksDelay = 200; // в миллисекундах

    static InputSimulator sim = new InputSimulator();

    [DllImport("user32.dll")]
    static extern IntPtr GetKeyboardLayout(uint idThread);

    static void Main(string[] args)
    {
        Console.WriteLine("Нажмите Enter для вставки текста с управлением раскладкой...");
        Console.ReadLine();

        string text = Clipboard.GetText();
        if (string.IsNullOrEmpty(text))
        {
            Console.WriteLine("Буфер обмена пуст.");
            return;
        }

        var originalLayout = GetCurrentLanguage();

        for (int start = 0; start < text.Length; start += blockSize)
        {
            string block = text.Substring(start, Math.Min(blockSize, text.Length - start));

            foreach (char c in block)
            {
                if (IsRussianChar(c))
                    SetLanguage(0x419); // Русский
                else
                    SetLanguage(0x409); // Английский (США)

                sim.Keyboard.TextEntry(c);
                Thread.Sleep(betweenCharsDelay);
            }

            Thread.Sleep(betweenBlocksDelay);
        }

        SetLanguage(originalLayout);
    }

    static ushort GetCurrentLanguage()
    {
        return (ushort)((long)GetKeyboardLayout(0) & 0xFFFF);
    }

    static void SetLanguage(ushort langId)
    {
        ushort current = GetCurrentLanguage();
        if (current != langId)
        {
            // Отправка Alt+Shift для переключения
            sim.Keyboard.ModifiedKeyStroke(VirtualKeyCode.MENU, VirtualKeyCode.SHIFT);
            Thread.Sleep(layoutSwitchDelay);
        }
    }

    static bool IsRussianChar(char c)
    {
        int code = c;
        return (code >= 0x0410 && code <= 0x044F) || code == 0x0401 || code == 0x0451;
    }
}

