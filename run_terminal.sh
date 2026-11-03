#!/usr/bin/env bash
#
# Open an interactive terminal to the ESP32-S3 console over USB.
# Usage: ./run_terminal.sh [port]
# Default port: /dev/ttyACM0 (built-in USB Serial/JTAG — no external adapter needed)
# For the external UART bridge instead, pass /dev/ttyUSB0 explicitly.
#
# Exit picocom with Ctrl-A Ctrl-X.

set -euo pipefail

PORT="${1:-/dev/ttyACM0}"
BAUD=115200

if [[ ! -e "$PORT" ]]; then
    echo "Error: $PORT not found — is the board plugged in?"
    exit 1
fi

echo "==> Connecting to $PORT at ${BAUD} baud (Ctrl-A Ctrl-X to exit)..."
picocom -b "$BAUD" "$PORT"
