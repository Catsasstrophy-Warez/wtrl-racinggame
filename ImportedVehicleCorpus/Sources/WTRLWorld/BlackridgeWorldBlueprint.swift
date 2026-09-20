import Foundation

public enum BlackridgeDistrict: String, Codable, CaseIterable, Sendable {
    case freightDocks, foundryRow, riverBypass, icehouseIndustrial, briar, mountainCrest
}
public struct SurfaceEnvironment: Codable, Hashable, Sendable {
    public var dryGripScale01: Double
    public var wetGripScale01: Double
    public var roughness01: Double
    public var standingWaterRisk01: Double
}
public struct BlackridgeDistrictDefinition: Codable, Hashable, Sendable {
    public var district: BlackridgeDistrict
    public var environment: SurfaceEnvironment
    public var trafficDensity01: Double
    public var acousticReflectivity01: Double
}
public enum BlackridgeWorldBlueprint {
    public static let districts:[BlackridgeDistrictDefinition] = [
        .init(district:.freightDocks,environment:.init(dryGripScale01:0.78,wetGripScale01:0.55,roughness01:0.45,standingWaterRisk01:0.70),trafficDensity01:0.35,acousticReflectivity01:0.75),
        .init(district:.foundryRow,environment:.init(dryGripScale01:0.86,wetGripScale01:0.67,roughness01:0.65,standingWaterRisk01:0.35),trafficDensity01:0.72,acousticReflectivity01:0.88),
        .init(district:.riverBypass,environment:.init(dryGripScale01:0.90,wetGripScale01:0.70,roughness01:0.38,standingWaterRisk01:0.48),trafficDensity01:0.45,acousticReflectivity01:0.42),
        .init(district:.icehouseIndustrial,environment:.init(dryGripScale01:0.84,wetGripScale01:0.65,roughness01:0.50,standingWaterRisk01:0.40),trafficDensity01:0.30,acousticReflectivity01:0.82),
        .init(district:.briar,environment:.init(dryGripScale01:0.96,wetGripScale01:0.62,roughness01:0.20,standingWaterRisk01:0.25),trafficDensity01:0.12,acousticReflectivity01:0.30),
        .init(district:.mountainCrest,environment:.init(dryGripScale01:0.92,wetGripScale01:0.66,roughness01:0.58,standingWaterRisk01:0.30),trafficDensity01:0.18,acousticReflectivity01:0.22)
    ]
}
