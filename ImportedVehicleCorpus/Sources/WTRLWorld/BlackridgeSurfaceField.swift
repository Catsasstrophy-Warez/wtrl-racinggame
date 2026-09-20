import Foundation
import WTRLVehicle

public struct BlackridgeSurfaceZone: Codable, Hashable, Sendable {
    public var id:String, center:WorldPoint2D, radiusM:Double, surface:RoadSurfaceKind, baseHeightM:Double, crownM:Double, roughness:Double
    public init(id:String,center:WorldPoint2D,radiusM:Double,surface:RoadSurfaceKind,baseHeightM:Double=0,crownM:Double=0.015,roughness:Double=0.04){self.id=id;self.center=center;self.radiusM=radiusM;self.surface=surface;self.baseHeightM=baseHeightM;self.crownM=crownM;self.roughness=roughness}
}
public enum BlackridgeSurfaceField {
    public static let productionSeed:[BlackridgeSurfaceZone] = [
        .init(id:"foundry-row",center:.init(0,0),radiusM:700,surface:.urbanAsphalt,roughness:0.055),
        .init(id:"freight-docks",center:.init(900,-250),radiusM:600,surface:.marineConcrete,roughness:0.025),
        .init(id:"crest",center:.init(-900,650),radiusM:850,surface:.tarChip,roughness:0.075),
        .init(id:"rail-depot",center:.init(420,780),radiusM:450,surface:.packedGravel,roughness:0.13)]
    public static func sample(at p:WorldPoint2D, zones:[BlackridgeSurfaceZone]=productionSeed, climate:ClimateState)->RoadPatchSample {
        let z=zones.min{ $0.center.distanceSquared(to:p) < $1.center.distanceSquared(to:p) } ?? productionSeed[0]
        let lateralWave=sin(p.x*0.037+p.y*0.011)*z.roughness*0.018;let joint=(Int(abs(p.y)/11.5)%2==0 ? 0.0:-0.006)
        var s=RoadPatchSample();s.heightM=z.baseHeightM+lateralWave+joint;s.macroRoughness=z.roughness;s.surface=z.surface;s.waterFilmMm=climate.waterFilmMm*(z.surface == .roadPaint ? 1.15:1.0);return s
    }
    public static func wheelEnvironment(center:WorldPoint2D, speedMps:Double, pressureKPa:Double, treadDepthMm:Double, climate:ClimateState, zones:[BlackridgeSurfaceZone]=productionSeed)->WheelEnvironmentInput {
        let samples=[-0.12,-0.04,0.04,0.12].map{dx in sample(at:.init(center.x+dx,center.y),zones:zones,climate:climate)}
        let r=SurfaceClimateAuthority.resolve(samples:samples,speedMps:speedMps,tirePressureKPa:pressureKPa,treadDepthMm:treadDepthMm,climate:climate)
        var e=WheelEnvironmentInput();e.roadHeightM=r.meanHeightM;e.effectiveMu=r.effectiveMu;e.roughness01=r.roughness;e.waterFilmMm=r.waterFilmMm;e.ambientC=climate.ambientC;return e
    }
}
