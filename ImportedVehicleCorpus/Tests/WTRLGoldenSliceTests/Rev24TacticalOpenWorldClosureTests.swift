import XCTest
@testable import WTRLVehicle
@testable import WTRLWorld
@testable import WTRLGarage

final class Rev24TacticalOpenWorldClosureTests:XCTestCase {
 func testImpactCreatesAlignmentAndPressureEvidence(){let d=PursuitImpactDamageAuthority.resolve(impulseNs:11000,contactLateral01:0.9,wheelContact:true);XCTAssertGreaterThan(d.toeShiftDeg,0.2);XCTAssertGreaterThan(d.pressureLeakSeverity01,0)}
 func testOpenDiffIsLoadLimited(){var p=DifferentialModelParameters();p.type = .open;let s=DifferentialModelAuthority.split(inputTorqueNm:800,leftOmega:20,rightOmega:25,leftLoadN:300,rightLoadN:4000,p:p);XCTAssertLessThan(s.leftNm+s.rightNm,200)}
 func testPursuitTrackingUsesOcclusionAndCooldown(){var s=PursuitSystemsState();PursuitSystemsAuthority.step(state:&s,heat:.containment,visible:true,occluded:false,speedMps:30,dt:0.1);XCTAssertEqual(s.tracking,.visual);PursuitSystemsAuthority.step(state:&s,heat:.containment,visible:false,occluded:true,speedMps:30,dt:1);XCTAssertEqual(s.tracking,.occluded);XCTAssertTrue(s.roadblockRequested)}
 func testRecoveryRequiresReleaseInsteadOfRaid(){var l=VehicleRecoveryLedger(vehicleId:"hero");VehicleRecoveryAuthority.placeHold(&l,heat:4,days:2);XCTAssertFalse(VehicleRecoveryAuthority.lawfulRelease(&l,paymentCredits:100));XCTAssertTrue(VehicleRecoveryAuthority.lawfulRelease(&l,paymentCredits:2000));XCTAssertEqual(l.status,.released)}
 func testValveLashMustBeMeasuredBeforeLock(){var s=ValveLashState();XCTAssertEqual(PrecisionValveLashAuthority.adjust(state:&s,deltaMm:-0.25),.withinSpec);XCTAssertTrue(PrecisionValveLashAuthority.lock(state:&s));XCTAssertEqual(s.safeRpmCeiling,6800)}
 func testWorkshopTierChangesLogistics(){var s=WorldCommerceState();WorldCommerceAuthority.upgrade(&s,to:5);XCTAssertEqual(s.workshopTier,5);XCTAssertGreaterThan(s.inventorySlots,100);XCTAssertLessThan(s.partsDeliveryHours,1)}
}
