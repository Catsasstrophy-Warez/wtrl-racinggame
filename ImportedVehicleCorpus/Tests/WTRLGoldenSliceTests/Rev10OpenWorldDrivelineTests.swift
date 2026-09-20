import Foundation
import Testing
@testable import WTRLWorld
@testable import WTRLVehicle
@testable import WTRLGarage
@testable import WTRLAudio

@Test func trafficPromotesNearestWithoutExceedingCap() {
    var agents=(0..<40).map { AmbientTrafficAgent(id:UInt32($0),position:.init(Double($0),0)) }
    var p=TrafficLODPolicy();p.maximumInteractiveAgents=16
    AmbientTrafficAuthority.update(agents:&agents,player:.init(0,0),policy:p)
    #expect(agents.filter{$0.tier == .nearInteractive}.count == 16)
}
@Test func trafficHysteresisPreventsBoundaryThrash() {
    var a=[AmbientTrafficAgent(id:1,position:.init(64,0))]
    AmbientTrafficAuthority.update(agents:&a,player:.init(0,0));#expect(a[0].tier == .nearInteractive)
    a[0].position = .init(70,0)
    AmbientTrafficAuthority.update(agents:&a,player:.init(0,0));#expect(a[0].tier == .nearInteractive)
    a[0].position = .init(90,0)
    AmbientTrafficAuthority.update(agents:&a,player:.init(0,0));#expect(a[0].tier == .farKinematic)
}
@Test func streamingPromotesAndSleepsCells() {
    var cells=[WorldStreamingCell(id:"a",center:.init(0,0),halfExtentM:100),WorldStreamingCell(id:"b",center:.init(5000,0),halfExtentM:100)]
    WorldStreamingAuthority.update(cells:&cells,player:.init(0,0))
    #expect(cells[0].tier == .nearInteractive);#expect(cells[1].tier == .dormant)
}
@Test func pursuitHeatDecaysOnlyAfterLostVisibility() {
    var s=PursuitState();PursuitAuthority.recordObservedViolation(points:45,repairOrPropertyLiabilityCredits:100,state:&s)
    let start=s.heat.rawValue
    PursuitAuthority.updateVisibility(isObserved:false,dt:19,state:&s);#expect(s.heat.rawValue == start)
    PursuitAuthority.updateVisibility(isObserved:false,dt:1,state:&s);#expect(s.heat.rawValue == start-1)
}
@Test func drivelineTwistTransmitsTorqueAndCanFail() {
    var s=DrivelineElasticityState();var p=DrivelineElasticityParameters();p.failureTwistRad=0.1
    DrivelineElasticityAuthority.step(state:&s,gearboxOmegaRadPerSec:20,pinionOmegaRadPerSec:0,dt:0.002,parameters:p)
    #expect(s.transmittedTorqueNm > 0)
    for _ in 0..<10 { DrivelineElasticityAuthority.step(state:&s,gearboxOmegaRadPerSec:20,pinionOmegaRadPerSec:0,dt:0.002,parameters:p) }
    #expect(s.failed)
}
@Test func axleHopDetectorMeasuresOscillationInsteadOfGuessingFromOmega() {
    var w=OscillationWindow();var detected:Double?
    let dt=1.0/240.0
    for i in 0..<240 {
        let t=Double(i)*dt
        detected=AxleHopDetector.observe(signal:sin(2*Double.pi*14*t),time:t,window:&w) ?? detected
    }
    #expect(detected != nil);#expect(abs(detected!-14) < 1)
}
@Test func impactAddsLinearAndAngularResponse() {
    var b=ImpactBody2D(velocityX:0,velocityY:0,yawRateRadPerSec:0,massKg:1500,yawInertiaKgM2:2400)
    let r=KineticImpactAuthority.resolve(target:&b,strikerVelocityX:10,strikerVelocityY:0,strikerMassKg:1800,contactXFromTargetCG:0,contactYFromTargetCG:0.8,normalX:1,normalY:0)
    #expect(r.applied);#expect(b.velocityX>0);#expect(abs(b.yawRateRadPerSec)>0)
}
@Test func carbWOTPowerValveEnrichesRelativeToCruise() {
    let c=CarburetorCircuitSpec()
    let cruise=c.estimatedAFR(engineVacuumInHg:14,wideOpenThrottle:false)
    let power=c.estimatedAFR(engineVacuumInHg:2,wideOpenThrottle:true)
    #expect(power < cruise)
}
@Test func carbDiagnosticAsksForVerificationBeforeJets() {
    #expect(CarburetorDiagnostic.recommendation(measuredAFR:15.5,targetAFR:12.5...13.2).contains("Verify"))
}
@Test func acousticReflectionDelayUsesRoundTripDistance() {
    let taps=EnvironmentalAcoustics.earlyReflections([.init(distanceM:17.15,reflectivity01:1,highFrequencyAbsorption01:0)])
    #expect(abs(taps[0].delaySeconds-0.1)<0.001);#expect(taps[0].gain01<1)
}
