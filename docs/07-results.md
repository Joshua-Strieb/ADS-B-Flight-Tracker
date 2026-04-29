# Measured Results

> **TODO:** 

## Configuration A — Baseline - No LNA, Ground Level

**Date:** 2026-04-16 | **Duration:** 24h | **Weather:** Clear

| Metric | Value |
|--------|-------|
| Avg aircraft tracked | 5 |
| Peak aircraft tracked | 19 |
| Max range (NM) | 107.7 |
| Avg messages/sec | 8.1 |
| Mean signal (dBFS) | -23.9 |

## Configuration B — With Filtered LNA, Ground Level

**Date:** 2026-04-17 | **Duration:** 24h | **Weather:** Partial Rain

| Metric | Value |
|--------|-------|
| Avg aircraft tracked | 8 |
| Peak aircraft tracked | 23 |
| Max range (NM) | 141.3 |
| Avg messages/sec | 8.3 |
| Mean signal (dBFS) | -21.0 |

## Configuration C — With Filtered LNA, Elevated Antenna

**Date:** 2026-04-24 | **Duration:** 24h | **Antenna height:** 3m AGL | **Weather:** Clear

| Metric | Value |
|--------|-------|
| Avg aircraft tracked | 17 |
| Peak aircraft tracked | 47 |
| Max range (NM) | 195.0 |
| Avg messages/sec | 8.5 |
| Mean signal (dBFS) | -20.6 |

## Comparison

| Metric | A (Baseline) | B (+ LNA) | C (+ Elevated) |
|--------|--------------|-----------|-----------------|
| Avg aircraft | 5 | 8 | 17 |
| Max range (NM) | 107.7 | 141.3 | 195.0 |
| Mean signal (dBFS) | -23.9 | -21.0 | -20.6 |

## NanoVNA Measurements

### Antenna

| Parameter | Target | Measured |
|-----------|--------|----------|
| VSWR @ 1090 MHz | < 2.0 | 1.6 |
| Resonant frequency | 1090 MHz | -13dB @1090MHz |

## Predicted vs Measured

| Parameter | Predicted | Measured | Notes |
|-----------|-----------|----------|-------|
| Max range (with LNA) | ~200+ NM | 195.0 | Inital prediction included a tighter band filter |

