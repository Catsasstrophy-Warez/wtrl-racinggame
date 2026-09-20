import Foundation
import WTRLCore

public enum MeasurementKind:String,Codable,Sendable { case backlash, ringGearRunout, pinionPreload, carrierPreload, contactPattern, bearingDiameter, fluidDebris }
public struct MeasurementReading:Codable,Hashable,Sendable,Identifiable {
    public var id:String=UUID().uuidString
    public var kind:MeasurementKind
    public var value:Double
    public var unit:String
    public var confidence01:Double
    public var evidenceId:String
}
public enum MeasurementRuntime {
    public static func dialIndicator(kind:MeasurementKind,trueValue:Double,tool:WorkshopTool,baseMagneticLocked:Bool,probeLoaded:Bool)->MeasurementReading? {
        guard tool.kind == .dialIndicator, baseMagneticLocked, probeLoaded else{return nil}
        let error=(tool.calibrationError01 * max(abs(trueValue),0.01))
        let observed=trueValue+error
        return .init(kind:kind,value:observed,unit:kind == .backlash || kind == .ringGearRunout ? "mm" : "",confidence01:WTRLMath.clamp01(tool.condition01-tool.calibrationError01),evidenceId:UUID().uuidString)
    }
    public static func rotationalPreload(kind:MeasurementKind,trueValue:Double,tool:WorkshopTool)->MeasurementReading? {
        guard tool.kind == .torqueWrench else{return nil}
        return .init(kind:kind,value:trueValue*(1+tool.calibrationError01),unit:"N·m",confidence01:WTRLMath.clamp01(tool.condition01-tool.calibrationError01),evidenceId:UUID().uuidString)
    }
    public static func contactPattern(depth01:Double,bias01:Double,compoundApplied:Bool,rotatedUnderLoad:Bool)->[MeasurementReading] {
        guard compoundApplied,rotatedUnderLoad else{return []}
        return [
            .init(kind:.contactPattern,value:depth01,unit:"depth01",confidence01:0.92,evidenceId:UUID().uuidString),
            .init(kind:.contactPattern,value:bias01,unit:"bias01",confidence01:0.92,evidenceId:UUID().uuidString)
        ]
    }
}
