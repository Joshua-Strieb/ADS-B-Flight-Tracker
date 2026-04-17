# Software Setup

## OS Selection

Use Raspberry Pi OS Lite (64-bit) Bookworm (Debian 12). The latest Raspberry Pi Imager may default to Trixie (Debian 13) which is incompatible with the current ADS-B software repositories.

In Raspberry Pi Imager:
- Choose OS > Raspberry Pi OS (other) > Raspberry Pi OS (Legacy) Lite (64-bit)
- Verify after boot: `cat /etc/os-release | grep VERSION` should show `12 (bookworm)`

## Initial Setup

Configure in Raspberry Pi Imager before writing:
- Hostname: `adsb`
- Username: `pi`, password: your choice
- WiFi: your SSID, password, country IE
- Enable SSH with password authentication

After first boot, SSH (Secure Shell Protocol) in:

```bash
ssh pi@adsb.local
sudo apt update && sudo apt upgrade -y
sudo raspi-config nonint do_change_timezone "Europe/Dublin"
```

## Install RTL-SDR Blog V4 Custom Drivers

The standard Debian `librtlsdr` package does not properly support the V4's R828D tuner. Install the Blog drivers:

```bash
sudo apt install -y libusb-1.0-0-dev cmake git
cd ~
git clone https://github.com/rtlsdrblog/rtl-sdr-blog.git
cd rtl-sdr-blog
mkdir build && cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
```

Remove the old library so nothing links against it:

```bash
sudo apt remove -y librtlsdr-dev librtlsdr0
sudo ldconfig
```

## Blacklist Kernel DVB Drivers

Without this, the Linux kernel claims the USB device and SDR software cannot access it:

```bash
echo "blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
blacklist dvb_usb_v2
blacklist dvb_core" | sudo tee /etc/modprobe.d/blacklist-rtlsdr.conf
sudo depmod -a
sudo reboot
```

After reboot, verify: `lsmod | grep dvb` should return nothing.

## Install readsb

readsb is used instead of dump1090-fa because:
- FlightAware's apt repository (`repo.feed.flightaware.com`) is currently offline
- dump1090-fa built from source has driver compatibility issues with the V4
- readsb has native V4 support and is actively maintained

```bash
cd ~
git clone https://github.com/wiedehopf/readsb.git readsb-src
cd readsb-src
CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" make -j4 RTLSDR=yes
sudo cp readsb /usr/bin/readsb
sudo cp viewadsb /usr/bin/viewadsb
```

If readsb is already installed via the install script, rebuild it anyway to link against the V4 library:

```bash
sudo systemctl stop readsb
sudo cp readsb /usr/bin/readsb
sudo cp viewadsb /usr/bin/viewadsb
sudo systemctl start readsb
```

### Verify the library linkage

```bash
ldd /usr/bin/readsb | grep rtlsdr
```

Should show `/usr/local/lib/librtlsdr.so`. If it shows `/lib/arm-linux-gnueabihf/`, copy the V4 library over:

```bash
sudo cp /usr/local/lib/librtlsdr.so.0.6git /lib/arm-linux-gnueabihf/librtlsdr.so.0
sudo ldconfig
sudo systemctl restart readsb
```

### Configure readsb

```bash
sudo nano /etc/default/readsb
```

Set your coordinates in DECODER_OPTIONS (note the space before negative longitude):

```
DECODER_OPTIONS="--max-range 450 --write-json-every 1 --lat XX.XXXX --lon -XX.XXXX"
```

> IMPORTANT: A negative longitude like `-6.9072` must have a space before it: `--lon -XX.XXXX` not `--lon-XX.XXXX`. Without the space, the parser interprets it as an unknown flag and readsb won't start.

```bash
sudo systemctl enable readsb
sudo systemctl restart readsb
```

### Verify

```bash
cat /run/readsb/aircraft.json | python3 -c "import json,sys; d=json.load(sys.stdin); print('Messages:', d['messages'], 'Aircraft:', len(d['aircraft']))"
```

Messages should be climbing. Use `viewadsb` for a live terminal display.

## Install tar1090

```bash
sudo bash -c "$(wget -qO - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"
```

Available at `http://adsb.local/tar1090`.

### Set your location in tar1090

```bash
sudo nano /usr/local/share/tar1090/html/config.js
```

Uncomment and set:

```javascript
SiteLat = XX.XXXX;
SiteLon = -XX.XXXX;
DefaultCenterLat = XX.XXXX;
DefaultCenterLon = -XX.XXXX;
```

Also set in the tar1090 defaults:

```bash
sudo nano /etc/default/tar1090
```

```
DEFAULTLAT=XX.XXXX
DEFAULTLON=-XX.XXXX
```

```bash
sudo systemctl restart tar1090
```

## Install graphs1090

```bash
sudo bash -c "$(wget -qO - https://github.com/wiedehopf/graphs1090/raw/master/install.sh)"
```

Available at `http://adsb.local/graphs1090`.

## Display Setup (7-inch DSI Touchscreen)

The official Pi touchscreen connects via DSI ribbon cable. Power via GPIO pins 4 (5V) and 6 (GND).

Install desktop environment:

```bash
sudo apt install -y raspberrypi-ui-mods chromium-browser xdotool unclutter matchbox-keyboard
sudo raspi-config nonint do_boot_behaviour B4
sudo reboot
```

### Kiosk Mode

Copy `software/scripts/kiosk.sh` to `~/kiosk.sh` and set up autostart:

```bash
chmod +x ~/kiosk.sh
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/kiosk.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=ADS-B Kiosk
Exec=/home/pi/kiosk.sh
X-GNOME-Autostart-enabled=true
EOF
sudo reboot
```

### VNC Access

To control the Pi's desktop from your PC:

```bash
sudo raspi-config nonint do_vnc 0
```

Connect with RealVNC Viewer to `adsb.local`.

## Quick Reference

| URL | Site |
|-----|------|
| `http://adsb.local/tar1090` | Aircraft map |
| `http://adsb.local/graphs1090` | Performance graphs |

## Troubleshooting

readsb won't start: Check `journalctl -u readsb -n 20`. Common causes: negative longitude without space, kernel driver not blacklisted, wrong library linked.

SDR not detected: Run `lsusb | grep Realtek`. If missing, replug USB. If present but software can't access it, run `sudo rmmod dvb_usb_rtl28xxu` and check blacklist.

0 messages: Confirm library with `ldd /usr/bin/readsb | grep rtlsdr`. Test SDR independently with `rtl_adsb -V` (stop readsb first). If rtl_adsb shows messages but readsb doesn't, rebuild readsb against V4 library.

tar1090 shows 404:  Reinstall: `sudo bash -c "$(wget -qO - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"`

Map centered on wrong location: Edit both `/etc/default/tar1090` AND `/usr/local/share/tar1090/html/config.js`. Clear Chromium cache: `rm -rf ~/.cache/chromium ~/.config/chromium`

Display asks for password: Set autologin: `sudo raspi-config nonint do_boot_behaviour B4`

