import Foundation
import WTRLCore
import WTRLVehicle

public enum DifferentialPartKind: String, Codable, CaseIterable, Sendable {
    case housing, carrier, ringGear, pinionGear, pinionBearingInner, pinionBearingOuter
    case carrierBearingLeft, carrierBearingRight, crushSleeve, pinionSeal, axleSealLeft, axleSealRight
    case differentialCase, spiderGearLeft, spiderGearRight, sideGearLeft, sideGearRight
    case clutchPackLeft, clutchPackRight, crossPin, yoke, cover, fillPlug, drainPlug
}

public struct DifferentialPart: Codable, Hashable, Sendable, Identifiable {
    public var id: String
    public var kind: DifferentialPartKind
    public var condition01: Double
    public var wear01: Double
    public var installed: Bool
    public var parentId: String?
    public var removalAxis: Vector3D
    public var extractionDistanceM: Double
    public var requiredTool: String
    public var torqueNm: Double?
    public init(id:String, kind:DifferentialPartKind, condition01:Double=1, wear01:Double=0, installed:Bool=true,
                parentId:String?=nil, removalAxis:Vector3D=Vector3D(0,0,1), extractionDistanceM:Double=0.15,
                requiredTool:String="ratchet", torqueNm:Double?=nil) {
        self.id=id; self.kind=kind; self.condition01=condition01; self.wear01=wear01; self.installed=installed
        self.parentId=parentId; self.removalAxis=removalAxis; self.extractionDistanceM=extractionDistanceM
        self.requiredTool=requiredTool; self.torqueNm=torqueNm
    }
}

public struct DifferentialSetupSpecification: Codable, Hashable, Sendable {
    public var targetBacklashMm: ClosedRangeCodable
    public var targetPinionPreloadNm: ClosedRangeCodable
    public var targetCarrierPreloadNm: ClosedRangeCodable
    public var targetRingGearRunoutMm: ClosedRangeCodable
    public var targetContactPatternDepth01: ClosedRangeCodable
    public var targetContactPatternBias01: ClosedRangeCodable
    public init(targetBacklashMm:ClosedRangeCodable = .init(0.15,0.23),
                targetPinionPreloadNm:ClosedRangeCodable = .init(1.4,2.6),
                targetCarrierPreloadNm:ClosedRangeCodable = .init(1.0,2.2),
                targetRingGearRunoutMm:ClosedRangeCodable = .init(0,0.10),
                targetContactPatternDepth01:ClosedRangeCodable = .init(0.40,0.62),
                targetContactPatternBias01:ClosedRangeCodable = .init(-0.18,0.18)) {
        self.targetBacklashMm=targetBacklashMm; self.targetPinionPreloadNm=targetPinionPreloadNm
        self.targetCarrierPreloadNm=targetCarrierPreloadNm; self.targetRingGearRunoutMm=targetRingGearRunoutMm
        self.targetContactPatternDepth01=targetContactPatternDepth01; self.targetContactPatternBias01=targetContactPatternBias01
    }
}
public struct ClosedRangeCodable: Codable, Hashable, Sendable {
    public var lower:Double; public var upper:Double
    public init(_ lower:Double,_ upper:Double){self.lower=lower;self.upper=upper}
    public func contains(_ x:Double)->Bool { x >= lower && x <= upper }
    public var midpoint:Double {(lower+upper)/2}
}

public struct DifferentialMeasurements: Codable, Hashable, Sendable {
    public var backlashMm=0.19
    public var pinionPreloadNm=2.0
    public var carrierPreloadNm=1.6
    public var ringGearRunoutMm=0.04
    public var contactPatternDepth01=0.51
    public var contactPatternBias01=0.0
    public var oilTemperatureC=25.0
    public var oilDebris01=0.0
    public var coastNoise01=0.0
    public var driveNoise01=0.0
    public init(){}
}

public struct DifferentialSetupAssessment: Codable, Hashable, Sendable {
    public var passed:Bool
    public var score01:Double
    public var findings:[String]
}
public enum DifferentialSetupMath {
    public static func assess(_ m:DifferentialMeasurements, spec:DifferentialSetupSpecification = .init())->DifferentialSetupAssessment {
        var findings:[String]=[]
        func judge(_ value:Double,_ range:ClosedRangeCodable,_ name:String)->Double {
            if range.contains(value) { return 1 }
            findings.append("\(name) out of specification")
            let width=max(0.0001,range.upper-range.lower)
            let d=value < range.lower ? range.lower-value : value-range.upper
            return WTRLMath.clamp01(1-d/(width*2))
        }
        let scores=[
            judge(m.backlashMm,spec.targetBacklashMm,"Backlash"),
            judge(m.pinionPreloadNm,spec.targetPinionPreloadNm,"Pinion preload"),
            judge(m.carrierPreloadNm,spec.targetCarrierPreloadNm,"Carrier preload"),
            judge(m.ringGearRunoutMm,spec.targetRingGearRunoutMm,"Ring gear runout"),
            judge(m.contactPatternDepth01,spec.targetContactPatternDepth01,"Contact pattern depth"),
            judge(m.contactPatternBias01,spec.targetContactPatternBias01,"Contact pattern bias")
        ]
        let score=scores.reduce(0,+)/Double(scores.count)
        return .init(passed:findings.isEmpty,score01:score,findings:findings)
    }
}

public struct DifferentialAssembly: Codable, Hashable, Sendable {
    public var assemblyId:String
    public var ratio:Double
    public var limitedSlip:Bool
    public var parts:[DifferentialPart]
    public var measurements:DifferentialMeasurements
    public var setupSpecification:DifferentialSetupSpecification
    public init(assemblyId:String="KR-DIFF-001",ratio:Double=3.50,limitedSlip:Bool=true) {
        self.assemblyId=assemblyId; self.ratio=ratio; self.limitedSlip=limitedSlip
        self.measurements = .init(); self.setupSpecification = .init()
        self.parts=Self.krParts()
    }
    public static func krParts()->[DifferentialPart] {
        DifferentialPartKind.allCases.enumerated().map { i,k in
            DifferentialPart(id:"KR-DIFF-\(String(format:"%02d",i+1))",kind:k,
                parentId:k == .housing ? nil : "KR-DIFF-01",
                removalAxis: (k.rawValue.contains("Left") ? Vector3D(-1,0,0) : k.rawValue.contains("Right") ? Vector3D(1,0,0) : Vector3D(0,0,1)),
                extractionDistanceM:k == .carrier ? 0.28 : 0.14,
                requiredTool: k == .ringGear ? "torque_wrench" : k.rawValue.contains("Bearing") ? "bearing_pullerset" : "ratchet")
        }
    }
}
