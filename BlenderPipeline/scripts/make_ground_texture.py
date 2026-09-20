"""Generates the procedural grass/dirt ground texture used by
WTRL-Unity's VerticalSliceSceneBuilder.BuildGround.

Authors pixels directly via Blender's own Image API and saves a plain
PNG file, rather than relying on FBX texture embedding -- the same
approach already required for the track asphalt/barrier textures,
since Unity's FBX importer does not reliably wire embedded FBX
textures regardless of how the source image was packed/saved on the
Blender side (see world_tracks/README or WTRL-Unity's UI/CONTRACT.md
for the full writeup of that interop bug).

Run headless:
    blender -b --python make_ground_texture.py
Output:
    <tempdir>/wtrl_ground_texture/world_ground_grass.png
Copy the result into:
    WTRL-Unity/Assets/WrenchToRaceLegends/Art/Environment/Textures/
"""

import math
import tempfile
from pathlib import Path

import bpy

OUT_DIR = Path(tempfile.gettempdir()) / "wtrl_ground_texture"


def _noise(x, y, seed=0):
    n = math.sin(x * 12.9898 + y * 78.233 + seed * 37.719) * 43758.5453
    return n - math.floor(n)


def make_ground_image(name, size=512):
    """A tileable grass base with sparse worn-dirt patches."""
    img = bpy.data.images.new(name, width=size, height=size, alpha=False)
    px = [0.0] * (size * size * 4)
    for y in range(size):
        for x in range(size):
            u, v = x / size, y / size
            base_n = _noise(u * 40, v * 40, 1)
            patch_n = _noise(u * 6, v * 6, 7)

            g = 0.28 + base_n * 0.07
            r = 0.14 + base_n * 0.05
            b = 0.10 + base_n * 0.04

            if patch_n > 0.78:
                dirt_mix = (patch_n - 0.78) / 0.22
                r = r * (1 - dirt_mix) + 0.32 * dirt_mix
                g = g * (1 - dirt_mix) + 0.24 * dirt_mix
                b = b * (1 - dirt_mix) + 0.16 * dirt_mix

            idx = (y * size + x) * 4
            px[idx + 0] = r
            px[idx + 1] = g
            px[idx + 2] = b
            px[idx + 3] = 1.0
    img.pixels = px

    OUT_DIR.mkdir(exist_ok=True)
    out_path = str(OUT_DIR / f"{name}.png")
    img.filepath_raw = out_path
    img.file_format = "PNG"
    img.save()
    print("SAVED", out_path)


def main():
    make_ground_image("world_ground_grass")


if __name__ == "__main__":
    main()
