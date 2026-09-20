import Testing
@testable import WTRLVehicle
@testable import WTRLWorld
@testable import WTRLCore

@Test func wiebeBurnFractionIsMonotonic() { let a=CombustionCycleAuthority.burnedFraction(crankDegATDC:-20,sparkAdvanceBTDC:24,burnDurationDeg:48);let b=CombustionCycleAuthority.burnedFraction(crankDegATDC:10,sparkAdvanceBTDC:24,burnDurationDeg:48);#expect(b>a);#expect(a>=0 && b<=1) }
@Test func advancedLeanCombustionRaisesKnockRisk() { var n=CombustionCycleInput();n.afr=12.6;n.sparkAdvanceBTDC=24;var k=n;k.afr=14.5;k.sparkAdvanceBTDC=38;let a=CombustionCycleAuthority.evaluate(input:n),b=CombustionCycleAuthority.evaluate(input:k);#expect(b.knockRisk01>a.knockRisk01);#expect(a.indicatedTorqueNm>0) }
@Test func tireSlipHeatsLayersRaisesPressureAndWearsRubber() { var s=MultiLayerTireThermalState();for _ in 0..<1200 { MultiLayerTireThermalAuthority.step(state:&s,slipPowerW:22000,verticalLoadN:4200,wheelOmega:90,ambientC:22,roadC:30,dt:0.01) };#expect(s.treadC>24);#expect(s.carcassC>24);#expect(s.pressureKPa>206.8);#expect(s.wearLife01<1) }
@Test func driveshaftResonanceRiskRisesNearCriticalSpeed() { var s=DriveshaftResonanceState();let base=DriveshaftResonanceAuthority.step(state:&s,shaftRPM:2500,torqueNm:400,chassisTwistDeg:0.2,dt:0.01);let near=DriveshaftResonanceAuthority.step(state:&s,shaftRPM:base.criticalRPM*0.98,torqueNm:700,chassisTwistDeg:1.0,dt:0.01);#expect(near.estimatedDeflectionMm>base.estimatedDeflectionMm);#expect(near.fractureRisk01>base.fractureRisk01) }
@Test func sanTrianaStreamingHandlesNegativeCoordinatesAndEviction() { let c=SanTrianaStreamingAuthority.coordinate(x:620,z:-310);#expect(c.x==2);#expect(c.z == -2);let old=SanTrianaStreamingAuthority.desired(around:.init(x:0,z:0),radius:1);let d=SanTrianaStreamingAuthority.page(current:old,player:.init(x:4,z:4),radius:1);#expect(d.resident.count==9);#expect(!d.evict.isEmpty);#expect(!d.load.isEmpty) }
@Test func acousticReflectionsHavePhysicalDelayAndDistanceLoss() { let r=EnvironmentalAcousticAuthority.reflections(vehicle:.zero,exhaustDirection:.init(1,0,0),walls:[.init(10,0,0),.init(30,0,0)]);#expect(r.count==2);#expect(r[0].gain>r[1].gain);#expect(r[0].delayS<r[1].delayS) }
