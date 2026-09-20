import Foundation
import WTRLCore
import WTRLVehicle

public enum FastenerStateRev34:String,Codable,Hashable,Sendable { case torqued, brokenLoose, fingerLoose, removed, installed, finalTorqued }
public struct FastenerPositionRev34:Codable,Hashable,Sendable,Identifiable { public var id:String; public var assemblyNodeId:String; public var localPosition:Vector3D; public var driveFamily:String; public var state:FastenerStateRev34; public var torqueNm:Double?; public var torqueResearchGated:Bool; public var toolCalibrationId:String? }
public enum ConnectorLockStateRev34:String,Codable,Hashable,Sendable { case locked, secondaryReleased, primaryReleased, disconnected, connectedLocked }
public struct ConnectorInteractionRev34:Codable,Hashable,Sendable,Identifiable { public var id:String; public var assemblyNodeId:String; public var lockState:ConnectorLockStateRev34; public var localPosition:Vector3D; public var requiresSecondaryLock:Bool }
public struct FluidContainmentRev34:Codable,Hashable,Sendable { public var family:String; public var capacityLiters:Double; public var capturedLiters:Double; public var spilledLiters:Double; public var drainPanPresent:Bool }
public struct SupportFixtureRev34:Codable,Hashable,Sendable { public var id:String; public var assemblyNodeId:String; public var engaged:Bool; public var capacityKg:Double?; public var capacityResearchGated:Bool }
public struct ExtractionWaypointRev34:Codable,Hashable,Sendable { public var position:Vector3D; public var clearanceRadiusMeters:Double }
public struct CollisionAwareExtractionPathRev34:Codable,Hashable,Sendable { public var assemblyNodeId:String; public var waypoints:[ExtractionWaypointRev34]; public var collisionChecked:Bool; public var clear:Bool }
public struct PhysicalInteractionRuntimeRev34:Codable,Hashable,Sendable { public var service:ProductionServiceRuntimeRev33; public var fasteners:[String:[FastenerPositionRev34]]; public var connectors:[String:[ConnectorInteractionRev34]]; public var fluids:[String:FluidContainmentRev34]; public var supports:[String:SupportFixtureRev34]; public var extractionPaths:[String:CollisionAwareExtractionPathRev34] }
public enum PhysicalInteractionAuthorityRev34 {
 public static func seed(vehicleInstanceId:String,platform:HeritageVehicleEngineeringProfile)->PhysicalInteractionRuntimeRev34 {
  let service = ProductionServiceRuntimeAuthorityRev33.seed(vehicleInstanceId:vehicleInstanceId,platform:platform)
  var fast:[String:[FastenerPositionRev34]] = [:]
  var con:[String:[ConnectorInteractionRev34]] = [:]
  var fluids:[String:FluidContainmentRev34] = [:]
  var supports:[String:SupportFixtureRev34] = [:]
  var paths:[String:CollisionAwareExtractionPathRev34] = [:]
  for (slot,plan) in service.plans {
   for interface in plan.interfaces {
    switch interface.role {
    case .fastenerGroup:
     var group:[FastenerPositionRev34] = []
     for index in 0..<4 {
      let px = Double(index % 2) * 0.08 - 0.04
      let py = Double(index / 2) * 0.08 - 0.04
      group.append(.init(id:"\(interface.id).\(index)",assemblyNodeId:slot,localPosition:Vector3D(px,py,0),driveFamily:interface.requiredToolFamily,state:.torqued,torqueNm:interface.torque?.valueNm,torqueResearchGated:interface.torque?.researchGated ?? true,toolCalibrationId:nil))
     }
     fast[slot] = group
    case .electricalConnector:
     con[slot,default:[]].append(.init(id:interface.id,assemblyNodeId:slot,lockState:.locked,localPosition:.zero,requiresSecondaryLock:true))
    case .hoseClamp,.fluidJoint:
     if let family = interface.fluidFamily { fluids[slot] = .init(family:family,capacityLiters:0,capturedLiters:0,spilledLiters:0,drainPanPresent:false) }
    case .supportPoint:
     supports[slot] = .init(id:interface.id,assemblyNodeId:slot,engaged:false,capacityKg:nil,capacityResearchGated:true)
    case .extractionClearance:
     let t = plan.extractionPose.translationMeters
     let end = Vector3D(t.count > 0 ? t[0] : 0,t.count > 1 ? t[1] : 0,t.count > 2 ? t[2] : 0)
     paths[slot] = .init(assemblyNodeId:slot,waypoints:[.init(position:.zero,clearanceRadiusMeters:0.18),.init(position:end,clearanceRadiusMeters:0.25)],collisionChecked:false,clear:false)
    case .bondedJoint: break
    }
   }
  }
  return .init(service:service,fasteners:fast,connectors:con,fluids:fluids,supports:supports,extractionPaths:paths)
 }
 public static func torqueFastener(slot:String,id:String,measuredNm:Double,calibrationId:String,runtime:inout PhysicalInteractionRuntimeRev34)->Bool { guard var group=runtime.fasteners[slot],let i=group.firstIndex(where:{$0.id==id}),measuredNm>0,!calibrationId.isEmpty else{return false}; group[i].state = .finalTorqued; group[i].toolCalibrationId=calibrationId; if !group[i].torqueResearchGated {group[i].torqueNm=measuredNm}; runtime.fasteners[slot]=group; return true }
 public static func releaseConnector(slot:String,id:String,runtime:inout PhysicalInteractionRuntimeRev34)->Bool { guard var c=runtime.connectors[slot],let i=c.firstIndex(where:{$0.id==id}) else{return false}; switch c[i].lockState {case .locked:c[i].lockState = c[i].requiresSecondaryLock ? .secondaryReleased:.primaryReleased;case .secondaryReleased:c[i].lockState = .primaryReleased;case .primaryReleased:c[i].lockState = .disconnected;default:break}; let disconnected = c[i].lockState == .disconnected; runtime.connectors[slot]=c; return disconnected }
 public static func drain(slot:String,liters:Double,runtime:inout PhysicalInteractionRuntimeRev34){ guard var f=runtime.fluids[slot],liters>0 else{return}; if f.drainPanPresent {f.capturedLiters += liters}else{f.spilledLiters += liters}; runtime.fluids[slot]=f }
 public static func engageSupport(slot:String,runtime:inout PhysicalInteractionRuntimeRev34){ guard var s=runtime.supports[slot] else{return}; s.engaged=true; runtime.supports[slot]=s }
 public static func setExtractionClear(slot:String,clear:Bool,runtime:inout PhysicalInteractionRuntimeRev34){ guard var p=runtime.extractionPaths[slot] else{return}; p.collisionChecked=true;p.clear=clear;runtime.extractionPaths[slot]=p }
}
