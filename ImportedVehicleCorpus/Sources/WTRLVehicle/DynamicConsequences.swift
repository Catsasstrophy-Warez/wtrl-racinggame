import Foundation

public struct BrakeThermalState:Codable,Hashable,Sendable {
    public var frontTemperatureC=30.0; public var rearTemperatureC=30.0; public var fade01=0.0
    public init(){}
}
public enum BrakeThermalAuthority {
    public static func step(state:inout BrakeThermalState,vehicleMassKg:Double,speedBeforeMps:Double,speedAfterMps:Double,frontBias01:Double,thermalCapacityJPerK:Double,cooling01:Double,dt:Double) {
        let energy=max(0,0.5*vehicleMassKg*(speedBeforeMps*speedBeforeMps-speedAfterMps*speedAfterMps))
        let cap=max(thermalCapacityJPerK,1)
        state.frontTemperatureC += energy*frontBias01/cap
        state.rearTemperatureC += energy*(1-frontBias01)/cap
        state.frontTemperatureC += (30-state.frontTemperatureC)*0.025*cooling01*dt
        state.rearTemperatureC += (30-state.rearTemperatureC)*0.025*cooling01*dt
        let hottest=max(state.frontTemperatureC,state.rearTemperatureC)
        state.fade01=min(0.85,max(0,(hottest-350)/350))
    }
}

public struct TurboResponseState:Codable,Hashable,Sendable { public var boost01=0.0; public var manifoldTemperatureC=35.0; public init(){} }
public enum TurboResponseAuthority {
    public static func step(state:inout TurboResponseState,rpm:Double,throttle:Double,boostThresholdRPM:Double=3100,thermalEfficiency01:Double=0.68,dt:Double) {
        let rpmDemand=max(0,min(1,(rpm-boostThresholdRPM)/1800))*max(0,min(1,throttle))
        let tau = rpm < boostThresholdRPM ? 0.55 : 0.22
        state.boost01 += (rpmDemand-state.boost01)*(1-exp(-dt/max(tau,0.01)))
        state.manifoldTemperatureC += state.boost01*(1-thermalEfficiency01)*22*dt + (35-state.manifoldTemperatureC)*0.02*dt
    }
}

public struct VibrationFatigueState:Codable,Hashable,Sendable {
    public var bracketFatigue01=0.0; public var fastenerLooseness01=0.0; public var gaugeNoise01=0.0
    public init(){}
}
public enum VibrationFatigueAuthority {
    public static func step(state:inout VibrationFatigueState,rpm:Double,vibrationG:Double,componentAge01:Double,fastenerRetention01:Double,dt:Double) {
        let highRPM=max(0,(rpm-5500)/3000)
        let exposure=max(0,vibrationG)*highRPM*dt
        state.bracketFatigue01=min(1,state.bracketFatigue01+exposure*(0.00008+0.00012*componentAge01))
        state.fastenerLooseness01=min(1,state.fastenerLooseness01+exposure*0.00009*(1-fastenerRetention01))
        state.gaugeNoise01=min(1,0.45*state.fastenerLooseness01+0.35*state.bracketFatigue01)
    }
}

public struct AeroRideHeightState:Codable,Hashable,Sendable { public var frontCompressionM:Double; public var rearCompressionM:Double; public var platformPitchRad:Double; public init(frontCompressionM:Double=0,rearCompressionM:Double=0,platformPitchRad:Double=0){self.frontCompressionM=frontCompressionM;self.rearCompressionM=rearCompressionM;self.platformPitchRad=platformPitchRad} }
public enum AeroPlatformAuthority {
    public static func evaluate(speedMps:Double,airDensity:Double=1.225,frontDownforceCoefficientArea:Double,rearDownforceCoefficientArea:Double,frontSpringRateNPerM:Double,rearSpringRateNPerM:Double)->AeroRideHeightState {
        let q=0.5*airDensity*speedMps*speedMps
        let f=q*max(0,frontDownforceCoefficientArea), r=q*max(0,rearDownforceCoefficientArea)
        let fc=f/max(frontSpringRateNPerM,1), rc=r/max(rearSpringRateNPerM,1)
        return .init(frontCompressionM:fc,rearCompressionM:rc,platformPitchRad:atan2(fc-rc,2.7))
    }
}

public struct RearKinematicState:Codable,Hashable,Sendable { public var camberDegrees:Double; public var toeDegrees:Double; public var wheelLoadDeltaN:Double }
public enum RearSuspensionKinematicsAuthority {
    public static func evaluate(compressionM:Double,rollRad:Double,camberGainDegPerM:Double,toeGainDegPerM:Double,springRateNPerM:Double)->RearKinematicState {
        .init(camberDegrees:compressionM*camberGainDegPerM,toeDegrees:compressionM*toeGainDegPerM,wheelLoadDeltaN:compressionM*springRateNPerM*cos(rollRad))
    }
}
