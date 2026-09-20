import XCTest
@testable import WTRLVehicle
@testable import WTRLCareer
final class Rev38EngineeringTruthInspectionTests:XCTestCase {
 func testEngineeringTruthCoversAllPlayerVehicles(){XCTAssertTrue(VehicleEngineeringTruthCatalogRev38.completeCoverage);XCTAssertEqual(VehicleEngineeringTruthCatalogRev38.profiles.count,186)}
 func testApexIsFrontRearTransaxle(){let e=CompleteVehicleCatalogRev36.entries.first{$0.id==SecretApexVehicleRev34.platformId}!;XCTAssertEqual(VehicleEngineeringTruthCatalogRev38.profile(for:e).drivetrain,.frontRearTransaxleRWD)}
 func testInspectionRevealsHiddenProjectHardware(){let e=CompleteVehicleCatalogRev36.entries.first{$0.displayName.contains("1968 Crownfire King")}!;let l=AcquisitionEcosystemRev37.listing(platform:e,modelYear:1968,channel:.barnFind,careerYear:1990)!;var s=PrePurchaseInspectionAuthorityRev38.begin(l);PrePurchaseInspectionAuthorityRev38.perform(.identityDecode,on:l,state:&s);XCTAssertFalse(s.findings.isEmpty);XCTAssertTrue(s.completed.contains(.identityDecode))}
 func testInspectionRiskFallsAsEvidenceGrows(){let e=CompleteVehicleCatalogRev36.entries[0];let l=AcquisitionEcosystemRev37.listing(platform:e,modelYear:1967,channel:.usedDealer,careerYear:1990)!;var s=PrePurchaseInspectionAuthorityRev38.begin(l);let before=s.risk01;PrePurchaseInspectionAuthorityRev38.perform(.liftInspection,on:l,state:&s);XCTAssertLessThan(s.risk01,before)}
 func testApexEvolutionCannotSkipBaseline(){var s=ApexRevenantEvolutionRev38();ApexRevenantEvolutionAuthorityRev38.unlockExperimentalProgram(&s);XCTAssertFalse(s.experimentalProgramUnlocked);ApexRevenantEvolutionAuthorityRev38.certifyBaseline(&s);ApexRevenantEvolutionAuthorityRev38.unlockExperimentalProgram(&s);ApexRevenantEvolutionAuthorityRev38.certifyUltimate(&s);XCTAssertEqual(s.configuration,.ultimateV12Certified)}
}
