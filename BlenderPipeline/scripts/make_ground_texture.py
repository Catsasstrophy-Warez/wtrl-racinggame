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


def _layered_noise(x, y, seed, octaves):
    """Multi-octave version of `_noise` -- sums several frequencies so
    the grass reads with both coarse tonal variation and fine grain,
    instead of one uniform-frequency speckle. Matches the technique
    added to generate_world_tracks.py's asphalt texture, for visual
    consistency between the two ground-level textures."""
    total, amplitude, weight, freq = 0.0, 1.0, 0.0, 1.0
    for _ in range(octaves):
        total += _noise(x * freq, y * freq, seed) * amplitude
        weight += amplitude
        amplitude *= 0.5
        freq *= 2.3
    return total / weight


def _ground_sample(x, y, size):
    """Shared surface description for one ground texel -- same "one
    source of truth for color AND PBR maps" pattern used for the track
    textures in generate_world_tracks.py. Returns
    (height, base_n, patch_n, streak_n, dirt_mix)."""
    u, v = x / size, y / size
    base_n = _layered_noise(u * 40, v * 40, 1, 3)
    patch_n = _layered_noise(u * 6, v * 6, 7, 2)
    streak_n = _noise(u * 90, v * 14, 3)
    dirt_mix = max(0.0, (patch_n - 0.78) / 0.22) if patch_n > 0.78 else 0.0

    # Height field: fine grass-blade relief from base_n, dirt patches
    # sit slightly lower (packed/worn earth), mowing streaks are a
    # shallow groove.
    height = base_n * 0.5 - dirt_mix * 0.3
    if streak_n > 0.72:
        height -= (streak_n - 0.72) / 0.28 * 0.15

    return height, base_n, patch_n, streak_n, dirt_mix


def make_ground_image(name, size=1024):
    """A tileable grass base with sparse worn-dirt patches. Upgraded
    from single-octave noise to layered noise for both the fine grass
    grain and the coarse dirt-patch mask, plus a subtle darker "blade
    shadow" streak pattern so the grass doesn't read as a flat speckled
    color at close range. Resolution raised 512->1024 since this
    texture now tiles across large track-scene ground planes viewed
    from much closer than a hub-world overview camera."""
    img = bpy.data.images.new(name, width=size, height=size, alpha=False)
    px = [0.0] * (size * size * 4)
    for y in range(size):
        for x in range(size):
            _, base_n, patch_n, streak_n, dirt_mix = _ground_sample(x, y, size)

            g = 0.28 + base_n * 0.08
            r = 0.14 + base_n * 0.055
            b = 0.10 + base_n * 0.045

            if streak_n > 0.72:
                darken = (streak_n - 0.72) / 0.28 * 0.06
                r -= darken * 0.5
                g -= darken
                b -= darken * 0.4

            if dirt_mix > 0:
                r = r * (1 - dirt_mix) + 0.32 * dirt_mix
                g = g * (1 - dirt_mix) + 0.24 * dirt_mix
                b = b * (1 - dirt_mix) + 0.16 * dirt_mix

            idx = (y * size + x) * 4
            px[idx + 0] = max(0.0, r)
            px[idx + 1] = max(0.0, g)
            px[idx + 2] = max(0.0, b)
            px[idx + 3] = 1.0
    img.pixels = px

    OUT_DIR.mkdir(exist_ok=True)
    out_path = str(OUT_DIR / f"{name}.png")
    img.filepath_raw = out_path
    img.file_format = "PNG"
    img.save()
    print("SAVED", out_path)


def _height_to_normal_and_ao(height_fn, size, bump_strength, ao_strength):
    """Same finite-difference normal/AO derivation as
    generate_world_tracks.py's `_height_to_normal_and_ao` -- duplicated
    rather than imported since these two scripts are each invoked as
    Blender's `--python` entry point independently (no shared package
    import path between them), not because the logic is meant to
    diverge. Keep both in sync if either changes."""
    normal_px = [0.0] * (size * size * 4)
    ao_px = [0.0] * (size * size * 4)
    for y in range(size):
        for x in range(size):
            h_c = height_fn(x, y, size)
            h_x = height_fn((x + 1) % size, y, size)
            h_y = height_fn(x, (y + 1) % size, size)
            dx = (h_x - h_c) * bump_strength
            dy = (h_y - h_c) * bump_strength
            nx, ny, nz = -dx, -dy, 1.0
            length = math.sqrt(nx * nx + ny * ny + nz * nz)
            nx, ny, nz = nx / length, ny / length, nz / length
            idx = (y * size + x) * 4
            normal_px[idx] = nx * 0.5 + 0.5
            normal_px[idx + 1] = ny * 0.5 + 0.5
            normal_px[idx + 2] = nz * 0.5 + 0.5
            normal_px[idx + 3] = 1.0
            grad_mag = math.sqrt(dx * dx + dy * dy)
            ao = max(0.0, min(1.0, 1.0 - grad_mag * ao_strength))
            ao_px[idx] = ao_px[idx + 1] = ao_px[idx + 2] = ao
            ao_px[idx + 3] = 1.0
    return normal_px, ao_px


def _ground_height(x, y, size):
    return _ground_sample(x, y, size)[0]


def make_ground_pbr_maps(name, size=1024):
    """Real normal/AO/metallic-smoothness maps for the ground, derived
    from the same `_ground_sample` height field the albedo painter
    uses. Grass/dirt is fully non-metallic and quite rough (matte),
    with dirt patches slightly rougher still (dry packed earth) and a
    small smoothness bump in the mowing-streak grooves (compressed,
    slightly burnished grass)."""
    normal_px, ao_px = _height_to_normal_and_ao(_ground_height, size, bump_strength=4.0, ao_strength=1.3)

    ms_px = [0.0] * (size * size * 4)
    for y in range(size):
        for x in range(size):
            idx = (y * size + x) * 4
            _, base_n, patch_n, streak_n, dirt_mix = _ground_sample(x, y, size)
            smoothness = 0.08 + base_n * 0.04
            if dirt_mix > 0:
                smoothness *= 0.7
            if streak_n > 0.72:
                smoothness += 0.05
            ms_px[idx] = 0.0
            ms_px[idx + 1] = 0.0
            ms_px[idx + 2] = 0.0
            ms_px[idx + 3] = max(0.0, min(1.0, smoothness))

    for suffix, px in (("_normal", normal_px), ("_ao", ao_px), ("_metallicsmoothness", ms_px)):
        # alpha=True: _metallicsmoothness packs smoothness into alpha
        # (Unity URP/Lit's Metallic Gloss Map convention) -- the same
        # real bug found and fixed in generate_world_tracks.py's
        # _save_pbr_maps applies here too (Blender's alpha=False
        # default silently discards the alpha channel on PNG save).
        img = bpy.data.images.new(f"{name}{suffix}", width=size, height=size, alpha=True)
        img.pixels = px
        out_path = str(OUT_DIR / f"{name}{suffix}.png")
        img.filepath_raw = out_path
        img.file_format = "PNG"
        img.save()
        print("SAVED", out_path)


def main():
    make_ground_image("world_ground_grass")
    make_ground_pbr_maps("world_ground_grass")


if __name__ == "__main__":
    main()
