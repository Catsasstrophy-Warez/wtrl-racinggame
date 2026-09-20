import Testing
@testable import WTRLVehicle
@testable import WTRLDyno
@testable import WTRLCareer
@testable import WTRLAudio

@Test func magicFormulaIsOddAroundZero() {
    let c=MagicFormulaCoefficients()
    let p=MagicFormula.lateralForce(slipAngleRad:0.08,normalLoadN:4000,coefficients:c)
    let n=MagicFormula.lateralForce(slipAngleRad:-0.08,normalLoadN:4000,coefficients:c)
    #expect(abs(p+n)<0.0001)
}
@Test func planarRK4AcceleratesAndStaysFinite() {
    var s=PlanarVehicleState();var u=PlanarVehicleInput();u.throttle01=0.8
    let p=PlanarVehicleParameters()
    for _ in 0..<240 {PlanarVehicleDynamics.rk4Step(&s,input:u,parameters:p,dt:1.0/120.0)}
    #expect(s.longitudinalVelocityMps>0);#expect(s.xM>0);#expect(s.yM.isFinite)
}
@Test func steeringProducesYaw() {
    var s=PlanarVehicleState();s.longitudinalVelocityMps=20
    var u=PlanarVehicleInput();u.steeringRadians=0.04
    let p=PlanarVehicleParameters()
    for _ in 0..<60 {PlanarVehicleDynamics.rk4Step(&s,input:u,parameters:p,dt:1.0/120.0)}
    #expect(abs(s.yawRateRadPerSec)>0.001)
}
@Test func instabilityEstimatorSeparatesEvidence() {
    let r=InstabilityEstimator.evaluate(axMps2:7,ayMps2:4,frictionCoefficient:1,slipContribution01:0.4,inputRateContribution01:0.5)
    #expect(r.normalizedAccelerationDemand01>0.5);#expect(r.inputRateContribution01==0.5)
}
@Test func diagnosticNeedsRepeatedThermalEvidence() {
    func s(_ temp:Double)->SectorTelemetrySample {.init(timestamp:0,sectorId:2,lateralG:0,longitudinalG:0,frontLeftCompressionTravelM:0.05,frontRightCompressionTravelM:0.05,rearLeftCompressionTravelM:0.05,rearRightCompressionTravelM:0.05,steeringWheelAngleDegrees:0,vehicleYawRateDegreesPerSec:0,frontSlipMetric01:0,rearSlipMetric01:0,coolantTemperatureC:temp,throttle01:1)}
    #expect(TelemetryDiagnosticAnalyzer.evaluate([s(116)]).severity != .catastrophicImminent)
    #expect(TelemetryDiagnosticAnalyzer.evaluate([s(116),s(117),s(118)]).severity == .catastrophicImminent)
}
@Test func rearSlipDiagnosticDoesNotOverclaimDifferential() {
    let x=SectorTelemetrySample(timestamp:0,sectorId:4,lateralG:0.7,longitudinalG:0.4,frontLeftCompressionTravelM:0.04,frontRightCompressionTravelM:0.04,rearLeftCompressionTravelM:0.04,rearRightCompressionTravelM:0.04,steeringWheelAngleDegrees:10,vehicleYawRateDegreesPerSec:40,frontSlipMetric01:0.1,rearSlipMetric01:0.4,coolantTemperatureC:95,throttle01:0.8)
    let r=TelemetryDiagnosticAnalyzer.evaluate([x,x,x])
    #expect(r.targetedComponentId=="rear_traction_system");#expect(r.mechanicalExplanation.contains("does not uniquely prove"))
}
@Test func intimidationDoesNotModifyVehiclePower() {
    var d=RivalDriverAttributes();d.composure01=0.1
    let c=RivalTrackContext(distanceToApexM:100,brakingDistanceBeforeApexM:50,trackWidthM:10,cornerRadiusM:60)
    let r=IntimidationDecisionModel.evaluate(driver:d,context:c,playerLongitudinalDeltaM:0,playerReputation01:1)
    #expect(r.intimidation01>0);#expect(r.throttle01>=0 && r.throttle01<=1)
}
@Test func v8FiringFrequencyIsFourEventsPerRevolution() {
    let p=CombustionAudioParameters(cylinderCount:8)
    #expect(abs(p.firingEventFrequencyHz(rpm:6000)-400)<0.001)
}
@Test func blowerWhineUsesRotorPassFrequency() {
    var b=SuperchargerAudioParameters();b.rotorLobeCount=3;b.driveRatio=2
    #expect(abs(b.rotorPassFrequencyHz(engineRPM:6000)-600)<0.001)
}
@Test func clubContactReducesSafety() {
    var c=CareerCurrencies();c.safetyRating01=0.8
    CareerEconomyAuthority.apply(.init(contactSeverity01:1,offTrackSeconds:0,aggressiveBlockSeverity01:0,repairCostCredits:0),culture:.club,to:&c)
    #expect(c.safetyRating01<0.8)
}
@Test func streetContactDoesNotPretendToBeFreeRepair() {
    var c=CareerCurrencies();c.cashCredits=1000
    CareerEconomyAuthority.apply(.init(contactSeverity01:1,offTrackSeconds:0,aggressiveBlockSeverity01:0,repairCostCredits:250),culture:.street,to:&c)
    #expect(c.cashCredits==750);#expect(c.reputation01>0)
}
@Test func shakedownProgressesInOrder() {
    var s=ShakedownMissionState()
    #expect(ShakedownMissionAuthority.advance(&s,successful:true));#expect(s.stage == .transportToRoad)
}
