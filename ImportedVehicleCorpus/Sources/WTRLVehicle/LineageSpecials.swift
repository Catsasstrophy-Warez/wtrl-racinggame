import Foundation

public enum DiagnosticEra:String,Codable,Sendable { case analogMechanical,vacuumEmissions,earlyEFI,obdElectronic,canTelemetry,activeSystems }
public struct FictionalLineageSpecial:Codable,Hashable,Sendable {
    public var id:String,name:String,era:String,engine:String,rearArchitecture:String,diagnostics:DiagnosticEra
    public var massBiasFront01:Double,chassisRigidity01:Double,brakeThermalCapacity01:Double,thermalRejection01:Double,vibrationSeverity01:Double
    public var sourceStatus:String
}
public enum FictionalLineageSpecialCatalog {
    public static let specials:[FictionalLineageSpecial]=[
        .init(id:"origin_homologation",name:"Vanguard Origin Homologation",era:"mid_1960s",engine:"high-response carbureted small V8",rearArchitecture:"leaf_live_axle",diagnostics:.analogMechanical,massBiasFront01:0.53,chassisRigidity01:0.34,brakeThermalCapacity01:0.38,thermalRejection01:0.45,vibrationSeverity01:0.48,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"colossus_bigblock",name:"Vanguard Colossus",era:"late_1960s",engine:"large-displacement iron V8",rearArchitecture:"traction_aided_live_axle",diagnostics:.analogMechanical,massBiasFront01:0.58,chassisRigidity01:0.38,brakeThermalCapacity01:0.46,thermalRejection01:0.50,vibrationSeverity01:0.58,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"downsized_emissions",name:"Vanguard Compact King",era:"late_1970s",engine:"emissions-era small V8",rearArchitecture:"soft_bushed_live_axle",diagnostics:.vacuumEmissions,massBiasFront01:0.52,chassisRigidity01:0.29,brakeThermalCapacity01:0.42,thermalRejection01:0.34,vibrationSeverity01:0.40,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"turbo_lightweight",name:"Vanguard Turbo Vector",era:"mid_1980s",engine:"intercooled turbo four",rearArchitecture:"four_link_live_axle",diagnostics:.earlyEFI,massBiasFront01:0.50,chassisRigidity01:0.39,brakeThermalCapacity01:0.58,thermalRejection01:0.61,vibrationSeverity01:0.44,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"lightweight_v8",name:"Vanguard Street Apex",era:"late_1980s",engine:"roller-cam EFI V8",rearArchitecture:"four_link_live_axle",diagnostics:.earlyEFI,massBiasFront01:0.53,chassisRigidity01:0.35,brakeThermalCapacity01:0.48,thermalRejection01:0.55,vibrationSeverity01:0.50,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"modular_highrev",name:"Vanguard Modular RS",era:"late_1990s",engine:"high-rev multivalve V8",rearArchitecture:"live_axle",diagnostics:.obdElectronic,massBiasFront01:0.55,chassisRigidity01:0.54,brakeThermalCapacity01:0.64,thermalRejection01:0.64,vibrationSeverity01:0.52,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"supercharged_irs",name:"Vanguard Eliminator SC",era:"early_2000s",engine:"forged supercharged multivalve V8",rearArchitecture:"independent_rear",diagnostics:.obdElectronic,massBiasFront01:0.56,chassisRigidity01:0.59,brakeThermalCapacity01:0.69,thermalRejection01:0.59,vibrationSeverity01:0.63,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"highrev_track",name:"Vanguard Resonance R",era:"mid_2010s",engine:"high-rev naturally aspirated V8",rearArchitecture:"multilink_independent",diagnostics:.canTelemetry,massBiasFront01:0.53,chassisRigidity01:0.77,brakeThermalCapacity01:0.84,thermalRejection01:0.81,vibrationSeverity01:0.82,sourceStatus:"fictional engineering archetype; historical calibration research-gated"),
        .init(id:"aero_transaxle",name:"Vanguard Aero Prototype",era:"2020s",engine:"dry-sump supercharged V8",rearArchitecture:"inboard_damped_multilink",diagnostics:.activeSystems,massBiasFront01:0.50,chassisRigidity01:0.91,brakeThermalCapacity01:0.94,thermalRejection01:0.92,vibrationSeverity01:0.61,sourceStatus:"fictional engineering archetype; historical calibration research-gated")]
}
public struct BuildPhilosophyAssessment:Codable,Hashable,Sendable { public var historicEligibility01:Double,periodRaceEligibility01:Double,modernCapability01:Double,restorationCostMultiplier:Double,irreversibleFabrication:Bool }
public enum BuildPhilosophyAuthority {
    public static func assess(_ path:HeroBuildPhilosophy,modernization01:Double,chassisCuts:Int,periodCorrect01:Double)->BuildPhilosophyAssessment {
        let cuts=chassisCuts>0
        switch path {
        case .preserved:return .init(historicEligibility01:max(0,periodCorrect01-modernization01*0.8-(cuts ? 0.7:0)),periodRaceEligibility01:periodCorrect01*0.8,modernCapability01:modernization01*0.25,restorationCostMultiplier:1,irreversibleFabrication:cuts)
        case .periodOutlaw:return .init(historicEligibility01:max(0,periodCorrect01*0.35-(cuts ? 0.1:0)),periodRaceEligibility01:periodCorrect01,modernCapability01:0.35+modernization01*0.25,restorationCostMultiplier:1.8,irreversibleFabrication:cuts)
        case .livingShip:return .init(historicEligibility01:max(0,0.25-modernization01*0.2-(cuts ? 0.2:0)),periodRaceEligibility01:max(0,0.4-modernization01*0.3),modernCapability01:min(1,0.5+modernization01*0.5),restorationCostMultiplier:cuts ? 4.5:2.5,irreversibleFabrication:cuts)
        }
    }
}
