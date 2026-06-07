# ADS-B Aircraft Tracking Station

A 1090 MHz ADS-B receiver built from scratch — homemade coaxial collinear antenna, broadband LNA, Raspberry Pi software stack, and live map display — designed as a second-year electrical engineering portfolio project.

<!-- TODO: Add a hero photo of your completed station here -->
<!-- ![Station Photo](images/station-overview.jpg) -->

## System Block Diagram

![System Block Diagram](images/system-block-diagram.svg)

## Performance (Theoretical)

| Metric | Without LNA | With Lana | Improvement |
|--------|-------------|-----------|-------------|
| System noise figure | 8.0 dB | 1.18 dB | **~6.8 dB** |
| System noise temp | ~1540 K | ~100 K | **~15× lower** |
| Typical max range | ~100 NM | ~150+ NM | **~40%** |

> **Note:** These are best-case numbers assuming no out-of-band overload. Since the Lana has no bandpass filter, actual performance in urban/suburban areas may be lower. See [noise budget](docs/02-noise-budget.md) and [LNA notes](docs/03-lna-notes.md).

## Repository Structure

```
├── README.md
├── docs/
│   ├── 01-link-budget.md
│   ├── 02-antenna.md
│   ├── 03-noise-budget.md
│   ├── 04-LNA-notes.md
│   ├── 05-software.md
│   ├── 06-experiment.md
│   ├── 07-results.md
│   └── 08-build-log.md 
├── hardware/
│   └── bom/
│       └── bom.csv
├── software/
│   ├── install.sh
│   ├── kiosk.sh
├── LICENSE
└── README.md
```

## Quick Start

### 1. Build the Antenna

See the full [antenna build guide](docs/02-antenna.md). Key number: **113 mm per element** for RG-6 with VF = 0.82. This was verified experimentally using a NanoVNA shorted-stub test on a 1 m cable section (dip at 122.5 MHz → VF = 0.817).

### 2. Flash the Pi

Use **Raspberry Pi OS Lite (64-bit) — Bookworm (Debian 12)**. Do NOT use Trixie/Debian 13 — the ADS-B software packages are not compatible. See [software setup](docs/05-software.md) for details.

### 3. Install Software

```bash
git clone https://github.com/YOUR_USERNAME/adsb-station.git
cd adsb-station
chmod +x software/scripts/install.sh
./software/scripts/install.sh
```

### 4. Dashboard

```bash
mkdir -p ~/dashboard
cp software/dashboard/app.py ~/dashboard/
nano ~/dashboard/app.py   # Set your coordinates
sudo cp software/dashboard/adsb-dashboard.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now adsb-dashboard
# View at http://<pi-ip>:5000
```

### 5. Polar Range Plot

```bash
mkdir -p ~/polar
cp software/polar/*.py ~/polar/
nano ~/polar/collector.py   # Set your coordinates
python3 ~/polar/collector.py &   # Run 24+ hours
python3 ~/polar/plotter.py       # Generate plot
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Broadband LNA (Nooelec Lana) | Low NF (~1 dB), 20 dB gain, bias tee powered; no built-in SAW filter — standalone 1090 MHz SAW filter recommended |
| 113 mm CoCo elements | Verified by NanoVNA: VF = 0.817, λ/2 = c × VF / (2 × f) = 113 mm. Common online guides incorrectly state 168 mm |
| 8-element CoCo | ~5 dBi gain at horizon; good balance between range and overhead coverage |
| readsb (not dump1090-fa) | Native RTL-SDR Blog V4 support; dump1090-fa's FlightAware repository is offline and V4 driver integration is problematic |
| Pi 4 2GB + OS Lite (Bookworm) | Enough RAM for kiosk mode; Trixie/Debian 13 is incompatible with ADS-B packages |
| RTL-SDR Blog V4 custom drivers | Standard Debian rtlsdr drivers cause PLL lock failures on V4 hardware; Blog drivers required |
| F-to-SMA adapters | SMA crimp connectors are sized for RG-58 (5 mm), not RG-6 (7 mm); adapters are simpler and more reliable |

## Critical Build Notes

1. **Element length is 113 mm, NOT 168 mm.** The 168 mm value found in many online guides uses an inverted formula. Verify with a NanoVNA shorted-stub test before cutting all elements.
2. **Solder all antenna junctions.** Pushing wires into the shield does not work at 1090 MHz. Every junction must be soldered with flux and heat-shrunk.
3. **Use Bookworm, not Trixie.** The latest Raspberry Pi Imager defaults to Trixie/Debian 13. Select "Raspberry Pi OS (Legacy) Lite (64-bit)" for Bookworm.
4. **Install RTL-SDR Blog V4 custom drivers.** The standard Debian `librtlsdr` package does not properly support the V4's R828D tuner.
5. **Blacklist the DVB kernel drivers.** Without blacklisting, the kernel claims the USB device and the SDR software cannot access it.

## Bill of Materials (April 2026 Pricing)

| Category | Item | Cost (€) |
|----------|------|----------|
| SDR | RTL-SDR Blog V4 | 35.00 |
| LNA | Nooelec Lana (broadband 20 MHz–4 GHz) | 37.28 |
| Antenna | RG-6 5m Smedz satellite cable | 7.00 |
| Antenna | PVC pipe 2m + tape + heat shrink | 16.00 |
| Adapters | F-to-SMA ×2, SMA barrel | 8.00 |
| Pi | Raspberry Pi 4 2GB | 71.20 |
| Pi | Okdo K-0532 Kit (32GB SD, case, fan, micro HDMI) | 23.84 |
| Pi | 7-inch LCD TFT (DSI touchscreen) | 49.51 |
| Test | NanoVNA | 50.00 |
| **Total** | | **~€300** |

## Software Stack

| Component | Purpose |
|-----------|---------|
| **readsb** | ADS-B decoder (replaces dump1090-fa) |
| **tar1090** | Web-based aircraft map |
| **graphs1090** | Long-term performance graphs |
| **Chromium** | Kiosk mode on touchscreen |

## License

[MIT License](LICENSE)

---

*Built as a second-year electrical engineering portfolio project.*
