import Foundation
public struct CarburetorRebuildState: Codable, Hashable, Sendable {
    public enum Step:Int,Codable,Sendable { case airHorn, jetsRemoved, jetsInstalled, floatSet, powerValve, torquePattern, complete }
    public var step:Step = .airHorn, jetSize=68, floatHeightMM=14.5, targetFloatMM=11.2, floatToleranceMM=0.5, boltTorquesNm=Array(repeating:0.0,count:8); public init(){}
}
public enum CarburetorRebuildResult: Hashable, Sendable { case advanced, outOfSpecFloat(Double), torquePatternRejected, complete }
public enum CarburetorRebuildAuthority {
    public static func advance(_ s:inout CarburetorRebuildState,floatMM:Double?=nil,boltTorquesNm:[Double]?=nil)->CarburetorRebuildResult {
        switch s.step {
        case .airHorn:s.step = .jetsRemoved;return .advanced
        case .jetsRemoved:s.step = .jetsInstalled;return .advanced
        case .jetsInstalled:s.step = .floatSet;return .advanced
        case .floatSet:
            if let f=floatMM {s.floatHeightMM=f;let e=abs(f-s.targetFloatMM);if e>s.floatToleranceMM{return .outOfSpecFloat(e)}}
            s.step = .powerValve;return .advanced
        case .powerValve:s.step = .torquePattern;return .advanced
        case .torquePattern:
            guard let t=boltTorquesNm,t.count==8 else{return .torquePatternRejected};s.boltTorquesNm=t
            let avg=t.reduce(0,+)/8; guard abs(avg-4.5)<=0.8 && (t.max()!-t.min()!)<=1.0 else{return .torquePatternRejected};s.step = .complete;return .complete
        case .complete:return .complete }
    }
}
