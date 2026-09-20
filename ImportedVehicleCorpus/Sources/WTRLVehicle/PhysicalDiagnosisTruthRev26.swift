import Foundation
import WTRLCore

public enum PhysicalComponentKind:String,Codable,CaseIterable,Sendable { case wheel,tire,hub,wheelBearing,tieRod,ballJoint,controlArm,bushing,damper,spring,driveshaft,differential,chassisDatum,steeringRack }
public struct ComponentPhysicalCondition:Codable,Hashable,Sendable,Identifiable {
    public var id:String { componentId }; public var componentId:String; public var kind:PhysicalComponentKind; public var corner:VehicleCorner?
    public var deformationMm=0.0, loosenessMm=0.0, runoutMm=0.0, wear01=0.0, damage01=0.0, temperatureC=25.0, leakRatePerMinute=0.0
    public var installed=true, serviceable=true
    public init(componentId:String,kind:PhysicalComponentKind,corner:VehicleCorner?=nil){self.componentId=componentId;self.kind=kind;self.corner=corner}
}
public struct CornerAlignmentState:Codable,Hashable,Sendable { public var casterDeg=0.0,camberDeg=0.0,toeDeg=0.0; public init(casterDeg:Double=0,camberDeg:Double=0,toeDeg:Double=0){self.casterDeg=casterDeg;self.camberDeg=camberDeg;self.toeDeg=toeDeg} }
public struct VehicleAlignmentState:Codable,Hashable,Sendable {
    public var frontLeft=CornerAlignmentState(),frontRight=CornerAlignmentState(),rearLeft=CornerAlignmentState(),rearRight=CornerAlignmentState()
    public var steeringWheelCenterDeg=0.0, rackCenterOffsetMm=0.0
    public init(){}
    public subscript(_ c:VehicleCorner)->CornerAlignmentState { get { switch c {case .frontLeft:return frontLeft;case .frontRight:return frontRight;case .rearLeft:return rearLeft;case .rearRight:return rearRight} } set { switch c {case .frontLeft:frontLeft=newValue;case .frontRight:frontRight=newValue;case .rearLeft:rearLeft=newValue;case .rearRight:rearRight=newValue} } }
    public var frontTotalToeDeg:Double { frontLeft.toeDeg+frontRight.toeDeg }
    public var rearTotalToeDeg:Double { rearLeft.toeDeg+rearRight.toeDeg }
    public var thrustAngleDeg:Double { (rearRight.toeDeg-rearLeft.toeDeg)*0.5 }
    public var crossCamberDeg:Double { frontLeft.camberDeg-frontRight.camberDeg }
    public var crossCasterDeg:Double { frontLeft.casterDeg-frontRight.casterDeg }
}
public struct ChassisDatumState:Codable,Hashable,Sendable { public var datumId:String; public var nominal:Vector3D; public var measured:Vector3D; public init(datumId:String,nominal:Vector3D,measured:Vector3D){self.datumId=datumId;self.nominal=nominal;self.measured=measured}; public var displacementMm:Double { let dx=measured.x-nominal.x,dy=measured.y-nominal.y,dz=measured.z-nominal.z; return sqrt(dx*dx+dy*dy+dz*dz)*1000 } }

public enum PhysicalTruthBridgeAuthority {
    public static func synchronizeLegacyDamage(_ state:inout PersistentVehicleDamageState) {
        for corner in VehicleCorner.allCases {
            let d=state[corner], prefix=corner.rawValue
            upsert(&state, .init(componentId:"\(prefix).wheel",kind:.wheel,corner:corner), runout:d.wheelRunoutMm, damage:min(1,d.wheelRunoutMm/8))
            upsert(&state, .init(componentId:"\(prefix).tire",kind:.tire,corner:corner), damage:min(1,d.pressureLeakKPaPerMinute/42), leak:d.pressureLeakKPaPerMinute)
            upsert(&state, .init(componentId:"\(prefix).bearing",kind:.wheelBearing,corner:corner), damage:d.wheelBearingDamage01, temp:d.wheelBearingTempC)
            upsert(&state, .init(componentId:"\(prefix).tieRod",kind:.tieRod,corner:corner), damage:d.tieRodDamage01, deformation:abs(d.permanentToeShiftDeg)*2.5)
            upsert(&state, .init(componentId:"\(prefix).bushing",kind:.bushing,corner:corner), damage:d.bushingDamage01, looseness:d.mountLooseness01*3)
        }
        state.alignment.steeringWheelCenterDeg=state.steeringCenterOffsetDeg
        for c in VehicleCorner.allCases { state.alignment[c].toeDeg=state[c].permanentToeShiftDeg; state.alignment[c].camberDeg=state[c].permanentCamberShiftDeg }
    }
    private static func upsert(_ state:inout PersistentVehicleDamageState,_ seed:ComponentPhysicalCondition,runout:Double=0,damage:Double=0,temp:Double=25,leak:Double=0,deformation:Double=0,looseness:Double=0){ var x=state.componentConditions[seed.componentId] ?? seed;x.runoutMm=max(x.runoutMm,runout);x.damage01=max(x.damage01,damage);x.temperatureC=max(x.temperatureC,temp);x.leakRatePerMinute=max(x.leakRatePerMinute,leak);x.deformationMm=max(x.deformationMm,deformation);x.loosenessMm=max(x.loosenessMm,looseness);state.componentConditions[x.componentId]=x }
}

public enum DiagnosticCause:String,Codable,CaseIterable,Sendable { case wheelRunout,tireLeak,wheelBearing,tieRod,ballJoint,bushing,chassisAlignment,driveshaft,differential,damper }
public struct DiagnosticEvidenceInput:Codable,Hashable,Sendable { public var kind:String,value:Double,unit:String,corner:VehicleCorner?; public init(kind:String,value:Double,unit:String="",corner:VehicleCorner?=nil){self.kind=kind;self.value=value;self.unit=unit;self.corner=corner} }
public struct WeightedDiagnosticHypothesis:Codable,Hashable,Sendable,Identifiable { public var id:String { cause.rawValue }; public var cause:DiagnosticCause; public var probability01:Double; public var supportingEvidence:[String]; public var contradictingEvidence:[String]; public var nextMeasurement:String; public init(cause:DiagnosticCause,probability01:Double,supportingEvidence:[String]=[],contradictingEvidence:[String]=[],nextMeasurement:String=""){self.cause=cause;self.probability01=probability01;self.supportingEvidence=supportingEvidence;self.contradictingEvidence=contradictingEvidence;self.nextMeasurement=nextMeasurement} }
public enum DiagnosticReasoningAuthority {
    public static func hypotheses(symptoms:Set<String>, evidence:[DiagnosticEvidenceInput])->[WeightedDiagnosticHypothesis] {
        var scores=Dictionary(uniqueKeysWithValues:DiagnosticCause.allCases.map{($0,1.0)})
        func boost(_ c:DiagnosticCause,_ x:Double){scores[c,default:1]*=x}
        if symptoms.contains("speed_vibration"){boost(.wheelRunout,3);boost(.wheelBearing,2);boost(.driveshaft,2.2);boost(.differential,1.5)}
        if symptoms.contains("pull"){boost(.tieRod,2.8);boost(.chassisAlignment,2.4);boost(.bushing,1.8);boost(.tireLeak,1.5)}
        if symptoms.contains("steering_off_center"){boost(.tieRod,3.2);boost(.chassisAlignment,2.8)}
        for e in evidence { switch e.kind {
            case "wheel_runout": boost(.wheelRunout,e.value>1.5 ? 5:0.5)
            case "pressure_decay": boost(.tireLeak,e.value>0.5 ? 6:0.4)
            case "bearing_heat": boost(.wheelBearing,e.value>75 ? 5:0.6)
            case "toe_error": boost(.tieRod,abs(e.value)>0.2 ? 3.5:0.6);boost(.chassisAlignment,abs(e.value)>0.2 ? 2:0.8)
            case "bearing_play": boost(.wheelBearing,e.value>0.15 ? 5:0.5);boost(.ballJoint,e.value>0.5 ? 1.5:1)
            case "bushing_deflection": boost(.bushing,e.value>1 ? 5:0.5)
            case "driveshaft_runout": boost(.driveshaft,e.value>0.4 ? 6:0.5)
            case "backlash": boost(.differential,e.value>0.3 ? 5:0.7)
            default: break }
        }
        let total=max(0.0001,scores.values.reduce(0,+))
        return scores.map { pair in WeightedDiagnosticHypothesis(cause:pair.key,probability01:pair.value/total,supportingEvidence:evidence.filter{supports($0,cause:pair.key)}.map{$0.kind},nextMeasurement:next(pair.key)) }.sorted{$0.probability01>$1.probability01}
    }
    private static func supports(_ e:DiagnosticEvidenceInput,cause:DiagnosticCause)->Bool { switch cause {case .wheelRunout:return e.kind=="wheel_runout";case .tireLeak:return e.kind=="pressure_decay";case .wheelBearing:return e.kind=="bearing_heat"||e.kind=="bearing_play";case .tieRod,.chassisAlignment:return e.kind=="toe_error";case .bushing:return e.kind=="bushing_deflection";case .driveshaft:return e.kind=="driveshaft_runout";case .differential:return e.kind=="backlash";default:return false} }
    private static func next(_ c:DiagnosticCause)->String { switch c {case .wheelRunout:return "measure tire, rim, then hub runout with indexed remount";case .tireLeak:return "perform temperature-compensated timed pressure decay and leak localization";case .wheelBearing:return "compare cooled corner play, rotational drag, temperature and vibration";case .tieRod:return "measure individual toe, steering center and loaded tie-rod free play";case .ballJoint:return "perform loaded and unloaded joint-play measurement";case .bushing:return "apply directional load and measure compliance displacement";case .chassisAlignment:return "measure thrust angle, setback and chassis datums";case .driveshaft:return "measure shaft runout, operating angles and vibration order";case .differential:return "measure backlash, ring runout, preload and contact pattern";case .damper:return "measure travel, ride height, leakage and force response"} }
}
