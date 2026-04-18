#!/bin/bash
# install.sh — Install the full ADS-B software stack on Raspberry Pi OS Bookworm
# Designed for RTL-SDR Blog V4
# Usage: chmod +x install.sh && ./install.sh
set -euo pipefail

echo "=== ADS-B Station Installer ==="
echo ""

# --- System update ---
echo "[1/7] Updating system..."
sudo apt update && sudo apt upgrade -y

# --- Install build dependencies ---
echo "[2/7] Installing build dependencies..."
sudo apt install -y build-essential libusb-1.0-0-dev cmake git python3-flask libncurses-dev libzstd-dev zlib1g-dev

# --- RTL-SDR Blog V4 custom drivers ---
echo "[3/7] Installing RTL-SDR Blog V4 drivers..."
if [ ! -d ~/rtl-sdr-blog ]; then
    cd ~
    git clone https://github.com/rtlsdrblog/rtl-sdr-blog.git
    cd rtl-sdr-blog
    mkdir -p build && cd build
    cmake ../ -DINSTALL_UDEV_RULES=ON
    make
    sudo make install
    sudo ldconfig
fi

# Remove old Debian rtlsdr library if present
sudo apt remove -y librtlsdr-dev librtlsdr0 2>/dev/null || true
sudo ldconfig

# --- Blacklist kernel DVB drivers ---
echo "[4/7] Blacklisting kernel DVB drivers..."
echo "blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
blacklist dvb_usb_v2
blacklist dvb_core" | sudo tee /etc/modprobe.d/blacklist-rtlsdr.conf
sudo depmod -a
sudo rmmod dvb_usb_rtl28xxu 2>/dev/null || true

# --- Build and install readsb ---
echo "[5/7] Building readsb..."
if [ ! -d ~/readsb-src ]; then
    cd ~
    git clone https://github.com/wiedehopf/readsb.git readsb-src
fi
cd ~/readsb-src
make clean 2>/dev/null || true
CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" make -j4 RTLSDR=yes
sudo systemctl stop readsb 2>/dev/null || true
sudo cp readsb /usr/bin/readsb
sudo cp viewadsb /usr/bin/viewadsb

# Ensure library linkage is correct
sudo cp /usr/local/lib/librtlsdr.so.0.6git /lib/arm-linux-gnueabihf/librtlsdr.so.0 2>/dev/null || true
sudo ldconfig

# Install readsb service if not already present
sudo bash -c "$(wget -qO - https://github.com/wiedehopf/adsb-scripts/raw/master/readsb-install.sh)" 2>/dev/null || true
# Re-copy our built binary over the installed one
sudo systemctl stop readsb 2>/dev/null || true
sudo cp ~/readsb-src/readsb /usr/bin/readsb
sudo cp ~/readsb-src/viewadsb /usr/bin/viewadsb

sudo systemctl enable readsb
sudo systemctl start readsb || true

# --- Install tar1090 ---
echo "[6/7] Installing tar1090..."
sudo bash -c "$(wget -qO - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"

# --- Install graphs1090 ---
echo "[7/7] Installing graphs1090..."
sudo bash -c "$(wget -qO - https://github.com/wiedehopf/graphs1090/raw/master/install.sh)"

echo ""
echo "=== Installation complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit /etc/default/readsb — set --lat and --lon in DECODER_OPTIONS"
echo "  2. sudo systemctl restart readsb"
echo "  3. Open http://$(hostname -I | awk '{print $1}')/tar1090"
echo "  4. Open http://$(hostname -I | awk '{print $1}')/graphs1090"
echo ""
echo "NOTE: A reboot is recommended to ensure kernel driver blacklist takes effect."
echo ""
