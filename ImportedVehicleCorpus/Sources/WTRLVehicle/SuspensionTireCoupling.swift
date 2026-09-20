import Foundation

public struct SuspensionAlignmentCurve: Codable, Hashable, Sendable {
    public var staticCamberDeg = -0.7
    public var camberGainDegPerM = -14.0
    public var staticToeDeg = 0.05
    public var toeGainDegPerM = 1.5
    public init() {}
}

public struct BodyAttitudeState: Codable, Hashable, Sendable {
    public var heaveM = 0.0
    public var rollRad = 0.0
    public var pitchRad = 0.0
    public var rollRateRadPerSec = 0.0
    public var pitchRateRadPerSec = 0.0
    public init() {}
}

public enum SuspensionTireCouplingAuthority {
    public static func dynamicLoads(suspension: FourCornerSuspensionState, quasiStatic: FourCornerLoads) -> FourCornerLoads {
        var out = quasiStatic
        for c in VehicleCorner.allCases {
            // The tire spring is the instantaneous road-to-wheel reaction. Preserve quasi-static gravity/load-transfer
            // as a floor while allowing bumps, curb strikes and wheel unloading to alter Fz every substep.
            let verticalReaction = max(0, suspension[c].tireForceN)
            let blended = max(25, quasiStatic[c] + verticalReaction * 0.55)
            out[c] = blended
        }
        return out
    }

    public static func alignment(corner: VehicleCorner, suspension: FourCornerSuspensionState, front: SuspensionAlignmentCurve, rear: SuspensionAlignmentCurve) -> (camberDeg: Double, toeDeg: Double) {
        let s = suspension[corner]
        let travel = s.sprungPositionM - s.unsprungPositionM
        let p = (corner == .frontLeft || corner == .frontRight) ? front : rear
        let side = (corner == .frontLeft || corner == .rearLeft) ? 1.0 : -1.0
        return (p.staticCamberDeg + p.camberGainDegPerM * travel,
                side * (p.staticToeDeg + p.toeGainDegPerM * travel))
    }

    public static func attitude(suspension s: FourCornerSuspensionState, geometry g: VehicleGeometry) -> BodyAttitudeState {
        let front = 0.5 * (s.frontLeft.sprungPositionM + s.frontRight.sprungPositionM)
        let rear = 0.5 * (s.rearLeft.sprungPositionM + s.rearRight.sprungPositionM)
        let left = 0.5 * (s.frontLeft.sprungPositionM + s.rearLeft.sprungPositionM)
        let right = 0.5 * (s.frontRight.sprungPositionM + s.rearRight.sprungPositionM)
        var a = BodyAttitudeState()
        a.heaveM = 0.25 * (s.frontLeft.sprungPositionM+s.frontRight.sprungPositionM+s.rearLeft.sprungPositionM+s.rearRight.sprungPositionM)
        a.pitchRad = atan2(front-rear, max(0.1,g.wheelbaseM))
        a.rollRad = atan2(right-left, max(0.1,0.5*(g.frontTrackM+g.rearTrackM)))
        return a
    }
}

public struct LimitedSlipParameters: Codable, Hashable, Sendable {
    public var preloadNm = 80.0
    public var powerLock01 = 0.55
    public var coastLock01 = 0.25
    public var maxBiasRatio = 3.0
    public init() {}
}
public struct AxleTorqueSplit: Codable, Hashable, Sendable { public var leftNm=0.0,rightNm=0.0; public init(){}; public init(leftNm:Double,rightNm:Double){self.leftNm=leftNm;self.rightNm=rightNm} }
public enum LimitedSlipDifferentialAuthority {
    public static func split(inputTorqueNm: Double, leftOmega: Double, rightOmega: Double, p: LimitedSlipParameters) -> AxleTorqueSplit {
        let total = inputTorqueNm
        let lock = total >= 0 ? p.powerLock01 : p.coastLock01
        let delta = rightOmega-leftOmega
        let correction = max(-abs(total)*0.5, min(abs(total)*0.5, delta * p.preloadNm * lock))
        var left = total*0.5 + correction, right = total*0.5 - correction
        let hi=max(abs(left),abs(right)), lo=max(1,min(abs(left),abs(right)))
        if hi/lo > max(1,p.maxBiasRatio) {
            let favoredLeft=abs(left)>abs(right), magnitude=abs(total), low=magnitude/(1+p.maxBiasRatio), high=magnitude-low
            left=(favoredLeft ? high:low)*(total >= 0 ? 1:-1); right=(favoredLeft ? low:high)*(total >= 0 ? 1:-1)
        }
        return .init(leftNm:left,rightNm:right)
    }
}

public struct DamperThermalState: Codable, Hashable, Sendable { public var temperatureC=35.0, fade01=0.0; public init(){} }
public enum DamperThermalAuthority {
    public static func step(state: inout DamperThermalState, damperForceN: Double, shaftVelocityMps: Double, ambientC: Double, dt: Double) {
        let powerW=abs(damperForceN*shaftVelocityMps)
        state.temperatureC += (powerW/18_000 - (state.temperatureC-ambientC)*0.018)*dt
        state.fade01=max(0,min(0.45,(state.temperatureC-105)/120))
    }
}

public struct WheelHopSpectralObserver: Codable, Hashable, Sendable {
    public var samples:[Double]=[]
    public var sampleRateHz=120.0
    public init(){}
    public mutating func append(_ value:Double, maximum:Int=256){samples.append(value);if samples.count>maximum{samples.removeFirst(samples.count-maximum)}}
    public func dominantFrequencyHz(minHz:Double=6,maxHz:Double=25)->Double {
        guard samples.count>=32 else{return 0}
        let n=samples.count,mean=samples.reduce(0,+)/Double(n);var bestF=0.0,bestP=0.0
        for k in 1..<(n/2){let f=Double(k)*sampleRateHz/Double(n);if f<minHz||f>maxHz{continue};var re=0.0,im=0.0;for j in 0..<n{let a=2*Double.pi*Double(k*j)/Double(n),v=samples[j]-mean;re += v*cos(a);im -= v*sin(a)};let p=re*re+im*im;if p>bestP{bestP=p;bestF=f}}
        return bestF
    }
}
