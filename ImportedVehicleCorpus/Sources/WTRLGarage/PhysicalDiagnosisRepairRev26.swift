import Foundation
import WTRLCore
import WTRLVehicle

public enum WorkshopMeasurementType:String,Codable,CaseIterable,Sendable { case caster,camber,toe,steeringCenter,wheelRunout,tireRunout,hubRunout,bearingPlay,bearingTemperature,pressureDecay,bushingDeflection,chassisDatum,driveshaftRunout,differentialBacklash,damperTravel }
public struct WorkshopMeasurementEvidence:Codable,Hashable,Sendable,Identifiable {
    public var id:String; public var vehicleId:String; public var componentId:String?; public var corner:VehicleCorner?; public var type:WorkshopMeasurementType
    public var value:Double; public var unit:String; public var toolId:String; public var toolCalibrationError01:Double; public var confidence01:Double
    public var ambientC:Double; public var setupNotes:String; public var timestamp:Date
    public init(id:String=UUID().uuidString,vehicleId:String,componentId:String?=nil,corner:VehicleCorner?=nil,type:WorkshopMeasurementType,value:Double,unit:String,tool:WorkshopTool,ambientC:Double=20,setupNotes:String="",timestamp:Date=Date()){self.id=id;self.vehicleId=vehicleId;self.componentId=componentId;self.corner=corner;self.type=type;self.value=value;self.unit=unit;self.toolId=tool.id;self.toolCalibrationError01=tool.calibrationError01;self.confidence01=max(0,min(1,tool.condition01-tool.calibrationError01));self.ambientC=ambientC;self.setupNotes=setupNotes;self.timestamp=timestamp}
}
public struct AlignmentRackSetup:Codable,Hashable,Sendable { public var vehicleOnRack=false,targetsInstalled:Set<VehicleCorner>=[],turnPlatesUnlocked=false,steeringWheelHeld=false,suspensionSettled=false; public init(){}; public var valid:Bool {vehicleOnRack && targetsInstalled.count==4 && turnPlatesUnlocked && steeringWheelHeld && suspensionSettled} }
public struct AlignmentRackReport:Codable,Hashable,Sendable { public var alignment:VehicleAlignmentState;public var valid:Bool;public var confidence01:Double;public var warnings:[String];public init(alignment:VehicleAlignmentState,valid:Bool,confidence01:Double,warnings:[String]){self.alignment=alignment;self.valid=valid;self.confidence01=confidence01;self.warnings=warnings} }
public enum AlignmentRackAuthority {
    public static func measure(truth:PersistentVehicleDamageState,setup:AlignmentRackSetup,headCalibrationErrorDeg:Double=0)->AlignmentRackReport {
        var a=truth.alignment; var warnings:[String]=[]; var confidence=1.0
        if !setup.vehicleOnRack {warnings.append("vehicle not positioned on alignment rack");confidence*=0.1}
        if setup.targetsInstalled.count != 4 {warnings.append("four-corner targets incomplete");confidence*=0.35}
        if !setup.turnPlatesUnlocked {warnings.append("turn plates locked; caster sweep invalid");confidence*=0.55}
        if !setup.steeringWheelHeld {warnings.append("steering center not constrained");confidence*=0.65}
        if !setup.suspensionSettled {warnings.append("suspension not settled/jounced");confidence*=0.55}
        for c in VehicleCorner.allCases { a[c].toeDeg += headCalibrationErrorDeg; a[c].camberDeg += headCalibrationErrorDeg*0.5; if !setup.turnPlatesUnlocked {a[c].casterDeg=0} }
        return .init(alignment:a,valid:setup.valid,confidence01:max(0,min(1,confidence-abs(headCalibrationErrorDeg)*0.1)),warnings:warnings)
    }
}
public struct DialIndicatorSetup:Codable,Hashable,Sendable { public var magneticBaseLocked=false,probePreloadMm=0.0,zeroed=false,fixtureStable=false;public init(){}; public var valid:Bool {magneticBaseLocked && probePreloadMm >= 0.2 && zeroed && fixtureStable} }
public struct RunoutSeparationReport:Codable,Hashable,Sendable { public var tireMm:Double,rimMm:Double,hubMm:Double; public var likelySource:String { if hubMm > 0.4{return "hub"};if rimMm > 0.8{return "wheel/rim"};if tireMm > 1.5{return "tire or tire-to-wheel indexing"};return "within modeled service envelope"} }
public enum RunoutDiagnosisAuthority { public static func separate(tireMm:Double,rimMm:Double,hubMm:Double,setup:DialIndicatorSetup)->RunoutSeparationReport? {guard setup.valid else{return nil};return .init(tireMm:tireMm,rimMm:rimMm,hubMm:hubMm)} }
public struct PressureDecayReport:Codable,Hashable,Sendable { public var startKPa:Double,endKPa:Double,minutes:Double,startTempC:Double,endTempC:Double;public var temperatureCompensatedLossKPa:Double;public var leakKPaPerMinute:Double }
public enum TireLeakDiagnosisAuthority { public static func evaluate(startKPa:Double,endKPa:Double,minutes:Double,startTempC:Double,endTempC:Double)->PressureDecayReport { let absoluteStart=startTempC+273.15,absoluteEnd=endTempC+273.15;let compensatedEnd=endKPa*absoluteStart/max(1,absoluteEnd);let loss=max(0,startKPa-compensatedEnd);return .init(startKPa:startKPa,endKPa:endKPa,minutes:minutes,startTempC:startTempC,endTempC:endTempC,temperatureCompensatedLossKPa:loss,leakKPaPerMinute:loss/max(0.1,minutes)) } }

public enum ServiceOperationKind:String,Codable,Sendable {case diagnose,disassemble,inspect,replace,reuse,torque,align,calibrate,verify}
public struct ServiceHistoryRecord:Codable,Hashable,Sendable,Identifiable { public var id:String;public var vehicleId:String;public var operation:ServiceOperationKind;public var componentIds:[String];public var evidenceIds:[String];public var notes:String;public var timestamp:Date;public init(id:String=UUID().uuidString,vehicleId:String,operation:ServiceOperationKind,componentIds:[String]=[],evidenceIds:[String]=[],notes:String="",timestamp:Date=Date()){self.id=id;self.vehicleId=vehicleId;self.operation=operation;self.componentIds=componentIds;self.evidenceIds=evidenceIds;self.notes=notes;self.timestamp=timestamp} }
public struct RepairVerificationMetric:Codable,Hashable,Sendable {public var name:String,before:Double,after:Double,maximumAcceptable:Double;public var improved:Bool{abs(after)<abs(before)};public var passed:Bool{abs(after)<=maximumAcceptable}}
public struct RepairVerificationReport:Codable,Hashable,Sendable {public var vehicleId:String;public var metrics:[RepairVerificationMetric];public var originalSymptomResolved:Bool;public var introducedRegression:Bool;public var summary:String}
public enum RepairVerificationAuthority {
    public static func compare(vehicleId:String,before:[String:Double],after:[String:Double],limits:[String:Double])->RepairVerificationReport { let metrics=limits.keys.sorted().map{RepairVerificationMetric(name:$0,before:before[$0] ?? 0,after:after[$0] ?? 0,maximumAcceptable:limits[$0] ?? 0)};let resolved=metrics.allSatisfy{$0.passed};let regression=metrics.contains{abs($0.after)>abs($0.before)*1.15 && !$0.passed};return .init(vehicleId:vehicleId,metrics:metrics,originalSymptomResolved:resolved,introducedRegression:regression,summary:resolved ? "verification passed: measured symptoms are within the modeled acceptance envelope" : "verification incomplete: one or more measured symptoms remain outside the modeled acceptance envelope") }
    public static func replace(componentId:String,with replacement:ComponentPhysicalCondition,state:inout PersistentVehicleDamageState){state.componentConditions[componentId]=replacement; if let c=replacement.corner {var d=state[c];switch replacement.kind {case .wheel:d.wheelRunoutMm=replacement.runoutMm;case .wheelBearing:d.wheelBearingDamage01=replacement.damage01;d.wheelBearingTempC=replacement.temperatureC;case .tieRod:d.tieRodDamage01=replacement.damage01;d.permanentToeShiftDeg=0;case .bushing:d.bushingDamage01=replacement.damage01;d.mountLooseness01=replacement.loosenessMm/3;case .tire:d.pressureLeakKPaPerMinute=replacement.leakRatePerMinute;default:break};state[c]=d};PhysicalTruthBridgeAuthority.synchronizeLegacyDamage(&state)}
    public static func align(corner:VehicleCorner,to target:CornerAlignmentState,state:inout PersistentVehicleDamageState){state.alignment[corner]=target;var d=state[corner];d.permanentToeShiftDeg=target.toeDeg;d.permanentCamberShiftDeg=target.camberDeg;state[corner]=d}
    public static func calibrateSteeringCenter(to degrees:Double,state:inout PersistentVehicleDamageState){state.steeringCenterOffsetDeg=degrees;state.alignment.steeringWheelCenterDeg=degrees}
}
