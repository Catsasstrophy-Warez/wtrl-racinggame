"""WTRL mobile fleet blockout generator.

Run with Blender in background mode:
  blender -b --python generate_mobile_fleet.py -- --manifest catalog_manifest.json --out export

The generator intentionally creates a consistent, low-cost blockout rather than
pretending to be a finished historically accurate vehicle model. Each output is
named from the stable catalog ID and includes render, collision, wheel-marker,
and LOD collections so Unity import automation can consume it.
"""
import argparse
import json
import math
import os
import sys
from pathlib import Path

import bpy
from mathutils import Vector


def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for datablocks in (bpy.data.meshes, bpy.data.curves, bpy.data.materials, bpy.data.cameras, bpy.data.lights):
        for block in list(datablocks):
            if block.users == 0:
                datablocks.remove(block)


def material(name, color, metallic=0.0, roughness=0.45):
    m = bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1.0)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*color, 1.0)
    bsdf.inputs["Metallic"].default_value = metallic
    bsdf.inputs["Roughness"].default_value = roughness
    return m


def cube(name, location, scale, mat, bevel=0.0, collection=None):
    bpy.ops.mesh.primitive_cube_add(location=location)
    o = bpy.context.object
    o.name = name
    o.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if bevel:
        mod = o.modifiers.new("MobileBevel", "BEVEL")
        mod.width = bevel
        mod.segments = 2
    o.data.materials.append(mat)
    if collection:
        for c in list(o.users_collection):
            c.objects.unlink(o)
        collection.objects.link(o)
    return o


def wheel(name, location, radius, width, tire_mat, collection):
    bpy.ops.mesh.primitive_cylinder_add(vertices=16, radius=radius, depth=width, rotation=(math.pi / 2, 0, 0), location=location)
    o = bpy.context.object
    o.name = name
    o.data.materials.append(tire_mat)
    collection.objects.link(o)
    for c in list(o.users_collection):
        if c != collection:
            c.objects.unlink(o)
    return o


def make_vehicle(entry, out_dir):
    clear_scene()
    vid = entry["id"]
    name = entry.get("displayName", vid)
    profile = entry.get("profile", {})
    body_color = tuple(profile.get("bodyColor", [0.18, 0.24, 0.32]))
    body = material(f"{vid}_Body", body_color, metallic=0.25, roughness=0.32)
    glass = material(f"{vid}_Glass", (0.04, 0.08, 0.12), metallic=0.0, roughness=0.16)
    tire = material(f"{vid}_Tire", (0.015, 0.015, 0.015), roughness=0.82)
    metal = material(f"{vid}_Metal", (0.28, 0.30, 0.32), metallic=0.8, roughness=0.24)

    root = bpy.data.collections.new(f"{vid}_ROOT")
    bpy.context.scene.collection.children.link(root)
    render = bpy.data.collections.new(f"{vid}_LOD0_RENDER")
    lod1 = bpy.data.collections.new(f"{vid}_LOD1_RENDER")
    lod2 = bpy.data.collections.new(f"{vid}_LOD2_RENDER")
    colliders = bpy.data.collections.new(f"{vid}_COLLIDERS")
    markers = bpy.data.collections.new(f"{vid}_SERVICE_MARKERS")
    for c in (render, lod1, lod2, colliders, markers):
        root.children.link(c)

    length = float(profile.get("length", 4.65))
    width = float(profile.get("width", 1.82))
    height = float(profile.get("height", 1.28))
    wheelbase = float(profile.get("wheelbase", 2.72))
    track = float(profile.get("track", 1.55))
    wheel_r = float(profile.get("wheelRadius", 0.34))

    cube(f"{vid}_BodyShell", (0, 0.68, 0), (length * 0.48, height * 0.23, width * 0.48), body, 0.12, render)
    cube(f"{vid}_Cabin", (-0.10, 1.04, 0), (length * 0.22, height * 0.20, width * 0.39), glass, 0.10, render)
    cube(f"{vid}_Collision", (0, 0.70, 0), (length * 0.47, height * 0.25, width * 0.46), tire, 0.0, colliders)
    for x in (-wheelbase / 2, wheelbase / 2):
        for y in (-track / 2, track / 2):
            wheel(f"{vid}_Wheel_{'F' if x < 0 else 'R'}_{'L' if y < 0 else 'R'}", (x, wheel_r, y), wheel_r, 0.22, tire, render)
            marker = cube(f"{vid}_WheelMarker_{x}_{y}", (x, wheel_r, y), (0.04, 0.04, 0.04), metal, 0, markers)
            marker.hide_render = True
    cube(f"{vid}_LOD1_Body", (0, 0.70, 0), (length * 0.47, height * 0.24, width * 0.47), body, 0.10, lod1)
    cube(f"{vid}_LOD2_Body", (0, 0.70, 0), (length * 0.46, height * 0.23, width * 0.46), body, 0.08, lod2)

    bpy.context.scene["wtrl_vehicle_id"] = vid
    bpy.context.scene["wtrl_display_name"] = name
    bpy.context.scene["wtrl_generation"] = entry.get("generation", "unknown")
    bpy.context.scene["wtrl_mobile_blockout"] = True
    bpy.context.scene["wtrl_unity_scale_meters"] = 1.0

    out_dir.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out_dir / f"{vid}.blend"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    manifest = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    out_dir = Path(args.out)
    for entry in manifest["vehicles"]:
        make_vehicle(entry, out_dir)
    print(f"Generated {len(manifest['vehicles'])} WTRL mobile vehicle blockouts in {out_dir}")


if __name__ == "__main__":
    main()
