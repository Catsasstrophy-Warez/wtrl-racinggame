# RVP Triage Report

**Step 1 from the "next step" plan, actually done.** `02-TOOLCHAIN.md` and
`README.md` both said to clone RVP and see how badly it breaks before
committing to it as the physics foundation. This is that, with real numbers
instead of estimates — the repository was cloned and inspected directly,
not guessed at from the manual.

**Bottom line: less bad than the vague warning implied.** The API surface is
a mechanical rename (tested, working migration script below). The shader
situation looked scarier than it is — the custom logic turns out to be
about fifteen lines, identical in both shader files, wrapped in boilerplate
a URP rewrite replaces trivially.

---

## What was actually checked

Cloned `JustInvoke/Randomation-Vehicle-Physics` at its current `master`,
inspected directly rather than relying on the manual or prior assumptions.

| Fact | Finding |
|---|---|
| Unity version targeted | **2019.4.0f1** (confirmed via `ProjectVersion.txt`) |
| Render pipeline | **Built-in.** No URP references anywhere in `ProjectSettings/` |
| Script count | **58** `.cs` files under `Assets/Scripts/` |
| Shader count | **2** (`Tires.shader`, `Tires-Bump.shader`) — both legacy Surface Shaders |

## The API surface — 27 sites, 13 files, all mechanical

Every deprecated call site was found by pattern search across all 58
scripts, then verified against a diff after applying the fix (see below) to
confirm zero false positives and zero corruption.

| Pattern | Sites | Fix |
|---|---|---|
| `Rigidbody.velocity` | 19 | → `Rigidbody.linearVelocity` |
| `Rigidbody.drag` | 1 | → `Rigidbody.linearDamping` |
| `Rigidbody.angularDrag` | 4 | → `Rigidbody.angularDamping` |
| `FindObjectOfType<T>()` | 3 | → `FindFirstObjectByType<T>()` |
| **Total** | **27** | |

**Files affected (13):** `HoverWheel.cs`, `FlipControl.cs`, `FollowAI.cs`,
`Suspension.cs`, `DetachablePart.cs`, `VehicleAssist.cs`, `VehicleParent.cs`,
`VehicleDebug.cs`, `CameraControl.cs`, `Wheel.cs`,
`GroundSurfaceInstanceEditor.cs`, `TerrainSurfaceEditor.cs`,
`MobileInputGet.cs`.

**`Rigidbody.angularVelocity` was deliberately excluded** — it was not
renamed in Unity 6 and needs no change. The migration script below is
careful not to touch it.

> **This confirms the "20–100 errors, a few days" band** from the original
> triage plan (`02`), and lands solidly at the cheap end of it. Nothing
> structural, no API that was *removed* rather than renamed, no networking
> code (UNET, fully removed) or `GUIText`/`GUITexture` (also removed) —
> both checked for and found absent.

### The migration script — written, tested, verified clean

`migrate-to-unity6.sh`, shipped alongside this report. **Actually run
against a disposable copy of the real RVP checkout**, not just written and
assumed correct:

- Dry-run first, prints every change, asks for confirmation
- Word-boundary-safe patterns (won't touch an unrelated `.velocityChangeMode`
  or similar)
- **Verified after running:** zero old-pattern hits remain, zero corruption
  from operation ordering (`angularDrag` handled correctly relative to
  `drag`), and a spot-check diff on `VehicleAssist.cs` confirms every
  change is exactly the intended one-line rename

Point it at your own checkout's `Assets/Scripts` — it takes the directory as
an argument and re-scans rather than trusting these numbers blindly, since
your fork may have drifted from what was inspected here.

## The shaders — smaller than feared

Both `Tires.shader` and `Tires-Bump.shader` are **legacy Surface Shaders**
(`#pragma surface surf Lambert vertex:vert addshadow` and
`#pragma surface surf Standard vertex:vert addshadow` respectively). URP's
automatic built-in-to-URP material converter **cannot touch these at all**
— it remaps simple Standard-shader materials, not custom surface shader
code. This is the real reason a rewrite is needed, not a converter setting.

**But the actual custom logic is small.** Reading both files directly:

- Everything in each `surf()` function is boilerplate — sample a base
  texture, tint it, and (in the Bump variant) sample occlusion and a
  normal map. URP's `Lit` shader does all of this natively.
- **The only genuinely custom code is the `vert()` function** — a vertex
  deformation driven by a `_DeformMap` texture and a `_DeformNormal`
  vector, squashing the tyre mesh under load. **This function is
  byte-for-byte identical between the two shader files** — confirmed by
  direct comparison, not assumed. There is exactly one deformation trick
  to port, used twice.

### The URP replacement — written, not compiled

`Tire-URP.shader`, shipped alongside this report. A hand-written
URP-compatible ShaderLab/HLSL shader (not Shader Graph, for inspectability)
with:

- The exact deformation math transcribed from the original `vert()`
  function, ported into URP's vertex stage using `Core.hlsl`'s transform
  functions
- A forward-lit pass using `UniversalFragmentPBR`
- A `ShadowCaster` pass that applies the same deformation, so the shadow
  matches the squashed silhouette rather than the undeformed mesh — the
  original got this for free via `addshadow`; URP needs it explicit
- A porting note at the bottom for extending it into the Bump variant
  (occlusion + normal map + tangent-space basis; the `vert()` function
  itself needs no changes since it's identical in both originals)

**Honest status, same as the C# prototype code:** written and reasoned
through against URP/SRP Core conventions, not compiled. There is no
Unity/URP package available in the environment this was produced in. One
place flagged inline where the port makes a judgement call rather than a
literal translation — the deformation now runs in world space instead of
object space transformed by `unity_WorldToObject`, which should be
equivalent but is worth confirming visually once you can compare the two
side by side.

## Tags and layers — smaller than the earlier general guidance implied

Earlier guidance (`04-EXTRACTION-INVENTORY.md`) said RVP requires specific
tags and layers without pinning down exactly how many or where they're
used. Now confirmed by direct search:

**Two tags, three use sites, two files:**
- `"Underside"` — checked in `VehicleParent.cs` (twice)
- `"Pop Tire"` — checked in `Wheel.cs` (once, tyre-popping logic)

**Layer usage** appears via `LayerMask`/`.layer` across 8 files — standard
Unity layer-based filtering, nothing unusual.

**No committed script execution order asset was found** in the repository
itself. The "mandatory script execution order" requirement mentioned
elsewhere in this package appears to come from RVP's manual/PDF rather than
an enforced `ProjectSettings` file — **this specific claim needs checking
against the manual directly**, since the source alone doesn't confirm or
deny it.

## What this changes in the package

**The risk assessment softens.** `02-TOOLCHAIN.md` and the README both
treated the RVP port as an open question with a wide cost range. It no
longer is, for the two biggest line items:

- **API renames:** mechanical, tested, scriptable. Run
  `migrate-to-unity6.sh`, let the compiler catch anything it missed.
- **Shader port:** one deformation trick, already ported. Paste in
  `Tire-URP.shader`, extend it for the Bump variant per the note at the
  bottom, verify visually against the original.

**What's still genuinely unknown**, because it requires Unity itself to
answer: whether the physics *feels* the same after all of this — the
question the original triage plan flagged as the one number nobody can
give you in advance. That part of the plan is unchanged. This report closes
the mechanical uncertainty around it, not the "does it still feel good"
uncertainty, which still needs a real editor session.

---

## Files in this delivery

| File | What it is |
|---|---|
| `RVP-TRIAGE.md` | This report |
| `migrate-to-unity6.sh` | Tested API migration script |
| `Tire-URP.shader` | URP replacement for `Tires.shader`, with a porting note for `Tires-Bump.shader` |
