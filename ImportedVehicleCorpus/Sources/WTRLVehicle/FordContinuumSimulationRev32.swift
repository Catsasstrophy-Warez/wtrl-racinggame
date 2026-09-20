import Foundation
public enum FordContinuumTrackRev32:String,Codable,Sendable { case heavyIronPursuit, homologationRally, aerospaceEndurance }
public struct FordContinuumSimulationProfileRev32:Codable,Hashable,Sendable { public var vehicleId:String; public var track:FordContinuumTrackRev32; public var priorityDomains:[String]; public var executableFaults:[HeritageFaultPrimitiveRev30]; public var diagnosticFamilies:[String]; public var sourceStatus:EngineeringProvenance }
public enum FordContinuumSimulationAuthorityRev32 {
 public static func profile(for v:HeritageVehicleEngineeringProfile)->FordContinuumSimulationProfileRev32? { guard v.lineageId=="ford_triple_wide" else{return nil}; let t:FordContinuumTrackRev32; let priorities:[String]; let diag:[String]; switch v.trackId { case "heavy_iron": t = .heavyIronPursuit; priorities=["high-mass momentum transfer","brake and fluid thermal capacity","frame/unibody compliance","low-speed torque delivery"]; diag=["thermal gradient","structural datum","linkage clearance","cooling pressure drop"]
 case "homologation": t = .homologationRally; priorities=["elastokinematic migration","boost transient","multi-surface torque transfer","driveline compliance"]; diag=["airflow synchronization","actuator waveform","breakaway torque","bushing loaded-position"]
 default: t = .aerospaceEndurance; priorities=["speed-sensitive aerodynamic load","transaxle and driveline thermal stress","exotic material heat rejection","ride-height aero coupling"]; diag=["gear contact pattern","nondestructive structure inspection","thermal shielding audit","ride-height sensor zero"] }
 let p=HeritageExecutablePhysicsAuthorityRev30.profile(for:v); return .init(vehicleId:v.id,track:t,priorityDomains:priorities,executableFaults:p.faultPrimitives,diagnosticFamilies:diag,sourceStatus:.researchPending) }
 public static var all:[FordContinuumSimulationProfileRev32] { HeritageLineageEngineeringRev29.fordTripleWide.vehicles.compactMap(profile) }
}
