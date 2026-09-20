"""Re-open a saved .blend or re-import an exported .fbx and dump real mesh
stats (vertex count, face count, bounding box per mesh + totals) so pipeline
claims can be checked against actual headless output.

Usage:
  blender -b --python verify_mesh_stats.py -- --file path/to/file.blend_or_fbx
"""
import argparse, sys
from pathlib import Path
import bpy
from mathutils import Vector


def dump():
    total_v = total_f = 0
    for o in bpy.context.scene.objects:
        if o.type != 'MESH':
            continue
        bbox = [o.matrix_world @ Vector(c) for c in o.bound_box]
        xs = [v.x for v in bbox]; ys = [v.y for v in bbox]; zs = [v.z for v in bbox]
        v = len(o.data.vertices); f = len(o.data.polygons)
        total_v += v; total_f += f
        print('%-32s verts=%-6d faces=%-6d bbox=[%.2f,%.2f]x[%.2f,%.2f]x[%.2f,%.2f]' % (
            o.name, v, f, min(xs), max(xs), min(ys), max(ys), min(zs), max(zs)))
    print('TOTAL verts=%d faces=%d' % (total_v, total_f))


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--file', required=True)
    a = p.parse_args(av)
    path = Path(a.file)
    bpy.ops.wm.read_factory_settings(use_empty=True)
    if path.suffix.lower() == '.blend':
        bpy.ops.wm.open_mainfile(filepath=str(path))
    elif path.suffix.lower() == '.fbx':
        bpy.ops.import_scene.fbx(filepath=str(path))
    else:
        raise SystemExit('Unsupported file type: %s' % path.suffix)
    print('=== VERIFY %s ===' % path)
    dump()
    print('=== END VERIFY ===')


if __name__ == '__main__':
    main()
