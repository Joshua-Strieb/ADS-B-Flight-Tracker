# System Noise Figure Budget

## Friis Noise Formula

```math
F_{total} = F_1 + (F_2 − 1)/G_1 + (F_3 − 1)/(G_1·G@) + …
```

## Scenario A — No LNA

| Stage | Component | NF (dB) | NF (linear) | Gain (dB) | Gain (linear) |
|-------|-----------|---------|-------------|-----------|---------------|
| 1 | RG-6 cable (1.5 m) | 2.0 | 1.58 | −2.0 | 0.63 |
| 2 | RTL-SDR R828D | 6.0 | 3.98 | 30 | 1000 |

```
F_{total} = 1.58 + (3.98 − 1) / 0.63 = 6.31
NF_{total| = 10·log_{10}(6.31) = 8.0 dB
```

## Scenario B — Nooelec Lana at Antenna Feedpoint

| Stage | Component | NF (dB) | NF (linear) | Gain (dB) | Gain (linear) |
|-------|-----------|---------|-------------|-----------|---------------|
| 1 | Nooelec Lana | 1.0 | 1.26 | 20 | 100 |
| 2 | RG-6 cable (1.5 m) | 2.0 | 1.58 | −2.0 | 0.63 |
| 3 | RTL-SDR R828D | 6.0 | 3.98 | 30 | 1000 |

```
F_{total} = 1.26 + (1.58 − 1)/100 + (3.98 − 1)/(100 × 0.63) = 1.31
NF_{total} = 10·log_{10}(1.31) = 1.18 dB
```

## Summary

| Metric | No LNA | With Lana | Delta |
|--------|--------|-----------|-------|
| System NF | 8.0 dB | 1.18 dB | **6.8 dB improvement** |
| System noise temp | ~1540 K | ~100 K | **~15× lower** |

## Important Caveat: Broadband LNA

The Lana has no bandpass filter. The noise figure above is best-case assuming only thermal noise. In practice, amplified out-of-band signals (GSM 800/900 MHz, LTE, TV) can overload the RTL-SDR's ADC, raising the effective noise floor.

**Mitigation:** Add a standalone 1090 MHz SAW bandpass filter before the Lana. Likely for a future project, design an LNA that operates at 1090MHz with a SAW filter.
