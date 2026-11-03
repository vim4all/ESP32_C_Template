#!/usr/bin/env bash
#
# Flash ESP32 over USB/UART using esptool via idf.py.
# Usage: ./run_flash.sh [port]
# Default port: /dev/ttyACM0 (built-in USB Serial/JTAG — no external adapter needed)
# For the external UART bridge instead, pass /dev/ttyUSB0 explicitly.

set -euo pipefail

PORT="${1:-/dev/ttyACM0}"
BIN="build/ESP32_C_Template.bin"

if [[ ! -f "$BIN" ]]; then
    echo "Error: $BIN not found — run ./run_rebuild.sh first"
    exit 1
fi

unset IDF_PYTHON_ENV_PATH
source "${IDF_PATH:-$HOME/esp/esp-idf}/export.sh" 2>/dev/null

echo "==> Flashing to $PORT..."
idf.py -p "$PORT" flash

echo ""
echo "✅ Flash complete."
