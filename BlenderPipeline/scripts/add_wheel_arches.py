"""Cut real wheel-arch openings into the body shell mesh via boolean difference.

Reads wheel (TIRE) object world transforms from the file itself (no guessing),
builds a cutting cylinder per wheel sized/positioned from those transforms,
and boolean-differences it against the body shell so the wheel opening is
real topology (a hole with a rim of new geometry), not a decal.

Usage:
  blender -b --python add_wheel_arches.py -- --input in.blend --out out.blend \
      --body-name Crownfire_BODY_SHELL --tire-prefix Crownfire_TIRE \
      --margin 0.075 --depth 0.5
"""
import argparse, sys, math
from pathlib import Path
import bpy
from mathutils import Vector


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--body-name', required=True)
    p.add_argument('--tire-prefix', required=True)
    p.add_argument('--margin', type=float, default=0.075)
    p.add_argument('--depth', type=float, default=0.5)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    body = bpy.data.objects[a.body_name]
    before_verts = len(body.data.vertices)
    before_faces = len(body.data.polygons)

    tires = [o for o in bpy.context.scene.objects if o.name == a.tire_prefix or o.name.startswith(a.tire_prefix + '.')]
    print('Found %d tire objects for arch cutting' % len(tires))

    cutters = []
    for i, t in enumerate(tires):
        bbox = [t.matrix_world @ Vector(c) for c in t.bound_box]
        xs = [v.x for v in bbox]; ys = [v.y for v in bbox]; zs = [v.z for v in bbox]
        cx = (min(xs)+max(xs))/2.0
        cy = (min(ys)+max(ys))/2.0
        cz = (min(zs)+max(zs))/2.0
        radius = (max(ys)-min(ys))/2.0 + a.margin
        loc_x = max(xs) if cx > 0 else min(xs)  # push cutter to outboard face of tire (body wall side)
        bpy.ops.mesh.primitive_cylinder_add(vertices=32, radius=radius, depth=a.depth,
                                             location=(loc_x, cy, cz), rotation=(0, math.pi/2, 0))
        cutter = bpy.context.object
        cutter.name = 'ArchCutter_%d' % i
        cutters.append(cutter)
        print('Cutter %d: loc=(%.3f,%.3f,%.3f) radius=%.3f depth=%.3f' % (i, loc_x, cy, cz, radius, a.depth))

    for i, cutter in enumerate(cutters):
        mod = body.modifiers.new('WheelArchBool_%d' % i, 'BOOLEAN')
        mod.operation = 'DIFFERENCE'
        mod.object = cutter
        mod.solver = 'EXACT'

    bpy.context.view_layer.objects.active = body
    for mod in list(body.modifiers):
        if mod.type == 'BOOLEAN':
            bpy.ops.object.modifier_apply(modifier=mod.name)

    for cutter in cutters:
        bpy.data.objects.remove(cutter, do_unlink=True)

    after_verts = len(body.data.vertices)
    after_faces = len(body.data.polygons)
    print('BODY VERT/FACE BEFORE: %d/%d  AFTER: %d/%d' % (before_verts, before_faces, after_verts, after_faces))

    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out))
    print('Saved', out)


if __name__ == '__main__':
    main()
