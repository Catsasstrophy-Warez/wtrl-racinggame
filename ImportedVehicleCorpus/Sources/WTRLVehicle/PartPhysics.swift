import Foundation
import WTRLCore

public enum EngineeringPrimitiveKind: String, Codable, CaseIterable, Sendable { case Bearing, Pump, Hose, Filter, Conductor, Connector, Shaft, Gear, FrictionSurface, Fastener, Spring, Damper, HeatExchanger }

public struct EngineeringPrimitiveDefinition: Codable, Hashable, Sendable {
    public var primitiveId: String; public var kind: EngineeringPrimitiveKind
    public var loadCapacity: Double; public var thermalCapacity: Double
    public var baseRestriction01: Double; public var baseResistance01: Double; public var nominalEfficiency01: Double
    public var wearRatePerHour: Double; public var parameterSource: String; public var calibrationConfidence01: Double; public var validationProcedure: String
}
public struct EngineeringPrimitiveState: Codable, Hashable, Sendable {
    public var primitiveId=""; public var kind: EngineeringPrimitiveKind = .Fastener; public var condition01=1.0; public var contamination01=0.0
    public var normalizedLoad01=0.0; public var normalizedThermal01=0.0; public var normalizedRestriction01=0.0; public var normalizedResistance01=0.0
    public var clearanceOrWear=0.0; public var temperatureC=25.0
}
public struct EngineeringPrimitiveResult: Codable, Hashable, Sendable { public var efficiency01=1.0; public var deliveredCapacity01=1.0; public var heatGeneration01=0.0; public var failureRisk01=0.0; public var evidenceSeverity01=0.0 }

public enum PartPhysicsCompiler {
    public static func evaluate(_ s: EngineeringPrimitiveState?) -> EngineeringPrimitiveResult {
        guard let s else { return .init(efficiency01:0, deliveredCapacity01:0, heatGeneration01:0, failureRisk01:1, evidenceSeverity01:1) }
        let condition=WTRLMath.clamp01(s.condition01), load=max(0,s.normalizedLoad01), thermal=max(0,s.normalizedThermal01), contam=WTRLMath.clamp01(s.contamination01)
        let restriction=max(0,s.normalizedRestriction01), resistance=max(0,s.normalizedResistance01)
        let typePenalty: Double
        switch s.kind {
        case .Filter: typePenalty=restriction*0.28; case .Hose: typePenalty=restriction*0.18; case .Conductor: typePenalty=resistance*0.24
        case .Connector: typePenalty=resistance*0.30; case .Bearing: typePenalty=max(0,load-0.75)*0.22; case .FrictionSurface: typePenalty=max(0,thermal-0.70)*0.25
        case .HeatExchanger: typePenalty=restriction*0.20+contam*0.18; default: typePenalty=restriction*0.10+resistance*0.10
        }
        let heat=WTRLMath.clamp01(max(0,load-0.5)*0.35+max(0,thermal-0.5)*0.5+resistance*0.18)
        let failure=WTRLMath.clamp01((1-condition)*0.48+max(0,load-1)*0.28+max(0,thermal-1)*0.32+contam*0.18+typePenalty)
        let efficiency=WTRLMath.clamp01(condition-contam*0.16-typePenalty-heat*0.08)
        return .init(efficiency01:efficiency, deliveredCapacity01:WTRLMath.clamp01(efficiency*(1-restriction*0.12)), heatGeneration01:heat, failureRisk01:failure, evidenceSeverity01:WTRLMath.clamp01(max(failure,1-efficiency)))
    }
}

public struct PartPhysicsProfile: Codable, Hashable, Sendable { public var specificationId:String; public var family:String; public var subtype:String; public var variantLevel:Int; public var calibrationSource:String; public var calibrationConfidence01:Double; public var calibrationMethod:String; public var requiresReferenceConfirmation:Bool; public var primitives:[EngineeringPrimitiveDefinition] }
public struct PartPhysicsCatalogFile: Codable, Sendable { public var schema:String; public var entryCount:Int; public var primitiveCount:Int; public var entries:[PartPhysicsProfile] }
