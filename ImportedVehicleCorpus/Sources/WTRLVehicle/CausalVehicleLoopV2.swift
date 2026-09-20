import Foundation

public struct CausalVehicleLoopV2State:Codable,Hashable,Sendable {
    public var powertrain=UnifiedPowertrainState(), mechanical=MechanicalConsequenceState(), brakes=BrakeThermalState(), vibration=VibrationFatigueState()
    public var tires=FourCornerTireState(), axleHop=AxleHopObserverState()
    public var speedMps=0.0, longitudinalAccelerationMps2=0.0, lateralAccelerationMps2=0.0, distanceM=0.0
    public init(){}
}
public struct CausalVehicleLoopV2Input:Sendable {
    public var throttle=0.0,brake01=0.0,engineRPM=900.0,gearboxOutputOmega=0.0,pinionOmega=0.0,steeringSlipAngleDeg=0.0
    public var surfaceGrip01=1.0,water01=0.0,chassisRigidity01=0.5
    public var geometry=VehicleGeometry(),tireCoefficients=EmpiricalTireCoefficients()
    public init(){}
}
public enum CausalVehicleLoopV2Authority {
    public static func step(state:inout CausalVehicleLoopV2State,input i:CausalVehicleLoopV2Input,setup:DifferentialSetupQuality,p:UnifiedPowertrainParameters = .init(),dt:Double) {
        state.powertrain.engineRPM=i.engineRPM
        let drive=UnifiedPowertrainAuthority.step(state:&state.powertrain,throttle:i.throttle,gearboxOutputOmega:i.gearboxOutputOmega,pinionOmega:i.pinionOmega,dt:dt,p:p)
        var ti=FourCornerTireInput();ti.speedMps=state.speedMps;ti.longitudinalAccelerationMps2=state.longitudinalAccelerationMps2;ti.lateralAccelerationMps2=state.lateralAccelerationMps2;ti.steeringSlipAngleDeg=i.steeringSlipAngleDeg;ti.rearDriveTorqueNm=drive.wheelTorqueNm;ti.wheelRadiusM=p.wheelRadiusM;ti.surfaceGrip01=i.surfaceGrip01;ti.water01=i.water01;ti.geometry=i.geometry;ti.coefficients=i.tireCoefficients;ti.dt=dt
        let tire=FourCornerTireAuthority.step(state:&state.tires,input:ti)
        let brakeCapacity=max(0,i.brake01)*i.geometry.massKg*9.80665*min(1.25,i.surfaceGrip01)
        let rolling=0.012*i.geometry.massKg*9.80665
        let net=tire.totalLongitudinalN-brakeCapacity-rolling
        state.longitudinalAccelerationMps2=net/max(i.geometry.massKg,1)
        state.lateralAccelerationMps2=tire.totalLateralN/max(i.geometry.massKg,1)
        let old=state.speedMps;state.speedMps=max(0,state.speedMps+state.longitudinalAccelerationMps2*dt);state.distanceM += state.speedMps*dt
        MechanicalConsequenceAuthority.step(state:&state.mechanical,wheelTorqueNm:drive.wheelTorqueNm,differentialSpeedRadPerSec:i.pinionOmega,setup:setup,chassisRigidity01:i.chassisRigidity01,dt:dt)
        BrakeThermalAuthority.step(state:&state.brakes,vehicleMassKg:i.geometry.massKg,speedBeforeMps:old,speedAfterMps:state.speedMps,frontBias01:0.68,thermalCapacityJPerK:120_000,cooling01:0.6,dt:dt)
        let rearLoad=tire.loads.rearLeftN+tire.loads.rearRightN
        AxleHopObserver.step(state:&state.axleHop,rearLoadN:rearLoad,drivelineTwistRad:state.powertrain.driveline.relativeTwistRad,rearSlipDifference:tire.rearSlipDifference,dt:dt)
        VibrationFatigueAuthority.step(state:&state.vibration,rpm:i.engineRPM,vibrationG:0.2+state.axleHop.confidence01*1.8,componentAge01:0.55,fastenerRetention01:0.72,dt:dt)
    }
}
