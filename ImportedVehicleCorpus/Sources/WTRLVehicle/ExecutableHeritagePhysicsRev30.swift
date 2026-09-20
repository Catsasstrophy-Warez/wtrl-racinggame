import Foundation

public enum HeritageFuelArchitectureRev30:String,Codable,Sendable { case carbureted, mechanicalInjection, portEFI, directInjection, unknown }
public enum HeritageInductionArchitectureRev30:String,Codable,Sendable { case naturallyAspirated, supercharged, turbocharged, twinTurbo, quadTurbo }
public enum HeritageDriveArchitectureRev30:String,Codable,Sendable { case rwd, fwd, awd }
public enum HeritageFaultPrimitiveRev30:String,Codable,CaseIterable,Sendable { case fuelRestriction, vacuumLeak, boostLeak, chargeHeatSoak, bearingWear, drivelineLash, brakeHeatSaturation, bushingCompliance, damperFade, aeroRideHeightLoss, awdClutchHeat, fastenerLooseness }

public struct HeritageExecutablePhysicsProfileRev30:Codable,Hashable,Sendable {
 public var vehicleId:String; public var fuel:HeritageFuelArchitectureRev30; public var induction:HeritageInductionArchitectureRev30; public var drive:HeritageDriveArchitectureRev30
 public var primitiveKinds:[EngineeringPrimitiveKind]; public var faultPrimitives:[HeritageFaultPrimitiveRev30]; public var fixedStepHz:Int; public var sourceStatus:EngineeringProvenance
}

public struct HeritageFaultStateRev30:Codable,Hashable,Sendable { public var fault:HeritageFaultPrimitiveRev30; public var severity01:Double; public init(_ fault:HeritageFaultPrimitiveRev30,_ severity01:Double){self.fault=fault;self.severity01=max(0,min(1,severity01))} }
public struct HeritageFaultEffectRev30:Codable,Hashable,Sendable { public var torqueScale:Double=1; public var gripScale:Double=1; public var brakeScale:Double=1; public var coolingScale:Double=1; public var vibration01:Double=0; public var evidence:[String]=[] }

public enum HeritageExecutablePhysicsAuthorityRev30 {
 public static func profile(for v:HeritageVehicleEngineeringProfile)->HeritageExecutablePhysicsProfileRev30 {
  let text=[v.powertrainArchitecture,v.fuelMetering,v.induction,v.frontKinematics,v.rearKinematics,v.steering,v.dynamicMechanisms.joined(separator:" ")].joined(separator:" ").lowercased()
  let fuel:HeritageFuelArchitectureRev30 = text.contains("carb") ? .carbureted : text.contains("mechanical injection") ? .mechanicalInjection : text.contains("direct injection") ? .directInjection : text.contains("efi") || text.contains("electronic injection") || text.contains("port injection") ? .portEFI : .unknown
  let induction:HeritageInductionArchitectureRev30 = text.contains("quad-turbo") ? .quadTurbo : text.contains("twin-turbo") ? .twinTurbo : text.contains("turbo") ? .turbocharged : text.contains("supercharg") ? .supercharged : .naturallyAspirated
  let drive:HeritageDriveArchitectureRev30 = text.contains("awd") || text.contains("4wd") ? .awd : text.contains("fwd") || text.contains("front-wheel") ? .fwd : .rwd
  var primitives:[EngineeringPrimitiveKind]=[.Bearing,.Fastener,.FrictionSurface,.Spring,.Damper,.Shaft,.Gear]
  var faults:[HeritageFaultPrimitiveRev30]=[.bearingWear,.drivelineLash,.brakeHeatSaturation,.bushingCompliance,.damperFade,.fastenerLooseness]
  switch fuel { case .carbureted,.mechanicalInjection: primitives += [.Filter,.Hose]; faults += [.fuelRestriction,.vacuumLeak]; case .portEFI,.directInjection: primitives += [.Pump,.Filter,.Connector,.Conductor]; faults += [.fuelRestriction]; case .unknown: break }
  if induction != .naturallyAspirated { primitives += [.HeatExchanger,.Hose]; faults += [.boostLeak,.chargeHeatSoak] }
  if drive == .awd { primitives += [.FrictionSurface]; faults += [.awdClutchHeat] }
  if text.contains("aero") || text.contains("downforce") || text.contains("wing") { faults += [.aeroRideHeightLoss] }
  return .init(vehicleId:v.id,fuel:fuel,induction:induction,drive:drive,primitiveKinds:Array(Set(primitives)).sorted{$0.rawValue<$1.rawValue},faultPrimitives:Array(Set(faults)).sorted{$0.rawValue<$1.rawValue},fixedStepHz:120,sourceStatus:v.sourceStatus)
 }
 public static func effects(_ states:[HeritageFaultStateRev30])->HeritageFaultEffectRev30 {
  var o=HeritageFaultEffectRev30()
  for s in states { let x=s.severity01; switch s.fault {
   case .fuelRestriction: o.torqueScale *= 1-0.38*x; o.evidence += ["fuel delivery falls with demand"]
   case .vacuumLeak: o.torqueScale *= 1-0.20*x; o.evidence += ["idle/part-throttle mixture instability"]
   case .boostLeak: o.torqueScale *= 1-0.32*x; o.evidence += ["commanded boost exceeds measured boost"]
   case .chargeHeatSoak: o.torqueScale *= 1-0.18*x; o.coolingScale *= 1-0.30*x; o.evidence += ["charge temperature rises across repeated load"]
   case .bearingWear: o.vibration01=max(o.vibration01,0.65*x); o.gripScale *= 1-0.08*x; o.evidence += ["speed-order vibration and local heat"]
   case .drivelineLash: o.vibration01=max(o.vibration01,0.55*x); o.evidence += ["torque-reversal clunk and phase oscillation"]
   case .brakeHeatSaturation: o.brakeScale *= 1-0.42*x; o.evidence += ["pedal demand rises with brake temperature"]
   case .bushingCompliance: o.gripScale *= 1-0.16*x; o.evidence += ["load-dependent alignment migration"]
   case .damperFade: o.gripScale *= 1-0.14*x; o.evidence += ["wheel control decays with damper temperature"]
   case .aeroRideHeightLoss: o.gripScale *= 1-0.12*x; o.evidence += ["aero balance departs as platform height changes"]
   case .awdClutchHeat: o.gripScale *= 1-0.10*x; o.evidence += ["torque split collapses as coupling temperature rises"]
   case .fastenerLooseness: o.vibration01=max(o.vibration01,0.35*x); o.evidence += ["joint motion grows under cyclic load"]
  }}
  return o
 }
}
