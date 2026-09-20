# Pacejka reference implementation

**Origin:** `github.com/Yousef0M/Brian-Beckman-phors-Implementation`
**Licence:** **Unlicense — public domain.** *"Anyone is free to copy, modify,
publish, use, compile, sell, or distribute this software... for any purpose,
commercial or non-commercial."* No attribution required. Retrieved 1 Sep 2026.

A Python implementation of Beckman's tyre model using **his exact published
constants**, covering:

| Chapter | What it implements |
|---|---|
| **Part 21** | Longitudinal magic formula (`longPacejka`) |
| **Part 22** | Lateral magic formula (`latPacejka`) |
| **Part 25** | **Combination grip — the traction circle** |

See `34-PHYSICS-READING.md` Parts 1c and 1d for the theory.

---

## Why this is worth having

**It is the commensurability fix in executable form.**

Part 25's whole problem is that longitudinal slip is a *percentage* and lateral
slip is an *angle* — not commensurable, so you cannot combine them directly. The
solution is to normalise each by its own peak, combine by Pythagoras, then scale
the outputs by each component's share of the magnitude.

That is exactly what the combined section does:

```python
S = (i/(steps/2))-1          # normalised slip ratio
A = (j/(steps/2))-1          # normalised slip angle
p = math.sqrt(S*S + A*A)     # combined magnitude

fx = (S/p) * longPacejka(p * maxSlipRatio, Fz)
fy = (A/p) * latPacejka (p * maxSlipAngle, Fz, 0)

grip = math.sqrt(fx*fx + fy*fy)
```

**The measured peaks match Beckman's text:**

| | Code | Beckman |
|---|---|---|
| `maxSlipRatio` | **0.0796** | *"peaks at around σ = 0.08"* (Part 21) |
| `maxSlipAngle` | **≈3.27°** | *"peak at about 4 degrees of slip"* (Part 22) |

Those two numbers are the normalisers. **Everything in the combination hinges on
them**, so measure them from your own tyre curves rather than copying these.

---

## ⚠️ One bug to fix before porting

In `latPacejka`, the ply-steer / conicity term reads:

```python
Sv = ((a[11]*Fz + a[11])*Y + a[12])*Fz + a[13]
```

**`a[11]` appears twice.** It should almost certainly be `a[11]*Fz + a[12]`, with
the following indices shifted accordingly.

**The bug is latent in this file** because it is only ever called with camber
`Y = 0`, which collapses the term. **It will bite the moment you introduce
camber** — which `25` Part 5 lists as a practice-session tuning parameter.

Also note `maxSlipRatio` is computed from the curve and then immediately
overwritten with a hardcoded `.0796` on the next line. Harmless here; remove it
when porting.

---

## Porting notes for Unity / C#

- Both functions are pure and allocation-free — a direct C# translation is
  trivial and Burst-compatible if you need it
- `Fz` is in **kiloNewtons**; slip ratio is a fraction (the function multiplies
  by 100 internally); slip angle is in **degrees**
- The constants are Genta's "possible-Ferrari" data. Coefficient of friction
  works out near **1.7** — very sticky. Substitute your own per-compound values
  (`31` §6.2 on authoring curves)
- **Watch the low-speed divergence** (`34` Part 3.2): Pacejka has a velocity term
  in the denominator and blows up near pit-lane speeds. Plan a clamp or blend
- **And there is no speed term at all** (`34` Part 1d, Part 22) — the model is
  speed-blind by construction

---

## Cross-references
- Theory: longitudinal → `34` Part 1d (Part 21); lateral → `34` Part 1d (Part 22)
- Combination slip and grip → `34` Part 1d (Parts 24–25)
- The cup region / instability threshold → `20` §1
- Authoring tyre curves in the dyno → `31` §6.2
- TLabVehiclePhysics, an existing Unity Pacejka implementation → `04` §2
