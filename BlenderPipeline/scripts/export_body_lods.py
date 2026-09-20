"""Generate LOD1 (~50%) and LOD2 (~20%) decimated versions of the body shell
and export each as its own FBX, using the same export_scene.fbx() convention
as export_collision_hulls.py (axis_forward='-Z', axis_up='Y', FBX_SCALE_NONE).

Usage:
  blender -b --python export_body_lods.py -- --input in.blend \
      --body-name Crownfire_BODY_SHELL \
      --lod1-out out_LOD1.fbx --lod2-out out_LOD2.fbx
"""
import argparse, sys
from pathlib import Path
import bpy


def export_selected(obj, out_path):
    bpy.ops.object.select_all(action='DESELECT')
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    out = Path(out_path)
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
    print('Exported', out)


def make_lod(body, ratio, name, out_path):
    dup = body.copy()
    dup.data = body.data.copy()
    dup.name = name
    bpy.context.collection.objects.link(dup)
    dec = dup.modifiers.new('LOD_Decimate', 'DECIMATE')
    dec.ratio = ratio
    bpy.context.view_layer.objects.active = dup
    bpy.ops.object.modifier_apply(modifier=dec.name)
    print('%s verts/faces: %d/%d (ratio=%.2f)' % (name, len(dup.data.vertices), len(dup.data.polygons), ratio))
    export_selected(dup, out_path)
    return dup


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--body-name', required=True)
    p.add_argument('--lod1-out', required=True)
    p.add_argument('--lod2-out', required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    body = bpy.data.objects[a.body_name]
    src_verts = len(body.data.vertices)
    src_faces = len(body.data.polygons)
    print('SRC body verts/faces: %d/%d' % (src_verts, src_faces))

    make_lod(body, 0.5, a.body_name + '_LOD1', a.lod1_out)
    make_lod(body, 0.2, a.body_name + '_LOD2', a.lod2_out)


if __name__ == '__main__':
    main()
