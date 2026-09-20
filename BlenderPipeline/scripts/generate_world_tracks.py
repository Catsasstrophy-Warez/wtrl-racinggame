"""WTRL world-track ribbon-road blockout generator.

Run with Blender in background mode:
  blender -b --python generate_world_tracks.py -- --manifest world_tracks_manifest.json --out export/world_tracks

Builds a simple ribbon-road mesh (a ground-hugging quad strip following
the same waypoint coordinates as WTRL.World.SampleContent /
WTRL.Racing.SampleContent) for every track. Oval tracks apply a real
cross-section roll (banking) through their turns, matching each
track's WTRL.World.TrackDefinition.BankingDegrees.

Like generate_mobile_fleet.py, this is a bootstrap/blockout: a flat
road ribbon with no elevation, no barriers, no run-off, no surface
texture -- proof of layout and scale, not finished track art. In
particular, the "forest elevation"/"coastal drop" archetypes' actual
elevation change is NOT modeled here (this project has no
terrain/heightmap system anywhere yet) -- only their 2D shape is.
"""
import argparse
import json
import math
import sys
from pathlib import Path

import bpy


def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for datablocks in (bpy.data.meshes, bpy.data.materials):
        for block in list(datablocks):
            if block.users == 0:
                datablocks.remove(block)


def material(name, color, roughness=0.85):
    m = bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1.0)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*color, 1.0)
    bsdf.inputs["Roughness"].default_value = roughness
    return m


def build_oval_nodes(straight_length, turn_radius, banking_deg, nodes_per_turn=6):
    """Mirrors WTRL.Racing.SampleContent.BuildOvalLine exactly -- same
    stadium-shape loop (2 straights + 2 semicircular ends), so this
    Blender geometry matches the C# AI racing line's actual shape."""
    half = straight_length / 2.0
    nodes = [(-half, -turn_radius, 0.0), (half, -turn_radius, 0.0)]

    for i in range(1, nodes_per_turn):
        t = i / nodes_per_turn
        angle = -math.pi / 2 + t * math.pi
        nodes.append((half + turn_radius * math.cos(angle), turn_radius * math.sin(angle), banking_deg))

    nodes.append((half, turn_radius, 0.0))
    nodes.append((-half, turn_radius, 0.0))

    for i in range(1, nodes_per_turn):
        t = i / nodes_per_turn
        angle = math.pi / 2 + t * math.pi
        nodes.append((-half + turn_radius * math.cos(angle), turn_radius * math.sin(angle), banking_deg))

    return nodes, True


def make_ribbon(track_id, nodes_xzb, closed, width_m, out_dir, road_color):
    """nodes_xzb: list of (x, z, banking_deg). Builds a single quad-strip
    road surface following the polyline, banked per-node where
    banking_deg is nonzero."""
    clear_scene()
    road_mat = material(f"{track_id}_road", road_color)

    count = len(nodes_xzb)
    verts = []
    faces = []

    def perpendicular(i):
        prev_i = (i - 1) % count if closed else max(0, i - 1)
        next_i = (i + 1) % count if closed else min(count - 1, i + 1)
        x0, z0, _ = nodes_xzb[prev_i]
        x1, z1, _ = nodes_xzb[next_i]
        dx, dz = x1 - x0, z1 - z0
        length = math.hypot(dx, dz)
        if length < 1e-6:
            return 1.0, 0.0
        return -dz / length, dx / length

    # NOTE on the vertex layout below: empirically, Blender's default FBX
    # export axis remap (as this pipeline always uses it) turns local
    # Blender-space (a, b, c) into Unity-space (a, c, -b) -- confirmed by
    # comparing the vehicle export's known intended (width, height,
    # length) against its observed Unity bounds. Pre-compensating for
    # that HERE (baking (x, -lengthZ, heightY) into the actual exported
    # vertex data, not a Unity-side runtime rotation) means the imported
    # mesh lands correctly as Unity (width=X, height=Y, length=Z) with
    # ZERO extra rotation needed on the Unity side -- avoiding a second,
    # separately-confirmed bug where changing Transform.rotation at
    # runtime in this environment's headless batchmode does not reliably
    # propagate to computed vertex/bounds queries (see
    # Editor/ModelBoundsDiagnostic.cs's own notes on that).
    half_w = width_m / 2.0
    for i, (x, z, banking) in enumerate(nodes_xzb):
        px, pz = perpendicular(i)
        roll = math.radians(banking)
        # Bank the cross-section: outer edge (away from track center) rises.
        rise = half_w * math.sin(roll)
        left_x = x - px * half_w * math.cos(roll)
        left_z = z - pz * half_w * math.cos(roll)
        right_x = x + px * half_w * math.cos(roll)
        right_z = z + pz * half_w * math.cos(roll)
        verts.append((-left_x, -left_z, rise))
        verts.append((-right_x, -right_z, rise))

    segment_count = count if closed else count - 1
    for i in range(segment_count):
        a = i * 2
        b = ((i + 1) % count) * 2
        # Reversed winding order (a, b, b+1, a+1 instead of a, a+1, b+1, b)
        # to compensate for the X-axis mirror baked into each vertex
        # above -- a single-axis mirror flips face chirality/normal
        # direction, so this keeps the road surface's normal pointing up
        # rather than into the ground.
        faces.append((a, b, b + 1, a + 1))

    mesh = bpy.data.meshes.new(f"{track_id}_mesh")
    mesh.from_pydata(verts, [], faces)
    mesh.update()
    obj = bpy.data.objects.new(track_id, mesh)
    bpy.context.scene.collection.objects.link(obj)
    obj.data.materials.append(road_mat)

    bpy.context.scene[f"wtrl_track_id"] = track_id
    bpy.context.scene["wtrl_track_blockout"] = True

    out_dir.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out_dir / f"{track_id}.blend"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    manifest = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    out_dir = Path(args.out)

    built = 0
    for track in manifest["explicitTracks"]:
        nodes = [(x, z, 0.0) for x, z in track["nodes"]]
        make_ribbon(track["id"], nodes, track["closed"], track["widthM"], out_dir, (0.15, 0.15, 0.16))
        built += 1

    for track in manifest["ovalTracks"]:
        nodes, closed = build_oval_nodes(track["straightLengthM"], track["turnRadiusM"], track["bankingDeg"])
        make_ribbon(track["id"], nodes, closed, track["widthM"], out_dir, (0.17, 0.17, 0.19))
        built += 1

    print(f"Generated {built} WTRL world-track ribbon blockouts in {out_dir}")


if __name__ == "__main__":
    main()
