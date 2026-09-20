# WTRL Blender Pipeline

This directory is the Blender-first production path for the Unity mobile conversion.

`generate_mobile_fleet.py` creates named, stable-ID blockout `.blend` files with:

- LOD0/LOD1/LOD2 render collections
- Collision collection
- Wheel and service markers
- Unity-meter scene scale
- Stable vehicle ID and display-name custom properties

The generated geometry is a production bootstrap/blockout. It is not a finished historically accurate model; hero and rival vehicles must receive dedicated refinement passes after the pipeline is proven.

Expected command:

```text
blender -b --python scripts/generate_mobile_fleet.py -- --manifest catalog_manifest.json --out export
```
