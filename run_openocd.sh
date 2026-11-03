#!/usr/bin/env bash
#
# Launch OpenOCD for ESP32-S3 JTAG debugging via the chip's built-in USB-JTAG
# bridge (native USB, GPIO19/20) — no external JTAG adapter needed.
#
# If using an external JTAG adapter (ESP-Prog / FT2232-based) instead,
# replace the -f line with:
#   -f interface/ftdi/esp_ftdi.cfg -f target/esp32s3.cfg
#
# Usage: ./run_openocd.sh

OPENOCD="$HOME/.espressif/tools/openocd-esp32/v0.12.0-esp32-20260304/openocd-esp32/bin/openocd"
SCRIPTS="$(dirname "$OPENOCD")/../share/openocd/scripts"

echo "✅ OpenOCD launched (GDB server on :3333, telnet on :4444)"
# ESP_RTOS none: OpenOCD's default FreeRTOS-aware backend creates a GDB
# thread per task on attach. GDB's own DAP layer (gdb/dap/events.py
# _new_thread) unconditionally flips its internal "running" flag on any
# new thread, which races with the real stop state and makes stackTrace
# requests fail with "notStopped". Disabling RTOS task enumeration avoids
# triggering that race; the halted core still debugs fine, you just lose
# per-task inspection.
# NOTE: do NOT set ESP_ONLYCPU 1 here. This is a genuine dual-core app
# ("Multicore app" per the boot log) — cpu0's early startup calls
# start_other_core() and blocks waiting for cpu1 to come up. Restricting
# OpenOCD to cpu0 only leaves cpu1 parked in debug-halt/reset at the
# hardware level, since OpenOCD never examines/releases it, so that
# handshake never completes and boot hangs forever inside
# start_other_core() (cpu_start.c). Both cores must stay under OpenOCD's
# SMP target for the app to boot at all.
"$OPENOCD" -s "$SCRIPTS" \
    -c "set ESP_RTOS none" \
    -f board/esp32s3-builtin.cfg
echo "✅ OpenOCD closed"
