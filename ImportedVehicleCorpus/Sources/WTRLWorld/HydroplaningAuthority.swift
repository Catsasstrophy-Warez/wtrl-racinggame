import Foundation
public struct HydroplaningResult: Codable, Hashable, Sendable { public var effectiveMu=0.9, risk01=0.0, active=false; public init(){} }
public enum HydroplaningAuthority {
    /// Calibratable game model. It intentionally does not present a single pressure-only formula as universal truth.
    public static func resolve(baseMu:Double,waterFilmMM:Double,speedMps:Double,treadDepthMM:Double,tirePressureKPa:Double)->HydroplaningResult {
        let water=max(0,min(1,waterFilmMM/5.0)), speed=max(0,min(1,(speedMps-18)/35)), tread=max(0,min(1,(3.5-treadDepthMM)/3.5)), pressure=max(0,min(1,(tirePressureKPa-180)/220))
        let risk=max(0,min(1,water*speed*(0.35+0.45*tread+0.20*pressure)))
        var r=HydroplaningResult();r.risk01=risk;r.active=risk>0.58;r.effectiveMu=max(0.10,baseMu*(1-0.78*risk));return r
    }
}
