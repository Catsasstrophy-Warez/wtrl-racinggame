# Licensing Status

Verified 29 Aug 2026 by cloning each repository and reading its actual license
files, not by reading README summaries. Re-verify before shipping — licenses change.

---

## PERRINN Project 424 — DO NOT COPY ANYTHING

**Status: all rights reserved. No usable grant.**

The repository has **no LICENSE file at any level**. Under default copyright,
that means no rights are granted to you at all.

The bundled dependencies are worse, and both are explicit:

**`Assets/Vehicle Physics Pro/LICENSE.txt`**
> This edition of Vehicle Physics Pro (VPP-424) is licensed to be used in the
> context of the PERRINN 424 project. VPP-424 may be distributed and used free
> of charge as part of the PERRINN 424 project only. Commercial usage of
> VPP-424 is not permitted.

**`Assets/Locations/Nordschleife/LICENSING.txt`**
> Nordschleife track data and graphics provided by OHW Studios under license for
> non-commercial usage. Commercial usage of all or any part is NOT permitted.

**You may:** clone it, run it, study how it works, learn from the architecture.
**You may not:** copy code, copy assets, or use any part in a commercial game.

### The useful consolation
That same VPP license file points to a free tier:

> A free Community Edition suitable for use in commercial projects is available
> in the Unity Asset Store:
> https://assetstore.unity.com/packages/tools/physics/vehicle-physics-pro-community-edition-153556

### ⚠️ CORRECTED — the Community Edition cannot ship on iOS

An earlier revision of this document called the CE "the single most actionable
find in the whole survey." **That was wrong.** The Asset Store listing states
the limits:

- 2 axles, 4 wheels per vehicle
- **1 vehicle per scene**
- **Single ground material**
- **Desktop builds only**

**Three of those are independently fatal here.** Desktop-only means no iOS build
at all. One vehicle per scene means no AI opponents, so no racing. A single
ground material kills surface-dependent grip (`17` §3.3).

**The CE is a learning and benchmarking tool, not a foundation.** See
`02-TOOLCHAIN.md` §"Vehicle physics" for the corrected options, and `20` §2 for
what is still genuinely usable from VPP for free.

---

## Unity ECS Network Racing Sample — Unity Companion License

**Status: usable within Unity projects. Not a blanket open-source grant.**

`LICENCE.md` (note the British spelling):
> ECS Network Racing Sample copyright (c) 2022 Unity Technologies ApS
> Licensed under the Unity Companion License for Unity-dependent projects.
> http://www.unity3d.com/legal/licenses/Unity_Companion_License

It is **not MIT**. The UCL permits use in projects that depend on Unity, which
covers your case, but read the full terms before shipping code verbatim —
particularly the trademark clauses.

Source is not bundled here. Clone it fresh:
- Requires **Git LFS**. Do not download as a ZIP; it will be broken.
- Requires **Unity 6000.2.11f1 or later**. Project version 3.0.0.

---

## TORSION Community Edition — MIT

**Status: fully usable, including commercially. Code only.**

`LICENSE`: MIT License, Copyright (c) 2025 Lemon Montage. Standard MIT terms —
use, copy, modify, merge, publish, distribute, sublicense, sell, provided the
copyright notice and permission notice are included.

**The art is NOT covered.** The README lists third-party showcase assets:
- Low Poly Car / Vehicle Pack (Unity Asset Store)
- Drift Race Track Free (Sketchfab)
- Cartoon Race Track – Oval (Sketchfab)

`Assets/Models/Vehicles.fbx` and the track models are excluded from this package
for that reason. Source your own art.

**What is bundled here:** all 10 `.cs` files plus the MIT license, in
`code/TORSION-MIT/`. Keep the LICENSE file alongside them if you ship.

---

## CrazyCar — MIT

**Status: fully usable, including commercially.**

`LICENSE`: MIT License, Copyright (c) 2021 TastSong.

Bundled here: the license and `data.sql` (the MySQL schema), plus a backend
class index. The Unity client and Java server are not bundled — clone them if
you want to read the implementation. Docs are primarily Chinese; there is a
`README_en.md`.

---

## Randomation Vehicle Physics — MIT code, PD art, mixed audio

Not cloned in this pass, but verified earlier from the repo README.

- **Code:** MIT. The author states you can sell projects using it as long as the
  MIT license is included and the code is not sold by itself.
- **Models and textures:** public domain, created specifically for the package.
- **Audio:** from freesound.org under a *mix* of licenses — some public domain
  (CC0), some CC Attribution 3.0, some CC Sampling Plus 1.0. **Check each clip
  individually.** The CC-BY ones require credit in your game.
- **Font:** Roboto, Apache 2.0.

---

## General warnings for this whole category

1. **Most Unity game repos bundle Asset Store content the author cannot
   sublicense.** Kirisaki00's README says so outright. Assume art is not yours
   unless the repo explicitly says otherwise.
2. **Ishaan35's Mario Kart** is Nintendo-derived. Read the AI pathing approach;
   copy nothing.
3. **"MIT" on a Unity repo usually covers only the code**, not the `Assets/`
   art folders. Check for per-folder license files.
4. **A missing LICENSE file is not permission.** It is the opposite.
