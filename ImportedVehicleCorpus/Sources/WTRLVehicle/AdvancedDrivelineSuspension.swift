import Foundation

public struct ClutchFrictionSpecification: Codable, Hashable, Sendable {
    public var maximumStaticTorqueNm=520.0, staticMu=0.38, dynamicMu=0.29, thermalMassJPerK=4200.0, maximumTemperatureC=280.0
    public var wearEnergyCapacityJ=42_000_000.0, coolingWPerK=18.0
    public init() {}
}
public struct ClutchFrictionState: Codable, Hashable, Sendable { public var temperatureC=60.0, wear01=0.0, glazed01=0.0, slipEnergyJ=0.0; public init(){} }
public struct ClutchFrictionOutput: Codable, Hashable, Sendable { public var transmittedTorqueNm=0.0, slipRPM=0.0, wheelTorqueNm=0.0, failed=false; public init(){} }
public enum DynamicClutchAuthority {
    public static func step(state s:inout ClutchFrictionState,spec p:ClutchFrictionSpecification,engineTorqueNm:Double,engineOmega:Double,gearboxInputOmega:Double,pedal01:Double,gearRatio:Double,finalDrive:Double,ambientC:Double=35,dt:Double)->ClutchFrictionOutput {
        let h=max(dt,1e-4), engage=max(0,min(1,pedal01)), dOmega=engineOmega-gearboxInputOmega, slipRPM=abs(dOmega)*60/(2*Double.pi)
        let thermalFade=max(0.18,1-max(0,s.temperatureC-170)/max(1,p.maximumTemperatureC-170)*0.65)
        let wearFade=max(0.25,1-s.wear01*0.55-s.glazed01*0.35)
        let staticCapacity=p.maximumStaticTorqueNm*engage*thermalFade*wearFade
        let locked=slipRPM<15 && engage>0.98 && abs(engineTorqueNm)<=staticCapacity
        let dynamicCapacity=staticCapacity*(p.dynamicMu/max(p.staticMu,0.01))
        let magnitude=locked ? abs(engineTorqueNm):min(abs(engineTorqueNm),dynamicCapacity)
        let transmitted=magnitude*(engineTorqueNm >= 0 ? 1:-1)
        if !locked { let power=abs(transmitted*dOmega); let energy=power*h; s.slipEnergyJ += energy; s.temperatureC += energy/max(p.thermalMassJPerK,1); s.wear01=min(1,s.wear01+energy/max(p.wearEnergyCapacityJ,1)); if s.temperatureC>220 {s.glazed01=min(1,s.glazed01+(s.temperatureC-220)/120*h*0.02)} }
        s.temperatureC += (ambientC-s.temperatureC)*min(1,p.coolingWPerK/max(p.thermalMassJPerK,1)*h)
        var o=ClutchFrictionOutput();o.transmittedTorqueNm=transmitted;o.slipRPM=slipRPM;o.wheelTorqueNm=transmitted*gearRatio*finalDrive*0.94;o.failed=s.temperatureC>=p.maximumTemperatureC || s.wear01>=0.98;return o
    }
}

public enum SuspensionArchitecture:String,Codable,Sendable {case doubleWishbone,macPherson,solidAxle,semiTrailing,multiLink}
public struct KinematicSuspensionProfile:Codable,Hashable,Sendable { public var architecture:SuspensionArchitecture = .doubleWishbone; public var staticCamberDeg:Double = -0.8, camberGainDegPerM:Double = -18.0, toeGainDegPerM:Double = 1.5, staticRollCenterM:Double=0.10, rollCenterMigrationPerM:Double=0.25, maxJounceM:Double=0.095, maxReboundM:Double=0.080; public init(){} }
public struct KinematicSuspensionResult:Codable,Hashable,Sendable {public var camberDeg=0.0,toeDeg=0.0,rollCenterHeightM=0.0,bumpStopEngagement01=0.0;public init(){}}
public enum SuspensionKinematicsAuthority {
    public static func evaluate(_ p:KinematicSuspensionProfile,jounceM:Double,oppositeJounceM:Double)->KinematicSuspensionResult {
        let j=max(-p.maxReboundM,min(p.maxJounceM,jounceM)), axleAverage=(j+oppositeJounceM)*0.5
        var r=KinematicSuspensionResult();r.camberDeg=p.staticCamberDeg+j*p.camberGainDegPerM;r.toeDeg=j*p.toeGainDegPerM;r.rollCenterHeightM=max(0.01,p.staticRollCenterM+axleAverage*p.rollCenterMigrationPerM)
        r.bumpStopEngagement01=max(0,min(1,(jounceM-p.maxJounceM)/0.03));return r
    }
}
