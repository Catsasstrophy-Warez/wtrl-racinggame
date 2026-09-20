import Foundation

public struct DrivelineElasticityParameters: Codable, Hashable, Sendable {
    public var shaftStiffnessNmPerRad = 14_500.0
    public var shaftDampingNmSecPerRad = 120.0
    public var maximumElasticTorqueNm = 2_400.0
    public var failureTwistRad = 0.22
    public init() {}
}
public struct DrivelineElasticityState: Codable, Hashable, Sendable {
    public var relativeTwistRad = 0.0
    public var transmittedTorqueNm = 0.0
    public var overload01 = 0.0
    public var failed = false
    public init() {}
}
public enum DrivelineElasticityAuthority {
    public static func step(state:inout DrivelineElasticityState, gearboxOmegaRadPerSec:Double, pinionOmegaRadPerSec:Double, dt:Double, parameters p:DrivelineElasticityParameters = .init()) {
        guard !state.failed else { state.transmittedTorqueNm=0; return }
        let h=max(dt,0)
        let relativeOmega=gearboxOmegaRadPerSec-pinionOmegaRadPerSec
        state.relativeTwistRad += relativeOmega*h
        let raw=p.shaftStiffnessNmPerRad*state.relativeTwistRad+p.shaftDampingNmSecPerRad*relativeOmega
        state.transmittedTorqueNm=max(-p.maximumElasticTorqueNm,min(p.maximumElasticTorqueNm,raw))
        state.overload01=min(1,abs(raw)/max(p.maximumElasticTorqueNm,1))
        if abs(state.relativeTwistRad)>=p.failureTwistRad { state.failed=true; state.transmittedTorqueNm=0 }
    }
}

/// Axle hop is a coupled tire/suspension/driveline oscillation, so this detector consumes a measured
/// wheel-load/slip signal rather than declaring hop from one instantaneous shaft-speed difference.
public struct OscillationWindow: Codable, Hashable, Sendable {
    public var previousSignal = 0.0
    public var lastCrossingTime: Double?
    public var crossingIntervals: [Double] = []
    public init() {}
}
public enum AxleHopDetector {
    public static func observe(signal:Double,time:Double,window:inout OscillationWindow)->Double? {
        let crossed=(signal >= 0 && window.previousSignal < 0)||(signal < 0 && window.previousSignal >= 0)
        defer { window.previousSignal=signal }
        guard crossed else{return nil}
        if let last=window.lastCrossingTime {
            let halfPeriod=time-last
            if halfPeriod>0 {
                window.crossingIntervals.append(halfPeriod)
                if window.crossingIntervals.count>8 { window.crossingIntervals.removeFirst() }
            }
        }
        window.lastCrossingTime=time
        guard window.crossingIntervals.count>=4 else{return nil}
        let avg=window.crossingIntervals.reduce(0,+)/Double(window.crossingIntervals.count)
        return 1/(2*avg)
    }
}
