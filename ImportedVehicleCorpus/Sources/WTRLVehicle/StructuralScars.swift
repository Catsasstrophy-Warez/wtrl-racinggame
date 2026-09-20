import Foundation
public enum StructuralScarKind:String,Codable,Hashable,Sendable {case patchWeld,primerRepair,panelGapSet,reinforcementPlate,cutAndReboxed,heatDiscoloration}
public struct StructuralScar:Codable,Hashable,Sendable,Identifiable {public var id=UUID().uuidString;public var kind:StructuralScarKind;public var location:String;public var severity01:Double;public var createdOdometerKm:Double;public init(kind:StructuralScarKind,location:String,severity01:Double,createdOdometerKm:Double){self.kind=kind;self.location=location;self.severity01=severity01;self.createdOdometerKm=createdOdometerKm}}
public struct StructuralScarHistory:Codable,Hashable,Sendable {public var scars:[StructuralScar]=[];public init(){};public mutating func record(_ scar:StructuralScar){scars.append(scar)}}
