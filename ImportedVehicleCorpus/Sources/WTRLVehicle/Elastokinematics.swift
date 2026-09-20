import Foundation

public struct ElastokinematicCornerSpec: Codable, Hashable, Sendable {
    public var staticCamberDeg = -0.8, staticToeDeg = 0.05, camberGainDegPerM = -8.0, bumpSteerDegPerM = 2.6
    public var complianceToeDegPerKN = 0.015, scrubRadiusM = 0.015, casterDeg = 5.0, kingpinInclinationDeg = 8.0
    public var antiDive01 = 0.15, antiSquat01 = 0.25
    public init(){}
}
public struct ElastokinematicCornerOutput: Codable, Hashable, Sendable { public var camberDeg=0.0,toeDeg=0.0,scrubMomentNm=0.0,pitchForceScale=1.0; public init(){} }
public enum ElastokinematicAuthority {
    public static func resolve(spec:ElastokinematicCornerSpec,jounceM:Double,lateralForceN:Double,longitudinalForceN:Double)->ElastokinematicCornerOutput { var o=ElastokinematicCornerOutput();o.camberDeg=spec.staticCamberDeg+jounceM*spec.camberGainDegPerM;o.toeDeg=spec.staticToeDeg+jounceM*spec.bumpSteerDegPerM+(lateralForceN/1000)*spec.complianceToeDegPerKN;o.scrubMomentNm=lateralForceN*spec.scrubRadiusM;o.pitchForceScale=1-max(-0.5,min(0.5,(longitudinalForceN>=0 ? spec.antiSquat01:spec.antiDive01)));return o }
}
public struct CornerScaleWeights: Codable, Hashable, Sendable { public var flKg:Double,frKg:Double,rlKg:Double,rrKg:Double; public var totalKg:Double{flKg+frKg+rlKg+rrKg}; public var crossWeight01:Double{totalKg>0 ? (flKg+rrKg)/totalKg:0}; public var frontBias01:Double{totalKg>0 ? (flKg+frKg)/totalKg:0} }
public enum CornerWeightAuthority {
    public static func resolve(base:CornerScaleWeights,perchAdjustMM:(Double,Double,Double,Double),springRateNPerMM:Double)->CornerScaleWeights {
        // Setup approximation preserving total vehicle mass: a perch load is reacted diagonally through the chassis.
        let k=springRateNPerMM/9.80665; let a=[perchAdjustMM.0*k,perchAdjustMM.1*k,perchAdjustMM.2*k,perchAdjustMM.3*k]
        let d0=(a[0]-a[1]-a[2]+a[3])*0.25, d1=(-a[0]+a[1]+a[2]-a[3])*0.25
        return .init(flKg:max(1,base.flKg+d0),frKg:max(1,base.frKg+d1),rlKg:max(1,base.rlKg+d1),rrKg:max(1,base.rrKg+d0))
    }
}
