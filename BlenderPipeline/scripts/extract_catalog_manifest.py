"""Extract a practical Blender manifest from the repository's Swift catalogs.

This preserves source names/IDs as far as they are authored in the catalog and
marks entries as blockouts until a dedicated model is supplied.
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "BlenderPipeline" / "catalog_manifest.json"

vehicles = []
seen = set()


def add(name, vid, generation="catalog"):
    name = name.strip()
    if not name or name in seen:
        return
    seen.add(name)
    vehicles.append({
        "id": vid,
        "displayName": name,
        "generation": generation,
        "profile": {
            "length": 4.65,
            "width": 1.82,
            "height": 1.28,
            "wheelbase": 2.72,
            "track": 1.55,
            "wheelRadius": 0.34,
        },
    })


prod = ROOT / "ImportedVehicleCorpus/Sources/WTRLVehicle/ProductionVehicleRosterRev27.swift"
if prod.exists():
    for m in re.finditer(r'displayName:"([^"]+)"', prod.read_text(encoding="utf-8")):
        add(m.group(1), re.sub(r"[^a-z0-9]+", "_", m.group(1).lower()).strip("_"), "hero")

enforcement = ROOT / "ImportedVehicleCorpus/Sources/WTRLWorld/EnforcementVehicleRosterRev27.swift"
if enforcement.exists():
    for m in re.finditer(r'displayName:"([^"]+)"', enforcement.read_text(encoding="utf-8")):
        if "Platform" not in m.group(1):
            add(m.group(1), re.sub(r"[^a-z0-9]+", "_", m.group(1).lower()).strip("_"), "enforcement")

heritage = ROOT / "ImportedVehicleCorpus/Sources/WTRLVehicle/HeritageLineageEngineeringRev29.swift"
if heritage.exists():
    text = heritage.read_text(encoding="utf-8")
    # Heritage arrays are authored as quoted model names. Filter out source
    # labels and engineering phrases while retaining model-like entries.
    for m in re.finditer(r'"([0-9]{4} [^"]+|Mustang [^"]+|Dark Horse [^"]+)"', text):
        name = m.group(1)
        add(name, re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_"), "heritage")

mustang = ROOT / "ImportedVehicleCorpus/Sources/WTRLVehicle/MustangHeritageRev33.swift"
if mustang.exists():
    for m in re.finditer(r'v\(\d+,"([^"]+)"', mustang.read_text(encoding="utf-8")):
        add(m.group(1), re.sub(r"[^a-z0-9]+", "_", m.group(1).lower()).strip("_"), "mustang_heritage")

OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text(json.dumps({"schema": 1, "source": "Swift catalogs", "vehicles": vehicles}, indent=2), encoding="utf-8")
print(f"Wrote {len(vehicles)} entries to {OUT}")
