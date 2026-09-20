import XCTest
import WTRLVehicle
import WTRLWorld
import WTRLDyno

final class Rev28MechanicalCalibrationTests:XCTestCase {
 func testEveryHeroHasMechanicalCalibration(){XCTAssertEqual(VehicleMechanicalCalibrationRosterRev28.hero.count,9);XCTAssertEqual(VehicleMechanicalCalibrationRosterRev28.allHeroVehicleIds,Set(HeroProductionRosterRev27.vehicles.map(\.id)))}
 func testHeroCalibrationsAreExecutable(){for c in VehicleMechanicalCalibrationRosterRev28.hero {XCTAssertGreaterThanOrEqual(c.engineCurve.count,5);XCTAssertGreaterThan(c.gearbox.ratios.count,3);XCTAssertGreaterThan(c.suspension.frontSpringNPerM,0);XCTAssertGreaterThan(c.brakes.thermalCapacityKJPerC,0);XCTAssertFalse(c.stableVisualPartIds.isEmpty);XCTAssertFalse(c.researchGatedFields.isEmpty)}}
 func testAllEnforcementVehiclesHaveCalibration(){for e in EnforcementProductionRosterRev27.vehicles {let c=EnforcementMechanicalCalibrationRev28.calibration(for:e.id);XCTAssertNotNil(c);XCTAssertEqual(c?.vehicleId,e.platform.id)}}
 func testDCTHasSevenRatios(){let c=VehicleMechanicalCalibrationRosterRev28.hero.first{$0.vehicleId=="hero_2022_apex"}!;XCTAssertEqual(c.gearbox.ratios.count,7);XCTAssertLessThan(c.gearbox.shiftTimeS,0.15)}
 func testPeriodCarRetainsDifferentMechanicalCharacter(){let old=VehicleMechanicalCalibrationRosterRev28.hero.first{$0.vehicleId=="hero_1967_original"}!;let apex=VehicleMechanicalCalibrationRosterRev28.hero.first{$0.vehicleId=="hero_2022_apex"}!;XCTAssertLessThan(old.brakes.frontRotorMm,apex.brakes.frontRotorMm);XCTAssertGreaterThan(old.gearbox.shiftTimeS,apex.gearbox.shiftTimeS)}
 func testTelemetryBufferIsBounded(){var b=SectorTelemetryBuffer(capacity:32);for i in 0..<100 {b.append(.init(timestamp:Double(i),sectorId:1,lateralG:0,longitudinalG:0,frontLeftCompressionTravelM:0.1,frontRightCompressionTravelM:0.1,rearLeftCompressionTravelM:0.1,rearRightCompressionTravelM:0.1,steeringWheelAngleDegrees:0,vehicleYawRateDegreesPerSec:0,frontSlipMetric01:0,rearSlipMetric01:0,coolantTemperatureC:90,throttle01:0))};XCTAssertLessThanOrEqual(b.count,32);XCTAssertGreaterThan(b.count,0)}
}
