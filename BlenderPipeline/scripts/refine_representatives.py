"""Representative-quality detail pass for WTRL's anchor vehicles."""
import argparse
import math
import sys
from pathlib import Path
import bpy

REPRESENTATIVES = {
    "marsh_nsx91.blend": "marsh_rival",
    "1967_crownfire_original.blend": "hero_muscle",
    "1968_charger_r_t.blend": "mopar_muscle",
    "1992_viper_rt_10.blend": "viper_exotic",
    "1967_camaro_ss_396.blend": "bowtie_muscle",
    "1963_corvette_split_window.blend": "fiberglass_gt",
    "1965_gto_tri_power.blend": "wide_track",
    "1959_eldorado_biarritz.blend": "cadillac_luxury",
    "1956_continental_mark_ii.blend": "lincoln_luxury",
    "1969_fairlady_2000.blend": "fairlady_z",
    "1969_skyline_2000gt_r_sedan.blend": "skyline",
    "1967_toyota_2000gt.blend": "toyota_gt",
    "1972_celica_1600gt.blend": "toyota_lightweight",
    "1985_crx_si.blend": "honda_vtec",
    "1973_bmw_3_0_csl.blend": "bmw_motorsport",
    "1967_911s.blend": "porsche_rear",
    "1964_galaxie_500_lightweight_427_sohc.blend": "ford_heavy_iron",
    "1965_lotus_cortina_mk1.blend": "ford_homologation",
    "1966_gt40_mk_ii.blend": "ford_endurance",
    "1965_shelby_gt350_reference.blend": "mustang_heritage",
    "sentinel_county_v8.blend": "enforcement_county",
    "vector_highway_interceptor.blend": "enforcement_highway",
    "rhino_heavy_containment.blend": "enforcement_heavy",
    "phantom_special_response.blend": "enforcement_special",
    "apex_state_hunter.blend": "enforcement_hunter",
}


def material(name, color, metallic=0.0, roughness=0.4):
    m = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1)
    m.use_nodes = True
    b = m.node_tree.nodes.get("Principled BSDF")
    b.inputs["Base Color"].default_value = (*color, 1)
    b.inputs["Metallic"].default_value = metallic
    b.inputs["Roughness"].default_value = roughness
    return m


def col(name):
    c = bpy.data.collections.get(name)
    if not c:
        c = bpy.data.collections.new(name)
        bpy.context.scene.collection.children.link(c)
    return c


def cube(name, loc, scale, mat, bevel=0.025, collection=None):
    bpy.ops.mesh.primitive_cube_add(location=loc)
    o = bpy.context.object
    o.name = name
    o.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if bevel:
        mod = o.modifiers.new("RepresentativeBevel", "BEVEL")
        mod.width = bevel
        mod.segments = 2
    o.data.materials.append(mat)
    if collection:
        for old in list(o.users_collection):
            old.objects.unlink(o)
        collection.objects.link(o)
    return o


def add_details(filename, style, output):
    source = Path(args.input) / filename
    if not source.exists():
        return False
    bpy.ops.wm.open_mainfile(filepath=str(source))
    vid = bpy.context.scene.get("wtrl_vehicle_id", source.stem)
    details = col(f"{vid}_REPRESENTATIVE_DETAIL")
    paint = material(f"{vid}_DetailPaint", {
        "hero_muscle": (0.11, 0.18, 0.30), "mopar_muscle": (0.32, 0.04, 0.025),
        "viper_exotic": (0.35, 0.015, 0.03), "bowtie_muscle": (0.20, 0.05, 0.025),
        "fiberglass_gt": (0.70, 0.10, 0.025), "wide_track": (0.22, 0.42, 0.06),
        "cadillac_luxury": (0.12, 0.15, 0.18), "lincoln_luxury": (0.20, 0.20, 0.22),
        "fairlady_z": (0.68, 0.08, 0.025), "skyline": (0.04, 0.10, 0.23),
        "toyota_gt": (0.75, 0.55, 0.08), "toyota_lightweight": (0.92, 0.92, 0.88),
        "honda_vtec": (0.06, 0.12, 0.16), "bmw_motorsport": (0.10, 0.16, 0.28),
        "porsche_rear": (0.75, 0.75, 0.70), "ford_heavy_iron": (0.12, 0.16, 0.18),
        "ford_homologation": (0.20, 0.28, 0.38), "ford_endurance": (0.82, 0.82, 0.76),
        "mustang_heritage": (0.22, 0.05, 0.025), "marsh_rival": (0.08, 0.08, 0.09), "enforcement_county": (0.02, 0.04, 0.06),
        "enforcement_highway": (0.015, 0.02, 0.03), "enforcement_heavy": (0.05, 0.06, 0.07),
        "enforcement_special": (0.01, 0.01, 0.012), "enforcement_hunter": (0.025, 0.035, 0.05),
    }[style], metallic=0.3, roughness=0.28)
    trim = material(f"{vid}_DetailTrim", (0.015, 0.018, 0.022), metallic=0.65, roughness=0.22)
    chrome = material(f"{vid}_DetailChrome", (0.55, 0.58, 0.62), metallic=0.95, roughness=0.12)
    lamp = material(f"{vid}_DetailLamp", (0.9, 0.12, 0.03), roughness=0.18)

    if style in ("hero_muscle", "mopar_muscle", "bowtie_muscle", "wide_track", "mustang_heritage", "ford_heavy_iron"):
        cube(f"{vid}_HoodStripe", (-0.25, 1.17, 0), (0.85, 0.012, 0.035), trim, 0.006, details)
        cube(f"{vid}_HoodBulge", (-0.45, 1.10, 0), (0.42, 0.08, 0.30), paint, 0.025, details)
        cube(f"{vid}_Grille", (-2.34, 0.78, 0), (0.02, 0.16, 0.55), trim, 0.01, details)
        cube(f"{vid}_Bumper", (-2.38, 0.52, 0), (0.04, 0.07, 0.75), chrome, 0.015, details)
    elif style in ("viper_exotic", "fiberglass_gt", "porsche_rear", "ford_endurance", "marsh_rival"):
        cube(f"{vid}_AeroSplitter", (-2.37, 0.38, 0), (0.10, 0.035, 0.86), trim, 0.01, details)
        cube(f"{vid}_CanardL", (-2.15, 0.62, -0.75), (0.20, 0.025, 0.04), paint, 0.01, details)
        cube(f"{vid}_CanardR", (-2.15, 0.62, 0.75), (0.20, 0.025, 0.04), paint, 0.01, details)
        cube(f"{vid}_WingBlade", (1.75, 1.35, 0), (0.12, 0.035, 0.92), trim, 0.01, details)
    elif style in ("fairlady_z", "skyline", "toyota_gt", "toyota_lightweight", "honda_vtec", "ford_homologation"):
        cube(f"{vid}_FrontLip", (-2.32, 0.43, 0), (0.12, 0.04, 0.80), trim, 0.01, details)
        cube(f"{vid}_SideSkirtL", (0, 0.43, -0.88), (0.90, 0.035, 0.035), paint, 0.01, details)
        cube(f"{vid}_SideSkirtR", (0, 0.43, 0.88), (0.90, 0.035, 0.035), paint, 0.01, details)
        cube(f"{vid}_CompactWing", (1.65, 1.25, 0), (0.10, 0.035, 0.72), trim, 0.01, details)
    elif style in ("bmw_motorsport", "cadillac_luxury", "lincoln_luxury"):
        cube(f"{vid}_TrimLine", (0, 0.77, -0.90), (1.45, 0.025, 0.025), chrome, 0.005, details)
        cube(f"{vid}_TrimLineR", (0, 0.77, 0.90), (1.45, 0.025, 0.025), chrome, 0.005, details)
        cube(f"{vid}_RearLip", (1.85, 1.18, 0), (0.28, 0.035, 0.65), paint, 0.01, details)
    else:
        cube(f"{vid}_ReinforcedFront", (-2.38, 0.68, 0), (0.12, 0.24, 0.88), chrome, 0.025, details)
        cube(f"{vid}_RoofEquipment", (-0.12, 1.40, 0), (0.48, 0.06, 0.22), trim, 0.015, details)
        cube(f"{vid}_RearProtection", (2.32, 0.62, 0), (0.10, 0.24, 0.86), chrome, 0.025, details)
    for z in (-0.50, 0.50):
        cube(f"{vid}_TailLampDetail_{z}", (2.37, 0.82, z), (0.025, 0.08, 0.14), lamp, 0.01, details)

    bpy.context.scene["wtrl_representative_refinement"] = True
    bpy.context.scene["wtrl_design_anchor"] = style
    output.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(output / filename))
    return True


def main():
    global args
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--out", required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
    src = Path(args.input)
    out = Path(args.out)
    done = sum(add_details(f, s, out) for f, s in REPRESENTATIVES.items())
    print(f"Refined {done}/{len(REPRESENTATIVES)} representative vehicles")


if __name__ == "__main__":
    main()
