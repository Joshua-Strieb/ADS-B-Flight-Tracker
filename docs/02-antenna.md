## Coaxial Collinear (CoCo) Antenna — 1090 MHz Theory

the CoCo antenna consists of aseperate half wave coax sections that alternate shield and center connections. The phase reverse that is occurs at each section's junction cases radaited ields to add in-phase, producing an omnidirectional pattern with gain on the horizon.

## Section Length Calculation

The current RG-6 coax on order is assumed to have a VF of 0.82 but will need to be measured when aquired.

```math
\frac{λ}{2} = \frac{c × VF}{2 × f}
```
```math
\frac{λ}{2} = \frac{300,000,000 × 0.82}{2 × 1,090,000,000}
```
```math
    = 112.8 mm → 113 mm
```

## Velocity Factor Verification

The VF of the Smedz RG-6 satellite cable was measured using a NanoVNA shorted-stub test on a 1 m section:

1. Cut 1 m of cable
2. Soldered center conductor to shield at one end
3. Connected other end to NanoVNA via F connector + F-to-SMA adapter
4. Swept 50–300 MHz
5. First S11 dip appeared at **122.5 MHz**

```
VF = \frac{2 × length × f_dip}{c}
   = \fra{2 × 1.0 × 122,500,000}{300,000,000}
   = 0.817
```

With eight segments of 113mm this should give an approximate gain of 5dBi. The following material was used to construct the antenna in full:

## Materials
- RG-6 coaxial cable
- 3/4″ PVC pipe (~2m)
- Self-amalgamating tape
- Electrical tape
- F-to-SMA adapter

## Process

1. 10mm of the outer jacket and shield was removed to soley expose the center wire
2. From where the outer jacket begins 168mm was measured and marked
3. Then beyond the mark, an additional 10mm was stripped to expose the center wire
4. A total of eight segments were created
5. Before interconnection, a piece of electrical tape was placed in the middle of two segments with both center wires running through it, This ensures no short occurs. 
6. The segments were then connected with the center wire being driven into shield of the other segment. After each connection was made, continuity was tested with a multimeter to ensure proper connection.
7. Once continity was confirmed the junction was wrapped in electrical tape.





