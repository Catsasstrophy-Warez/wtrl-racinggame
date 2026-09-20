import Foundation

public enum HeroBuildPhilosophy: String, Codable, CaseIterable, Sendable {
    case preserved, periodOutlaw, livingShip
}
public enum ModificationReversibility: String, Codable, Sendable { case boltOn, repairableFabrication, structuralCut }
public struct ChassisModificationRecord: Codable, Hashable, Sendable {
    public var id: UUID
    public var description: String
    public var yearApplied: Int
    public var reversibility: ModificationReversibility
    public var authenticityImpact01: Double
    public var massDeltaKg: Double
    public var torsionalRigidityDelta01: Double
    public init(description:String,yearApplied:Int,reversibility:ModificationReversibility,authenticityImpact01:Double,massDeltaKg:Double=0,torsionalRigidityDelta01:Double=0) {
        self.id=UUID();self.description=description;self.yearApplied=yearApplied;self.reversibility=reversibility;self.authenticityImpact01=authenticityImpact01;self.massDeltaKg=massDeltaKg;self.torsionalRigidityDelta01=torsionalRigidityDelta01
    }
}
public struct VisibleHistoryMark: Codable, Hashable, Sendable {
    public enum Kind:String,Codable,Sendable { case patchWeld, heatDiscoloration, oxidation, paintRepair, seamWeld, fabricationCut }
    public var id: UUID
    public var kind: Kind
    public var componentID: String
    public var yearCreated: Int
    public var intensity01: Double
    public var storyTag: String?
    public init(kind:Kind,componentID:String,yearCreated:Int,intensity01:Double,storyTag:String?=nil){self.id=UUID();self.kind=kind;self.componentID=componentID;self.yearCreated=yearCreated;self.intensity01=intensity01;self.storyTag=storyTag}
}
public struct HeroLineageState: Codable, Hashable, Sendable {
    public var philosophy: HeroBuildPhilosophy
    public var chassisIdentity: UUID
    public var modifications:[ChassisModificationRecord]=[]
    public var historyMarks:[VisibleHistoryMark]=[]
    public var periodCorrectness01:Double=1
    public var structuralOriginality01:Double=1
    public var documentationCompleteness01:Double=1
    public init(philosophy:HeroBuildPhilosophy,chassisIdentity:UUID=UUID()){self.philosophy=philosophy;self.chassisIdentity=chassisIdentity}
    public mutating func apply(_ record:ChassisModificationRecord) {
        modifications.append(record)
        structuralOriginality01=max(0,structuralOriginality01-record.authenticityImpact01)
        if record.reversibility == .structuralCut {
            historyMarks.append(.init(kind:.fabricationCut,componentID:"chassis",yearCreated:record.yearApplied,intensity01:record.authenticityImpact01))
        }
    }
    /// A multidimensional provenance record is authoritative. This display index is not a legal or historical certification.
    public var preservationIndex01:Double { max(0,min(1,0.45*periodCorrectness01+0.35*structuralOriginality01+0.20*documentationCompleteness01)) }
}
