# ESP32 C Template

A minimal **ESP-IDF v6** project template in C for the **ESP32-S3**, with
one-command build/flash scripts, OpenOCD debugging over the chip's built-in
USB-JTAG, and a VS Code dev container. Clone it, rename it, start writing
firmware.

The example app is a FreeRTOS task blinking two LEDs (GPIO 4 and 5) through a
small GPIO helper module.

## Features

- **ESP-IDF v6.0.1**, CMake project layout, target `esp32s3` (4 MB flash)
- **No external adapter needed** — flashing, console and JTAG all go through
  the ESP32-S3's native USB (`/dev/ttyACM0`)
- **Scripts** for every step: install toolchain, build + flash, serial console, OpenOCD
- **Dev container** (`espressif/idf:v6.0.1`) with the ESP-IDF and C/C++ VS Code extensions
- FreeRTOS task + GPIO driver example (`main/espGPIO.c`)

## Quick start

```bash
git clone https://github.com/vim4all/ESP32_C_Template.git my_project
cd my_project

./install_esp_idf.sh      # one-time: installs ESP-IDF v6.0.1 into ~/esp/esp-idf (Debian/Ubuntu)
./run_rebuild.sh          # build and flash
./run_terminal.sh         # serial console (exit: Ctrl-A Ctrl-X)
```

Or open the folder in VS Code and choose **Reopen in Container** — the toolchain
is already inside the image.

## Scripts

| Script | What it does |
|---|---|
| `install_esp_idf.sh` | Installs apt prerequisites and ESP-IDF v6.0.1 to `~/esp/esp-idf`, adds it to `~/.bashrc` |
| `run_rebuild.sh [port]` | `idf.py build`, then flashes if the build succeeds |
| `run_flash.sh [port]` | Flashes the existing build |
| `run_terminal.sh [port]` | Opens the serial console with `picocom` at 115200 baud |
| `run_openocd.sh` | Starts OpenOCD for the ESP32-S3 USB-JTAG (GDB on `:3333`, telnet on `:4444`) |

The default port is `/dev/ttyACM0` (built-in USB Serial/JTAG). For an external
UART bridge, pass the port explicitly, e.g. `./run_flash.sh /dev/ttyUSB0`.

## Debugging

```bash
./run_openocd.sh
# in another terminal:
xtensa-esp32s3-elf-gdb build/ESP32_C_Template.elf -ex "target remote :3333"
```

`run_openocd.sh` documents two non-obvious settings: FreeRTOS thread awareness
is disabled to avoid a GDB DAP race, and both cores stay under OpenOCD so the
dual-core app can boot.

## Project layout

```
├── CMakeLists.txt          # project definition
├── sdkconfig.defaults      # target and config defaults
├── main/
│   ├── main.c              # app_main, blink task
│   ├── espGPIO.c/.h        # LED/GPIO helpers
│   └── CMakeLists.txt      # component registration
└── .devcontainer/          # VS Code dev container
```

To start a new project, change `project(ESP32_C_Template)` in `CMakeLists.txt`
and the `BIN` name in `run_flash.sh`.

## License

[MIT](LICENSE)
