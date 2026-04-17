# Controlled Performance Experiment

## Design

| Config | Description | Duration |
|--------|-------------|----------|
| A — Baseline | SDR + coax + CoCo antenna at ground level, no LNA | 24 hours |
| B — Add LNA | SDR +  LNA + coax + CoCo at ground level | 24 hours |
| C — Elevated | SDR +  LNA + coax + CoCo elevated | 24 hours |

## Metrics (from graphs1090)

For each 24-hour period data was record from `http://192.168.0.151/graphs1090/?timeframe=24h`:

1. **Aircraft count** — average and peak
2. **Messages per second** — average and peak
3. **Maximum range** — 24-hour max and 95th percentile
4. **Signal strength distribution** — mean RSSI in dBFS
5. **Positions per second** — average

## Controls

- The same fixed SDR gain was used across all configs
- Data was acquired for a full 24 hours to average out traffic variation
- Weather data was recorded due to 1090MHz having measurable attenuation during heavy rain fall
