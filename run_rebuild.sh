#!/usr/bin/env bash
#
# Rebuild the project and flash the ESP32.
# Usage: ./run_rebuild.sh [port]
# Default port: /dev/ttyACM0 (built-in USB Serial/JTAG — no external adapter needed)
# For the external UART bridge instead, pass /dev/ttyUSB0 explicitly.

set -euo pipefail

unset IDF_PYTHON_ENV_PATH
source "${IDF_PATH:-$HOME/esp/esp-idf}/export.sh" 2>/dev/null

echo "==> Building..."

if ! idf.py build; then
    echo ""
    echo "❌ Build FAILED. Skipping flash."
    exit 1
fi

echo "✅ Build successful."
echo ""

./run_flash.sh "${1:-/dev/ttyACM0}"
