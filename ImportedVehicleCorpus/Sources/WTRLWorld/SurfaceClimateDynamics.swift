import Foundation
import WTRLCore

public enum RoadSurfaceKind: String, Codable, CaseIterable, Sendable { case marineConcrete, urbanAsphalt, tarChip, roadPaint, packedGravel }
public struct SurfaceCalibration: Codable, Hashable, Sendable {
    public var dryMu: Double; public var wetMu: Double; public var wearScale: Double; public var thermalAbsorption01: Double
    public init(dryMu:Double, wetMu:Double, wearScale:Double, thermalAbsorption01:Double){self.dryMu=dryMu;self.wetMu=wetMu;self.wearScale=wearScale;self.thermalAbsorption01=thermalAbsorption01}
}
public struct ClimateState: Codable, Hashable, Sendable { public var ambientC=22.0, relativeHumidity01=0.45, rain01=0.0, waterFilmMm=0.0; public init(){} }
public struct RoadPatchSample: Codable, Hashable, Sendable { public var heightM=0.0, normalX=0.0, normalY=1.0, normalZ=0.0, macroRoughness=0.04, waterFilmMm=0.0; public var surface:RoadSurfaceKind = .urbanAsphalt; public init(){} }
public struct WheelPatchResult: Codable, Hashable, Sendable { public var effectiveMu=0.9, meanHeightM=0.0, roughness=0.0, waterFilmMm=0.0; public init(){} }
public enum SurfaceClimateAuthority {
    public static let calibration:[RoadSurfaceKind:SurfaceCalibration] = [
        .marineConcrete:.init(dryMu:0.82,wetMu:0.51,wearScale:0.72,thermalAbsorption01:0.25),
        .urbanAsphalt:.init(dryMu:0.94,wetMu:0.68,wearScale:1.0,thermalAbsorption01:0.5),
        .tarChip:.init(dryMu:1.08,wetMu:0.76,wearScale:1.45,thermalAbsorption01:0.8),
        .roadPaint:.init(dryMu:0.65,wetMu:0.28,wearScale:0.35,thermalAbsorption01:0.1),
        .packedGravel:.init(dryMu:0.58,wetMu:0.42,wearScale:1.8,thermalAbsorption01:0.75)]
    public static func vaporPressureKPa(ambientC:Double, humidity01:Double)->Double { let sat=0.61078*exp((17.2694*ambientC)/(ambientC+237.29)); return sat*max(0,min(1,humidity01)) }
    public static func resolve(samples:[RoadPatchSample], speedMps:Double, tirePressureKPa:Double, treadDepthMm:Double, climate:ClimateState)->WheelPatchResult {
        guard !samples.isEmpty else{return .init()}; var mu=0.0,h=0.0,r=0.0,w=0.0
        for s in samples { let c=calibration[s.surface]!; let film=max(s.waterFilmMm,climate.waterFilmMm); let wetBlend=max(0,min(1,film/1.5)); var m=c.dryMu+(c.wetMu-c.dryMu)*wetBlend
            // Calibratable hydro-risk proxy, not a universal physical hydroplaning equation.
            let speedRisk=max(0,(speedMps-18)/35), waterRisk=max(0,min(1,film/3)), treadRisk=max(0,min(1,(3.0-treadDepthMm)/3.0)), pressureRisk=max(0,min(1,(tirePressureKPa-220)/160))
            m *= 1-max(0,min(0.72,speedRisk*waterRisk*(0.45+0.35*treadRisk+0.20*pressureRisk)))
            mu += max(0.12,m); h += s.heightM; r += s.macroRoughness; w += film }
        let n=Double(samples.count); var out=WheelPatchResult(); out.effectiveMu=mu/n;out.meanHeightM=h/n;out.roughness=r/n;out.waterFilmMm=w/n;return out
    }
}
