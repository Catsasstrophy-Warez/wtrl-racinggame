"""Generate LOD meshes for the full vehicle (all mesh objects) using the Decimate
modifier (collapse ratio) and export each LOD as its own FBX.

Usage:
  blender -b --python export_lods.py -- --input in.blend --out-prefix HeroCrownfire \
      --out-dir export/pipeline_updated --ratio 0.5 --tag LOD1
"""
import argparse, sys
from pathlib import Path
import bpy


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--ratio', type=float, required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    mesh_objs = [o for o in bpy.context.scene.objects if o.type == 'MESH']

    total_before = sum(len(o.data.polygons) for o in mesh_objs)

    for o in mesh_objs:
        mod = o.modifiers.new('LOD_Decimate', 'DECIMATE')
        mod.ratio = a.ratio
        bpy.context.view_layer.objects.active = o
        bpy.ops.object.modifier_apply(modifier=mod.name)

    total_after = sum(len(o.data.polygons) for o in mesh_objs)
    print('TOTAL FACES BEFORE: %d  AFTER (ratio=%.2f): %d  actual_ratio=%.3f' % (
        total_before, a.ratio, total_after, (total_after / total_before) if total_before else 0))

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
    print('Exported LOD to', out)


if __name__ == '__main__':
    main()
