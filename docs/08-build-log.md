# Build Log — Issues Encountered

This documents every significant problem hit during the build and how it was resolved.

## 1. Wrong Antenna Element Length (168 mm vs 113 mm)

**Problem:** Initial element length was calculated as 168 mm using the formula `λ/2 = c / (2 × f × VF)`. This formula is inverted — the velocity factor should be in the numerator, not the denominator.

**Correct formula:** `λ/2 = (c × VF) / (2 × f) = 113 mm`

**How it was found:** A NanoVNA shorted-stub test on a 1 m cable section confirmed VF = 0.817, which gives 113 mm. The 168 mm elements produced an antenna that resonated far from 1090 MHz.

**Lesson:** Always verify calculated values experimentally. The incorrect formula appears in multiple online CoCo guides and is widely copied.

## 2. Trixie vs Bookworm OS

**Problem:** The latest Raspberry Pi Imager defaults to Trixie (Debian 13). FlightAware's repository and most ADS-B packages only support Bookworm (Debian 12).

**Fix:** Reflashed with "Raspberry Pi OS (Legacy) Lite (64-bit)" which is Bookworm.

**Lesson:** Always verify OS version with `cat /etc/os-release` before installing ADS-B software.

## 3. FlightAware Repository Offline

**Problem:** `repo.feed.flightaware.com` returned no DNS A record. dump1090-fa could not be installed from the official package repository.

**Fix:** Built dump1090-fa from source, then later switched to readsb which has better V4 support.

**Lesson:** Have a fallback plan for packages hosted by third-party repositories.

## 4. RTL-SDR Blog V4 Driver Incompatibility

**Problem:** The standard Debian `librtlsdr` package does not properly support the V4's R828D tuner. Symptoms: `[R82XX] PLL not locked!` messages, near-zero ADS-B message decoding in dump1090-fa/readsb, but `rtl_adsb` from the Blog drivers decoded messages fine.

**Root cause:** The V4 uses an R828D tuner (not R820T2). The Debian library initializes it incorrectly.

**Fix:** Installed RTL-SDR Blog's custom drivers from source, removed the Debian package, and rebuilt readsb against the new library.

**Critical detail:** Even after installing the Blog library to `/usr/local/lib/`, readsb continued linking against the old library at `/lib/arm-linux-gnueabihf/`. Had to physically copy the new library over the old one:
```bash
sudo cp /usr/local/lib/librtlsdr.so.0.6git /lib/arm-linux-gnueabihf/librtlsdr.so.0
```

## 5. Kernel DVB Driver Conflict

**Problem:** Linux kernel automatically loaded `dvb_usb_rtl28xxu` which claimed the USB device, preventing SDR software from accessing it. Error: `usb_claim_interface error -6`.

**Fix:** Blacklisted the driver modules:
```bash
echo "blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
blacklist dvb_usb_v2
blacklist dvb_core" | sudo tee /etc/modprobe.d/blacklist-rtlsdr.conf
```

Required a reboot to take effect. `sudo rmmod` worked temporarily but didn't persist.
