import Foundation

/// Fictional engineering archetypes. They intentionally describe mechanisms rather than copy
/// real vehicle badges, trade dress, homologation names, or unverified historical specifications.
public enum HeroEngineeringEra: String, Codable, CaseIterable, Sendable {
    case mechanicalOrigins, emissionsTransition, electronicLightweight, modularPerformance, modernAero
}
public enum EngineArchitecture: String, Codable, Sendable {
    case pushrodCarburetedV8, emissionsCarburetedV8, turbochargedInlineFour, portInjectedV8
    case naturallyAspiratedDOHCV8, superchargedDOHCV8, highRevV8, drySumpSuperchargedV8
}
public enum RearSuspensionArchitecture: String, Codable, Sendable { case leafLiveAxle, linkedLiveAxle, independentMultiLink, pushrodIndependent }
public enum BrakeArchitecture: String, Codable, Sendable { case drumDrum, discDrum, fourWheelDisc, performanceABS, carbonCeramicABS }
public enum DiagnosticTechnology: String, Codable, Sendable { case earAndGauge, timingLightAndVacuum, earlyElectronic, obdAndScan, canTelemetry }

public struct GenerationalEngineeringProfile: Codable, Hashable, Sendable {
    public var id:String
    public var displayName:String
    public var era:HeroEngineeringEra
    public var engine:EngineArchitecture
    public var rearSuspension:RearSuspensionArchitecture
    public var brakes:BrakeArchitecture
    public var diagnostics:DiagnosticTechnology
    public var baseMassKg:Double
    public var frontWeightFraction:Double
    public var chassisRigidity01:Double
    public var thermalCapacity01:Double
    public var technologyYearWindow:ClosedRange<Int>
    public var researchStatus:String
}
public enum GenerationalEngineeringCatalog {
    public static let profiles:[GenerationalEngineeringProfile] = [
        .init(id:"origin_mechanical_gt",displayName:"Origin Mechanical GT",era:.mechanicalOrigins,engine:.pushrodCarburetedV8,rearSuspension:.leafLiveAxle,brakes:.discDrum,diagnostics:.timingLightAndVacuum,baseMassKg:1325,frontWeightFraction:0.54,chassisRigidity01:0.34,thermalCapacity01:0.42,technologyYearWindow:1965...1973,researchStatus:"fictional engineering calibration"),
        .init(id:"origin_lightweight_homologation",displayName:"Origin Lightweight Homologation",era:.mechanicalOrigins,engine:.pushrodCarburetedV8,rearSuspension:.leafLiveAxle,brakes:.fourWheelDisc,diagnostics:.timingLightAndVacuum,baseMassKg:1260,frontWeightFraction:0.53,chassisRigidity01:0.43,thermalCapacity01:0.50,technologyYearWindow:1965...1973,researchStatus:"fictional engineering calibration"),
        .init(id:"origin_bigblock_special",displayName:"Origin Big-Block Special",era:.mechanicalOrigins,engine:.pushrodCarburetedV8,rearSuspension:.leafLiveAxle,brakes:.fourWheelDisc,diagnostics:.timingLightAndVacuum,baseMassKg:1510,frontWeightFraction:0.58,chassisRigidity01:0.48,thermalCapacity01:0.56,technologyYearWindow:1968...1973,researchStatus:"fictional engineering calibration"),
        .init(id:"transition_emissions_gt",displayName:"Transition Emissions GT",era:.emissionsTransition,engine:.emissionsCarburetedV8,rearSuspension:.linkedLiveAxle,brakes:.discDrum,diagnostics:.timingLightAndVacuum,baseMassKg:1370,frontWeightFraction:0.55,chassisRigidity01:0.38,thermalCapacity01:0.38,technologyYearWindow:1974...1978,researchStatus:"fictional engineering calibration"),
        .init(id:"electronic_turbo_clubsport",displayName:"Electronic Turbo Clubsport",era:.electronicLightweight,engine:.turbochargedInlineFour,rearSuspension:.linkedLiveAxle,brakes:.fourWheelDisc,diagnostics:.earlyElectronic,baseMassKg:1320,frontWeightFraction:0.51,chassisRigidity01:0.46,thermalCapacity01:0.58,technologyYearWindow:1979...1993,researchStatus:"fictional engineering calibration"),
        .init(id:"electronic_v8_clubsport",displayName:"Electronic V8 Clubsport",era:.electronicLightweight,engine:.portInjectedV8,rearSuspension:.linkedLiveAxle,brakes:.fourWheelDisc,diagnostics:.earlyElectronic,baseMassKg:1390,frontWeightFraction:0.55,chassisRigidity01:0.44,thermalCapacity01:0.56,technologyYearWindow:1979...1993,researchStatus:"fictional engineering calibration"),
        .init(id:"modular_supercharged_special",displayName:"Modular Supercharged Special",era:.modularPerformance,engine:.superchargedDOHCV8,rearSuspension:.independentMultiLink,brakes:.performanceABS,diagnostics:.obdAndScan,baseMassKg:1660,frontWeightFraction:0.57,chassisRigidity01:0.66,thermalCapacity01:0.72,technologyYearWindow:1994...2009,researchStatus:"fictional engineering calibration"),
        .init(id:"modern_highrev_track",displayName:"Modern High-Rev Track",era:.modernAero,engine:.highRevV8,rearSuspension:.independentMultiLink,brakes:.performanceABS,diagnostics:.canTelemetry,baseMassKg:1650,frontWeightFraction:0.54,chassisRigidity01:0.86,thermalCapacity01:0.85,technologyYearWindow:2010...2022,researchStatus:"fictional engineering calibration"),
        .init(id:"modern_aero_transaxle",displayName:"Modern Aero Transaxle Prototype",era:.modernAero,engine:.drySumpSuperchargedV8,rearSuspension:.pushrodIndependent,brakes:.carbonCeramicABS,diagnostics:.canTelemetry,baseMassKg:1740,frontWeightFraction:0.50,chassisRigidity01:0.95,thermalCapacity01:0.95,technologyYearWindow:2022...2030,researchStatus:"fictional prototype calibration")
    ]
}
