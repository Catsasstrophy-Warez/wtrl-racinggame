import Foundation
import Testing
@testable import WTRLVehicle
@testable import WTRLCareer

@Test func generationalCatalogHasDistinctMechanicalArchetypes() {
    #expect(GenerationalEngineeringCatalog.profiles.count >= 9)
    #expect(Set(GenerationalEngineeringCatalog.profiles.map{$0.engine}).count >= 6)
    #expect(GenerationalEngineeringCatalog.profiles.allSatisfy{$0.researchStatus.contains("fictional")})
}
@Test func oversizedHighTorqueSwapRequiresPhysicalWork() {
    let c=SwapCandidate(id:"modern_high_output",massKg:265,torqueNm:900,widthM:0.86,heightM:0.78,heatRejectionKW:155,requiresCAN:true,vibrationOrder:4)
    let h=HostEnvelope(availableWidthM:0.72,availableHeightM:0.72,coolingCapacityKW:80,chassisRigidity01:0.3,brakeThermalCapacity01:0.45,supportsCAN:false)
    let a=SwapCompatibilityAuthority.assess(candidate:c,host:h)
    #expect(!a.directFit);#expect(a.operations.contains(.shockTowerClearance));#expect(a.operations.contains(.coolingUpgrade));#expect(a.operations.contains(.wiringHarness));#expect(a.operations.contains(.subframeMounts));#expect(a.operations.contains(.brakeUpgrade))
}
@Test func repeatedHardStopsCreateBrakeFade() {
    var s=BrakeThermalState()
    for _ in 0..<12 { BrakeThermalAuthority.step(state:&s,vehicleMassKg:1500,speedBeforeMps:42,speedAfterMps:8,frontBias01:0.7,thermalCapacityJPerK:24_000,cooling01:0.15,dt:1) }
    #expect(s.frontTemperatureC>s.rearTemperatureC);#expect(s.fade01>0)
}
@Test func turboHasTransientBoostResponse() {
    var s=TurboResponseState()
    TurboResponseAuthority.step(state:&s,rpm:4200,throttle:1,dt:0.01);let early=s.boost01
    for _ in 0..<100 { TurboResponseAuthority.step(state:&s,rpm:4200,throttle:1,dt:0.01) }
    #expect(s.boost01>early);#expect(s.manifoldTemperatureC>35)
}
@Test func highRPMVibrationAccumulatesPhysicalEvidence() {
    var s=VibrationFatigueState()
    for _ in 0..<10_000 { VibrationFatigueAuthority.step(state:&s,rpm:8000,vibrationG:2.8,componentAge01:0.8,fastenerRetention01:0.3,dt:0.01) }
    #expect(s.fastenerLooseness01>0);#expect(s.bracketFatigue01>0);#expect(s.gaugeNoise01>0)
}
@Test func downforceCompressesSuspensionQuadraticallyWithSpeed() {
    let a=AeroPlatformAuthority.evaluate(speedMps:30,frontDownforceCoefficientArea:0.7,rearDownforceCoefficientArea:0.9,frontSpringRateNPerM:90_000,rearSpringRateNPerM:100_000)
    let b=AeroPlatformAuthority.evaluate(speedMps:60,frontDownforceCoefficientArea:0.7,rearDownforceCoefficientArea:0.9,frontSpringRateNPerM:90_000,rearSpringRateNPerM:100_000)
    #expect(b.frontCompressionM > a.frontCompressionM*3.9)
}
@Test func mentorKeepsMechanicalAuthorityWhileCollaboratingOnModernSystems() {
    let p=MentorKnowledgeProfile()
    #expect(MentorGuidanceAuthority.guidance(profile:p,domain:.fabrication).guidanceMode=="expert coaching")
    #expect(MentorGuidanceAuthority.guidance(profile:p,domain:.canTelemetry).guidanceMode=="defer to specialist/player evidence")
}
@Test func causalLoopTurnsWheelTorqueIntoMotionSlipAndConsequences() {
    var s=CausalVehicleLoopState()
    var p=UnifiedPowertrainParameters();p.enginePeakTorqueNm=700;p.clutchCapacityNm=650
    let bad=DifferentialSetupQuality(backlashError01:0.6,preloadError01:0.5,patternError01:0.6,fluidFill01:0.7)
    for _ in 0..<600 {
        CausalVehicleLoopAuthority.step(state:&s,input:.init(throttle:1,brake01:0,engineRPM:4500,gearboxOutputOmega:30.02,pinionOmega:30,tireMu:0.9,drivenNormalLoadN:7200,chassisRigidity01:0.35,vibrationG:0.4),setup:bad,p:p,dt:0.01)
    }
    #expect(s.longitudinalSpeedMps>0);#expect(s.accumulatedDistanceM>0);#expect(s.mechanical.differentialTemperatureC>45);#expect(abs(s.mechanical.chassisTwistRad)>0)
}
