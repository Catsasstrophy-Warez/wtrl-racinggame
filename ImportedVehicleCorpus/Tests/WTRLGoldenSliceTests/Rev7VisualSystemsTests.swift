import Testing
@testable import WTRLRendering

@Test func instabilityLoadRespondsToGripDemandAndSlip() {
    let calm=InstabilityMeterMath.load(lateralG:0.2,longitudinalG:0.1,availableMuG:1.0,slipRatio:0.01,slipAngleDegrees:1)
    let edge=InstabilityMeterMath.load(lateralG:0.9,longitudinalG:0.5,availableMuG:0.9,slipRatio:0.11,slipAngleDegrees:7)
    #expect(edge > calm);#expect(edge <= 1)
}
@Test func instabilityDecayIsAsymmetric() {
    let rise=InstabilityMeterMath.decayed(previous:0.2,target:0.9,dt:0.1)
    let fall=InstabilityMeterMath.decayed(previous:0.9,target:0.2,dt:0.1)
    #expect(rise-0.2 > 0.9-fall)
}
@Test func thumbZoneReservesBottomFifth() {
    let z=ThumbZoneLayout()
    #expect(z.bottomReservedFraction == 0.20)
    #expect(z.upperHUDMaximumYFraction < 0.80)
}
@Test func speedBlurDoesNotBeginAtParkingSpeed() {
    #expect(SpeedEffectMath.evaluate(speedKph:20).peripheralBlur01 == 0)
    #expect(SpeedEffectMath.evaluate(speedKph:240).peripheralBlur01 > 0.7)
}
@Test func heroExteriorBudgetAcceptsCompliantMesh() {
    let b=MobileArtBudgetCatalog.assets.first{$0.id=="hero_car_exterior"}!
    let r=MeshBudgetValidator.validate(.init(assetId:b.id,triangles:31000,materialSlots:2,hasNGons:false,hasLOD1:true),against:b)
    #expect(r.passed)
}
@Test func meshBudgetRejectsNGonsAndTooManyMaterials() {
    let b=MobileArtBudgetCatalog.assets.first{$0.id=="hero_car_exterior"}!
    let r=MeshBudgetValidator.validate(.init(assetId:b.id,triangles:31000,materialSlots:4,hasNGons:true,hasLOD1:true),against:b)
    #expect(!r.passed);#expect(r.violations.count == 2)
}
