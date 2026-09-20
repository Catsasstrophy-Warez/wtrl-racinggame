"""Lineage-aware refinement pass for generated WTRL vehicle blockouts.

This pass is deliberately procedural and repeatable. It upgrades all generated
blockouts with family-specific proportions and recognizable visual cues while
keeping mobile-friendly geometry and stable collection names.
"""
import argparse
import math
import re
import sys
from pathlib import Path

import bpy


def mat(name, color, metallic=0.0, roughness=0.45):
    m = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1.0)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*color, 1.0)
    bsdf.inputs["Metallic"].default_value = metallic
    bsdf.inputs["Roughness"].default_value = roughness
    return m


def collection(name):
    c = bpy.data.collections.get(name)
    if not c:
        c = bpy.data.collections.new(name)
        bpy.context.scene.collection.children.link(c)
    return c


def cube(name, loc, scale, material, bevel=0.04, col=None):
    bpy.ops.mesh.primitive_cube_add(location=loc)
    o = bpy.context.object
    o.name = name
    o.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if bevel:
        b = o.modifiers.new("RefinementBevel", "BEVEL")
        b.width = bevel
        b.segments = 2
    o.data.materials.append(material)
    if col:
        for old in list(o.users_collection):
            old.objects.unlink(o)
        col.objects.link(o)
    return o


def cyl(name, loc, radius, depth, material, rotation=(math.pi / 2, 0, 0), col=None):
    bpy.ops.mesh.primitive_cylinder_add(vertices=16, radius=radius, depth=depth, location=loc, rotation=rotation)
    o = bpy.context.object
    o.name = name
    o.data.materials.append(material)
    if col:
        for old in list(o.users_collection):
            old.objects.unlink(o)
        col.objects.link(o)
    return o


def style_for(name):
    n = name.lower()
    if any(x in n for x in ("viper", "911", "porsche", "gt40", "ford gt", "gt90", "m1", "corvette", "crownfire apex", "legend gt")):
        return "exotic"
    if any(x in n for x in ("skyline", "supra", "fairlady", "civic", "integra", "corolla", "celica", "focus", "escort", "sierra", "lotus", "puma")):
        return "tuner"
    if any(x in n for x in ("bmw", "m3", "m4", "cts", "blackwing", "vogel")):
        return "touring"
    if any(x in n for x in ("eldorado", "continental", "allante", "lincoln", "coupe deville", "magnum")):
        return "luxury"
    if any(x in n for x in ("mustang", "shelby", "boss", "charger", "challenger", "camaro", "chevelle", "gto", "firebird", "torino", "galaxie", "falcon", "crownfire", "duquesne")):
        return "muscle"
    if any(x in n for x in ("sentinel", "vector", "rhino", "phantom", "hunter", "interceptor", "police")):
        return "enforcement"
    return "sports"


def refine(path, out_dir):
    bpy.ops.wm.open_mainfile(filepath=str(path))
    name = bpy.context.scene.get("wtrl_display_name", path.stem)
    style = style_for(name)
    vid = bpy.context.scene.get("wtrl_vehicle_id", path.stem)
    root = collection(f"{vid}_ROOT")
    render = collection(f"{vid}_LOD0_RENDER")
    accents = collection(f"{vid}_LINEAGE_DETAILS")
    body = mat(f"{vid}_LineagePaint", {
        "muscle": (0.42, 0.055, 0.025),
        "tuner": (0.025, 0.16, 0.27),
        "touring": (0.18, 0.19, 0.22),
        "luxury": (0.10, 0.12, 0.15),
        "exotic": (0.30, 0.025, 0.055),
        "enforcement": (0.025, 0.03, 0.035),
        "sports": (0.08, 0.22, 0.12),
    }[style], metallic=0.35, roughness=0.30)
    dark = mat(f"{vid}_LineageTrim", (0.012, 0.014, 0.018), metallic=0.45, roughness=0.28)
    chrome = mat(f"{vid}_LineageChrome", (0.42, 0.45, 0.48), metallic=0.9, roughness=0.18)
    lamp = mat(f"{vid}_LineageLamp", (0.95, 0.62, 0.18), metallic=0.0, roughness=0.2)

    # Scale the base shell by design family.
    body_obj = bpy.data.objects.get(f"{vid}_BodyShell")
    cabin = bpy.data.objects.get(f"{vid}_Cabin")
    if body_obj:
        factors = {"muscle": (1.08, 1.0, 1.04), "tuner": (0.98, 0.92, 1.08), "touring": (1.04, 1.0, 1.02), "luxury": (1.12, 1.04, 1.0), "exotic": (1.05, 0.84, 1.10), "enforcement": (1.14, 1.08, 0.98), "sports": (1.0, 0.92, 1.04)}[style]
        body_obj.scale = factors
    if cabin:
        cabin.scale = {"muscle": (1.08, 0.90, 1.02), "tuner": (0.96, 0.86, 1.0), "touring": (1.05, 0.98, 1.04), "luxury": (1.10, 1.05, 1.02), "exotic": (0.94, 0.72, 1.0), "enforcement": (1.12, 1.06, 1.02), "sports": (1.0, 0.86, 1.02)}[style]

    # Shared stance: wider/sportier families get wider wheel visual markers.
    stance = {"muscle": 1.08, "tuner": 1.10, "touring": 1.04, "luxury": 0.98, "exotic": 1.14, "enforcement": 1.10, "sports": 1.06}[style]
    for o in render.objects:
        if "Wheel_" in o.name:
            o.scale.y *= stance

    # Period/lineage cues kept as low-poly detail objects.
    if style in ("muscle", "luxury"):
        cube(f"{vid}_FrontChrome", (-2.18, 0.68, 0), (0.08, 0.15, 0.72), chrome, 0.03, accents)
        cube(f"{vid}_RearChrome", (2.18, 0.68, 0), (0.08, 0.12, 0.72), chrome, 0.03, accents)
        cube(f"{vid}_HoodScoop", (-0.35, 1.02, 0), (0.55, 0.10, 0.18), dark, 0.04, accents)
    if style in ("tuner", "exotic", "sports"):
        cube(f"{vid}_FrontSplitter", (-2.30, 0.40, 0), (0.18, 0.04, 0.78), dark, 0.02, accents)
        cube(f"{vid}_RearDiffuser", (2.25, 0.40, 0), (0.18, 0.05, 0.78), dark, 0.02, accents)
        cube(f"{vid}_RearWing", (1.55, 1.28, 0), (0.10, 0.06, 0.78 if style != 'exotic' else 0.95), dark, 0.02, accents)
    if style == "touring":
        cube(f"{vid}_TrackLip", (-2.18, 0.55, 0), (0.14, 0.06, 0.82), dark, 0.02, accents)
        cube(f"{vid}_RoofSpoiler", (1.72, 1.28, 0), (0.12, 0.06, 0.70), dark, 0.02, accents)
    if style == "enforcement":
        cube(f"{vid}_PushBar", (-2.32, 0.70, 0), (0.10, 0.28, 0.82), chrome, 0.03, accents)
        cube(f"{vid}_Lightbar", (-0.10, 1.42, 0), (0.44, 0.05, 0.18), lamp, 0.02, accents)
    # Headlamps and tail lamps are shared visual anchors.
    for z in (-0.42, 0.42):
        cube(f"{vid}_Headlamp_{z}", (-2.28, 0.80, z), (0.05, 0.12, 0.12), lamp, 0.02, accents)
    for z in (-0.42, 0.42):
        cube(f"{vid}_TailLamp_{z}", (2.28, 0.80, z), (0.05, 0.10, 0.12), lamp, 0.02, accents)

    bpy.context.scene["wtrl_refined"] = True
    bpy.context.scene["wtrl_lineage_style"] = style
    out_dir.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(out_dir / path.name))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    source = Path(args.input)
    out = Path(args.out)
    files = sorted(source.glob("*.blend"))
    for f in files:
        refine(f, out)
    print(f"Refined {len(files)} WTRL vehicles into {out}")


if __name__ == "__main__":
    main()
