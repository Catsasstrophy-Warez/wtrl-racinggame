"""WTRL world-track ribbon-road generator -- pass 2.

Run with Blender in background mode:
  blender -b --python generate_world_tracks.py -- --manifest world_tracks_manifest.json --out export/world_tracks

Builds, for every track: a UV-mapped road ribbon with a procedural
asphalt+centerline texture, two low barrier walls following each edge,
and (for tracks with an "elevationM" array in the manifest) real
vertical elevation change along the path -- not just the flat 2D shape
pass 1 shipped.

Still a blockout, not finished track art: no run-off/gravel trap
geometry, no distinct curb/rumble-strip mesh (the texture fakes a
centerline, nothing more), no foliage/scenery, and elevation is linear
interpolation between manifest waypoints, not a real terrain/heightmap
system (this project still has none). Barriers are a single straight
wall per side, not crash-tested guardrail geometry.
"""
import argparse
import json
import math
import sys
import tempfile
from pathlib import Path

import bpy

_TEXTURE_TMP_DIR = Path(tempfile.gettempdir()) / "wtrl_track_textures"


def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for datablocks in (bpy.data.meshes, bpy.data.materials, bpy.data.images):
        for block in list(datablocks):
            if block.users == 0:
                datablocks.remove(block)


def make_asphalt_image(name, size=256):
    """Procedurally paints a tileable asphalt texture directly into pixel
    data (no external texture asset, no PIL dependency) -- a dark,
    lightly-varied base with a dashed white centerline band, so the road
    reads as a road rather than a flat gray color. Tiles along V
    (the track's length direction); U 0..1 spans the road's width."""
    img = bpy.data.images.new(name, width=size, height=size)
    pixels = [0.0] * (size * size * 4)

    # Cheap deterministic pseudo-noise (no numpy/PIL dependency) --
    # good enough for a subtle asphalt grain, not meant to be a real
    # procedural material.
    def noise(x, y):
        n = math.sin(x * 12.9898 + y * 78.233) * 43758.5453
        return n - math.floor(n)

    for y in range(size):
        v = y / size  # along track length
        for x in range(size):
            u = x / size  # across track width
            idx = (y * size + x) * 4

            base = 0.09 + noise(x, y) * 0.03
            # Dashed centerline: a band around u=0.5, on for the first
            # half of each length-wise tile period, off for the second.
            on_centerline = abs(u - 0.5) < 0.03
            dash_on = (v * 10) % 1.0 < 0.55
            if on_centerline and dash_on:
                r = g = b = 0.85
            else:
                r = g = b = base

            pixels[idx] = r
            pixels[idx + 1] = g
            pixels[idx + 2] = b
            pixels[idx + 3] = 1.0

    img.pixels = pixels
    _save_image(img, name)
    return img


def _save_image(img, name):
    """Saves the image to an actual PNG file on disk and points the
    Blender image datablock at it. This turned out to be necessary, not
    optional: `Image.pack()` alone (packing the pixel data into the
    .blend file) was NOT enough for the FBX exporter's
    `embed_textures=True` to actually carry the texture into the
    exported file -- confirmed by importing the resulting FBX into
    Unity and finding its material's `mainTexture` was null despite
    `embed_textures=True` and a successful, error-free export. Giving
    the image a real `filepath_raw`/`file_format` and saving it before
    export fixed this."""
    _TEXTURE_TMP_DIR.mkdir(parents=True, exist_ok=True)
    path = _TEXTURE_TMP_DIR / f"{name}.png"
    img.filepath_raw = str(path)
    img.file_format = "PNG"
    img.save()


def make_barrier_image(name, size=64):
    """Alternating red/white barrier stripe, tiled along the wall's
    length -- the same cheap visibility convention real barrier/curbing
    uses, not a modeled physical barrier structure."""
    img = bpy.data.images.new(name, width=size, height=size)
    pixels = [0.0] * (size * size * 4)
    for y in range(size):
        v = y / size
        stripe_on = (v * 6) % 1.0 < 0.5
        r, g, b = (0.75, 0.05, 0.05) if stripe_on else (0.85, 0.85, 0.82)
        for x in range(size):
            idx = (y * size + x) * 4
            pixels[idx] = r
            pixels[idx + 1] = g
            pixels[idx + 2] = b
            pixels[idx + 3] = 1.0
    img.pixels = pixels
    _save_image(img, name)
    return img


def textured_material(name, image, roughness=0.8):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    nodes = m.node_tree.nodes
    links = m.node_tree.links
    bsdf = nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = roughness
    tex_node = nodes.new("ShaderNodeTexImage")
    tex_node.image = image
    links.new(tex_node.outputs["Color"], bsdf.inputs["Base Color"])
    return m


def build_oval_nodes(straight_length, turn_radius, banking_deg, nodes_per_turn=6):
    """Mirrors WTRL.Racing.SampleContent.BuildOvalLine exactly -- same
    stadium-shape loop (2 straights + 2 semicircular ends), so this
    Blender geometry matches the C# AI racing line's actual shape.
    Returns (x, z, banking, elevation=0) tuples -- ovals have no
    elevation data in the manifest, so this pass leaves them flat."""
    half = straight_length / 2.0
    nodes = [(-half, -turn_radius, 0.0, 0.0), (half, -turn_radius, 0.0, 0.0)]

    for i in range(1, nodes_per_turn):
        t = i / nodes_per_turn
        angle = -math.pi / 2 + t * math.pi
        nodes.append((half + turn_radius * math.cos(angle), turn_radius * math.sin(angle), banking_deg, 0.0))

    nodes.append((half, turn_radius, 0.0, 0.0))
    nodes.append((-half, turn_radius, 0.0, 0.0))

    for i in range(1, nodes_per_turn):
        t = i / nodes_per_turn
        angle = math.pi / 2 + t * math.pi
        nodes.append((-half + turn_radius * math.cos(angle), turn_radius * math.sin(angle), banking_deg, 0.0))

    return nodes, True


def _perpendiculars(nodes_xzbe, closed):
    count = len(nodes_xzbe)
    result = []
    for i in range(count):
        prev_i = (i - 1) % count if closed else max(0, i - 1)
        next_i = (i + 1) % count if closed else min(count - 1, i + 1)
        x0, z0 = nodes_xzbe[prev_i][0], nodes_xzbe[prev_i][1]
        x1, z1 = nodes_xzbe[next_i][0], nodes_xzbe[next_i][1]
        dx, dz = x1 - x0, z1 - z0
        length = math.hypot(dx, dz)
        result.append((1.0, 0.0) if length < 1e-6 else (-dz / length, dx / length))
    return result


def _cumulative_lengths(nodes_xzbe, closed):
    count = len(nodes_xzbe)
    seg_count = count if closed else count - 1
    lengths = [0.0]
    for i in range(seg_count):
        x0, z0 = nodes_xzbe[i][0], nodes_xzbe[i][1]
        j = (i + 1) % count
        x1, z1 = nodes_xzbe[j][0], nodes_xzbe[j][1]
        lengths.append(lengths[-1] + math.hypot(x1 - x0, z1 - z0))
    return lengths


# See make_ribbon's own note: everything here is baked to already match
# Unity's axis convention post-FBX-export, exactly like pass 1's ribbon
# and the vehicle models -- (x, z_length, y_height) input becomes
# Blender-local (-x, -z_length, y_height), exported to land correctly
# in Unity with zero additional rotation.

def make_ribbon(track_id, nodes_xzbe, closed, width_m, out_dir, barrier_offset_m=0.4, barrier_height_m=0.5):
    """nodes_xzbe: list of (x, z, banking_deg, elevation_m). Builds the
    road ribbon (UV-mapped, textured) plus a barrier wall along each
    edge."""
    clear_scene()

    road_image = make_asphalt_image(f"{track_id}_asphalt")
    road_mat = textured_material(f"{track_id}_road_mat", road_image)
    barrier_image = make_barrier_image(f"{track_id}_barrier_stripe")
    barrier_mat = textured_material(f"{track_id}_barrier_mat", barrier_image, roughness=0.6)

    count = len(nodes_xzbe)
    perp = _perpendiculars(nodes_xzbe, closed)
    cum_len = _cumulative_lengths(nodes_xzbe, closed)
    tile_length_m = 8.0  # one texture repeat every 8m along the track

    half_w = width_m / 2.0
    road_verts, road_faces, road_uvs = [], [], []
    barrier_l_verts, barrier_l_faces = [], []
    barrier_r_verts, barrier_r_faces = [], []

    for i, (x, z, banking, elevation) in enumerate(nodes_xzbe):
        px, pz = perp[i]
        roll = math.radians(banking)
        bank_rise = half_w * math.sin(roll)
        cos_roll = math.cos(roll)

        left_x = x - px * half_w * cos_roll
        left_z = z - pz * half_w * cos_roll
        right_x = x + px * half_w * cos_roll
        right_z = z + pz * half_w * cos_roll

        # Baked axis pre-compensation (see module doc): output as
        # (-x, -z, height).
        road_verts.append((-left_x, -left_z, elevation + bank_rise))
        road_verts.append((-right_x, -right_z, elevation + bank_rise))

        # Barrier walls: offset further outward from each edge, as a
        # short vertical quad strip (top vertex only added once per
        # node; base is the road edge itself's elevation).
        bl_x = x - px * (half_w + barrier_offset_m)
        bl_z = z - pz * (half_w + barrier_offset_m)
        br_x = x + px * (half_w + barrier_offset_m)
        br_z = z + pz * (half_w + barrier_offset_m)
        barrier_l_verts.append((-bl_x, -bl_z, elevation + bank_rise))
        barrier_l_verts.append((-bl_x, -bl_z, elevation + bank_rise + barrier_height_m))
        barrier_r_verts.append((-br_x, -br_z, elevation + bank_rise))
        barrier_r_verts.append((-br_x, -br_z, elevation + bank_rise + barrier_height_m))

    segment_count = count if closed else count - 1
    for i in range(segment_count):
        a = i * 2
        b = ((i + 1) % count) * 2
        # Reversed winding (a, b, b+1, a+1) to compensate for the
        # X-axis mirror baked into each vertex -- keeps normals up.
        road_faces.append((a, b, b + 1, a + 1))

        v0 = cum_len[i] / tile_length_m
        v1 = cum_len[i + 1] / tile_length_m
        # Per-face UVs matching the reversed winding order above:
        # (a=left0, b=left1, b+1=right1, a+1=right0).
        road_uvs.extend([(0.0, v0), (0.0, v1), (1.0, v1), (1.0, v0)])

        ba = i * 2
        bb = ((i + 1) % count) * 2
        barrier_l_faces.append((ba, bb, bb + 1, ba + 1))
        barrier_r_faces.append((ba, bb, bb + 1, ba + 1))

    road_obj = _build_object(f"{track_id}_road", road_verts, road_faces, road_mat, uvs=road_uvs)
    barrier_l_obj = _build_object(f"{track_id}_barrier_left", barrier_l_verts, barrier_l_faces, barrier_mat)
    barrier_r_obj = _build_object(f"{track_id}_barrier_right", barrier_r_verts, barrier_r_faces, barrier_mat)

    bpy.context.scene["wtrl_track_id"] = track_id
    bpy.context.scene["wtrl_track_blockout"] = True

    out_dir.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out_dir / f"{track_id}.blend"))


def _build_object(name, verts, faces, mat, uvs=None):
    mesh = bpy.data.meshes.new(f"{name}_mesh")
    mesh.from_pydata(verts, [], faces)
    mesh.update()

    if uvs:
        mesh.uv_layers.new(name="UVMap")
        uv_layer = mesh.uv_layers.active.data
        for loop_index, uv in enumerate(uvs):
            uv_layer[loop_index].uv = uv

    obj = bpy.data.objects.new(name, mesh)
    bpy.context.scene.collection.objects.link(obj)
    obj.data.materials.append(mat)
    return obj


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    manifest = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    out_dir = Path(args.out)

    built = 0
    for track in manifest["explicitTracks"]:
        elevations = track.get("elevationM")
        nodes = [
            (x, z, 0.0, (elevations[i] if elevations else 0.0))
            for i, (x, z) in enumerate(track["nodes"])
        ]
        make_ribbon(track["id"], nodes, track["closed"], track["widthM"], out_dir)
        built += 1

    for track in manifest["ovalTracks"]:
        nodes, closed = build_oval_nodes(track["straightLengthM"], track["turnRadiusM"], track["bankingDeg"])
        make_ribbon(track["id"], nodes, closed, track["widthM"], out_dir)
        built += 1

    print(f"Generated {built} WTRL world-track ribbons (textured, barriered, elevation-aware) in {out_dir}")


if __name__ == "__main__":
    main()
