import Foundation

public struct CornerSuspensionParameters: Codable, Hashable, Sendable {
    public var sprungMassKg=300.0, unsprungMassKg=42.0, springRateNPerM=55_000.0, damperBumpNsPerM=3_500.0, damperReboundNsPerM=5_200.0
    public var tireVerticalRateNPerM=210_000.0, bumpStopStartM=0.075, bumpStopRateNPerM=280_000.0, droopLimitM=0.09
    public var motionRatio=1.0, antiRollContributionNPerRad=0.0
    public init(){}
}
public struct CornerSuspensionState: Codable, Hashable, Sendable {
    public var sprungPositionM=0.0, sprungVelocityMps=0.0, unsprungPositionM=0.0, unsprungVelocityMps=0.0
    public var springForceN=0.0, damperForceN=0.0, tireForceN=0.0, bumpStopForceN=0.0
    public init(){}
}
public enum CornerSuspensionAuthority {
    public static func step(state: inout CornerSuspensionState, roadHeightM: Double, antiRollForceN: Double, p: CornerSuspensionParameters, dt: Double) {
        let travel=(state.sprungPositionM-state.unsprungPositionM)*p.motionRatio
        let relV=(state.sprungVelocityMps-state.unsprungVelocityMps)*p.motionRatio
        state.springForceN = -p.springRateNPerM*travel
        let damping = relV >= 0 ? p.damperReboundNsPerM : p.damperBumpNsPerM
        state.damperForceN = -damping*relV
        let compression=max(0,abs(travel)-p.bumpStopStartM)
        state.bumpStopForceN = compression > 0 ? -copysign(p.bumpStopRateNPerM*compression,travel) : 0
        state.tireForceN = p.tireVerticalRateNPerM*(roadHeightM-state.unsprungPositionM)
        let suspensionForce=state.springForceN+state.damperForceN+state.bumpStopForceN+antiRollForceN
        let sprungA=suspensionForce/max(p.sprungMassKg,1)
        let unsprungA=(-suspensionForce+state.tireForceN)/max(p.unsprungMassKg,1)
        state.sprungVelocityMps += sprungA*dt; state.sprungPositionM += state.sprungVelocityMps*dt
        state.unsprungVelocityMps += unsprungA*dt; state.unsprungPositionM += state.unsprungVelocityMps*dt
        if abs(state.sprungPositionM-state.unsprungPositionM)>p.droopLimitM*1.5 { state.sprungVelocityMps *= 0.75 }
    }
}

public struct FourCornerSuspensionState: Codable, Hashable, Sendable {
    public var frontLeft=CornerSuspensionState(),frontRight=CornerSuspensionState(),rearLeft=CornerSuspensionState(),rearRight=CornerSuspensionState()
    public init(){}
    public subscript(_ c:VehicleCorner)->CornerSuspensionState { get { switch c {case .frontLeft:return frontLeft;case .frontRight:return frontRight;case .rearLeft:return rearLeft;case .rearRight:return rearRight} } set { switch c {case .frontLeft:frontLeft=newValue;case .frontRight:frontRight=newValue;case .rearLeft:rearLeft=newValue;case .rearRight:rearRight=newValue} } }
}
public struct RoadCornerHeights: Codable, Hashable, Sendable { public var frontLeft=0.0,frontRight=0.0,rearLeft=0.0,rearRight=0.0; public init(){}; public subscript(_ c:VehicleCorner)->Double { get { switch c {case .frontLeft:return frontLeft;case .frontRight:return frontRight;case .rearLeft:return rearLeft;case .rearRight:return rearRight} } set { switch c {case .frontLeft:frontLeft=newValue;case .frontRight:frontRight=newValue;case .rearLeft:rearLeft=newValue;case .rearRight:rearRight=newValue} } } }
public struct SuspensionAxleParameters: Codable, Hashable, Sendable { public var front=CornerSuspensionParameters(),rear=CornerSuspensionParameters(); public var frontAntiRollNPerRad=18_000.0,rearAntiRollNPerRad=12_000.0; public init(){} }
public enum FourCornerSuspensionAuthority {
    public static func step(state:inout FourCornerSuspensionState,road:RoadCornerHeights,p:SuspensionAxleParameters,dt:Double) {
        let frontRoll=state.frontLeft.sprungPositionM-state.frontRight.sprungPositionM
        let rearRoll=state.rearLeft.sprungPositionM-state.rearRight.sprungPositionM
        let forces:[VehicleCorner:Double]=[.frontLeft:-frontRoll*p.frontAntiRollNPerRad,.frontRight:frontRoll*p.frontAntiRollNPerRad,.rearLeft:-rearRoll*p.rearAntiRollNPerRad,.rearRight:rearRoll*p.rearAntiRollNPerRad]
        for c in VehicleCorner.allCases { var s=state[c]; CornerSuspensionAuthority.step(state:&s,roadHeightM:road[c],antiRollForceN:forces[c] ?? 0,p:(c == .frontLeft || c == .frontRight) ? p.front:p.rear,dt:dt);state[c]=s }
    }
}
