# W2RL1.01 Vehicle Production Preparation

## Current audit

- Canonical Unity registry: 177 entries across 18 families.
- Ford Triple-Wide: 27 entries.
- Mustang Heritage: 14 entries requiring display-name resolution.
- Hero generations: 9 records.
- Current imported Blender/FBX validation assets: `hero_1967`, `marsh_nsx91`.
- Current Unity prototype prefabs: Hero 1967 and Marsh.
- Current vehicle art status: prototype/blockout; no vehicle is certified production-playable.

## Production rule

Each canonical entry receives a stable asset package: Blender source, FBX export, materials, interior, wheel set, LODs, damage proxies, Unity prefab, physics profile binding, audio binding, garage presentation binding, and certification evidence. Revision copies are not new vehicles. Trims remain variants unless their identity, geometry, physics, and gameplay role require a separate canonical ID.

## Quality gates

1. Identity: registry ID, family, generation, display name, variant, and provenance are resolved.
2. Reference: lawful references cover exterior, interior, wheels, engine bay, dimensions, and distinguishing details.
3. Blender: real-world scale, clean topology, separate serviceable parts, correct pivots, UVs, materials, anchors, and LOD plan.
4. Unity: FBX imports without warnings, materials bind correctly, prefab has colliders, wheel points, camera/garage/damage anchors, and physics profile.
5. Runtime: garage inspection, repair, part install, dyno, tuning, race, damage, and save/load work for the asset.
6. Performance: mobile LOD, texture memory, draw calls, physics cost, and Windows quality tier are recorded.
7. Certification: evidence file records import, tests, screenshots, known issues, and playable status.

## Staged production order

1. Hero 1967 and Marsh: production validation pair.
2. Remaining hero generations and named rivals: narrative-critical vehicles.
3. Police/enforcement roster and traffic silhouettes: open-world readability.
4. Ford Triple-Wide: Heavy Iron, Homologation, and Endurance subgroups.
5. Remaining 14-family heritage roster, family by family.
6. Experimental, reference-only, and unresolved entries after identity review.

The supplied art references guide proportions, display language, garage lighting, inspection UX, and mechanical storytelling. They do not become geometry, textures, logos, or copied layouts.
