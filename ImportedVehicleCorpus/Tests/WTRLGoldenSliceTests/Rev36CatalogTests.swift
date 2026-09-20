import XCTest
@testable import WTRLVehicle
final class Rev36CatalogTests:XCTestCase {
 func testPowertrainCatalogHasAllRequestedFamilies(){ XCTAssertEqual(PeriodAwarePowertrainCatalogRev36.engines.count,15); XCTAssertEqual(PeriodAwarePowertrainCatalogRev36.transmissions.count,11); XCTAssertEqual(PeriodAwarePowertrainCatalogRev36.all.count,26) }
 func testFutureTechnologyIsLocked(){ let p=PeriodAwarePowertrainCatalogRev36.engines.first{$0.id=="eng_coyote50"}!; XCTAssertFalse(PeriodAwarePowertrainCatalogRev36.availability(of:p,inYear:1970).available); XCTAssertTrue(PeriodAwarePowertrainCatalogRev36.availability(of:p,inYear:2011).available) }
 func testRetiredPartsBecomeHistoricalChannels(){ let p=PeriodAwarePowertrainCatalogRev36.engines.first{$0.id=="eng_flathead_v8"}!; let a=PeriodAwarePowertrainCatalogRev36.availability(of:p,inYear:2026); XCTAssertTrue(a.available); XCTAssertTrue(a.kinds.contains(.usedOriginal)); XCTAssertTrue(a.kinds.contains(.reproduction)) }
 func testPanteraAndTruckZFAreSeparated(){ XCTAssertNotNil(PeriodAwarePowertrainCatalogRev36.transmissions.first{$0.id=="tx_zf_truck5"}); XCTAssertNotNil(PeriodAwarePowertrainCatalogRev36.transmissions.first{$0.id=="tx_zf_pantera5"}) }
 func testCompleteVehicleCatalogIsUnique(){ XCTAssertTrue(CompleteVehicleCatalogRev36.uniqueIDs); XCTAssertEqual(CompleteVehicleCatalogRev36.playerFacingCount,186) }
 func testSecretVehicleRemainsCataloged(){ XCTAssertEqual(CompleteVehicleCatalogRev36.entries.filter{$0.catalogClass == .secretEndgame}.map(\.displayName),["Apex Revenant"]) }
}
