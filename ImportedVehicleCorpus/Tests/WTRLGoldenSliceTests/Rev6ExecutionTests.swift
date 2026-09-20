import Testing
import WTRLCore
import WTRLVehicle
@testable import WTRLGarage
@testable import WTRLRendering
@testable import WTRLDyno
@testable import WTRLWorld
@testable import WTRLApp

@Test func toolHitTestFeedsRealityInteraction() throws {
    var s=RealityInteractionState()
    let c=ToolContact(toolId:"tool_ratchet",fastenerId:"cover_bolt_1",distanceM:0.015,angularAlignment01:0.94)
    try RealityInteractionRuntime.engageTool(toolId:"tool_ratchet",fastenerId:"cover_bolt_1",contact:c,state:&s)
    #expect(s.activeFastenerId == "cover_bolt_1");#expect(s.hapticPulse01 > 0)
}
@Test func explodedBenchMovesPartAwayFromInstalledLocation() {
    let id=DifferentialBenchLayout.entities[3].componentId
    let a=DifferentialBenchLayout.transform(componentId:id,exploded01:0)!
    let b=DifferentialBenchLayout.transform(componentId:id,exploded01:1)!
    #expect(a.position != b.position)
}
@Test func dialIndicatorVisualShowsSpecification() {
    let spec=ClosedRangeCodable(0.15,0.23)
    #expect(InstrumentVisualization.dial(valueMm:0.19,spec:spec).inSpec)
    #expect(!InstrumentVisualization.dial(valueMm:0.40,spec:spec).inSpec)
}
@Test func torqueVisualClicksNearTargetAndFlagsOvertorque() {
    #expect(InstrumentVisualization.torque(appliedNm:114,targetNm:115).click)
    #expect(InstrumentVisualization.torque(appliedNm:130,targetNm:115).overTorque)
}
@Test func dynoCellRequiresStrapsAndServices() throws {
    var s=DynoCellState();DynoCellRuntime.position(&s)
    #expect(throws:DynoCellError.notStrapped){try DynoCellRuntime.certify(vehicleId:"KR",differential:DifferentialAssembly(),s:&s)}
    DynoCellRuntime.strap(front:true,rear:true,s:&s);DynoCellRuntime.enableServices(s:&s)
    try DynoCellRuntime.certify(vehicleId:"KR",differential:DifferentialAssembly(),s:&s)
    #expect(s.phase == .complete)
}
@Test func blackridgeSceneHasRoadGeometry() {
    let r=BlackridgeSceneCatalog.route(.blackridgeMountainLoop)
    #expect(r.points.count >= 8);#expect(r.points.last!.position.x > r.points.first!.position.x)
}
@Test func mobileDriveHUDSynchronizes() {
    var s=MobileDrivingRuntimeState();s.input.throttle=0.7;s.input.gear=2
    let route=BlackridgeCatalog.routes[.icehouseToRedline]!
    for _ in 0..<100 {PhysicalDriveBridge.step(&s.telemetry,input:s.input,route:route,dt:0.02)}
    s.synchronizeHUD()
    #expect(s.hudSpeedKph == s.telemetry.speedKph);#expect(s.hudRPM > 850)
}
@Test func completeGoldenSliceHeadlessPassesEveryPhase() {
    let result=GoldenSliceVerifier.executeHeadless()
    #expect(result.passed)
    #expect(result.completed.count == GoldenVerificationStep.allCases.count)
    #expect(result.evidence.contains("reload:same_vehicle"))
}
