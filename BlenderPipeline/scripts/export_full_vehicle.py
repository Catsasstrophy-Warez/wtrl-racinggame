"""Export the full-res vehicle (all visible mesh objects, arches+seams baked
in) as a single FBX using the same export_scene.fbx() convention as
export_collision_hulls.py / build_*_correct_axes.py's coordinate standard
(X width, Y up, Z length; forward -Z, up Y, FBX_SCALE_NONE).

Usage:
  blender -b --python export_full_vehicle.py -- --input in.blend --out out.fbx [--prefix Crownfire]
"""
import argparse, sys
from pathlib import Path
import bpy


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--prefix', default=None)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)

    bpy.ops.object.select_all(action='DESELECT')
    count = 0
    total_verts = 0
    total_faces = 0
    for o in bpy.context.scene.objects:
        if o.type != 'MESH':
            continue
        if a.prefix and not o.name.startswith(a.prefix):
            continue
        o.select_set(True)
        count += 1
        total_verts += len(o.data.vertices)
        total_faces += len(o.data.polygons)
    print('Selected %d mesh objects, verts=%d faces=%d' % (count, total_verts, total_faces))

    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.export_scene.fbx(
        filepath=str(out),
        use_selection=True,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_NONE',
        axis_forward='-Z',
        axis_up='Y',
        object_types={'MESH'},
        use_mesh_modifiers=True,
        mesh_smooth_type='FACE',
        add_leaf_bones=False,
        bake_anim=False,
    )
    print('Exported full vehicle to', out)


if __name__ == '__main__':
    main()
