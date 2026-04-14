# Link Budget Analysis

## Friis Transmission Equation

```
P_r = P_t + G_t + G_r + G_LNA - L_fs - L_cable - L_misc
```

## Parameter Values

| Parameter | Symbol | Value | Notes |
|-----------|--------|-------|-------|
| Transmit power (Mode-S) | P_t | +51 dBm (125 W) | ICAO minimum for large aircraft |
| Tx antenna gain | G_t | 0 dBi | Quarter-wave monopole on aircraft belly |
| Free-space path loss @ 250 km | L_fs | 141.2 dB | See below |
| Rx antenna gain (CoCo, 8 elements) | G_r | +5 dBi | Estimated |
| LNA gain (Nooelec Lana) | G_LNA | +20 dB | Broadband, no filter |
| Cable loss (1.5 m RG-6 @ 1090 MHz) | L_cable | 2.0 dB | RG-6 ≈ 5 dB/100 ft at 1 GHz |
| Connector and mismatch losses | L_misc | 1.5 dB | F-to-SMA adapters, barrel connector |

## Free-Space Path Loss

```
FSPL(dB) = 20·log₁₀(d_km) + 20·log₁₀(f_MHz) + 32.44
         = 20·log₁₀(250) + 20·log₁₀(1090) + 32.44
         = 47.96 + 60.75 + 32.44
         = 141.2 dB
```

## Received Power

**Without LNA:**
```
P_r = 51 + 0 + 5 − 141.2 − 2.0 − 1.5 = −88.7 dBm
```

**With Lana (+20 dB, mounted at antenna feedpoint):**
```
P_r = 51 + 0 + 5 + 20 − 141.2 − 2.0 − 1.5 = −68.7 dBm
```

## Interpretation

The RTL-SDR + decoder threshold is approximately −85 to −90 dBm. Without the LNA, 250 km is marginal. With the Lana, link margin is roughly 17–21 dB — provided out-of-band interference does not overload the SDR.

**Radio horizon:** For a ground-level antenna and aircraft at FL330 (10,000 m), the radio horizon is approximately 410 km. Terrain and buildings reduce practical range below this.

