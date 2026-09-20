"""Cleans up boolean/bevel seam artifacts (near-duplicate vertices,
sliver faces) on the vehicle body shells left over from
add_wheel_arches.py + add_panel_seams.py. Unity's FBX importer was
logging "self-intersecting polygon discarded" warnings on
Crownfire_BODY_SHELL after that pass -- Blender's own bmesh health
check (non_manifold_edges, degenerate_faces) found ZERO of either, so
this isn't topology damage, it's tiny near-coincident geometry at the
boolean cut seam. Standard fix: merge-by-distance (weld near-duplicate
verts from the boolean solver) + recalculate outside normals +
limited dissolve of nearly-flat sliver faces.

Usage:
    blender -b <file.blend> --python clean_body_mesh_artifacts.py -- --object <name> --output <file.blend>
"""
import argparse
import sys

import bmesh
import bpy


def main():
    av = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument("--object", required=True)
    p.add_argument("--output", required=True)
    a = p.parse_args(av)

    obj = bpy.data.objects.get(a.object)
    if obj is None:
        raise SystemExit(f"object {a.object} not found")

    before_verts = len(obj.data.vertices)
    before_faces = len(obj.data.polygons)

    bm = bmesh.new()
    bm.from_mesh(obj.data)

    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=0.0008)
    bmesh.ops.dissolve_degenerate(bm, dist=0.0005, edges=bm.edges)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)

    bm.to_mesh(obj.data)
    obj.data.update()
    bm.free()

    after_verts = len(obj.data.vertices)
    after_faces = len(obj.data.polygons)

    print(f"CLEANED object={a.object} verts {before_verts}->{after_verts} faces {before_faces}->{after_faces}")

    bpy.ops.wm.save_as_mainfile(filepath=a.output)
    print(f"SAVED {a.output}")


if __name__ == "__main__":
    main()
