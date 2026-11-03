#!/usr/bin/env bash
set -euo pipefail

IDF_VERSION="v6.0.1"
IDF_DIR="$HOME/esp/esp-idf"
BASHRC="$HOME/.bashrc"

# ── colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()     { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ── root check ───────────────────────────────────────────────────────────────
[ "$(id -u)" -eq 0 ] && err "Do not run as root. Run as your normal user."

# ── 1. apt prerequisites ─────────────────────────────────────────────────────
info "Installing apt prerequisites..."
sudo apt-get update -qq
sudo apt-get install -y \
    git wget flex bison gperf \
    python3 python3-pip python3-venv python3-setuptools \
    cmake ninja-build ccache \
    libffi-dev libssl-dev dfu-util libusb-1.0-0

# ── 2. clone / update ESP-IDF ────────────────────────────────────────────────
mkdir -p "$HOME/esp"

if [ -d "$IDF_DIR/.git" ]; then
    warn "ESP-IDF already cloned at $IDF_DIR — fetching $IDF_VERSION..."
    git -C "$IDF_DIR" fetch --tags -q
    git -C "$IDF_DIR" checkout "$IDF_VERSION"
    git -C "$IDF_DIR" submodule update --init --recursive
else
    info "Cloning ESP-IDF $IDF_VERSION into $IDF_DIR..."
    git clone --branch "$IDF_VERSION" --recursive \
        https://github.com/espressif/esp-idf.git "$IDF_DIR"
fi

# ── 3. run Espressif installer ───────────────────────────────────────────────
info "Running ESP-IDF installer for esp32 target..."
"$IDF_DIR/install.sh" esp32

# ── 4. add export.sh to .bashrc (idempotent) ─────────────────────────────────
EXPORT_LINE=". \$HOME/esp/esp-idf/export.sh"
if grep -qF "esp-idf/export.sh" "$BASHRC" 2>/dev/null; then
    warn "export.sh already present in $BASHRC — skipping."
else
    info "Adding ESP-IDF export to $BASHRC..."
    {
        echo ""
        echo "# ESP-IDF"
        echo "$EXPORT_LINE"
    } >> "$BASHRC"
fi

# ── 5. serial port group ─────────────────────────────────────────────────────
if groups "$USER" | grep -qw dialout; then
    warn "User $USER already in dialout group."
else
    info "Adding $USER to dialout group (re-login required to take effect)..."
    sudo usermod -aG dialout "$USER"
fi

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
info "Installation complete."
echo ""
echo "  To activate ESP-IDF in this terminal, run:"
echo "      unset IDF_PYTHON_ENV_PATH"
echo "      source ~/esp/esp-idf/export.sh"
echo ""
echo "  (The 'unset' is needed if you had a previous IDF version active"
echo "   in this shell — it clears the stale Python env path.)"
echo ""
echo "  Future terminals will load it automatically via .bashrc."
echo ""
echo "  To build this project:"
echo "      cd $(pwd)"
echo "      idf.py build"
echo ""
echo "  To flash:"
echo "      idf.py -p /dev/ttyUSB0 flash monitor"
echo ""
warn "If you were just added to 'dialout', log out and back in before flashing."
