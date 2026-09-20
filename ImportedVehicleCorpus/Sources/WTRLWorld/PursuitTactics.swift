import Foundation
public enum PursuitTactic:String,Codable,Sendable {case observe,follow,intercept,contain,roadblock}
public struct PursuitTacticalDirective:Codable,Hashable,Sendable {public var tactic:PursuitTactic;public var targetSpeedMps:Double;public var requestRoadblock:Bool;public var contactInterventionAllowed:Bool}
public enum PursuitTacticalAuthority {
 public static func resolve(heat01:Double,playerSpeedMps:Double,distanceM:Double)->PursuitTacticalDirective {let h=max(0,min(1,heat01));if h<0.2{return .init(tactic:.observe,targetSpeedMps:min(playerSpeedMps,22),requestRoadblock:false,contactInterventionAllowed:false)};if h<0.5{return .init(tactic:.follow,targetSpeedMps:playerSpeedMps+3,requestRoadblock:false,contactInterventionAllowed:false)};if h<0.75{return .init(tactic:.intercept,targetSpeedMps:playerSpeedMps+5,requestRoadblock:false,contactInterventionAllowed:false)};return .init(tactic:distanceM<25 ? .contain:.roadblock,targetSpeedMps:playerSpeedMps+4,requestRoadblock:true,contactInterventionAllowed:false)}
}
