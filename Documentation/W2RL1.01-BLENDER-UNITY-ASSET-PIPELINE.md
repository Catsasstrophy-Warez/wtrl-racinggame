# W2RL1.01 Blender → Unity Asset Pipeline

## Local project

`D:\W2RL1\UnityProject`

## Blender source folders

- `ArtSource/Blender/VehicleSource`
- `ArtSource/Blender/Interiors`
- `ArtSource/Blender/Wheels`
- `ArtSource/Blender/Materials`
- `ArtSource/Blender/LOD`

## Unity destination folders

- `Assets/Art/Vehicles/SourceMeshes`
- `Assets/Art/Vehicles/Interiors`
- `Assets/Art/Vehicles/Wheels`
- `Assets/Art/Vehicles/Materials`
- `Assets/Art/Vehicles/Prefabs`
- `Assets/Art/Vehicles/LOD`
- `Assets/Art/Vehicles/Audio`

## Vehicle export contract

Every Blender vehicle file must include the canonical vehicle ID in the filename and root collection. Apply transforms, use meters, place the vehicle origin at the ground-plane center, orient forward along +Z, and preserve separate body/interior/wheel collections. Export FBX with mesh, normals, tangents, armature disabled unless required, and units converted to meters.

Required Unity import checks: scale 1, readable disabled for production meshes, correct normals/tangents, material slots preserved, collider proxy available, four wheel anchors, camera anchor, garage anchor, damage proxy, and LOD chain.

Never let Blender filenames create identity. The canonical ID comes from `W2RL1.01-MASTER-VEHICLE-REGISTRY.json`; asset mappings must be approved separately.

## Production order

Hero 1967 → Marsh NSX → Duquesne Charger → Osei RX-7 → Kade Supra → Vogel M3 → Reyes GT-R → remaining lineages.
