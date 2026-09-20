"""Propagate representative design-anchor metadata and mobile detail to the rest."""
import argparse
import math
import sys
from pathlib import Path
import bpy

ANCHOR_NAMES = {"1967_crownfire_original.blend", "marsh_nsx91.blend", "sentinel_county_v8.blend", "vector_highway_interceptor.blend", "rhino_heavy_containment.blend", "phantom_special_response.blend", "apex_state_hunter.blend", "1968_charger_r_t.blend", "1992_viper_rt_10.blend", "1967_camaro_ss_396.blend", "1963_corvette_split_window.blend", "1965_gto_tri_power.blend", "1959_eldorado_biarritz.blend", "1956_continental_mark_ii.blend", "1969_fairlady_2000.blend", "1969_skyline_2000gt_r_sedan.blend", "1967_toyota_2000gt.blend", "1972_celica_1600gt.blend", "1985_crx_si.blend", "1973_bmw_3_0_csl.blend", "1967_911s.blend", "1964_galaxie_500_lightweight_427_sohc.blend", "1965_lotus_cortina_mk1.blend", "1966_gt40_mk_ii.blend", "1965_shelby_gt350_reference.blend"}


def style(name):
    n = name.lower()
    if any(x in n for x in ("sentinel", "vector", "rhino", "phantom", "hunter", "interceptor", "police")): return "enforcement"
    if any(x in n for x in ("viper", "911", "porsche", "gt40", "ford gt", "gt90", "m1", "corvette", "apex", "legend")): return "exotic"
    if any(x in n for x in ("skyline", "supra", "fairlady", "civic", "integra", "corolla", "celica", "focus", "escort", "sierra", "lotus", "puma")): return "tuner"
    if any(x in n for x in ("bmw", "m3", "m4", "cts", "blackwing")): return "touring"
    if any(x in n for x in ("eldorado", "continental", "allante", "lincoln", "deville", "magnum")): return "luxury"
    return "muscle"


def mat(name, color, metallic=0.0):
    m = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1)
    m.use_nodes = True
    b = m.node_tree.nodes.get("Principled BSDF")
    b.inputs["Base Color"].default_value = (*color, 1)
    b.inputs["Metallic"].default_value = metallic
    b.inputs["Roughness"].default_value = 0.3
    return m


def cube(name, loc, scale, material, col):
    bpy.ops.mesh.primitive_cube_add(location=loc)
    o = bpy.context.object
    o.name = name
    o.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    b = o.modifiers.new("PropagatedBevel", "BEVEL")
    b.width = 0.025
    b.segments = 2
    o.data.materials.append(material)
    for old in list(o.users_collection): old.objects.unlink(o)
    col.objects.link(o)


def refine(path, output):
    bpy.ops.wm.open_mainfile(filepath=str(path))
    vid = bpy.context.scene.get("wtrl_vehicle_id", path.stem)
    name = bpy.context.scene.get("wtrl_display_name", path.stem)
    s = style(name)
    col = bpy.data.collections.get(f"{vid}_REPRESENTATIVE_DETAIL") or bpy.data.collections.new(f"{vid}_PROPAGATED_DETAIL")
    if col.name not in [c.name for c in bpy.context.scene.collection.children]: bpy.context.scene.collection.children.link(col)
    trim = mat(f"{vid}_PropagatedTrim", (0.01, 0.015, 0.02), 0.7)
    accent = mat(f"{vid}_PropagatedAccent", (0.55, 0.07, 0.025) if s == "muscle" else (0.02, 0.18, 0.32) if s == "tuner" else (0.03, 0.03, 0.04), 0.3)
    if s == "enforcement":
        cube(f"{vid}_FleetPushProtection", (-2.35, 0.62, 0), (0.10, 0.18, 0.84), trim, col)
        cube(f"{vid}_FleetRoofModule", (-0.15, 1.38, 0), (0.34, 0.045, 0.16), accent, col)
    elif s in ("exotic", "tuner"):
        cube(f"{vid}_FleetFrontAero", (-2.32, 0.40, 0), (0.12, 0.035, 0.78), trim, col)
        cube(f"{vid}_FleetRearAero", (1.72, 1.25, 0), (0.10, 0.035, 0.70), trim, col)
    else:
        cube(f"{vid}_FleetHoodAccent", (-0.35, 1.12, 0), (0.46, 0.05, 0.24), accent, col)
        cube(f"{vid}_FleetBumper", (-2.34, 0.56, 0), (0.04, 0.08, 0.72), trim, col)
    bpy.context.scene["wtrl_representative_rules_propagated"] = True
    bpy.context.scene["wtrl_propagated_style"] = s
    output.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(output / path.name))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--anchors", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    src, anchors, out = Path(args.input), Path(args.anchors), Path(args.out)
    files = sorted(src.glob("*.blend"))
    done = 0
    for f in files:
        source = anchors / f.name if (anchors / f.name).exists() else f
        refine(source, out)
        done += 1
    print(f"Propagated representative rules across {done} vehicles")


if __name__ == "__main__": main()
