import Foundation

public struct GearboxCalibration: Codable, Hashable, Sendable {
    public var ratios:[Double]; public var finalDrive:Double; public var shiftTimeS:Double
    public init(_ ratios:[Double], finalDrive:Double, shiftTimeS:Double){self.ratios=ratios;self.finalDrive=finalDrive;self.shiftTimeS=shiftTimeS}
}
public struct SuspensionCalibration: Codable, Hashable, Sendable {
    public var frontSpringNPerM:Double; public var rearSpringNPerM:Double; public var frontDampingNsPerM:Double; public var rearDampingNsPerM:Double; public var frontRollStiffnessNmPerRad:Double; public var rearRollStiffnessNmPerRad:Double
}
public struct BrakeCalibration: Codable, Hashable, Sendable { public var frontRotorMm:Double; public var rearRotorMm:Double; public var frontPistonAreaCm2:Double; public var rearPistonAreaCm2:Double; public var thermalCapacityKJPerC:Double }
public struct AeroCalibration: Codable, Hashable, Sendable { public var cd:Double; public var frontalAreaM2:Double; public var liftCoefficientFront:Double; public var liftCoefficientRear:Double }
public struct CoolingCalibration: Codable, Hashable, Sendable { public var coolantL:Double; public var radiatorEffectiveness01:Double; public var oilCooling01:Double; public var chargeCooling01:Double }
public struct DifferentialCalibration: Codable, Hashable, Sendable { public var type:String; public var preloadNm:Double; public var powerLock01:Double; public var coastLock01:Double }
public struct EngineCurvePoint: Codable, Hashable, Sendable { public var rpm:Double; public var torqueNm:Double }

/// Fictionalized executable calibration. It is gameplay engineering data, not an OEM specification source.
public struct VehicleMechanicalCalibration: Codable, Hashable, Sendable, Identifiable {
    public var id:String; public var vehicleId:String; public var engineArchitecture:String; public var engineCurve:[EngineCurvePoint]
    public var gearbox:GearboxCalibration; public var suspension:SuspensionCalibration; public var brakes:BrakeCalibration; public var aero:AeroCalibration; public var cooling:CoolingCalibration; public var differential:DifferentialCalibration
    public var serviceNodes:[String]; public var stableVisualPartIds:[String]; public var researchGatedFields:[String]
}

public enum VehicleMechanicalCalibrationRosterRev28 {
    private static func curve(_ peak:Double,_ redline:Double)->[EngineCurvePoint] { [.init(rpm:1000,torqueNm:peak*0.58),.init(rpm:redline*0.45,torqueNm:peak*0.94),.init(rpm:redline*0.65,torqueNm:peak),.init(rpm:redline*0.85,torqueNm:peak*0.91),.init(rpm:redline,torqueNm:peak*0.76)] }
    private static func make(_ v:ProductionVehicleDefinition, enforcement:Bool=false)->VehicleMechanicalCalibration {
        let modern = v.modelYearBand.contains("20") || v.modelYearBand == "Current" || v.modelYearBand == "Prototype" || v.modelYearBand == "Experimental" || v.modelYearBand == "Endgame"
        let ratios:[Double] = v.transmission == .dct7 || v.transmission == .prototypeDCT ? [3.40,2.30,1.70,1.32,1.05,0.84,0.68] : (v.transmission == .manual6 || v.transmission == .sequential6 ? [2.97,2.07,1.43,1.00,0.80,0.63] : [2.78,1.93,1.36,1.00])
        let springScale=max(0.75,min(1.65,v.massKg/1650.0*(0.7+v.chassisRigidity01*0.55)))
        let tireScale=max(0.8,(v.tireSectionFrontMm+v.tireSectionRearMm)/520.0)
        return .init(id:"cal_\(v.id)",vehicleId:v.id,engineArchitecture: modern ? (v.ratedPowerKW > 520 ? "high-output forced-induction V8" : "modern performance V8") : "period large-displacement V8",engineCurve:curve(v.ratedTorqueNm,v.redlineRPM),gearbox:.init(ratios,finalDrive:v.finalDrive,shiftTimeS:(v.transmission == .dct7 || v.transmission == .prototypeDCT) ? 0.09 : 0.28),suspension:.init(frontSpringNPerM:34000*springScale,rearSpringNPerM:31000*springScale,frontDampingNsPerM:3100*springScale,rearDampingNsPerM:2850*springScale,frontRollStiffnessNmPerRad:29000*springScale,rearRollStiffnessNmPerRad:24000*springScale),brakes:.init(frontRotorMm:modern ? 390*tireScale : 300*tireScale,rearRotorMm:modern ? 365*tireScale : 280*tireScale,frontPistonAreaCm2:modern ? 34:24,rearPistonAreaCm2:modern ? 22:17,thermalCapacityKJPerC:75+v.brakeThermalCapacity01*125),aero:.init(cd:max(0.28,0.46-v.aeroDownforceScale01*0.10),frontalAreaM2:2.0+v.massKg/5000,liftCoefficientFront:0.10-v.aeroDownforceScale01*0.45,liftCoefficientRear:0.12-v.aeroDownforceScale01*0.58),cooling:.init(coolantL:10+v.ratedPowerKW/120,radiatorEffectiveness01:v.coolingCapacity01,oilCooling01:max(0.2,v.coolingCapacity01-0.08),chargeCooling01:v.ratedPowerKW>350 ? v.coolingCapacity01:0.15),differential:.init(type:v.drive == .frontEngineAWD ? "electronically managed AWD coupling" : (modern ? "limited-slip differential" : "clutch limited-slip/live axle"),preloadNm:60+v.ratedTorqueNm*0.12,powerLock01:min(0.90,0.40+v.ratedTorqueNm/1800),coastLock01:enforcement ? 0.35:0.25),serviceNodes:["engine.front","cooling.radiator","brake.fl","brake.fr","hub.fl","hub.fr","steering.center","driveline.output","differential.case"],stableVisualPartIds:["body.shell","hood","door.left","door.right","wheel.fl","wheel.fr","wheel.rl","wheel.rr","brake.fl","brake.fr","engine.longblock","cooling.radiator","transmission.case","driveshaft.main","differential.case","cockpit.cluster"],researchGatedFields:["OEM torque specifications","OEM alignment specifications","OEM calibration maps","OEM aero coefficients"])
    }
    public static let hero:[VehicleMechanicalCalibration] = HeroProductionRosterRev27.vehicles.map{make($0)}
    public static func enforcement(_ vehicles:[ProductionVehicleDefinition])->[VehicleMechanicalCalibration] { vehicles.map{make($0,enforcement:true)} }
    public static var allHeroVehicleIds:Set<String>{Set(hero.map(\.vehicleId))}
}
