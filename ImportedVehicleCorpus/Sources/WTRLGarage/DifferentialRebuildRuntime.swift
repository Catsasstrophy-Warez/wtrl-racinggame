import Foundation
import WTRLCore

public struct ShimPack:Codable,Hashable,Sendable,Identifiable {
    public var id:String
    public var thicknessMm:Double
    public var side:String
    public init(id:String,thicknessMm:Double,side:String){self.id=id;self.thicknessMm=thicknessMm;self.side=side}
}
public struct DifferentialRebuildState:Codable,Hashable,Sendable {
    public var carrierRemoved=false
    public var pinionRemoved=false
    public var bearingsPressedOff:Set<String>=[]
    public var bearingsPressedOn:Set<String>=[]
    public var selectedPinionShimMm=0.0
    public var selectedLeftCarrierShimMm=0.0
    public var selectedRightCarrierShimMm=0.0
    public var markingCompoundApplied=false
    public var contactPatternGenerated=false
    public var filledOilL=0.0
    public init(){}
}
public enum DifferentialRebuildError:Error,Equatable {case carrierInstalled, wrongTool, bearingNotRemoved, noCompound, invalidShim}
public enum DifferentialRebuildRuntime {
    public static func pressBearingOff(_ bearing:String,state:inout DifferentialRebuildState,tool:WorkshopTool)throws {
        guard tool.kind == .bearingPress || tool.kind == .bearingPuller else{throw DifferentialRebuildError.wrongTool}
        state.bearingsPressedOff.insert(bearing)
    }
    public static func pressBearingOn(_ bearing:String,state:inout DifferentialRebuildState,tool:WorkshopTool)throws {
        guard tool.kind == .bearingPress else{throw DifferentialRebuildError.wrongTool}
        guard state.bearingsPressedOff.contains(bearing) else{throw DifferentialRebuildError.bearingNotRemoved}
        state.bearingsPressedOn.insert(bearing)
    }
    public static func chooseShims(pinion:Double,left:Double,right:Double,state:inout DifferentialRebuildState)throws {
        guard (0.1...2.5).contains(pinion),(0.1...2.5).contains(left),(0.1...2.5).contains(right) else{throw DifferentialRebuildError.invalidShim}
        state.selectedPinionShimMm=pinion;state.selectedLeftCarrierShimMm=left;state.selectedRightCarrierShimMm=right
    }
    public static func predictedMeasurements(_ state:DifferentialRebuildState)->DifferentialMeasurements {
        let backlash=WTRLMath.clamp(0.19 + (state.selectedRightCarrierShimMm-state.selectedLeftCarrierShimMm)*0.18,0.02,0.7)
        let depth=WTRLMath.clamp01(0.5+(state.selectedPinionShimMm-0.75)*0.42)
        var m=DifferentialMeasurements();m.backlashMm=backlash;m.pinionPreloadNm=2.1;m.carrierPreloadNm=2.4;m.ringGearRunoutMm=0.04;m.contactPatternDepth01=depth;m.contactPatternBias01=0.5;return m
    }
    public static func applyCompound(state:inout DifferentialRebuildState){state.markingCompoundApplied=true}
    public static func rollPattern(state:inout DifferentialRebuildState)throws {
        guard state.markingCompoundApplied else{throw DifferentialRebuildError.noCompound}
        state.contactPatternGenerated=true
    }
}
