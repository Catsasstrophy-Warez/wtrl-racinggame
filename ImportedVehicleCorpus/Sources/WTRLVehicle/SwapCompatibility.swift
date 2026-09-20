import Foundation

public enum FabricationOperation:String,Codable,Hashable,Sendable {
    case engineMountFabrication, shockTowerClearance, transmissionCrossmember, driveshaftFabrication
    case rearFloorReconstruction, subframeMounts, fuelSystemConversion, coolingUpgrade, wiringHarness
    case brakeUpgrade, springRateChange, exhaustFabrication, alignmentRackSetup
}
public struct SwapCandidate:Codable,Hashable,Sendable {
    public var id:String; public var massKg:Double; public var torqueNm:Double
    public var widthM:Double; public var heightM:Double; public var heatRejectionKW:Double
    public var requiresCAN:Bool; public var vibrationOrder:Double
}
public struct HostEnvelope:Codable,Hashable,Sendable {
    public var availableWidthM:Double; public var availableHeightM:Double
    public var coolingCapacityKW:Double; public var chassisRigidity01:Double
    public var brakeThermalCapacity01:Double; public var supportsCAN:Bool
}
public struct SwapCompatibilityAssessment:Codable,Hashable,Sendable {
    public var directFit:Bool
    public var operations:[FabricationOperation]
    public var frontMassDeltaKg:Double
    public var coolingDeficitKW:Double
    public var torqueRigidityRisk01:Double
}
public enum SwapCompatibilityAuthority {
    public static func assess(candidate:SwapCandidate,host:HostEnvelope)->SwapCompatibilityAssessment {
        var ops:[FabricationOperation]=[]
        if candidate.widthM > host.availableWidthM { ops += [.shockTowerClearance,.engineMountFabrication] }
        if candidate.heightM > host.availableHeightM { ops.append(.engineMountFabrication) }
        let deficit=max(0,candidate.heatRejectionKW-host.coolingCapacityKW); if deficit>0 { ops.append(.coolingUpgrade) }
        if candidate.requiresCAN && !host.supportsCAN { ops.append(.wiringHarness) }
        let rigidityRisk=min(1,max(0,candidate.torqueNm/900)*(1-host.chassisRigidity01))
        if rigidityRisk > 0.35 { ops.append(.subframeMounts) }
        if candidate.torqueNm/900 > host.brakeThermalCapacity01 { ops.append(.brakeUpgrade) }
        return .init(directFit:ops.isEmpty,operations:Array(Set(ops)).sorted{$0.rawValue<$1.rawValue},frontMassDeltaKg:candidate.massKg-205,coolingDeficitKW:deficit,torqueRigidityRisk01:rigidityRisk)
    }
}
