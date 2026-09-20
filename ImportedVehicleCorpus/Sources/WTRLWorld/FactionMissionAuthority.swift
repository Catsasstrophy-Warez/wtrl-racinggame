import Foundation
public enum BlackridgeFaction:String,Codable,CaseIterable,Sendable { case ironheads,crestRunners,siliconSyndicate,continentalClub }
public struct FactionStanding:Codable,Hashable,Sendable { public var reputation:[BlackridgeFaction:Int]=[:];public init(){} }
public enum MissionObjectiveKind:String,Codable,Sendable { case diagnose,tune,drive,inspect,repair }
public struct EngineeringMission:Codable,Hashable,Sendable { public var id:String,title:String,faction:BlackridgeFaction,objectives:[MissionObjectiveKind],requiresWetSurface:Bool;public init(id:String,title:String,faction:BlackridgeFaction,objectives:[MissionObjectiveKind],requiresWetSurface:Bool=false){self.id=id;self.title=title;self.faction=faction;self.objectives=objectives;self.requiresWetSurface=requiresWetSurface} }
public enum FactionMissionCatalog { public static let inductionWar = EngineeringMission(id:"blackridge.induction-war",title:"The Induction War",faction:.siliconSyndicate,objectives:[.diagnose,.tune,.drive,.inspect],requiresWetSurface:true) }
