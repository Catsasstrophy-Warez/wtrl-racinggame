# TORSION Community Edition — source files

Origin: https://github.com/LemonMontage420/TORSION-Community-Edition
License: MIT, Copyright (c) 2025 Lemon Montage. See `LICENSE` — keep it with
these files if you ship them.

Retrieved 29 Aug 2026. Check upstream for updates.

## Contents
Only the `Assets/Scripts` C# sources plus `Assets/Camera/CameraController.cs`.
**No art is included.** The upstream repo bundles third-party showcase assets
(Low Poly Car Pack from the Asset Store, two Sketchfab tracks) that are NOT
covered by the MIT license.

| File | Notes |
|---|---|
| `Engine.cs` | Torque curve, inertia, friction losses, idle/redline, starter |
| `Clutch.cs` | Friction clutch — torque capacity, stiffness, damping, slip |
| `Gearbox.cs` | Gear ratio array, timed shift coroutines, inGear flag |
| `Differential.cs` | **STUB** — 18 lines, open-diff scaffold. Extend this. |
| `Wheel.cs` | Raycast suspension, wheel inertia, fX/fY/fZ force decomposition |
| `Steering.cs` | Steering input handling |
| `Vehicle.cs` | Top-level orchestration |
| `Visuals.cs` | Visual wheel/mesh updates |
| `EngineAudio.cs` | RPM-driven engine audio |
| `CameraController.cs` | Follow camera |

## The architectural pattern to preserve
Each drivetrain component exposes `GetDownstreamTorque()` and
`GetUpstreamAngularVelocity()`. Torque flows toward the wheels; angular velocity
flows back toward the engine. This bidirectional coupling is what makes a clutch
and differential physically correct. Do not flatten it into one-way torque
delivery when integrating with RVP.

Companion tutorial series (builds this from scratch):
https://www.youtube.com/playlist?list=PL2uvZKBCoAYnfkfYm47nP5S6UeBPJPbEF
