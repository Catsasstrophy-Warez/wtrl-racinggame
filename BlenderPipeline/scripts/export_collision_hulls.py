"""Generate a low-poly convex-hull collision mesh for the vehicle body and export as FBX.

Usage:
  blender -b --python export_collision_hulls.py -- --input in.blend --out out.fbx \
      --body-name Crownfire_BODY_SHELL --mesh-name HeroCrownfire_collision
"""
import argparse, sys
from pathlib import Path
import bpy, bmesh


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--body-name', required=True)
    p.add_argument('--mesh-name', required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    body = bpy.data.objects[a.body_name]
    src_verts = len(body.data.vertices)
    src_faces = len(body.data.polygons)

    me = bpy.data.meshes.new(a.mesh_name + '_mesh')
    hull_obj = bpy.data.objects.new(a.mesh_name, me)
    bpy.context.collection.objects.link(hull_obj)

    bm = bmesh.new()
    tmp = body.data.copy()
    bm.from_mesh(tmp)
    bmesh.ops.transform(bm, matrix=body.matrix_world, verts=bm.verts)
    res = bmesh.ops.convex_hull(bm, input=bm.verts)
    # remove interior geometry left over from the hull op
    bmesh.ops.delete(bm, geom=[g for g in res['geom_interior']], context='VERTS')
    bm.to_mesh(me)
    bm.free()
    bpy.data.meshes.remove(tmp)
    me.update()

    hull_verts = len(me.vertices)
    hull_faces = len(me.polygons)
    print('SRC body verts/faces: %d/%d  HULL verts/faces: %d/%d' % (src_verts, src_faces, hull_verts, hull_faces))

    # isolate: select only the hull for export
    bpy.ops.object.select_all(action='DESELECT')
    hull_obj.select_set(True)
    bpy.context.view_layer.objects.active = hull_obj

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
    print('Exported collision hull to', out)


if __name__ == '__main__':
    main()
