import Foundation

public struct CausalVehicleLoopState:Codable,Hashable,Sendable {
    public var powertrain=UnifiedPowertrainState()
    public var mechanical=MechanicalConsequenceState()
    public var brakes=BrakeThermalState()
    public var vibration=VibrationFatigueState()
    public var turbo=TurboResponseState()
    public var longitudinalSpeedMps=0.0
    public var drivenWheelOmegaRadPerSec=0.0
    public var tireSlipRatio=0.0
    public var tireForceN=0.0
    public var accumulatedDistanceM=0.0
    public init(){}
}
public struct CausalVehicleInputs:Codable,Hashable,Sendable {
    public var throttle:Double; public var brake01:Double; public var engineRPM:Double
    public var gearboxOutputOmega:Double; public var pinionOmega:Double
    public var tireMu:Double; public var drivenNormalLoadN:Double
    public var chassisRigidity01:Double; public var vibrationG:Double
    public init(throttle:Double,brake01:Double,engineRPM:Double,gearboxOutputOmega:Double,pinionOmega:Double,tireMu:Double=0.9,drivenNormalLoadN:Double=7000,chassisRigidity01:Double=0.5,vibrationG:Double=0){self.throttle=throttle;self.brake01=brake01;self.engineRPM=engineRPM;self.gearboxOutputOmega=gearboxOutputOmega;self.pinionOmega=pinionOmega;self.tireMu=tireMu;self.drivenNormalLoadN=drivenNormalLoadN;self.chassisRigidity01=chassisRigidity01;self.vibrationG=vibrationG}
}
public enum CausalVehicleLoopAuthority {
    /// Closes the first executable loop from combustion torque through clutch/driveline to contact-patch force,
    /// then returns slip/load consequences into heat, wear, vibration and chassis alignment evidence.
    public static func step(state:inout CausalVehicleLoopState,input:CausalVehicleInputs,setup:DifferentialSetupQuality,p:UnifiedPowertrainParameters = .init(),vehicleMassKg:Double=1450,dt:Double) {
        state.powertrain.engineRPM=input.engineRPM
        let out=UnifiedPowertrainAuthority.step(state:&state.powertrain,throttle:input.throttle,gearboxOutputOmega:input.gearboxOutputOmega,pinionOmega:input.pinionOmega,dt:dt,p:p)
        let wheelRadius=max(p.wheelRadiusM,0.05)
        let wheelLinear=state.drivenWheelOmegaRadPerSec*wheelRadius
        state.tireSlipRatio=(wheelLinear-state.longitudinalSpeedMps)/max(abs(state.longitudinalSpeedMps),2)
        let demanded=out.wheelTorqueNm/wheelRadius
        let grip=max(0,input.tireMu*input.drivenNormalLoadN)
        // Smooth saturation avoids an artificial hard traction cliff.
        state.tireForceN=grip>0 ? grip*tanh(demanded/grip) : 0
        let brakeForce=max(0,input.brake01)*input.drivenNormalLoadN*1.1
        let acceleration=(state.tireForceN-brakeForce)/max(vehicleMassKg,1)
        let oldSpeed=state.longitudinalSpeedMps
        state.longitudinalSpeedMps=max(0,state.longitudinalSpeedMps+acceleration*dt)
        state.drivenWheelOmegaRadPerSec += ((out.wheelTorqueNm-state.tireForceN*wheelRadius)/1.9)*dt
        state.accumulatedDistanceM += state.longitudinalSpeedMps*dt
        MechanicalConsequenceAuthority.step(state:&state.mechanical,wheelTorqueNm:out.wheelTorqueNm,differentialSpeedRadPerSec:input.pinionOmega,setup:setup,chassisRigidity01:input.chassisRigidity01,dt:dt)
        BrakeThermalAuthority.step(state:&state.brakes,vehicleMassKg:vehicleMassKg,speedBeforeMps:oldSpeed,speedAfterMps:state.longitudinalSpeedMps,frontBias01:0.68,thermalCapacityJPerK:140_000,cooling01:0.6,dt:dt)
        VibrationFatigueAuthority.step(state:&state.vibration,rpm:input.engineRPM,vibrationG:input.vibrationG+abs(state.tireSlipRatio)*0.2,componentAge01:0.6,fastenerRetention01:0.7,dt:dt)
    }
}
