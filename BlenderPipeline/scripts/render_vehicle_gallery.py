import argparse
import math
import sys
from pathlib import Path
import bpy
from mathutils import Vector

SAMPLES = [
    "1967_crownfire_original.blend", "marsh_nsx91.blend", "sentinel_county_v8.blend",
    "vector_highway_interceptor.blend", "rhino_heavy_containment.blend", "phantom_special_response.blend",
    "1968_charger_r_t.blend", "1992_viper_rt_10.blend", "1969_skyline_2000gt_r_sedan.blend",
    "1973_bmw_3_0_csl.blend", "1967_911s.blend", "1966_gt40_mk_ii.blend",
]

def aim(obj, target):
    obj.rotation_euler = (Vector(target) - obj.location).to_track_quat('-Z', 'Y').to_euler()

def render_one(path, out):
    bpy.ops.wm.open_mainfile(filepath=str(path))
    bpy.ops.object.select_all(action='DESELECT')
    for o in list(bpy.data.objects):
        if o.type == 'CAMERA' or o.type == 'LIGHT': bpy.data.objects.remove(o, do_unlink=True)
    scene = bpy.context.scene
    scene.render.engine = 'BLENDER_EEVEE'
    scene.render.resolution_x = 720
    scene.render.resolution_y = 480
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = 'PNG'
    scene.render.film_transparent = False
    world = scene.world or bpy.data.worlds.new('GalleryWorld')
    scene.world = world
    world.color = (0.025, 0.03, 0.045)
    bpy.ops.object.camera_add(location=(-7.2, 3.5, 6.8))
    cam = bpy.context.object
    aim(cam, (0, 0.75, 0))
    scene.camera = cam
    for loc, energy, size in [((-4, 6, 4), 1000, 5), ((3, 4, -4), 800, 4), ((2, 2, 5), 650, 3)]:
        bpy.ops.object.light_add(type='AREA', location=loc)
        light = bpy.context.object
        light.data.energy = energy
        light.data.shape = 'DISK'
        light.data.size = size
        aim(light, (0, 0.7, 0))
    scene.render.filepath = str(out / (path.stem + '.png'))
    bpy.ops.render.render(write_still=True)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--out', required=True)
    args, _ = parser.parse_known_args(sys.argv[sys.argv.index('--') + 1:] if '--' in sys.argv else [])
    src, out = Path(args.input), Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    for n in SAMPLES:
        p = src / n
        if p.exists(): render_one(p, out)
    print(f'Rendered gallery previews to {out}')

if __name__ == '__main__': main()
