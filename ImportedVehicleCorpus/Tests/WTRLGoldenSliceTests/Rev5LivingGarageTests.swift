import Testing
import WTRLCore
import WTRLVehicle
@testable import WTRLGarage
@testable import WTRLWorld
@testable import WTRLRendering
@testable import WTRLApp

@Test func liftRequiresCenteredCarAndPads() {
    var s=LiftState()
    #expect(throws: LiftError.vehicleNotCentered){try LiftRuntime.raise(to:.service,state:&s)}
    LiftRuntime.setVehicleCentered(true,state:&s)
    #expect(throws: LiftError.padsNotEngaged){try LiftRuntime.raise(to:.service,state:&s)}
}
@Test func liftRaisesToUnderbody() throws {
    var s=LiftState();LiftRuntime.setVehicleCentered(true,state:&s);LiftRuntime.engagePads(true,state:&s)
    try LiftRuntime.raise(to:.underbody,state:&s)
    #expect(s.heightM == 1.75);#expect(s.locksEngaged)
}
@Test func toolContactRequiresAlignment() {
    #expect(ToolHitTest.accepts(.init(toolId:"ratchet",fastenerId:"bolt",distanceM:0.02,angularAlignment01:0.95)))
    #expect(!ToolHitTest.accepts(.init(toolId:"ratchet",fastenerId:"bolt",distanceM:0.02,angularAlignment01:0.3)))
}
@Test func bearingPressRequiresCorrectToolAndPriorRemoval() throws {
    var s=DifferentialRebuildState()
    let press=WorkshopTool(id:"p",kind:.bearingPress)
    #expect(throws:DifferentialRebuildError.bearingNotRemoved){try DifferentialRebuildRuntime.pressBearingOn("pinion_inner",state:&s,tool:press)}
    try DifferentialRebuildRuntime.pressBearingOff("pinion_inner",state:&s,tool:press)
    try DifferentialRebuildRuntime.pressBearingOn("pinion_inner",state:&s,tool:press)
    #expect(s.bearingsPressedOn.contains("pinion_inner"))
}
@Test func shimChoiceChangesBacklashAndDepth() throws {
    var s=DifferentialRebuildState()
    try DifferentialRebuildRuntime.chooseShims(pinion:0.9,left:0.7,right:0.9,state:&s)
    let m=DifferentialRebuildRuntime.predictedMeasurements(s)
    #expect(m.backlashMm > 0.19);#expect(m.contactPatternDepth01 > 0.5)
}
@Test func patternNeedsCompound() {
    var s=DifferentialRebuildState()
    #expect(throws:DifferentialRebuildError.noCompound){try DifferentialRebuildRuntime.rollPattern(state:&s)}
}
@Test func contactPatternQualityRewardsCenteredPattern() {
    let centered=ContactPatternRendererModel.visual(depth01:0.5,bias01:0.5)
    let bad=ContactPatternRendererModel.visual(depth01:0.9,bias01:0.1)
    #expect(centered.quality01 > bad.quality01)
}
@Test func physicalDriveCreatesMileageAndRpm() {
    var t=PhysicalDriveTelemetry()
    let route=BlackridgeCatalog.routes[.icehouseToRedline]!
    var input=PhysicalDriveInput();input.throttle=0.8;input.gear=3
    for _ in 0..<1000 {PhysicalDriveBridge.step(&t,input:input,route:route,dt:0.02)}
    #expect(t.distanceKm > 0);#expect(t.rpm > 850);#expect(t.speedKph > 0)
}
@Test func goldenIntegratedDynoRoadForensicsUseSameVehicle() {
    var s=GoldenSliceRuntimeState(vehicleId:"KR-SAME",mileageKm:82000)
    #expect(GoldenSliceRuntime.certifyDyno(&s))
    GoldenSliceRuntime.completeRoadTest(&s)
    GoldenSliceRuntime.inspectAfterRun(&s)
    #expect(s.continuity.vehicleInstanceId == "KR-SAME")
    #expect(s.continuity.odometerKm > 82000)
    #expect(s.forensic != nil)
}
