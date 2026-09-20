import Testing
@testable import WTRLVehicle
@testable import WTRLGarage
@testable import WTRLWorld
@testable import WTRLDyno

@Test func aeroLoadAddsNormalLoadAndCompressesPlatform() {
    var s=AeroMechanicalState(); var i=AeroMechanicalInput();i.speedMps=75
    AeroMechanicalClosureAuthority.step(state:&s,input:i)
    #expect(s.aero.frontDownforceN > 0); #expect(s.loads.frontLeftN > 0); #expect(s.frontRideHeightM < i.frontStaticRideHeightM + 0.01)
}
@Test func lowRideHeightCanStallUnderbody() { var s=AeroMechanicalState();var i=AeroMechanicalInput();i.speedMps=70;i.frontStaticRideHeightM=0.015;AeroMechanicalClosureAuthority.step(state:&s,input:i);#expect(s.aero.stalled) }
@Test func garageTiersUnlockPhysicalCapabilities(){#expect(!WorkshopTierAuthority.capabilities(.barn).contains(.chassisDyno));#expect(WorkshopTierAuthority.capabilities(.speedLab).contains(.chassisDyno));#expect(WorkshopTierAuthority.capabilities(.empire).contains(.multiBayInventory))}
@Test func diagnosticBenchEvolvesByEra(){#expect(DiagnosticBenchAuthority.tools(for:.analog).contains(.dwellMeter));#expect(DiagnosticBenchAuthority.tools(for:.networked).contains(.canMonitor))}
@Test func hydroplaningRiskRespondsToWaterSpeedAndTread(){let dry=HydroplaningAuthority.resolve(baseMu:0.8,waterFilmMM:0.2,speedMps:20,treadDepthMM:7,tirePressureKPa:220);let wet=HydroplaningAuthority.resolve(baseMu:0.8,waterFilmMM:5,speedMps:45,treadDepthMM:1,tirePressureKPa:240);#expect(wet.risk01 > dry.risk01);#expect(wet.effectiveMu < dry.effectiveMu)}
@Test func dynoDiagnosticsSeparateClutchAndRollerSlip(){var c=DynoDiagnosticChannels();c.clutchSlipRPM=150;c.rollerSlip01=0.08;let d=DynoDiagnosticAuthority.classify(c);#expect(d.contains("clutch slip"));#expect(d.contains("tire-to-roller slip"))}
@Test func serviceInvoiceIsItemizedFromPhysicalWear(){var w=WorkshopWearLedger();w.chassisSet01=0.4;w.frontPadMM=2;w.tireWearRR=0.95;let lines=WorkshopInvoiceAuthority.invoice(w);#expect(lines.count >= 3);#expect(lines.reduce(0){$0+$1.costCredits}>1500)}
@Test func portingCreatesFlowGainAndEventuallyRisk(){var f=FlowBenchState();FlowBenchAuthority.handPort(&f,removalGrams:120);#expect(f.intakeFlowCFM>220);#expect(f.wallRisk01>0)}
