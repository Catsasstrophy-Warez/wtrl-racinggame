#!/usr/bin/env bash
# Clone the reference repositories. Run from wherever you want them.
# See ../01-LICENSING.md BEFORE copying anything out of these.
set -u
mkdir -p reference-repos && cd reference-repos

echo "== MIT, ship-safe code =="
git clone https://github.com/JustInvoke/Randomation-Vehicle-Physics.git
git clone https://github.com/LemonMontage420/TORSION-Community-Edition.git
git clone https://github.com/TastSong/CrazyCar.git
git clone https://github.com/TLabAltoh/TLabVehiclePhysics.git
( cd TLabVehiclePhysics && git submodule update --init )

echo "== Unity Companion License — requires Git LFS and Unity 6000.2.11f1+ =="
echo "   (do NOT download as ZIP, LFS pointers will be broken)"
git lfs install 2>/dev/null || echo "   !! git-lfs not installed — install it first"
git clone https://github.com/Unity-Technologies/ECS-Network-Racing-Sample.git

echo
echo "== NOT CLONED ON PURPOSE =="
echo "PERRINN/project-424-unity — no license grant; VPP-424 and the Nordschleife"
echo "track are both non-commercial only. Clone it manually to study if you want,"
echo "but nothing in it may be used in a commercial game."
echo
echo "Read-only references (verify licenses yourself):"
echo "  github.com/Ishaan35/Unity3D-Mario-Kart-Racing-Game   (Nintendo-derived)"
echo "  github.com/Kasperki/GolfRomeo"
echo "Free + commercially cleared, get from the Asset Store:"
echo "  Vehicle Physics Pro Community Edition"
echo "  com.unity.vehicles  (Unity first-party package)"
