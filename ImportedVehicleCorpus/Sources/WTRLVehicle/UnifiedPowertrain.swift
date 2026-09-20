import Foundation

public struct UnifiedPowertrainParameters:Codable,Hashable,Sendable {
    public var enginePeakTorqueNm=520.0
    public var enginePeakTorqueRPM=4200.0
    public var engineRedlineRPM=6500.0
    public var clutchCapacityNm=560.0
    public var clutchThermalMassJPerK=5200.0
    public var clutchStaticFriction01=0.38
    public var clutchDynamicFriction01=0.29
    public var clutchMaxTemperatureC=280.0
    public var gearRatio=2.32
    public var finalDriveRatio=3.50
    public var drivelineEfficiency01=0.90
    public var wheelRadiusM=0.335
    public init(){}
}
public struct UnifiedPowertrainState:Codable,Hashable,Sendable {
    public var engineRPM=900.0
    public var clutchTemperatureC=35.0
    public var clutchWear01=0.0
    public var clutchSlipRadPerSec=0.0
    public var clutchGlazed=false
    public var driveline=DrivelineElasticityState()
    public var wheelTorqueNm=0.0
    public var drivelineLossWatts=0.0
    public init(){}
}
public struct PowertrainStepOutput:Codable,Hashable,Sendable {
    public var engineTorqueNm:Double
    public var clutchTransmittedTorqueNm:Double
    public var wheelTorqueNm:Double
    public var clutchHeatWatts:Double
    public var drivelineHeatWatts:Double
}
public enum UnifiedPowertrainAuthority {
    public static func torqueCurve(rpm:Double,throttle:Double,p:UnifiedPowertrainParameters)->Double {
        let x=(rpm-p.enginePeakTorqueRPM)/max(p.enginePeakTorqueRPM,1)
        let shape=max(0.42,1-0.55*x*x)
        let limiter=rpm>p.engineRedlineRPM ? max(0,1-(rpm-p.engineRedlineRPM)/500) : 1
        return p.enginePeakTorqueNm*shape*max(0,min(1,throttle))*limiter
    }
    public static func step(state:inout UnifiedPowertrainState,throttle:Double,gearboxOutputOmega:Double,pinionOmega:Double,dt:Double,clutchEngagement01:Double=1.0,p:UnifiedPowertrainParameters = .init())->PowertrainStepOutput {
        let h=max(dt,0), engineTorque=torqueCurve(rpm:state.engineRPM,throttle:throttle,p:p)
        let engagement=max(0,min(1,clutchEngagement01)); let thermalFade=max(0.2,1-max(0,state.clutchTemperatureC-180)/max(1,p.clutchMaxTemperatureC-180)*0.65); let glazeFade=state.clutchGlazed ? 0.72:1.0; let clutchCapacity=max(0,p.clutchCapacityNm*(1-0.55*state.clutchWear01)*engagement*thermalFade*glazeFade)
        let transmitted=min(engineTorque,clutchCapacity)
        let excess=max(0,engineTorque-clutchCapacity)
        state.clutchSlipRadPerSec=excess/max(clutchCapacity,1)*max(state.engineRPM*2*Double.pi/60,1)
        let clutchHeat=abs(excess*state.clutchSlipRadPerSec)
        state.clutchTemperatureC += clutchHeat/max(p.clutchThermalMassJPerK,1)*h
        state.clutchTemperatureC += (35-state.clutchTemperatureC)*0.012*h
        state.clutchWear01=min(1,state.clutchWear01+clutchHeat*h/48_000_000)
        if state.clutchTemperatureC > p.clutchMaxTemperatureC*0.92 { state.clutchGlazed=true }
        DrivelineElasticityAuthority.step(state:&state.driveline,gearboxOmegaRadPerSec:gearboxOutputOmega,pinionOmegaRadPerSec:pinionOmega,dt:h)
        let elasticLimit=abs(state.driveline.transmittedTorqueNm)
        let shaftTorque=min(transmitted,elasticLimit)
        let drivelineHeat=abs(transmitted-shaftTorque)*abs(gearboxOutputOmega-pinionOmega)
        state.drivelineLossWatts=drivelineHeat
        state.wheelTorqueNm=shaftTorque*p.gearRatio*p.finalDriveRatio*p.drivelineEfficiency01
        return .init(engineTorqueNm:engineTorque,clutchTransmittedTorqueNm:transmitted,wheelTorqueNm:state.wheelTorqueNm,clutchHeatWatts:clutchHeat,drivelineHeatWatts:drivelineHeat)
    }
}
