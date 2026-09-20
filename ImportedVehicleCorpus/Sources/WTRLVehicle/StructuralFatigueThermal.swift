import Foundation

public struct ChassisStructureSpec: Codable, Hashable, Sendable { public var torsionalStiffnessNmPerDeg=8000.0, fatigueReferenceTwistDeg=0.45, fatigueExponent=3.2, permanentSetThresholdDeg=0.75, camberCoupling=0.30, toeCoupling=0.10; public init(){} }
public struct ChassisStructureState: Codable, Hashable, Sendable { public var fatigueDamage01=0.0, permanentTwistDeg=0.0, peakTwistDeg=0.0; public init(){} }
public struct ChassisFlexResult: Codable, Hashable, Sendable { public var twistDeg=0.0, frontCamberDistortionDeg=0.0, rearToeDistortionDeg=0.0, effectiveStiffnessNmPerDeg=0.0; public init(){} }
public enum StructuralFatigueAuthority {
    public static func step(state:inout ChassisStructureState,spec:ChassisStructureSpec,drivelineReactionNm:Double,lateralLoadTransferTorqueNm:Double,dt:Double)->ChassisFlexResult {
        let stiffness=spec.torsionalStiffnessNmPerDeg*max(0.55,1-0.35*state.fatigueDamage01); let twist=(drivelineReactionNm+lateralLoadTransferTorqueNm)/max(100,stiffness)+state.permanentTwistDeg
        state.peakTwistDeg=max(state.peakTwistDeg,abs(twist)); let severity=max(0,abs(twist)/max(0.05,spec.fatigueReferenceTwistDeg)-1); state.fatigueDamage01=min(1,state.fatigueDamage01+pow(severity,spec.fatigueExponent)*dt/18000)
        if abs(twist)>spec.permanentSetThresholdDeg { state.permanentTwistDeg += (twist.sign == .minus ? -1:1)*min(0.00002,abs(twist)*0.000002)*dt }
        var o=ChassisFlexResult();o.twistDeg=twist;o.frontCamberDistortionDeg=twist*spec.camberCoupling;o.rearToeDistortionDeg=twist*spec.toeCoupling;o.effectiveStiffnessNmPerDeg=stiffness;return o
    }
}
public struct CoolingThermalState: Codable, Hashable, Sendable { public var coolantC=88.0, radiatorC=75.0, heatSoak01=0.0; public init(){} }
public enum CoolingThermalAuthority { public static func step(state:inout CoolingThermalState,engineWasteHeatKW:Double,airSpeedMps:Double,ambientC:Double,radiatorCapacityKWPerC:Double,dt:Double){ let rejection=max(0,(state.radiatorC-ambientC))*radiatorCapacityKWPerC*(0.35+min(1.8,airSpeedMps/18));state.coolantC += (engineWasteHeatKW-rejection)*dt/18;state.radiatorC += ((state.coolantC-state.radiatorC)*0.08-rejection*0.006)*dt;state.heatSoak01=max(0,min(1,(state.coolantC-95)/35)) } }
public struct HubBearingState: Codable, Hashable, Sendable { public var damage01=0.0,temperatureC=35.0; public init(){} }
public enum HubBearingAuthority { public static func step(state:inout HubBearingState,radialLoadN:Double,lateralLoadN:Double,misalignmentDeg:Double,dt:Double){let equivalent=sqrt(radialLoadN*radialLoadN+1.7*lateralLoadN*lateralLoadN)*(1+abs(misalignmentDeg)*0.18);state.damage01=min(1,state.damage01+pow(max(0,equivalent/7000),3)*dt/1_500_000);state.temperatureC += (equivalent/9000-(state.temperatureC-30)*0.025)*dt} }
