"""Dump object names/types/world transforms/bounding boxes for a .blend file.
Usage: blender -b --python dump_object_report.py -- --input file.blend
"""
import argparse, sys
import bpy
from mathutils import Vector

def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    a = p.parse_args(av)
    bpy.ops.wm.open_mainfile(filepath=a.input)
    print('=== OBJECT REPORT for %s ===' % a.input)
    for o in bpy.context.scene.objects:
        loc = o.matrix_world.translation
        if o.type == 'MESH':
            bbox = [o.matrix_world @ Vector(c) for c in o.bound_box]
            xs = [v.x for v in bbox]; ys = [v.y for v in bbox]; zs = [v.z for v in bbox]
            print('%-32s type=%-6s loc=(%.3f,%.3f,%.3f) bbox_x=[%.3f,%.3f] bbox_y=[%.3f,%.3f] bbox_z=[%.3f,%.3f] verts=%d faces=%d' % (
                o.name, o.type, loc.x, loc.y, loc.z, min(xs), max(xs), min(ys), max(ys), min(zs), max(zs),
                len(o.data.vertices), len(o.data.polygons)))
        else:
            print('%-32s type=%-6s loc=(%.3f,%.3f,%.3f)' % (o.name, o.type, loc.x, loc.y, loc.z))
    print('=== END REPORT ===')

if __name__ == '__main__':
    main()
