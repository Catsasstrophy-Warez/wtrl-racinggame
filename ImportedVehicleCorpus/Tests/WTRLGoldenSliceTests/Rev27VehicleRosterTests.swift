import XCTest
@testable import WTRLVehicle
@testable import WTRLWorld

final class Rev27VehicleRosterTests:XCTestCase {
 func testNineHeroProductionVehiclesExist(){XCTAssertEqual(HeroProductionRosterRev27.vehicles.count,9);XCTAssertEqual(Set(HeroProductionRosterRev27.vehicles.map{$0.generationId}).count,9)}
 func testHeroVehiclesHaveUsablePhysicalCalibration(){for v in HeroProductionRosterRev27.vehicles {XCTAssertGreaterThan(v.massKg,1000);XCTAssertGreaterThan(v.wheelbaseM,2);XCTAssertGreaterThan(v.ratedPowerKW,100);XCTAssertGreaterThan(v.coolingCapacity01,0);XCTAssertFalse(v.signatureFailureMechanisms.isEmpty);XCTAssertFalse(v.serviceHighlights.isEmpty)}}
 func testHeroGeometryBindsIntoVehiclePhysics() throws {let v=try XCTUnwrap(HeroProductionRosterRev27.vehicle("hero_2022_apex"));XCTAssertEqual(v.geometry.massKg,v.massKg);XCTAssertEqual(v.geometry.wheelbaseM,v.wheelbaseM)}
 func testHeroExactValuesRemainResearchGated(){for v in HeroProductionRosterRev27.vehicles {XCTAssertFalse(v.researchGates.isEmpty)}}
 func testFiveEnforcementTiersHaveProductionVehicles(){XCTAssertEqual(EnforcementProductionRosterRev27.vehicles.count,5);XCTAssertEqual(Set(EnforcementProductionRosterRev27.vehicles.map{$0.tier}).count,5)}
 func testEnforcementFleetProfilesDeriveFromVehicleTruth(){for v in EnforcementProductionRosterRev27.vehicles {let f=v.fleetProfile;XCTAssertEqual(f.massKg,v.platform.massKg);XCTAssertEqual(f.powerKW,v.platform.ratedPowerKW);XCTAssertEqual(f.tier,v.tier)}}
 func testEnforcementEscalationIncreasesCapability() throws {let county=try XCTUnwrap(EnforcementProductionRosterRev27.vehicle("sentinel_county_v8"));let hunter=try XCTUnwrap(EnforcementProductionRosterRev27.vehicle("apex_state_hunter"));XCTAssertGreaterThan(hunter.platform.ratedPowerKW,county.platform.ratedPowerKW);XCTAssertGreaterThan(hunter.brakeEndurance01,county.brakeEndurance01)}
 func testCopCarsHaveServiceAndDamageHooks(){for v in EnforcementProductionRosterRev27.vehicles {XCTAssertFalse(v.platform.signatureFailureMechanisms.isEmpty);XCTAssertFalse(v.platform.serviceHighlights.isEmpty);XCTAssertFalse(v.equipment.isEmpty);XCTAssertFalse(v.behavior.isEmpty)}}
}
