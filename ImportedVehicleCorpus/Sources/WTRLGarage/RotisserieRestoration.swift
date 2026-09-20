import Foundation
public enum RotisserieStage:String,Codable,Sendable {case received,stripped,mediaBlasted,metalRepair,structuralMeasurement,fabrication,primer,assembly,complete}
public struct RotisserieRestorationState:Codable,Hashable,Sendable {public var stage:RotisserieStage = .received;public var rust01=0.65;public var seamWelded=false;public var tunnelCut=false;public var tubsInstalled=false;public var originalSubframe=true;public var cageInstalled=false;public var structuralScars:[String]=[];public init(){}}
public enum RotisserieRestorationAuthority {
 public static func advance(_ s:inout RotisserieRestorationState,to next:RotisserieStage)->Bool {let order:[RotisserieStage]=[.received,.stripped,.mediaBlasted,.metalRepair,.structuralMeasurement,.fabrication,.primer,.assembly,.complete];guard let a=order.firstIndex(of:s.stage),let b=order.firstIndex(of:next),b==a+1 else{return false};if next == .primer && s.rust01>0.08{return false};s.stage=next;return true}
 public static func preservationIndex01(_ s:RotisserieRestorationState)->Double {var v=1-s.rust01*0.35;if s.tunnelCut{v-=0.30};if s.tubsInstalled{v-=0.18};if !s.originalSubframe{v-=0.22};return max(0,min(1,v))}
}
