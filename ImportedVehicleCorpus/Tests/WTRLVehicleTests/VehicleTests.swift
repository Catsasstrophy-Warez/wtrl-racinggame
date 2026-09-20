import Testing
@testable import WTRLVehicle
@Test func failedBearingHasHigherRisk(){ var good=EngineeringPrimitiveState(); good.kind = .Bearing; good.condition01=1; var bad=good; bad.condition01=0.2; #expect(PartPhysicsCompiler.evaluate(bad).failureRisk01 > PartPhysicsCompiler.evaluate(good).failureRisk01) }
@Test func hydroplaningOnsetRisesWithPressure(){ #expect(EmpiricalTireModel.hydroplaningOnsetKph(pressureKpa:260) > EmpiricalTireModel.hydroplaningOnsetKph(pressureKpa:180)) }
@Test func tireProducesLongitudinalForce(){ var i=EmpiricalTireInput(); i.slipRatio=0.1; #expect(EmpiricalTireModel.evaluate(i).longitudinalN > 0) }
