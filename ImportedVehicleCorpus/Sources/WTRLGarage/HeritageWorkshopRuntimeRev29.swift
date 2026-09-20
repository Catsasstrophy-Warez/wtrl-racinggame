import Foundation
import WTRLVehicle
public enum WorkshopPrimitive:String,Codable,Sendable { case vacuumHold,airflowSynchronization,dialIndicator,backlashPattern,pressureDecay,actuatorSweep,resistanceMeasurement,waveformCapture,bumpSteerSweep,rideHeight,hydraulicBleed,thermalInspection,fastenerVerification,structuralMeasurement }
public struct HeritageWorkshopJob:Codable,Hashable,Sendable { public var vehicleId:String; public var title:String; public var primitive:WorkshopPrimitive; public var sourceStatus:EngineeringProvenance }
public enum HeritageWorkshopRuntimeRev29 {
 public static func job(for v:HeritageVehicleEngineeringProfile)->HeritageWorkshopJob {
  let text=(v.workshopProcedures.first?.title ?? "inspection").lowercased()
  let primitive:WorkshopPrimitive = text.contains("vacuum") ? .vacuumHold : text.contains("backlash") ? .backlashPattern : text.contains("thermal") || text.contains("pyrometer") ? .thermalInspection : text.contains("waveform") || text.contains("current") ? .waveformCapture : text.contains("zeroing") || text.contains("actuator") ? .actuatorSweep : text.contains("tram") || text.contains("structure") ? .structuralMeasurement : text.contains("play") || text.contains("lash") ? .dialIndicator : .fastenerVerification
  return .init(vehicleId:v.id,title:v.workshopProcedures.first?.title ?? "Generation-specific inspection",primitive:primitive,sourceStatus:v.sourceStatus)
 }
}
