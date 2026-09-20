"""Exports a track's generated ribbon-road .blend (produced by
generate_world_tracks.py, which only saves .blend + PNG textures, no
FBX) as FBX for Unity to import.

No FBX texture embedding: `embed_textures=True` was tried in an
earlier pass and confirmed NOT to work -- Unity's FBX importer never
wires the resulting material's texture slot regardless of how the
image was packed/saved on the Blender side (see
WTRL-Unity/Assets/WrenchToRaceLegends/UI/CONTRACT.md's writeup of that
bug). Geometry+UV only; textures are separate PNG files loaded
directly in Unity's VerticalSliceSceneBuilder/WorldTrackSceneBuilder.

Usage:
  blender -b --python export_track_fbx.py -- --input in.blend --out out.fbx
"""
import argparse
import sys
from pathlib import Path

import bpy


def main():
    av = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--out", required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    mesh_objs = [o for o in bpy.context.scene.objects if o.type == "MESH"]
    print(f"Exporting {len(mesh_objs)} mesh objects from {a.input}")

    bpy.ops.object.select_all(action="SELECT")
    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.export_scene.fbx(
        filepath=str(out),
        use_selection=True,
        apply_unit_scale=True,
        apply_scale_options="FBX_SCALE_NONE",
        axis_forward="-Z",
        axis_up="Y",
        object_types={"MESH"},
        use_mesh_modifiers=True,
        mesh_smooth_type="FACE",
        embed_textures=False,
        add_leaf_bones=False,
        bake_anim=False,
    )
    print(f"Exported track FBX to {out}")


if __name__ == "__main__":
    main()
