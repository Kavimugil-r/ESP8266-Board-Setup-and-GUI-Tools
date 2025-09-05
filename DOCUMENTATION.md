# NodeMCU ESP8266 V3 Setup Guide (Windows) — MicroPython

This guide is a beginner-friendly walkthrough to set up the NodeMCU ESP8266 V3 (CH340) board with MicroPython on a **Windows system**.

---

## 🔧 Requirements

### 🛠️ Hardware

- NodeMCU ESP8266 V3 (Lua CH340 WiFi Dev Board)
- Micro USB Cable (data-capable)

### 💻 Software

| Tool                | Use                             | Install With                                                  |
| ------------------- | ------------------------------- | ------------------------------------------------------------- |
| Python (3.8+)       | Required for scripting/flashing | [Download Python](https://www.python.org/downloads/)          |
| CH340 Driver        | USB-to-Serial driver for board  | [Download CH340 Driver](https://sparks.gogo.co.nz/ch340.html) |
| `esptool.py`        | Flash firmware to ESP8266       | `pip install esptool`                                         |
| `ampy` / `mpremote` | Upload Python files to board    | `pip install adafruit-ampy mpremote`                          |

---

## 🧠 Button Reference

### 🔁 Reset Button (RST)

**Purpose:** Restart the board (like rebooting a PC)

**When to use:**

- Your code crashes or freezes
- Reload firmware
- Serial monitor stops responding

**How to use:** Press `RST` to reboot. It re-runs `main.py` on boot.

---

### 📥 Flash Button (FLASH)

**Purpose:** Enter Flash (bootloader) Mode

**When to use:**

- Installing new firmware
- Uploading via `esptool`
- Recovering bricked boards

**How to enter flash mode:**

1. Hold `FLASH`
2. Press `RST` once (while holding `FLASH`)
3. Release `FLASH` after 1–2 seconds

---

## 🚀 Step-by-Step: Flash MicroPython

### 🔽 Step 1: Download Firmware

➡️ [Download MicroPython for ESP8266](https://micropython.org/download/esp8266/)

---

### 🔌 Step 2: Connect Your Board

- Plug in NodeMCU using USB
- Ensure CH340 driver is installed
- Check COM port: Open **Device Manager → Ports (COMx)**

---

### 🧹 Step 3: Erase Existing Firmware

```bash
esptool --port COM4 erase-flash
```

> Replace `COM4` with your port

---

### 📦 Step 4: Flash MicroPython

```bash
esptool --chip esp8266 --port COM4 --baud 115200 
  write-flash --flash-mode dio --flash-size detect 0x0 
  ESP8266_GENERIC-20250415-v1.25.0.bin
```

> ⚠️ **Use **``. Default `qio` causes bootloop with CH340 boards. ⚠️ Replace `.bin` with actual path to downloaded MicroPython firmware.

---

### ✅ Step 5: Test the Flash

```bash
python -m serial.tools.miniterm COM4 115200
```

> You should see `>>>` MicroPython REPL prompt.

---

## 📤 Upload Python Code (e.g., `main.py`)

### Option 1: Using ampy

```bash
ampy --port COM4 put main.py
```

### Option 2: Using mpremote

```bash
mpremote connect COM4 fs cp main.py :
```

---

## 🧾 Firmware Types Explained

| Firmware Type          | Description                        | Example File                   |
| ---------------------- | ---------------------------------- | ------------------------------ |
| AT Command Firmware    | Send AT commands via serial        | Factory default                |
| MicroPython Firmware   | Run Python scripts                 | `esp8266-20220618-v1.19.1.bin` |
| Arduino (C++) Firmware | Run compiled C/C++ via Arduino IDE | Arduino-generated `.bin`       |
| NodeMCU (Lua) Firmware | Run Lua scripts                    | `nodemcu-flash.bin`            |

---

## 🧠 Concepts: Firmware vs Code

- **Firmware** = OS of the ESP8266
- **Flashing** = Installing the OS
- **main.py** = Your App (auto runs on boot)

> Without MicroPython firmware, ESP can't run `.py` scripts.

---

## 🔌 UART and CH340

- **CH340** = USB ↔ Serial converter
- **UART** = Communication protocol (TX/RX)

Used for:

- Flashing firmware
- Serial monitoring
- Uploading code

---

## 🔁 Baud Rates

| Use                   | Recommended Baud Rates         |
| --------------------- | ------------------------------ |
| Flashing (esptool.py) | 115200 (default), up to 460800 |
| MicroPython Shell     | 115200 (most reliable)         |

---

## ⚠️ Troubleshooting

| Issue              | Fix                                     |
| ------------------ | --------------------------------------- |
| Bootloop           | Use `--flash-mode dio` instead of `qio` |
| Write error        | Try lower baud rate (115200)            |
| Board not detected | Check CH340 driver, USB cable, and port |
| Upload fails       | Confirm MicroPython flashed correctly   |

---

## 📌 Quick Command Reference

```bash
# Install esptool
pip install esptool

# Erase board
esptool --port COM4 erase-flash

# Flash MicroPython
esptool --chip esp8266 --port COM4 --baud 115200 
  write-flash --flash-mode dio --flash-size detect 0x0 firmware.bin

# Open MicroPython shell
python -m serial.tools.miniterm COM4 115200

# Upload Python file
ampy --port COM4 put main.py
```

---

> 📌 **Tip**: Always test your `main.py` with `print()` statements to verify it runs properly after reset.

---



