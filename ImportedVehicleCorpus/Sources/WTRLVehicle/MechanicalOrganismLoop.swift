import Foundation

public struct MechanicalOrganismState:Codable,Hashable,Sendable {
 public var vehicle=CausalVehicleLoopV2State(),combustion=CombustionCycleOutput(indicatedTorqueNm:0,imepKPa:0,peakPressureKPa:0,peakPressureAngleATDCDeg:0,knockRisk01:0,knockAcousticLevelDbRelative:0,egtC:20)
 public var tireThermals:[MultiLayerTireThermalState]=Array(repeating:.init(),count:4)
 public var coolantC=82.0,oilC=90.0,drivelineResonance01=0.0
 public init(){}
}
public struct MechanicalOrganismInput:Sendable {public var base=CausalVehicleLoopV2Input(),combustion=CombustionCycleInput(),ambientC=25.0,roadC=30.0;public init(){} }
public enum MechanicalOrganismAuthority {
 public static func step(state:inout MechanicalOrganismState,input:MechanicalOrganismInput,setup:DifferentialSetupQuality,dt:Double){
  state.combustion=CombustionCycleAuthority.evaluate(input:input.combustion)
  var b=input.base;b.engineRPM=input.combustion.rpm
  CausalVehicleLoopV2Authority.step(state:&state.vehicle,input:b,setup:setup,dt:dt)
  let loads=[state.vehicle.tires.frontLeft.normalLoadN,state.vehicle.tires.frontRight.normalLoadN,state.vehicle.tires.rearLeft.normalLoadN,state.vehicle.tires.rearRight.normalLoadN]
  let tireStates=[state.vehicle.tires.frontLeft,state.vehicle.tires.frontRight,state.vehicle.tires.rearLeft,state.vehicle.tires.rearRight]
  for i in 0..<4 {let slipPower=abs(tireStates[i].longitudinalForceN*state.vehicle.speedMps*tireStates[i].slipRatio)+abs(tireStates[i].lateralForceN*state.vehicle.speedMps*sin(tireStates[i].slipAngleDeg*Double.pi/180));MultiLayerTireThermalAuthority.step(state:&state.tireThermals[i],slipPowerW:slipPower,verticalLoadN:loads[i],wheelOmega:tireStates[i].wheelOmegaRadPerSec,ambientC:input.ambientC,roadC:input.roadC,dt:dt)}
  let load=max(0,min(1,input.base.throttle));state.coolantC += ((state.combustion.egtC-state.coolantC)*0.0009*load-(state.coolantC-input.ambientC)*0.0005*(1+state.vehicle.speedMps))*dt;state.oilC += ((state.combustion.egtC-state.oilC)*0.00055*load-(state.oilC-input.ambientC)*0.00018*(1+state.vehicle.speedMps))*dt
  state.drivelineResonance01=max(0,min(1,state.vehicle.axleHop.confidence01*0.65+abs(state.vehicle.powertrain.driveline.relativeTwistRad)*0.35))
 }
}
