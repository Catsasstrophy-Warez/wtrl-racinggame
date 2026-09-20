import XCTest
@testable import WTRLGarage

final class Rev27MechanicalInspectionTests:XCTestCase {
 func testLoadedBearingInspectionAmplifiesPlay(){let r=BearingInspectionAuthority.inspect(damage01:0.7,loosenessMm:0.1,temperatureC:105,radialLoadN:5500);XCTAssertGreaterThan(r.loadedPlayMm,r.unloadedPlayMm);XCTAssertTrue(r.findings.count>=2)}
 func testTieRodInspectionRespondsToDamageAndLoad(){let r=SteeringJointInspectionAuthority.inspect(damage01:0.6,loosenessMm:0.2,appliedLoadN:1200);XCTAssertTrue(r.serviceRequired);XCTAssertGreaterThan(r.loadedDeflectionMm,r.freePlayMm)}
 func testDirectionalBushingComplianceCreatesDynamicToeRisk(){let good=BushingComplianceAuthority.inspect(damage01:0.05,appliedLoadN:1500);let bad=BushingComplianceAuthority.inspect(damage01:0.8,appliedLoadN:1500);XCTAssertGreaterThan(bad.lateralMm,good.lateralMm);XCTAssertGreaterThan(bad.dynamicToeRiskDeg,good.dynamicToeRiskDeg)}
 func testDamperHeatAndLeakCreateFade(){let r=DamperInspectionAuthority.inspect(nominalTravelMm:110,measuredTravelMm:100,temperatureC:130,leakSeverity01:0.5);XCTAssertTrue(r.serviceRequired);XCTAssertLessThan(r.reboundRatio01,1)}
 func testDriveshaftOrderAnalysisFindsFirstOrder(){let r=DriveshaftInspectionAuthority.inspect(runoutMm:0.9,operatingAngleDeg:5,phaseErrorDeg:8,shaftRPM:3600,vibrationHz:60);XCTAssertEqual(r.dominantOrder,1,accuracy:0.01);XCTAssertFalse(r.findings.isEmpty)}
 func testChassisDatumDifferenceTriggersInspection(){let r=ChassisDatumAuthority.inspect(leftDiagonalMm:3100,rightDiagonalMm:3092);XCTAssertTrue(r.structuralInspectionRequired);XCTAssertEqual(r.diagonalDifferenceMm,8,accuracy:0.001)}
}
