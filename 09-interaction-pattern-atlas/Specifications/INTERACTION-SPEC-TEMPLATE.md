# WTRL Interaction Specification Template

## Pattern ID

`WTRL-IP-###`

## Player goal

What the player is trying to accomplish.

## Preconditions

Canonical runtime state required before interaction begins.

## State chain

`intent → screen → input → feedback → operation → consequence → test → persistence`

## WTRLCore contract

Inputs, state mutation, deterministic outputs, failure/invalid states.

## RealityKit contract

Entities/components, selection/focus behavior, animation,
LOD/performance constraints.

## SwiftUI contract

Navigation, controls, progressive disclosure, accessibility identifiers,
iPhone/iPad/Mac adaptations.

## Evidence contract

Telemetry or state values proving the mechanical consequence.

## Persistence contract

Fields that must round-trip through save/reload.

## Acceptance tests

1.  Core deterministic test
2.  UI reachability test
3.  Save/reload test
4.  Input parity test (touch/controller/keyboard)
5.  Performance gate
