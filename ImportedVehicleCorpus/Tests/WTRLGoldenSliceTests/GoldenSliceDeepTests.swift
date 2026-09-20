import Testing
import WTRLApp
import WTRLCore
@testable import WTRLGarage
@testable import WTRLRacing
@testable import WTRLWorld
@testable import WTRLDyno
import WTRLPersistence

@Test func differentialBadBacklashFailsSetup() {
    var d=DifferentialAssembly(); d.measurements.backlashMm=0.55
    let a=DifferentialSetupMath.assess(d.measurements,spec:d.setupSpecification)
    #expect(!a.passed); #expect(a.findings.contains("Backlash out of specification"))
}
@Test func extractionRequiresCorrectDirectionAndTravel() {
    let g=PhysicalComponentGeometry(componentId:"carrier",installedTransform:.init(),benchTransform:.init(),constraint:.init(axis:Vector3D(0,0,1),minimumTravelM:0.2),selectableBoundsM:Vector3D(0.4,0.4,0.4))
    #expect(throws: PhysicalInteractionError.self) { try PhysicalInteractionMath.validateExtraction(component:g,removed:[],dragVector:Vector3D(0.2,0,0)) }
}
@Test func blackridgeRoadCompletes() {
    var s=BlackridgeDriveState(route:.icehouseToRedline)
    for _ in 0..<10000 where !s.completed { BlackridgeDriveRuntime.step(&s,throttle:0.7,brake:0,dt:0.1) }
    #expect(s.completed); #expect(s.fuelUsedL > 0)
}
@Test func briarRunProducesReactionSixtyAndET() {
    var s=BriarDragState()
    BriarDragRuntime.burnout(&s,wheelSpeedKph:90,seconds:4)
    BriarDragRuntime.preStage(&s); BriarDragRuntime.stage(&s)
    let tree=BriarDragRuntime.arm(&s,now:5,type:.pro,starterDelay:0.5)
    BriarDragRuntime.launch(&s,tree:tree,at:tree.greenTime+0.08)
    for _ in 0..<3000 where s.quarterMileSeconds == nil { BriarDragRuntime.stepRun(&s,throttle:1,traction01:1,powerKw:340,dt:0.01) }
    #expect(s.drag.reactionSeconds != nil); #expect(s.drag.sixtyFootSeconds != nil); #expect(s.quarterMileSeconds != nil); #expect(!s.drag.redLight)
}
@Test func postRunForensicsFindsHeatAndBacklash() {
    var d=DifferentialAssembly(); d.measurements.backlashMm=0.30; d.measurements.oilDebris01=0.4
    let r=GoldenPlayableCoordinator.assessForensics(differential:d,postRunTempC:120)
    #expect(r.findings.count >= 3)
}
