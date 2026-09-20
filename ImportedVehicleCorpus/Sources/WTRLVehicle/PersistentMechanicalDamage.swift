import Foundation

public struct PersistentCornerDamage: Codable, Hashable, Sendable {
    public var permanentToeShiftDeg = 0.0
    public var permanentCamberShiftDeg = 0.0
    public var wheelRunoutMm = 0.0
    public var tirePressureKPa = 220.0
    public var pressureLeakKPaPerMinute = 0.0
    public var wheelBearingDamage01 = 0.0
    public var wheelBearingTempC = 35.0
    public var tieRodDamage01 = 0.0
    public var bushingDamage01 = 0.0
    public var mountLooseness01 = 0.0
    public var lastImpactImpulseNs = 0.0
    public init() {}
}

public struct PersistentVehicleDamageState: Codable, Hashable, Sendable {
    public var frontLeft = PersistentCornerDamage(), frontRight = PersistentCornerDamage(), rearLeft = PersistentCornerDamage(), rearRight = PersistentCornerDamage()
    public var chassisTwistDeg = 0.0
    public var steeringCenterOffsetDeg = 0.0
    public var driveshaftFatigue01 = 0.0
    public var evidenceSequence = 0
    public var componentConditions:[String:ComponentPhysicalCondition]=[:]
    public var alignment=VehicleAlignmentState()
    public var chassisDatums:[String:ChassisDatumState]=[:]
    public init() {}
    enum CodingKeys:String,CodingKey {case frontLeft,frontRight,rearLeft,rearRight,chassisTwistDeg,steeringCenterOffsetDeg,driveshaftFatigue01,evidenceSequence,componentConditions,alignment,chassisDatums}
    public init(from decoder:Decoder)throws { let c=try decoder.container(keyedBy:CodingKeys.self);frontLeft=try c.decodeIfPresent(PersistentCornerDamage.self,forKey:.frontLeft) ?? .init();frontRight=try c.decodeIfPresent(PersistentCornerDamage.self,forKey:.frontRight) ?? .init();rearLeft=try c.decodeIfPresent(PersistentCornerDamage.self,forKey:.rearLeft) ?? .init();rearRight=try c.decodeIfPresent(PersistentCornerDamage.self,forKey:.rearRight) ?? .init();chassisTwistDeg=try c.decodeIfPresent(Double.self,forKey:.chassisTwistDeg) ?? 0;steeringCenterOffsetDeg=try c.decodeIfPresent(Double.self,forKey:.steeringCenterOffsetDeg) ?? 0;driveshaftFatigue01=try c.decodeIfPresent(Double.self,forKey:.driveshaftFatigue01) ?? 0;evidenceSequence=try c.decodeIfPresent(Int.self,forKey:.evidenceSequence) ?? 0;componentConditions=try c.decodeIfPresent([String:ComponentPhysicalCondition].self,forKey:.componentConditions) ?? [:];alignment=try c.decodeIfPresent(VehicleAlignmentState.self,forKey:.alignment) ?? .init();chassisDatums=try c.decodeIfPresent([String:ChassisDatumState].self,forKey:.chassisDatums) ?? [:] }
    public subscript(_ corner: VehicleCorner) -> PersistentCornerDamage {
        get { switch corner { case .frontLeft:return frontLeft; case .frontRight:return frontRight; case .rearLeft:return rearLeft; case .rearRight:return rearRight } }
        set { switch corner { case .frontLeft:frontLeft=newValue; case .frontRight:frontRight=newValue; case .rearLeft:rearLeft=newValue; case .rearRight:rearRight=newValue } }
    }
}

public struct MechanicalDamageEvidence: Codable, Hashable, Sendable, Identifiable {
    public var id: String
    public var corner: VehicleCorner?
    public var kind: String
    public var severity01: Double
    public var measurement: String
    public init(id:String=UUID().uuidString,corner:VehicleCorner?=nil,kind:String,severity01:Double,measurement:String){self.id=id;self.corner=corner;self.kind=kind;self.severity01=max(0,min(1,severity01));self.measurement=measurement}
}

public enum PersistentMechanicalDamageAuthority {
    public static func applyImpact(state: inout PersistentVehicleDamageState, corner: VehicleCorner, damage: PursuitImpactDamage) -> [MechanicalDamageEvidence] {
        var c=state[corner]
        c.permanentToeShiftDeg += damage.toeShiftDeg * ((corner == .frontLeft || corner == .rearLeft) ? 1 : -1)
        c.wheelRunoutMm=max(c.wheelRunoutMm,damage.wheelRunoutMm)
        c.pressureLeakKPaPerMinute=max(c.pressureLeakKPaPerMinute,damage.pressureLeakSeverity01*42)
        c.wheelBearingDamage01=min(1,c.wheelBearingDamage01+damage.bearingDamage01)
        c.tieRodDamage01=min(1,c.tieRodDamage01+damage.tieRodDamage01)
        c.bushingDamage01=min(1,c.bushingDamage01+damage.tieRodDamage01*0.35)
        c.lastImpactImpulseNs=max(c.lastImpactImpulseNs,2500+damage.wheelRunoutMm/7*12000)
        state[corner]=c
        if corner == .frontLeft || corner == .frontRight { state.steeringCenterOffsetDeg += c.permanentToeShiftDeg*0.18 }
        state.evidenceSequence += 1
        PhysicalTruthBridgeAuthority.synchronizeLegacyDamage(&state)
        var e:[MechanicalDamageEvidence]=[]
        if abs(c.permanentToeShiftDeg)>0.12 { e.append(.init(corner:corner,kind:"alignment_shift",severity01:min(1,abs(c.permanentToeShiftDeg)/2),measurement:String(format:"toe offset %.2f deg",c.permanentToeShiftDeg))) }
        if c.wheelRunoutMm>1 { e.append(.init(corner:corner,kind:"wheel_runout",severity01:min(1,c.wheelRunoutMm/8),measurement:String(format:"runout %.1f mm",c.wheelRunoutMm))) }
        if c.pressureLeakKPaPerMinute>1 { e.append(.init(corner:corner,kind:"pressure_leak",severity01:min(1,c.pressureLeakKPaPerMinute/35),measurement:String(format:"leak %.1f kPa/min",c.pressureLeakKPaPerMinute))) }
        return e
    }

    public static func step(state: inout PersistentVehicleDamageState, speedMps: Double, lateralG: Double, ambientC: Double, dt: Double) {
        let h=max(0,min(dt,1))
        for corner in VehicleCorner.allCases {
            var c=state[corner]
            c.tirePressureKPa=max(35,c.tirePressureKPa-c.pressureLeakKPaPerMinute/60*h)
            let bearingPower=(c.wheelBearingDamage01*1200 + c.wheelRunoutMm*35)*abs(speedMps)
            c.wheelBearingTempC += (bearingPower/18000-(c.wheelBearingTempC-ambientC)*0.012)*h
            let cyclic=max(0,abs(lateralG)-0.35)*abs(speedMps)/45
            c.mountLooseness01=min(1,c.mountLooseness01+cyclic*(c.bushingDamage01+c.tieRodDamage01)*h/900)
            state[corner]=c
        }
    }

    public static func adjustedAlignment(base:(camberDeg:Double,toeDeg:Double), damage:PersistentCornerDamage)->(camberDeg:Double,toeDeg:Double){
        (base.camberDeg+damage.permanentCamberShiftDeg,base.toeDeg+damage.permanentToeShiftDeg)
    }

    public static func pressureGripScale(_ damage:PersistentCornerDamage, nominalKPa:Double=220)->Double {
        let r=max(0.15,min(1.25,damage.tirePressureKPa/max(1,nominalKPa)))
        return max(0.28,min(1,1-abs(1-r)*0.82-damage.wheelRunoutMm*0.018))
    }
}

public enum MechanicalDamageInspectionAuthority {
    public static func inspect(_ state:PersistentVehicleDamageState)->[MechanicalDamageEvidence]{
        var out:[MechanicalDamageEvidence]=[]
        for c in VehicleCorner.allCases { let d=state[c]
            if abs(d.permanentToeShiftDeg)>0.1 {out.append(.init(corner:c,kind:"alignment_rack",severity01:min(1,abs(d.permanentToeShiftDeg)/2),measurement:String(format:"toe %.2f deg",d.permanentToeShiftDeg)))}
            if d.wheelRunoutMm>0.8 {out.append(.init(corner:c,kind:"dial_indicator",severity01:min(1,d.wheelRunoutMm/8),measurement:String(format:"wheel runout %.1f mm",d.wheelRunoutMm)))}
            if d.wheelBearingTempC>75 {out.append(.init(corner:c,kind:"bearing_heat",severity01:min(1,(d.wheelBearingTempC-60)/80),measurement:String(format:"bearing %.0f C",d.wheelBearingTempC)))}
            if d.pressureLeakKPaPerMinute>0.5 {out.append(.init(corner:c,kind:"pressure_decay",severity01:min(1,d.pressureLeakKPaPerMinute/35),measurement:String(format:"pressure loss %.1f kPa/min",d.pressureLeakKPaPerMinute)))}
        }
        return out
    }
}
