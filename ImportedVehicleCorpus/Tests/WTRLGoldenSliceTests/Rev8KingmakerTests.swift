import Testing
import Foundation
@testable import WTRLVehicle
@testable import WTRLRendering
@testable import WTRLCareer
@testable import WTRLDyno
@testable import WTRLRacing
@testable import WTRLPersistence
@testable import WTRLApp

@Test func fixedStepProducesSamePhysicsAcrossRenderCadence() {
    func simulate(_ frame:Double)->DynamicState {
        var s=DynamicState(),clock=FixedStepClock();var elapsed=0.0
        while elapsed<2 {_ = clock.consume(frameDelta:frame){dt in var u=DynamicsInput();u.driveAccelerationMps2=3;RK4Dynamics.step(&s,input:u,dt:dt)};elapsed += frame}
        return s
    }
    let a=simulate(1.0/30),b=simulate(1.0/60)
    #expect(abs(a.velocityMps-b.velocityMps)<0.15)
}
@Test func tireLUTInterpolates() {
    let l=TireForceLUT(minimum:-1,maximum:1,values:[-100,0,100])
    #expect(abs(l.sample(0.5)-50)<0.001)
}
@Test func erraticInputRaisesOscillation() {
    var s=InputJerkState();var i=DriverInputSample();i.steering=1
    #expect(InputJerkModel.update(&s,current:i,dt:0.02)>0)
}
@Test func thermalGovernorPreservesPhysicsBeforeCritical() {
    #expect(PerformanceGovernor.policy(thermal:.serious,lowPower:false).physicsHz==120)
    #expect(PerformanceGovernor.policy(thermal:.serious,lowPower:false).renderFPS==30)
}
@Test func criticalThermalDropsPhysicsAsLastResort() {
    #expect(PerformanceGovernor.policy(thermal:.critical,lowPower:false).physicsHz==60)
}
@Test func reduceMotionDisablesBlurAndTilt() {
    var a=MotionAccessibility();a.reduceMotion=true
    let p=PerformanceGovernor.policy(thermal:.nominal,lowPower:false)
    #expect(!AccessibilityGovernor.effectiveBlur(user:a,performance:p))
    #expect(!AccessibilityGovernor.effectiveCameraTilt(user:a))
}
@Test func propertyUnlocksPhysicalCapabilities() {
    #expect(!PropertyAuthority.capabilities(.backyardShed).dyno)
    #expect(PropertyAuthority.capabilities(.proSpeedShop).dyno)
    #expect(PropertyAuthority.capabilities(.industrialWarehouse).multiBayStorage)
}
@Test func professionalContractRequiresSafetyAndDyno() {
    let c=ShopDriverContract(id:"c",title:"Dyno validation",payout:1000,requiredSafety:0.7,requiredCapability:"dyno")
    var r=DriverRatings();r.safety=0.8
    #expect(ContractAuthority.eligible(c,ratings:r,property:PropertyAuthority.capabilities(.proSpeedShop)))
    r.safety=0.4
    #expect(!ContractAuthority.eligible(c,ratings:r,property:PropertyAuthority.capabilities(.proSpeedShop)))
}
@Test func intimidationChangesRivalBehaviorWithoutPaceBoost() {
    let calm=RivalConfidenceModel.evaluate(playerReputation:0,playerThreat01:0,rivalBaseConfidence:0.8)
    let intimidated=RivalConfidenceModel.evaluate(playerReputation:1,playerThreat01:1,rivalBaseConfidence:0.8)
    #expect(intimidated.brakeHesitation01>calm.brakeHesitation01)
    #expect(intimidated.startHesitationSeconds>calm.startHesitationSeconds)
}
@Test func diagnosticNarrativeIsActionable() {
    let s=DiagnosticNarrative.sentence(.init(location:"in Turn 3",symptom:"Mid-corner understeer",likelyCause:"front rebound damping is too stiff for the curb transition",confidence01:0.82,nextAction:"Reduce front rebound two clicks and repeat the lap."))
    #expect(s.contains("understeer"));#expect(s.contains("Reduce"))
}
@Test func ghostRequiresMonotonicTime() {
    let g=GhostRun(id:"g",vehicleSpecHash:"x",routeId:"r",samples:[.init(time:0,position:.zero,speedKph:0,throttle:0,brake:0),.init(time:1,position:.zero,speedKph:50,throttle:1,brake:0)])
    #expect(GhostRunValidator.valid(g))
}
@Test func checkpointRejectsCorruptionAndRecoversOlder() throws {
    let s=SaveEnvelope();let good=try CheckpointAuthority.make(sequence:1,reason:"good",save:s)
    var bad=try CheckpointAuthority.make(sequence:2,reason:"bad",save:s);bad.saveData.append(0x42)
    #expect(CheckpointAuthority.recover([good,bad]) != nil)
}
@Test func assetFallbackKeepsGameplayLaunchable() {
    let e=AssetManifestEntry(id:"kr",resource:"KR.usdz",fallback:"proxy.usdz",criticality:.gameplay)
    let r=AssetFallbackResolver.resolve(e,available:["proxy.usdz"])
    #expect(r.playable);#expect(r.usedFallback)
}
