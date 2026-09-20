"""Author real door/hood/deck panel seam geometry into the body shell mesh.

The existing *_DOOR_FRONT_SEAM / *_DOOR_REAR_SEAM / *_HOOD_SEAM / *_DECK_SEAM
objects in these files are thin decorative MESH boxes overlaid on the body
surface (not empties/curves, and not real body-shell topology). This script
uses their positions to bisect the body shell mesh with a plane and bevel the
resulting new edge loop, producing an actual creased seam line cut into the
body topology, restricted to the panel's Z (or X) extent where possible.

Usage:
  blender -b --python add_panel_seams.py -- --input in.blend --out out.blend \
      --body-name Crownfire_BODY_SHELL --prefix Crownfire
"""
import argparse, sys
from pathlib import Path
import bpy, bmesh
from mathutils import Vector, Matrix


def seam_positions(prefix):
    objs = {}
    for o in bpy.context.scene.objects:
        for tag in ('DOOR_FRONT_SEAM', 'DOOR_REAR_SEAM', 'HOOD_SEAM', 'DECK_SEAM'):
            name = '%s_%s' % (prefix, tag)
            if o.name == name or o.name.startswith(name + '.'):
                objs.setdefault(tag, []).append(o)
    return objs


def bbox_world(o):
    bbox = [o.matrix_world @ Vector(c) for c in o.bound_box]
    xs = [v.x for v in bbox]; ys = [v.y for v in bbox]; zs = [v.z for v in bbox]
    return (min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))


def cut_seam_ring(body, plane_co, plane_no, z_range=None, x_range=None, bevel_width=0.012):
    me = body.data
    bm = bmesh.new()
    bm.from_mesh(me)
    bm.faces.ensure_lookup_table()

    def in_range(f):
        c = f.calc_center_median()
        if z_range and not (z_range[0] - 0.05 <= c.z <= z_range[1] + 0.05):
            return False
        if x_range and not (x_range[0] - 0.05 <= c.x <= x_range[1] + 0.05):
            return False
        return True

    geom = [f for f in bm.faces if in_range(f)]
    geom += [e for f in geom for e in f.edges]
    geom += [v for f in geom for v in f.verts]
    if not geom:
        bm.free()
        return 0

    res = bmesh.ops.bisect_plane(bm, geom=list(set(geom)), dist=1e-5,
                                  plane_co=plane_co, plane_no=plane_no,
                                  clear_inner=False, clear_outer=False)
    new_edges = [e for e in res['geom_cut'] if isinstance(e, bmesh.types.BMEdge)]
    n = len(new_edges)
    if new_edges:
        bmesh.ops.bevel(bm, geom=new_edges, offset=bevel_width, segments=2,
                         affect='EDGES', clamp_overlap=True)
    bm.to_mesh(me)
    bm.free()
    me.update()
    return n


def main():
    av = sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--body-name', required=True)
    p.add_argument('--prefix', required=True)
    a = p.parse_args(av)

    bpy.ops.wm.open_mainfile(filepath=a.input)
    body = bpy.data.objects[a.body_name]
    before_verts = len(body.data.vertices)
    before_faces = len(body.data.polygons)

    seams = seam_positions(a.prefix)
    total_cuts = 0
    for tag, objs in seams.items():
        for o in objs:
            xr, yr, zr = bbox_world(o)
            if tag in ('DOOR_FRONT_SEAM', 'DOOR_REAR_SEAM', 'DECK_SEAM'):
                # thin box, longest axis differs: DECK_SEAM spans X (a cross seam), doors span Y (const Z plane)
                if tag == 'DECK_SEAM':
                    z_mid = (zr[0] + zr[1]) / 2.0
                    n = cut_seam_ring(body, Vector((0, 0, z_mid)), Vector((0, 0, 1)),
                                       z_range=None)
                else:
                    z_mid = (zr[0] + zr[1]) / 2.0
                    # restrict the cut to this side of the car only (avoid mirroring to the other door)
                    x_lo, x_hi = (0, xr[1] + 0.2) if xr[0] > 0 else (xr[0] - 0.2, 0)
                    n = cut_seam_ring(body, Vector((0, 0, z_mid)), Vector((0, 0, 1)),
                                       x_range=(x_lo, x_hi))
            elif tag == 'HOOD_SEAM':
                x_mid = (xr[0] + xr[1]) / 2.0
                n = cut_seam_ring(body, Vector((x_mid, 0, 0)), Vector((1, 0, 0)),
                                   z_range=zr)
            else:
                n = 0
            total_cuts += n
            print('Seam %s (obj %s) -> %d new edges cut/beveled' % (tag, o.name, n))

    after_verts = len(body.data.vertices)
    after_faces = len(body.data.polygons)
    print('BODY VERT/FACE BEFORE: %d/%d AFTER: %d/%d, total seam edges: %d' % (
        before_verts, before_faces, after_verts, after_faces, total_cuts))

    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out))
    print('Saved', out)


if __name__ == '__main__':
    main()
