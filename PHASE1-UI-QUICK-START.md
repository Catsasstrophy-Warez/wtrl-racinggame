# Phase 1 UI Integration — Quick Start

Three systems ready. No build required — test in Unity Editor.

## 1. Test Garage UI + Upgrade Validation

**File:** `Assets/Scripts/Career/UI/PartsShopUI.cs`

**Setup:**
1. Open **UnityProject** in Unity Editor
2. Open scene: `Assets/Scenes/Garage` (or build new DynoCell → PartsWall station)
3. Press **P** to open parts shop
4. Select category (T/N/X/G/Z/S/Y/A)
5. Browse parts and observe:
   - ✓ **Green validation:** Compatible, can buy/install
   - ✗ **Red validation:** Shows reason + prerequisite

**Example Test Cases:**
- Try buying Turbo Stage 2 (should validate if stock clutch sufficient)
- Try buying Turbo Stage 3 without twin-disc clutch first (should reject with reason)
- Try buying super-stiff suspension without aero (should warn about grip loss)

---

## 2. Test Dyno UI + Live Sliders

**File:** `Assets/Scripts/Career/UI/DynoUI.cs`

**Setup:**
1. Open **DynoCell** scene (or F3 from anywhere in game)
2. Dyno UI appears automatically
3. Select subsystem: **E** (Engine), **T** (Trans), **D** (Diff), **S** (Susp), **Y** (Tyres), **A** (Aero), **C** (Aids)
4. Move sliders (↑/↓ arrow keys or click)
5. Observe:
   - Power curve updates in real-time
   - Telemetry summary shows peak kW/Nm
   - Multiplier values update (e.g., "×1.12 cam multiplier")

**Example Workflow:**
- Select **Engine** subsystem
- Increase **Cam Duration Bias** slider (drag right)
- Watch power multiplier increase in real-time
- Adjust **Rev Limit** to 6500 RPM
- Click **APPLY** → Changes apply to vehicle
- Press **R** to revert

---

## 3. Tag Track Surfaces

**File:** `Assets/Editor/TrackSurfaceTagger.cs`

**Setup:**
1. Open **PrototypeTestTrack** scene
2. Editor menu: **Window > Wrench2Legend > Track Surface Tagger**
3. Window opens (dockable)
4. Select track object in hierarchy (e.g., "TrackMesh")
5. Click **SCAN SELECTED FOR COLLIDERS** → Finds child colliders
6. Choose **Surface Type** dropdown (Asphalt, Gravel, Concrete, etc.)
7. Set environmental properties:
   - Wetness: 0.0 (dry)
   - Contamination: 0.0 (clean)
8. Click **APPLY ASPHALT TO [N] COLLIDERS** → Done!

**Verify:**
- Play scene
- Drive wheel onto track → Console should show `[SurfaceGripProvider] Wheel detected: Asphalt`
- Grip behaves correctly (no errors)

**Multi-Surface Example:**
```
Asphalt main track:     Wetness=0.0, Contamination=0.0 → grip=1.18
Gravel runoff:          Wetness=0.1, Contamination=0.2 → grip=0.58
Concrete kerbs:         Wetness=0.0, Contamination=0.0 → grip=1.25
Marbles zone (dirty):   Wetness=0.0, Contamination=0.8, MarbleZone=Yes → grip=0.66
```

---

## File Locations (New/Modified)

### New Files

| File | Purpose |
|------|---------|
| `Assets/Scripts/Career/UI/DynoUI.cs` | Dyno UI controller with subsystem selector & sliders |
| `Assets/Editor/TrackSurfaceTagger.cs` | Editor window for batch-tagging track surfaces |
| `UnityProject/GARAGE-DYNO-TRACK-INTEGRATION.md` | Full integration guide (detailed) |

### Modified Files

| File | Changes |
|------|---------|
| `Assets/Scripts/Career/UI/PartsShopUI.cs` | Added UpgradeDependencyValidator integration, physics-based purchase validation |
| `Assets/Scripts/Vehicle/Physics/SurfaceMaterial.cs` | Enhanced docs, added GetGripMultiplier(), marblesZone support, gizmo visualization |

### Verified Existing

| File | Status |
|------|--------|
| `Assets/Scripts/Career/UpgradeDependencyValidator.cs` | ✅ Ready to use |
| `Assets/Scripts/Vehicle/Dyno/DynoTuningController.cs` | ✅ Ready to use |
| `Assets/Scripts/Vehicle/Dyno/DynoTuneProfile.cs` | ✅ Ready to use |
| `Assets/Scripts/Vehicle/Physics/SurfaceGripProvider.cs` | ✅ Ready to use |

---

## Build Notes for iPhone

Before Phase 1 profiling, ensure:

1. **Scenes are generated:**
   ```
   Unity.exe -batchmode -nographics -projectPath "UnityProject" \
     -executeMethod Wrench2Legend.EditorTools.PrototypeSceneBuilder.RebuildEverything -quit
   ```

2. **EditMode tests pass:**
   ```
   ./scripts/run-unity-tests.ps1
   ```

3. **Play scene verification:**
   - Open `DynoCell` scene → Press Play
   - Dyno UI should appear (no errors)
   - Move sliders, apply profile
   - Open parts shop (P) → Select part → See validation

4. **iOS build:**
   - Development build
   - IL2CPP backend
   - Target iOS 15+

---

## Known Limitations (Phase 1)

1. **Power curve visualization:** ASCII placeholder (functional, not pretty)
2. **Environmental properties:** Static per-track; no progression during events
3. **Telemetry logging:** No dyno run recording/export
4. **UI framework:** Basic GUI, not full Canvas-based layout

---

## Next Steps (After Verification)

1. ✅ Compile check (done)
2. **In-editor test:** Verify all three systems work
3. **iPhone build:** `./scripts/run-unity-tests.ps1` → PHASE1-PROFILING-PROTOCOL.md
4. **Document results:** Update PRODUCTION-READINESS.md §2.1

---

**Status:** Phase 1 complete, ready for testing  
**Last Updated:** 2026-09-01
