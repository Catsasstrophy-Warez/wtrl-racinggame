import Foundation
import WTRLCore

public struct EmpiricalTireCoefficients: Codable, Hashable, Sendable {
    public var referenceLoadN=4000.0, referencePressureKpa=220.0, optimalTemperatureC=82.0, temperatureWindowC=38.0, peakMu=1.18, loadSensitivity=0.12
    public var longitudinalB=11.0, longitudinalC=1.62, longitudinalE=0.25, lateralB=8.5, lateralC=1.38, lateralE = -0.15
    public var camberThrustPerDeg=0.012, pressureSensitivity=0.22, wearGripLoss=0.38, wetGripLoss=0.48, treadWaterResistance=0.55, treadDepthMm=7.5, waterDepthAtFull01Mm=8.0, hydroplaningPressureScale=1.0
    public var rollingResistanceCoefficient=0.012, pneumaticTrailM=0.045, aligningTorqueScale=1.0, verticalStiffnessNPerM=210000.0, longitudinalRelaxationLengthM=0.35, lateralRelaxationLengthM=0.28
    public var calibrationSource="engineering-derived"; public var calibrationConfidence01=0.68
    public init() {}
}
public struct EmpiricalTireInput: Sendable { public var coefficients=EmpiricalTireCoefficients(); public var normalLoadN=4000.0, speedMps=0.0, slipRatio=0.0, slipAngleDeg=0.0, camberDeg=0.0, pressureKpa=220.0, temperatureC=82.0, wear01=0.0, surfaceGrip01=1.0, water01=0.0, previousLongitudinalN=0.0, previousLateralN=0.0, deltaTime=0.02; public init() {} }
public struct EmpiricalTireResult: Sendable { public var longitudinalN=0.0,lateralN=0.0,peakLongitudinalN=0.0,peakLateralN=0.0,effectiveMu=0.0,loadFactor01=0.0,temperatureFactor01=0.0,pressureFactor01=0.0,wearFactor01=0.0,wetFactor01=0.0,aquaplaningRisk01=0.0,hydroplaningOnsetKph=0.0,rollingResistanceN=0.0,aligningMomentNm=0.0,verticalDeflectionM=0.0,utilization01=0.0 }
public enum EmpiricalTireModel {
    static func magic(_ x:Double,_ b:Double,_ c:Double,_ e:Double)->Double { let bx=b*x; return sin(c*atan(bx-e*(bx-atan(bx)))) }
    public static func hydroplaningOnsetKph(pressureKpa:Double, pressureScale:Double=1)->Double { let psi=max(1,pressureKpa)*0.1450377; return 9*sqrt(psi)*1.852*max(0.6,pressureScale) }
    public static func evaluate(_ i:EmpiricalTireInput)->EmpiricalTireResult {
        let c=i.coefficients, fz=max(25,i.normalLoadN), loadRatio=fz/max(100,c.referenceLoadN), loadMu=pow(max(0.2,loadRatio),-max(0,c.loadSensitivity))
        let temp=exp(-pow((i.temperatureC-c.optimalTemperatureC)/max(5,c.temperatureWindowC),2)); let pressureError=abs(i.pressureKpa-c.referencePressureKpa)/max(50,c.referencePressureKpa)
        let pressure=WTRLMath.clamp01(1-pressureError*c.pressureSensitivity*2), wear=WTRLMath.lerp(1,1-c.wearGripLoss,WTRLMath.clamp01(i.wear01))
        let tread=max(0.4,c.treadDepthMm*(1-WTRLMath.clamp01(i.wear01)*0.88)), waterDepth=max(0,i.water01)*max(1,c.waterDepthAtFull01Mm), displaced=max(0,waterDepth-tread*WTRLMath.clamp(c.treadWaterResistance,0.15,1.25))
        let onset=hydroplaningOnsetKph(pressureKpa:i.pressureKpa,pressureScale:c.hydroplaningPressureScale), speed=abs(i.speedMps)*3.6, severity=WTRLMath.clamp01(displaced/max(1,c.waterDepthAtFull01Mm*0.65)), aqua=WTRLMath.clamp01(severity*WTRLMath.inverseLerp(onset*0.72,onset*1.12,speed))
        let wet=WTRLMath.clamp01(1-WTRLMath.clamp01(i.water01)*c.wetGripLoss*(0.35+0.65*aqua)); let mu=max(0.05,c.peakMu*loadMu*temp*pressure*wear*wet*WTRLMath.clamp(i.surfaceGrip01,0.2,1.6))
        let peak=fz*mu, fxDemand=magic(i.slipRatio,c.longitudinalB,c.longitudinalC,c.longitudinalE), angle=i.slipAngleDeg*Double.pi/180, fyDemand=magic(tan(angle),c.lateralB,c.lateralC,c.lateralE)+i.camberDeg*c.camberThrustPerDeg
        var fx=fxDemand*peak, fy=fyDemand*peak; let util=sqrt(pow(fx/peak,2)+pow(fy/peak,2)); if util>1 { fx/=util; fy/=util }
        let rr=fz*c.rollingResistanceCoefficient, align = -fy*c.pneumaticTrailM*c.aligningTorqueScale
        return .init(longitudinalN:fx,lateralN:fy,peakLongitudinalN:peak,peakLateralN:peak,effectiveMu:mu,loadFactor01:loadMu,temperatureFactor01:temp,pressureFactor01:pressure,wearFactor01:wear,wetFactor01:wet,aquaplaningRisk01:aqua,hydroplaningOnsetKph:onset,rollingResistanceN:rr,aligningMomentNm:align,verticalDeflectionM:fz/max(1000,c.verticalStiffnessNPerM),utilization01:min(1,util))
    }
}
