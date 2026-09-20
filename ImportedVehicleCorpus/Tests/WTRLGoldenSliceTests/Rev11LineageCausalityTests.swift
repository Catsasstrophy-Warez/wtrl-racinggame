import Foundation
import Testing
@testable import WTRLVehicle
@testable import WTRLCareer

@Test func preservedStructuralCutLeavesPermanentHistory() {
    var l=HeroLineageState(philosophy:.preserved)
    l.apply(.init(description:"IRS rear floor conversion",yearApplied:2018,reversibility:.structuralCut,authenticityImpact01:0.35,torsionalRigidityDelta01:0.3))
    #expect(l.structuralOriginality01 < 1)
    #expect(l.historyMarks.contains{$0.kind == .fabricationCut})
}
@Test func historicEligibilityComesFromConfigurationNotBranchLabel() {
    var l=HeroLineageState(philosophy:.livingShip);l.periodCorrectness01=0.92;l.structuralOriginality01=0.94
    let r=CompetitionEligibilityRule(id:"historic",technologyWindow:.historicStock,minimumPeriodCorrectness01:0.9,minimumStructuralOriginality01:0.9,maximumPerformanceIndex:0.55)
    #expect(LineageEligibilityAuthority.assess(lineage:l,performanceIndex:0.50,rule:r).eligible)
    #expect(!LineageEligibilityAuthority.assess(lineage:l,performanceIndex:0.70,rule:r).eligible)
}
@Test func livingShipToPreservedIsRestorationProjectNotMagicUndo() {
    let p=LineageConversionPlanner.plan(from:.livingShip,to:.preserved,structuralOriginality01:0.45)
    #expect(p.requiresFabrication);#expect(p.requiresPeriodPartsSourcing);#expect(p.laborHours>400);#expect(p.cannotEraseHistoryMarks)
}
@Test func clutchOverCapacityCreatesHeatAndWear() {
    var s=UnifiedPowertrainState();s.engineRPM=4200
    var p=UnifiedPowertrainParameters();p.enginePeakTorqueNm=900;p.clutchCapacityNm=300
    let before=s.clutchWear01
    var heat=0.0
    for _ in 0..<200 { heat += UnifiedPowertrainAuthority.step(state:&s,throttle:1,gearboxOutputOmega:80,pinionOmega:78,dt:0.01,p:p).clutchHeatWatts }
    #expect(heat>0);#expect(s.clutchTemperatureC>35);#expect(s.clutchWear01>before)
}
@Test func poorDifferentialSetupProducesMoreHeatNoiseAndWear() {
    var good=MechanicalConsequenceState(), bad=MechanicalConsequenceState()
    let g=DifferentialSetupQuality(), b=DifferentialSetupQuality(backlashError01:0.8,preloadError01:0.6,patternError01:0.7,fluidFill01:0.5)
    for _ in 0..<600 {
        MechanicalConsequenceAuthority.step(state:&good,wheelTorqueNm:900,differentialSpeedRadPerSec:70,setup:g,chassisRigidity01:0.8,dt:0.01)
        MechanicalConsequenceAuthority.step(state:&bad,wheelTorqueNm:900,differentialSpeedRadPerSec:70,setup:b,chassisRigidity01:0.8,dt:0.01)
    }
    #expect(bad.differentialTemperatureC>good.differentialTemperatureC)
    #expect(bad.gearNoise01>good.gearNoise01);#expect(bad.differentialWear01>good.differentialWear01)
}
@Test func weakOldChassisTwistsMoreUnderSameTorque() {
    var weak=MechanicalConsequenceState(), stiff=MechanicalConsequenceState();let setup=DifferentialSetupQuality()
    MechanicalConsequenceAuthority.step(state:&weak,wheelTorqueNm:1800,differentialSpeedRadPerSec:60,setup:setup,chassisRigidity01:0.25,dt:0.01)
    MechanicalConsequenceAuthority.step(state:&stiff,wheelTorqueNm:1800,differentialSpeedRadPerSec:60,setup:setup,chassisRigidity01:0.9,dt:0.01)
    #expect(abs(weak.chassisTwistRad)>abs(stiff.chassisTwistRad));#expect(weak.alignmentErrorDegrees>stiff.alignmentErrorDegrees)
}
