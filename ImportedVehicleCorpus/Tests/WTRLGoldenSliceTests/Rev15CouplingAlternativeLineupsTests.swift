import Foundation
import Testing
@testable import WTRLVehicle

@Test func suspensionReactionFeedsDynamicTireLoad(){var s=FourCornerSuspensionState();s.frontLeft.tireForceN=2500;var q=FourCornerLoads();q.frontLeftN=3000;let d=SuspensionTireCouplingAuthority.dynamicLoads(suspension:s,quasiStatic:q);#expect(d.frontLeftN>q.frontLeftN)}
@Test func suspensionTravelChangesCamberAndToe(){var s=FourCornerSuspensionState();s.frontLeft.sprungPositionM=0.03;let a=SuspensionTireCouplingAuthority.alignment(corner:.frontLeft,suspension:s,front:.init(),rear:.init());#expect(a.camberDeg != -0.7);#expect(a.toeDeg != 0.05)}
@Test func bodyAttitudeRespondsToAsymmetricRideHeight(){var s=FourCornerSuspensionState();s.frontRight.sprungPositionM=0.02;let a=SuspensionTireCouplingAuthority.attitude(suspension:s,geometry:.init());#expect(abs(a.rollRad)>0);#expect(abs(a.pitchRad)>0)}
@Test func limitedSlipBiasesTorqueTowardSlowerWheel(){let x=LimitedSlipDifferentialAuthority.split(inputTorqueNm:600,leftOmega:40,rightOmega:55,p:.init());#expect(x.leftNm>x.rightNm);#expect(abs((x.leftNm+x.rightNm)-600)<0.001)}
@Test func hotDamperDevelopsFade(){var s=DamperThermalState();for _ in 0..<20000{DamperThermalAuthority.step(state:&s,damperForceN:18000,shaftVelocityMps:2.5,ambientC:30,dt:0.01)};#expect(s.temperatureC>105);#expect(s.fade01>0)}
@Test func spectralObserverFindsWheelHopBand(){var o=WheelHopSpectralObserver();o.sampleRateHz=120;for n in 0..<240{o.append(sin(2*Double.pi*14*Double(n)/120),maximum:256)};let f=o.dominantFrequencyHz();#expect(f>13 && f<15)}
@Test func eightAlternativeLineupsAreFictionalAndResearchGated(){#expect(AlternativeHeroLineupCatalog.lineups.count==8);#expect(Set(AlternativeHeroLineupCatalog.lineups.map{$0.archetype}).count==8);#expect(AlternativeHeroLineupCatalog.lineups.allSatisfy{$0.sourceStatus.contains("fictional production identity")})}
@Test func livingShipSwapBlueprintsDemandFabrication(){#expect(CrossGenerationSwapCatalog.blueprints.count==4);#expect(CrossGenerationSwapCatalog.blueprints.allSatisfy{!$0.requiredOperations.isEmpty && $0.researchStatus.contains("calibrate")})}
