"""Export the full updated vehicle (wheel arches + panel seams applied) as FBX.

No FBX export previously existed in this project's scripts, so these settings
follow the project's documented coordinate standard (X width, Y up, Z length,
front -Z) rather than an existing precedent: axis_forward=-Z, axis_up=Y.

Usage:
  blender -b --python export_main_body_fbx.py -- --input in.blend --out out.fbx
"""
import argparse, sys
from pathlib import Path
import bpy


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    mesh_objs = [o for o in bpy.context.scene.objects if o.type == 'MESH']
    total_verts = sum(len(o.data.vertices) for o in mesh_objs)
    total_faces = sum(len(o.data.polygons) for o in mesh_objs)
    print('Exporting %d mesh objects, %d verts, %d faces' % (len(mesh_objs), total_verts, total_faces))

    bpy.ops.object.select_all(action='SELECT')
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
    print('Exported main body to', out)


if __name__ == '__main__':
    main()
