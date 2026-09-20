import Foundation
import WTRLVehicle
public enum HeritageMeasurementToolRev30:String,Codable,Sendable { case dialIndicator,vacuumGauge,pressureGauge,oscilloscope,pyrometer,alignmentRack,torqueTool,scanTool,rideHeightGauge }
public struct HeritageDiagnosticStepRev30:Codable,Hashable,Sendable { public var sequence:Int; public var action:String; public var tool:HeritageMeasurementToolRev30; public var expectedEvidence:String; public var sourceStatus:EngineeringProvenance }
public struct HeritageDiagnosticPlanRev30:Codable,Hashable,Sendable { public var vehicleId:String; public var suspectedFault:HeritageFaultPrimitiveRev30; public var steps:[HeritageDiagnosticStepRev30] }
public enum ExecutableHeritageWorkshopAuthorityRev30 {
 public static func plan(vehicle:HeritageVehicleEngineeringProfile,fault:HeritageFaultPrimitiveRev30)->HeritageDiagnosticPlanRev30 {
  let status=vehicle.sourceStatus
  func s(_ i:Int,_ a:String,_ t:HeritageMeasurementToolRev30,_ e:String)->HeritageDiagnosticStepRev30{.init(sequence:i,action:a,tool:t,expectedEvidence:e,sourceStatus:status)}
  let steps:[HeritageDiagnosticStepRev30]
  switch fault {
   case .fuelRestriction: steps=[s(1,"Measure delivery under load",.pressureGauge,"pressure/flow falls as demand rises"),s(2,"Inspect metering/filter path",.vacuumGauge,"restriction localizes upstream or at metering")]
   case .vacuumLeak: steps=[s(1,"Measure manifold vacuum stability",.vacuumGauge,"unstable or unexpectedly low vacuum"),s(2,"Isolate leak path before adjustment",.vacuumGauge,"signal normalizes when leak is isolated")]
   case .boostLeak: steps=[s(1,"Compare commanded and measured boost",.scanTool,"boost shortfall grows with airflow"),s(2,"Pressure-test charge path",.pressureGauge,"pressure decay localizes leak")]
   case .chargeHeatSoak: steps=[s(1,"Record charge temperature across repeated pulls",.scanTool,"temperature rises pull-to-pull"),s(2,"Verify cooling loop response",.pyrometer,"heat rejection or circulation is insufficient")]
   case .bearingWear: steps=[s(1,"Measure free play/runout",.dialIndicator,"mechanical clearance exceeds baseline"),s(2,"Compare local temperature after controlled run",.pyrometer,"affected bearing runs hotter")]
   case .drivelineLash: steps=[s(1,"Measure rotational free play",.dialIndicator,"lash exceeds established baseline"),s(2,"Inspect contact/load path",.dialIndicator,"motion localizes to joint or gearset")]
   case .brakeHeatSaturation: steps=[s(1,"Measure rotor/caliper temperatures",.pyrometer,"thermal imbalance or saturation appears"),s(2,"Correlate pedal travel with temperature",.pressureGauge,"braking effectiveness falls as heat rises")]
   case .bushingCompliance: steps=[s(1,"Load suspension and measure dynamic displacement",.dialIndicator,"joint moves under load"),s(2,"Run alignment sweep",.alignmentRack,"toe/camber migrates with applied load")]
   case .damperFade: steps=[s(1,"Compare response cold versus hot",.rideHeightGauge,"wheel control decays after heat"),s(2,"Inspect damper body temperature/leakage",.pyrometer,"affected damper differs from peer")]
   case .aeroRideHeightLoss: steps=[s(1,"Measure platform height/rake",.rideHeightGauge,"ride height leaves aero operating window"),s(2,"Inspect mounts and underbody",.torqueTool,"damage or movement explains balance shift")]
   case .awdClutchHeat: steps=[s(1,"Record coupling temperature and torque split",.scanTool,"rear/front contribution falls with heat"),s(2,"Command actuator sweep after cool-down",.scanTool,"capacity returns or actuator fault remains")]
   case .fastenerLooseness: steps=[s(1,"Inspect joint movement witness evidence",.dialIndicator,"cyclic motion exists at interface"),s(2,"Verify fastener condition using researched procedure",.torqueTool,"joint can be restored without inventing OEM torque")]
  }
  return .init(vehicleId:vehicle.id,suspectedFault:fault,steps:steps)
 }
}
