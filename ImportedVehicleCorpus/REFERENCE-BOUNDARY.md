# Reference boundary

This folder was merged in from a separate location (`Desktop/racing game/
ImportedVehicleCorpus/`) on 2026-09-19. It is a distinct Swift codebase
(`Sources/WTRLGarage`, `Sources/WTRLVehicle`, `Sources/WTRLWorld` — 136
Swift files, plus `WTRLGoldenSliceTests`/`WTRLVehicleTests`), at a later
revision (`Rev38-XCODE-READINESS.md` describes Rev38: 186 catalog entries,
component-instance bindings, physical diagnosis/repair, 292 platform-neutral
tests) than anything reconciled into `SwiftRacer/` this session.

**This is reference material, not production source for `SwiftRacer/`.**
It is not part of `SwiftRacer/Package.swift` and nothing in `SwiftRacer/`
imports from it. The 186-entry vehicle count and "Rev36" naming echoed
throughout `SwiftRacer/Sources/WTRLCore/Content/EnrichedRev36VehicleCatalog
.swift` (itself assembled from many external "Wave" uploads across this
session) strongly suggests this corpus — or something in its direct lineage
— is where that catalog work originates, which makes it a genuinely
valuable reference for understanding that catalog's design intent, but it
has not been diffed against `SwiftRacer/` file-by-file the way every other
upload this session was, and its own module boundaries (`WTRLGarage`/
`WTRLVehicle`/`WTRLWorld` vs `SwiftRacer`'s single `WTRLCore`) don't match
`SwiftRacer`'s current architecture.

Do not copy runtime truth from it into `SwiftRacer/` without the same
file-by-file verification discipline applied to every other reconciled
upload, and an explicit decision about whether adopting it means porting
individual pieces or reconsidering `SwiftRacer`'s module structure —
that decision was intentionally left to the project owner rather than
made here.
