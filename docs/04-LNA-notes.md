# LNA Notes — Nooelec Lana (Broadband)

The Nooelec Lana is a broadband LNA covering 20 MHz–4 GHz with ~20 dB gain and ~1 dB NF and no bandpass filter. It is powered via the RTL-SDR V4's bias tee or its USB port.

### Expected Behaviour

Due to being in a moderately urban area, additional noise and interefence will be expected to be amplified along with the desired 1090MHz.

## Recommended Mitigation

Adding an additional SAW filter would mitigate the expected noise, initially none will be used. An LNA circuit will later be disgned with an added SAW filter.

