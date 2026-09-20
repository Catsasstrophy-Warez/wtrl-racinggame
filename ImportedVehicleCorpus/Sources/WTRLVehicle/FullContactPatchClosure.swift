import Foundation

public struct RoadContactPatchSample: Codable, Hashable, Sendable {
    public var heightM: Double, verticalVelocityMps: Double, frictionScale01: Double
    public init(heightM: Double = 0, verticalVelocityMps: Double = 0, frictionScale01: Double = 1) { self.heightM=heightM; self.verticalVelocityMps=verticalVelocityMps; self.frictionScale01=frictionScale01 }
}
public struct FourCornerRoadProfile: Codable, Hashable, Sendable {
    public var frontLeft=RoadContactPatchSample(), frontRight=RoadContactPatchSample(), rearLeft=RoadContactPatchSample(), rearRight=RoadContactPatchSample()
    public init() {}
    public subscript(_ c: VehicleCorner) -> RoadContactPatchSample { get { switch c {case .frontLeft:return frontLeft;case .frontRight:return frontRight;case .rearLeft:return rearLeft;case .rearRight:return rearRight} } set { switch c {case .frontLeft:frontLeft=newValue;case .frontRight:frontRight=newValue;case .rearLeft:rearLeft=newValue;case .rearRight:rearRight=newValue} } }
}
public struct ChassisRigidBodyState: Codable, Hashable, Sendable { public var heaveM=0.0,heaveVelocityMps=0.0,rollRad=0.0,rollRateRadS=0.0,pitchRad=0.0,pitchRateRadS=0.0; public init(){} }
public struct ChassisRigidBodyParameters: Codable, Hashable, Sendable { public var massKg=1480.0,rollInertiaKgM2=620.0,pitchInertiaKgM2=2050.0,heaveDampingNsM=2200.0,rollDampingNmsRad=2600.0,pitchDampingNmsRad=3300.0; public init(){} }
public enum FullContactPatchClosureAuthority {
    public static func step(body: inout ChassisRigidBodyState, suspension: FourCornerSuspensionState, road: FourCornerRoadProfile, geometry: VehicleGeometry, parameters p: ChassisRigidBodyParameters = .init(), dt: Double) {
        let fl=max(0,suspension.frontLeft.tireForceN), fr=max(0,suspension.frontRight.tireForceN), rl=max(0,suspension.rearLeft.tireForceN), rr=max(0,suspension.rearRight.tireForceN)
        let total=fl+fr+rl+rr, g=9.80665
        let heaveA=(total-p.massKg*g-p.heaveDampingNsM*body.heaveVelocityMps)/max(1,p.massKg)
        let rollMoment=((fr+rr)-(fl+rl))*0.25*(geometry.frontTrackM+geometry.rearTrackM)-p.rollDampingNmsRad*body.rollRateRadS
        let pitchMoment=((rl+rr)-(fl+fr))*0.5*geometry.wheelbaseM-p.pitchDampingNmsRad*body.pitchRateRadS
        body.heaveVelocityMps += heaveA*dt; body.heaveM += body.heaveVelocityMps*dt
        body.rollRateRadS += rollMoment/max(1,p.rollInertiaKgM2)*dt; body.rollRad += body.rollRateRadS*dt
        body.pitchRateRadS += pitchMoment/max(1,p.pitchInertiaKgM2)*dt; body.pitchRad += body.pitchRateRadS*dt
    }
}

public enum DifferentialType: String, Codable, Sendable { case open, clutchLSD, helical, spool }
public struct DifferentialModelParameters: Codable, Hashable, Sendable { public var type:DifferentialType = .clutchLSD; public var preloadNm=75.0,powerLock01=0.55,coastLock01=0.22,biasRatio=2.8; public init(){} }
public enum DifferentialModelAuthority {
    public static func split(inputTorqueNm:Double,leftOmega:Double,rightOmega:Double,leftLoadN:Double,rightLoadN:Double,p:DifferentialModelParameters)->AxleTorqueSplit {
        switch p.type {
        case .open:
            let weak=max(0.05,min(1,min(leftLoadN,rightLoadN)/max(1,max(leftLoadN,rightLoadN)))); return .init(leftNm:inputTorqueNm*0.5*weak,rightNm:inputTorqueNm*0.5*weak)
        case .spool: return .init(leftNm:inputTorqueNm*0.5,rightNm:inputTorqueNm*0.5)
        case .clutchLSD,.helical:
            var lp=LimitedSlipParameters(); lp.preloadNm=p.preloadNm;lp.powerLock01=p.powerLock01;lp.coastLock01=p.coastLock01;lp.maxBiasRatio=p.biasRatio
            return LimitedSlipDifferentialAuthority.split(inputTorqueNm: inputTorqueNm, leftOmega: leftOmega, rightOmega: rightOmega, p: lp)
        }
    }
}

public struct PursuitImpactDamage: Codable, Hashable, Sendable { public var toeShiftDeg=0.0,wheelRunoutMm=0.0,pressureLeakSeverity01=0.0,bearingDamage01=0.0,tieRodDamage01=0.0; public init(){} }
public enum PursuitImpactDamageAuthority {
    public static func resolve(impulseNs:Double,contactLateral01:Double,wheelContact:Bool)->PursuitImpactDamage { var d=PursuitImpactDamage(); let e=max(0,impulseNs-2500)/12000; d.toeShiftDeg=min(2.5,e*1.4*abs(contactLateral01));d.wheelRunoutMm=wheelContact ? min(12,e*7):0;d.pressureLeakSeverity01=wheelContact ? min(1,max(0,e-0.12)*1.1):0;d.bearingDamage01=wheelContact ? min(1,e*0.35):0;d.tieRodDamage01=min(1,e*abs(contactLateral01)*0.6);return d }
}
