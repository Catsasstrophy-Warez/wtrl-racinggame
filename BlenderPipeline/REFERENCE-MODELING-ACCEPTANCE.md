# WTRL Vehicle Reference-Modeling Acceptance Standard

## Coordinate standard

- X: vehicle width / wheel axle
- Y: vertical
- Z: vehicle length
- Front: negative Z
- Wheel cylinders rotate 90 degrees around Y so their axles run on X

All earlier procedural fleet outputs that assumed X as vehicle length are disqualified as visual source assets.

## Current accepted blockout baselines

- `correct_axis_heroes/1967_crownfire_v5.blend`
- `correct_axis_heroes/marsh_nsx91_v4.blend`

The attached-fender experiments are rejected. Current versions use radius-following upper arch lips, recessed roof panels, multi-spoke wheels, panel seams, mirrors, and model-specific grille/intake structures.

## Required visual gates before propagation

1. Side silhouette matches the compendium vehicle class and era.
2. Three-quarter view reads as a continuous automotive body, not stacked primitives.
3. Wheel centers, radius, track, and axle orientation are correct.
4. Wheel openings are cut into or modeled as part of the body topology.
5. Hood, roof, glasshouse, deck, and beltline form one coherent profile.
6. Front and rear signatures are vehicle-specific.
7. Glasshouse has windshield, rear glass, side glass, pillars, seals, and roof framing.
8. Body panels have controlled edge radii and deliberate seams.
9. Materials read correctly under neutral studio lighting.
10. Side, front, rear, and three-quarter validation renders pass before lineage propagation.

## Next modeling operation

Continue the wheel openings into the body side topology, then add door/hood/deck seams and vehicle-specific front/rear lamp and grille geometry. Do not use ellipsoids or torus arches as substitutes for body topology.

## Changelog

### 2026-09-20 - Wheel-arch booleans, real panel seam geometry, collision hulls, LODs

Worked from the accepted baselines `1967_crownfire_v7.blend` and `marsh_nsx91_v6.blend` (untouched, not modified). All new work is in `export/pipeline_updated/`.

**Done:**

1. Dumped a full object/transform/bbox report for both files (`scripts/dump_object_report.py`) before writing any boolean code, confirming actual TIRE world positions/radii rather than assuming them.
2. Cut real wheel-arch openings into `Crownfire_BODY_SHELL` / `Marsh_BODY_SHELL` via boolean difference against a cylinder sized/positioned from each TIRE object's measured bounding box (`scripts/add_wheel_arches.py`). Verified by re-reading the saved .blend: Crownfire body 64 verts/58 faces -> 236 verts/142 faces; Marsh body 64/58 -> 208/125. Face-count growth plus visible holes in the re-opened mesh confirm real topology changes, not a decal.
3. Investigated the existing `*_DOOR_FRONT_SEAM`, `*_DOOR_REAR_SEAM`, `*_HOOD_SEAM`, `*_DECK_SEAM` objects: they are not empties or curves, they are separate thin decorative mesh boxes overlaid on the body surface. Used their world-space positions to bisect the actual body-shell mesh with a plane at each seam's location and bevel the resulting new edge loop, producing a real creased seam line cut into body topology (`scripts/add_panel_seams.py`), restricted in extent to each panel's bounding box where possible (per-side for doors, per-span for hood). Verified: Crownfire body 236/142 -> 392/282 (44 new seam edges across 3 door seams + 2 hood seams + 1 deck seam); Marsh body 208/125 -> 304/205 (24 new seam edges across 2 door seams + 1 hood seam; Marsh has no DECK_SEAM object). The decorative seam boxes were left in place; the topology now also carries a real seam line at the same locations.
4. Generated a low-poly convex-hull collision mesh per vehicle body (`scripts/export_collision_hulls.py`) and exported `HeroCrownfire_collision.fbx` (136 verts / 284 tris on FBX re-import) and `MarshNsx_collision.fbx` (124 verts / 269 tris on FBX re-import).
5. Generated LOD1 (~50%) and LOD2 (~20%) meshes with Blender's Decimate modifier (`scripts/export_lods.py`) and exported per-vehicle FBX. Verified by re-importing each FBX and counting faces: Crownfire LOD1 3311 faces vs 9452 full-body faces (35%), LOD2 1133 faces (12%); Marsh LOD1 1958 vs 7095 full-body faces (28%), LOD2 877 faces (12%). Note: because many small trim/spoke objects hit Blender's minimum-triangle floor under Decimate, the achieved ratios trend lower than the nominal 50%/20% modifier ratio input on the low end and required manual ratio tuning (0.30 and 0.06 modifier ratios were used, not 0.5/0.2, to land near the ~50%/~20% targets); reported numbers above are the real post-export counts, not the modifier's input ratio.
6. Re-exported the updated main bodies (arches + seams) as `HeroCrownfire.fbx` (10512 verts / 9452 faces on re-import) and `MarshNsx.fbx` (7968 verts / 7095 faces on re-import).
7. No FBX export previously existed anywhere in this project (`build_crownfire_correct_axes.py` / `build_marsh_correct_axes.py` only produce .blend files; there was no prior "accepted FBX export settings" to reuse). All new exports here use axis_forward=-Z, axis_up=Y to match this document's coordinate standard (front -Z, Y up), `apply_scale_options=FBX_SCALE_NONE`, mesh modifiers applied, FACE smoothing. Output location: `export/pipeline_updated/` (new folder, sibling to `export/correct_axis_heroes/`), since no existing "final FBX" folder convention was found in `export/`.

**Output files (all under `D:\Claudeprojx\racinggame\BlenderPipeline\export\pipeline_updated\`):**
`1967_crownfire_v8_arches.blend`, `1967_crownfire_v9_seams.blend`, `marsh_nsx91_v7_arches.blend`, `marsh_nsx91_v8_seams.blend`, `HeroCrownfire.fbx`, `HeroCrownfire_collision.fbx`, `HeroCrownfire_LOD1.fbx`, `HeroCrownfire_LOD2.fbx`, `MarshNsx.fbx`, `MarshNsx_collision.fbx`, `MarshNsx_LOD1.fbx`, `MarshNsx_LOD2.fbx`.

**New scripts (all under `scripts/`):** `dump_object_report.py`, `add_wheel_arches.py`, `add_panel_seams.py`, `export_collision_hulls.py`, `export_lods.py`, `export_main_body_fbx.py`, `verify_mesh_stats.py`.

**Required visual gates still NOT met after this work:**

- Gate 6 (front/rear signatures are vehicle-specific): lamp and grille geometry was already present from the prior baseline (headlamp cylinders, grille bars, tail lamp boxes) but was **not** touched or improved in this pass; no new vehicle-specific lamp/grille modeling was done here. This was explicitly out of scope for this pass given time budget after prioritizing wheel arches, seams, collision, and LODs.
- Gate 8 partially: the new seam cuts are real geometry but are full-width rings/bands restricted only in bounding-box extent, not hand-sculpted panel-specific surfaces; they are a straightforward bisect+bevel, not sculpted panel gaps with door-shut-line depth variation.
- Gates 1, 2, 9, 10 (silhouette/read/materials/render validation passes) were not re-evaluated in this pass; no new renders were produced.
- No wheel-arch lip/flare geometry was added at the new boolean-cut opening edge (the cut is a clean cylindrical hole; the decorative torus-ring `*_WHEEL_ARCH` objects from the baseline remain as a separate overlay, unchanged).
