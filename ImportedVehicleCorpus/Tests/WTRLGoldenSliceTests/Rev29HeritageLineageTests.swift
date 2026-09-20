import XCTest
@testable import WTRLVehicle
@testable import WTRLGarage
@testable import WTRLDyno
final class Rev29HeritageLineageTests:XCTestCase {
 func testFourteenCoreLineagesHaveNineCarsEach(){ XCTAssertEqual(HeritageLineageEngineeringRev29.core14.count,14); XCTAssertTrue(HeritageLineageEngineeringRev29.core14.allSatisfy{$0.vehicles.count==9}) }
 func testFordTripleWideHasTwentySevenCars(){ XCTAssertEqual(HeritageLineageEngineeringRev29.fordTripleWide.vehicles.count,27) }
 func testCombinedHeritageFleetHas153Vehicles(){ XCTAssertEqual(HeritageLineageEngineeringRev29.vehicleCount,153); XCTAssertEqual(HeritageLineageEngineeringRev29.lineageCount,15) }
 func testFordTracksHaveNineCarsEach(){ let g=Dictionary(grouping:HeritageLineageEngineeringRev29.fordTripleWide.vehicles,by:{$0.trackId ?? ""}); XCTAssertEqual(g["heavy_iron"]?.count,9); XCTAssertEqual(g["homologation"]?.count,9); XCTAssertEqual(g["endurance_halo"]?.count,9) }
 func testAllReferenceClaimsRemainResearchGated(){ XCTAssertTrue(HeritageLineageEngineeringRev29.allVehicles.allSatisfy{$0.sourceStatus == .researchPending && !$0.researchGatedClaims.isEmpty}) }
 func testEveryVehicleProducesWorkshopJobAndTelemetry(){ for v in HeritageLineageEngineeringRev29.allVehicles { XCTAssertFalse(HeritageWorkshopRuntimeRev29.job(for:v).title.isEmpty); XCTAssertTrue(HeritageTelemetrySignaturesRev29.signature(for:v).expectedChannels.contains("engine.rpm")) } }
 func testFordForcedInductionAddsChargeTelemetry(){ let v=HeritageLineageEngineeringRev29.fordTripleWide.vehicles.first{$0.displayName.contains("Focus RS Mk3")}!; XCTAssertTrue(HeritageTelemetrySignaturesRev29.signature(for:v).expectedChannels.contains("charge.temperature")) }
}
