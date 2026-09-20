import Testing
@testable import WTRLVehicle

@Test func accelerationTransfersNormalLoadRearward() {
    var g=VehicleGeometry();g.frontStaticWeightFraction=0.54
    let staticL=FourCornerLoadAuthority.evaluate(geometry:g,longitudinalAccelerationMps2:0,lateralAccelerationMps2:0)
    let accel=FourCornerLoadAuthority.evaluate(geometry:g,longitudinalAccelerationMps2:5,lateralAccelerationMps2:0)
    #expect(accel.rearLeftN+accel.rearRightN > staticL.rearLeftN+staticL.rearRightN)
    #expect(accel.frontLeftN+accel.frontRightN < staticL.frontLeftN+staticL.frontRightN)
}
@Test func corneringTransfersLoadToOutsidePair() {
    let l=FourCornerLoadAuthority.evaluate(geometry:.init(),longitudinalAccelerationMps2:0,lateralAccelerationMps2:6)
    #expect(l.frontRightN>l.frontLeftN);#expect(l.rearRightN>l.rearLeftN)
}
@Test func empiricalFourCornerTiresRespondToWaterAndLoad() {
    var dry=FourCornerTireState(),wet=FourCornerTireState()
    dry.rearLeft.wheelOmegaRadPerSec=80;dry.rearRight.wheelOmegaRadPerSec=80;wet=dry
    var i=FourCornerTireInput();i.speedMps=20;i.rearDriveTorqueNm=900;i.surfaceGrip01=1;i.water01=0
    let a=FourCornerTireAuthority.step(state:&dry,input:i);i.water01=1
    let b=FourCornerTireAuthority.step(state:&wet,input:i)
    #expect(abs(b.totalLongitudinalN)<abs(a.totalLongitudinalN))
}
@Test func tireSlipGeneratesHeatAndWearEvidence() {
    var s=FourCornerTireState();s.rearLeft.wheelOmegaRadPerSec=120;s.rearRight.wheelOmegaRadPerSec=120
    var i=FourCornerTireInput();i.speedMps=15;i.rearDriveTorqueNm=1200;i.dt=0.01
    let start=s.rearLeft.temperatureC
    for _ in 0..<500 { _=FourCornerTireAuthority.step(state:&s,input:i) }
    #expect(s.rearLeft.temperatureC>start);#expect(s.rearLeft.wear01>0)
}
@Test func causalV2ProducesMotionAndFourPhysicalEvidenceStreams() {
    var s=CausalVehicleLoopV2State(), i=CausalVehicleLoopV2Input();i.throttle=1;i.engineRPM=4800;i.gearboxOutputOmega=30.03;i.pinionOmega=30;i.chassisRigidity01=0.35
    var p=UnifiedPowertrainParameters();p.enginePeakTorqueNm=720;p.clutchCapacityNm=680
    let bad=DifferentialSetupQuality(backlashError01:0.5,preloadError01:0.45,patternError01:0.55,fluidFill01:0.75)
    for _ in 0..<900 { CausalVehicleLoopV2Authority.step(state:&s,input:i,setup:bad,p:p,dt:0.01) }
    #expect(s.speedMps>0);#expect(s.distanceM>0);#expect(s.mechanical.differentialTemperatureC>45);#expect(s.tires.rearLeft.wear01>0);#expect(s.vibration.gaugeNoise01>=0);#expect(s.axleHop.oscillationEnergy>=0)
}
