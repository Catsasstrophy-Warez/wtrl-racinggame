import Foundation

public enum ServiceInterfaceRoleRev33:String,Codable,Hashable,Sendable { case fastenerGroup, electricalConnector, hoseClamp, fluidJoint, supportPoint, extractionClearance, bondedJoint }
public enum ServiceInterfaceStateRev33:String,Codable,Hashable,Sendable { case secured, loosened, unlocked, disconnected, drained, supported, cleared, verified }
public struct TorqueProvenanceRev33:Codable,Hashable,Sendable { public var source:String; public var valueNm:Double?; public var verified:Bool; public var researchGated:Bool; public var toolCalibrationId:String? }
public struct ProductionServiceInterfaceRev33:Codable,Hashable,Sendable,Identifiable {
 public var id:String; public var assemblyNodeId:String; public var role:ServiceInterfaceRoleRev33; public var state:ServiceInterfaceStateRev33; public var requiredToolFamily:String; public var torque:TorqueProvenanceRev33?; public var containsFluid:Bool; public var fluidFamily:String?; public var requiresSupportBeforeRelease:Bool; public var blocksExtraction:Bool; public var researchGated:Bool
}
public struct ExtractionPoseRev33:Codable,Hashable,Sendable { public var translationMeters:[Double]; public var rotationDegrees:[Double]; public var stageAnchor:String }
public struct ProductionServicePlanRev33:Codable,Hashable,Sendable { public var vehicleId:String; public var componentNodeId:String; public var interfaces:[ProductionServiceInterfaceRev33]; public var extractionPose:ExtractionPoseRev33; public var rebuildable:Bool }
public enum ProductionServicePlanAuthorityRev33 {
 public static func plan(vehicle:HeritageVehicleEngineeringProfile,node:HeritageAssemblyNodeRev30)->ProductionServicePlanRev33 {
  let id=node.id, lower=id.lowercased(); var i:[ProductionServiceInterfaceRev33]=[]
  func add(_ suffix:String,_ role:ServiceInterfaceRoleRev33,_ tool:String, fluid:String?=nil, support:Bool=false, gated:Bool=true){i.append(.init(id:"svc.\(id).\(suffix)",assemblyNodeId:id,role:role,state:.secured,requiredToolFamily:tool,torque:role == .fastenerGroup ? .init(source:"research-gated service specification",valueNm:nil,verified:false,researchGated:true,toolCalibrationId:nil):nil,containsFluid:fluid != nil,fluidFamily:fluid,requiresSupportBeforeRelease:support,blocksExtraction:true,researchGated:gated))}
  add("retention",.fastenerGroup,"socket/torque tool",support: lower.contains("transmission") || lower.contains("differential") || lower.contains("engine"))
  if lower.contains("electrical") || lower.contains("pump") || lower.contains("damper") || lower.contains("actuator") || lower.contains("fuel") || lower.contains("induction") { add("connector",.electricalConnector,"connector release tool") }
  if lower.contains("cooling") || lower.contains("pump") || lower.contains("radiator") { add("coolant",.hoseClamp,"hose clamp tool",fluid:"coolant") }
  if lower.contains("brake") { add("hydraulic",.fluidJoint,"line wrench",fluid:"brake fluid") }
  if lower.contains("fuel") { add("fuel",.fluidJoint,"fuel-line disconnect",fluid:"fuel") }
  if lower.contains("transmission") || lower.contains("differential") || lower.contains("engine") { add("support",.supportPoint,"lifting/support fixture",support:true) }
  add("clearance",.extractionClearance,"collision/clearance check",gated:false)
  let pose = ExtractionPoseRev33(translationMeters: lower.contains("wheel") ? [0.55,0,0] : (lower.contains("engine") ? [0,0.8,0.2] : [0,0.45,0]),rotationDegrees:[0,0,0],stageAnchor:"garage.service_stage")
  let rebuildable = lower.contains("engine") || lower.contains("transmission") || lower.contains("differential") || lower.contains("caliper") || lower.contains("turbo") || lower.contains("supercharger") || lower.contains("pump")
  return .init(vehicleId:vehicle.id,componentNodeId:id,interfaces:i,extractionPose:pose,rebuildable:rebuildable)
 }
 public static func plans(for vehicle:HeritageVehicleEngineeringProfile)->[ProductionServicePlanRev33] { GenerationSpecificDeepAssemblyAuthorityRev31.assembly(for:vehicle).nodes.map{plan(vehicle:vehicle,node:$0)} }
 public static func canExtract(_ plan:ProductionServicePlanRev33)->Bool { plan.interfaces.allSatisfy { x in switch x.role { case .fastenerGroup: return x.state == .loosened || x.state == .verified; case .electricalConnector,.hoseClamp,.fluidJoint: return x.state == .disconnected || x.state == .drained || x.state == .verified; case .supportPoint: return x.state == .supported || x.state == .verified; case .extractionClearance: return x.state == .cleared || x.state == .verified; case .bondedJoint: return x.state == .cleared || x.state == .verified } } }
}
