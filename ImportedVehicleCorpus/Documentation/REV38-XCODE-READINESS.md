# Rev38 Xcode Readiness

## Product truth
Rev38 adds engineering-family truth for all 186 player-facing catalog entries, pre-purchase measured inspection, and a staged Apex Revenant evolution path. Real-world specifications remain research-gated until verified; fictional production calibrations are authored game truth.

## Apple build gate
1. Open Package.swift in Xcode 26+ on macOS.
2. Select an iOS 18+ Simulator and build WTRLUI/WTRLApp dependencies with Swift 6 strict concurrency diagnostics enabled.
3. Run all package tests.
4. Exercise RealityKit service target identity, hit testing, extraction/reparenting, tool contact, lift/stand/drain-pan interactions and exploded bench views.
5. Run Metal validation and GPU capture on garage, dyno and proving scenes.
6. Run save/relaunch during partial disassembly, acquisition inspection and Apex campaign progression.
7. Run XCUI journeys: acquire -> inspect -> diagnose -> teardown -> rebuild -> dyno -> prove -> save/reload.
8. Run Instruments: Time Profiler, Allocations, Leaks, Energy, thermal/device stress.
9. Validate on a physical iPhone and create a Release archive/signing build.

## Linux/platform-neutral proof
`swift test`: 171 Swift Testing + 121 XCTest = 292 executable tests, 0 failures.

Apple-specific RealityKit, Metal, SwiftUI/XCUI, signing, Instruments and physical-device execution are pending until run in Xcode/macOS.
