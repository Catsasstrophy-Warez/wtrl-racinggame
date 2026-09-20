import Foundation

public struct CylinderCombustionProfile: Codable, Hashable, Sendable {
    public var boreM: Double = 0.1016, strokeM: Double = 0.0729, rodLengthM: Double = 0.1308
    public var compressionRatio: Double = 10.5, cylinderCount: Int = 8
    public var lowerHeatingValueJPerKg: Double = 44.0e6
    public var wiebeA: Double = 5.0, wiebeM: Double = 2.0
    public init() {}
}
public struct CombustionCycleInput: Codable, Hashable, Sendable {
    public var rpm: Double = 3500, manifoldPressureKPa: Double = 96, intakeAirC: Double = 25
    public var afr: Double = 12.8, sparkAdvanceBTDC: Double = 24, burnDurationDeg: Double = 48
    public var volumetricEfficiency01: Double = 0.82
    public init() {}
}
public struct CombustionCycleOutput: Codable, Hashable, Sendable {
    public var indicatedTorqueNm: Double, imepKPa: Double, peakPressureKPa: Double, peakPressureAngleATDCDeg: Double
    public var knockRisk01: Double, knockAcousticLevelDbRelative: Double, egtC: Double
}
public enum CombustionCycleAuthority {
    static func clamp(_ x: Double,_ lo: Double,_ hi: Double)->Double { min(max(x,lo),hi) }
    public static func burnedFraction(crankDegATDC: Double, sparkAdvanceBTDC: Double, burnDurationDeg: Double, a: Double=5, m: Double=2)->Double {
        let progress=(crankDegATDC+sparkAdvanceBTDC)/max(1,burnDurationDeg); guard progress>0 else{return 0}; return clamp(1-exp(-a*pow(progress,m+1)),0,1)
    }
    public static func evaluate(profile: CylinderCombustionProfile = .init(), input: CombustionCycleInput)->CombustionCycleOutput {
        let vd=Double.pi*0.25*profile.boreM*profile.boreM*profile.strokeM, vc=vd/max(1,profile.compressionRatio-1)
        let tK=max(220,input.intakeAirC+273.15), rho=max(0.2,input.manifoldPressureKPa*1000/(287.05*tK))
        let air=vd*rho*clamp(input.volumetricEfficiency01,0.2,1.3), fuel=air/max(8,input.afr)
        let chemical=fuel*profile.lowerHeatingValueJPerKg
        let gamma=1.32, idealEff=1-pow(profile.compressionRatio,1-gamma)
        var weightedWork=0.0, peakP=0.0, peakAngle=0.0
        let baseTDC=input.manifoldPressureKPa*pow(profile.compressionRatio,gamma)
        for angle in stride(from:-40.0,through:80.0,by:1.0) {
            let xb=burnedFraction(crankDegATDC:angle,sparkAdvanceBTDC:input.sparkAdvanceBTDC,burnDurationDeg:input.burnDurationDeg,a:profile.wiebeA,m:profile.wiebeM)
            let timingLeverage=max(0.2,cos((angle-14)*Double.pi/180))
            weightedWork=max(weightedWork, chemical*idealEff*timingLeverage*0.78)
            let expansion=max(0.25,1+angle/90), p=(baseTDC + xb*chemical/max(vc*30,1))*pow(expansion,-gamma)
            if p>peakP { peakP=p; peakAngle=angle }
        }
        let totalDisp=vd*Double(profile.cylinderCount), imep=max(0,weightedWork*Double(profile.cylinderCount)/max(totalDisp,1e-6))
        let torque=imep*totalDisp/(4*Double.pi)
        let pressureRisk=clamp((peakP-7000)/5000,0,1), leanRisk=clamp((input.afr-13.0)/2.0,0,1), advanceRisk=clamp((input.sparkAdvanceBTDC-30)/12,0,1)
        let knock=clamp(0.5*pressureRisk+0.3*leanRisk+0.4*advanceRisk,0,1)
        let egt=clamp(720 + (14.0-input.afr)*18 + max(0,24-input.sparkAdvanceBTDC)*8,520,1050)
        return .init(indicatedTorqueNm:torque,imepKPa:imep,peakPressureKPa:peakP,peakPressureAngleATDCDeg:peakAngle,knockRisk01:knock,knockAcousticLevelDbRelative: knock > 0.05 ? 70+35*knock : 0,egtC:egt)
    }
}
