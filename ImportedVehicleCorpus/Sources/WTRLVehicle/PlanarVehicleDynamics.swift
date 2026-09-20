import Foundation
import WTRLCore

public struct PlanarVehicleState: Codable, Hashable, Sendable {
    public var xM = 0.0
    public var yM = 0.0
    public var longitudinalVelocityMps = 0.0
    public var lateralVelocityMps = 0.0
    public var yawRadians = 0.0
    public var yawRateRadPerSec = 0.0
    public init() {}
}

public struct PlanarVehicleInput: Codable, Hashable, Sendable {
    public var steeringRadians = 0.0
    public var throttle01 = 0.0
    public var brake01 = 0.0
    public init() {}
}

public struct PlanarVehicleParameters: Codable, Hashable, Sendable {
    public var massKg = 1450.0
    public var yawInertiaKgM2 = 2300.0
    public var cgToFrontAxleM = 1.35
    public var cgToRearAxleM = 1.45
    public var maxDriveForceN = 6500.0
    public var maxBrakeForceN = 12000.0
    public var rollingResistanceN = 180.0
    public var aeroDragCoefficientNPerMps2 = 0.42
    public var gravityMps2 = 9.80665
    public var tire = MagicFormulaCoefficients()
    public init() {}
}

public struct MagicFormulaCoefficients: Codable, Hashable, Sendable {
    public var b = 10.0
    public var c = 1.30
    public var peakFrictionCoefficient = 1.05
    public var e = -0.10
    public init() {}
}

public enum MagicFormula {
    public static func lateralForce(slipAngleRad: Double, normalLoadN: Double, coefficients c: MagicFormulaCoefficients) -> Double {
        let curve = c.b * slipAngleRad
        let shape = c.e * (curve - atan(curve))
        return c.peakFrictionCoefficient * normalLoadN * sin(c.c * atan(curve - shape))
    }
}

public enum PlanarVehicleDynamics {
    private struct D {
        var dx, dy, dvx, dvy, dyaw, dyawRate: Double
    }

    private static func derivative(_ s: PlanarVehicleState, input u: PlanarVehicleInput, p: PlanarVehicleParameters) -> D {
        let wheelbase = max(p.cgToFrontAxleM + p.cgToRearAxleM, 0.001)
        let frontLoad = p.massKg * p.gravityMps2 * p.cgToRearAxleM / wheelbase
        let rearLoad = p.massKg * p.gravityMps2 * p.cgToFrontAxleM / wheelbase
        let vxForSlip = max(abs(s.longitudinalVelocityMps), 1.0)

        let frontSlip = atan2(s.lateralVelocityMps + p.cgToFrontAxleM * s.yawRateRadPerSec, vxForSlip) - u.steeringRadians
        let rearSlip = atan2(s.lateralVelocityMps - p.cgToRearAxleM * s.yawRateRadPerSec, vxForSlip)
        let frontFy = -MagicFormula.lateralForce(slipAngleRad: frontSlip, normalLoadN: frontLoad, coefficients: p.tire)
        let rearFy = -MagicFormula.lateralForce(slipAngleRad: rearSlip, normalLoadN: rearLoad, coefficients: p.tire)

        let direction = s.longitudinalVelocityMps == 0 ? 0.0 : (s.longitudinalVelocityMps > 0 ? 1.0 : -1.0)
        let resist = direction * (p.rollingResistanceN + p.aeroDragCoefficientNPerMps2 * s.longitudinalVelocityMps * s.longitudinalVelocityMps)
        let longitudinalForce = WTRLMath.clamp01(u.throttle01) * p.maxDriveForceN - WTRLMath.clamp01(u.brake01) * p.maxBrakeForceN - resist

        let cosSteer = cos(u.steeringRadians)
        let sinSteer = sin(u.steeringRadians)
        let dvx = (longitudinalForce - frontFy * sinSteer) / p.massKg + s.lateralVelocityMps * s.yawRateRadPerSec
        let dvy = (rearFy + frontFy * cosSteer) / p.massKg - s.longitudinalVelocityMps * s.yawRateRadPerSec
        let yawMoment = p.cgToFrontAxleM * frontFy * cosSteer - p.cgToRearAxleM * rearFy

        return D(
            dx: s.longitudinalVelocityMps * cos(s.yawRadians) - s.lateralVelocityMps * sin(s.yawRadians),
            dy: s.longitudinalVelocityMps * sin(s.yawRadians) + s.lateralVelocityMps * cos(s.yawRadians),
            dvx: dvx,
            dvy: dvy,
            dyaw: s.yawRateRadPerSec,
            dyawRate: yawMoment / p.yawInertiaKgM2
        )
    }

    private static func shifted(_ s: PlanarVehicleState, _ k: D, _ dt: Double) -> PlanarVehicleState {
        var n = s
        n.xM += k.dx * dt; n.yM += k.dy * dt
        n.longitudinalVelocityMps += k.dvx * dt; n.lateralVelocityMps += k.dvy * dt
        n.yawRadians += k.dyaw * dt; n.yawRateRadPerSec += k.dyawRate * dt
        return n
    }

    public static func rk4Step(_ state: inout PlanarVehicleState, input: PlanarVehicleInput, parameters p: PlanarVehicleParameters, dt: Double) {
        let h = max(dt, 0.000_001)
        let k1 = derivative(state, input: input, p: p)
        let k2 = derivative(shifted(state, k1, h * 0.5), input: input, p: p)
        let k3 = derivative(shifted(state, k2, h * 0.5), input: input, p: p)
        let k4 = derivative(shifted(state, k3, h), input: input, p: p)
        state.xM += h * (k1.dx + 2*k2.dx + 2*k3.dx + k4.dx) / 6
        state.yM += h * (k1.dy + 2*k2.dy + 2*k3.dy + k4.dy) / 6
        state.longitudinalVelocityMps = max(0, state.longitudinalVelocityMps + h * (k1.dvx + 2*k2.dvx + 2*k3.dvx + k4.dvx) / 6)
        state.lateralVelocityMps += h * (k1.dvy + 2*k2.dvy + 2*k3.dvy + k4.dvy) / 6
        state.yawRadians += h * (k1.dyaw + 2*k2.dyaw + 2*k3.dyaw + k4.dyaw) / 6
        state.yawRateRadPerSec += h * (k1.dyawRate + 2*k2.dyawRate + 2*k3.dyawRate + k4.dyawRate) / 6
    }
}

public struct InstabilityObservation: Codable, Hashable, Sendable {
    public var normalizedAccelerationDemand01: Double
    public var slipContribution01: Double
    public var inputRateContribution01: Double
    public var total01: Double
}

public enum InstabilityEstimator {
    public static func evaluate(axMps2: Double, ayMps2: Double, frictionCoefficient: Double, gravity: Double = 9.80665, slipContribution01: Double, inputRateContribution01: Double) -> InstabilityObservation {
        let limit = max(frictionCoefficient * gravity, 0.001)
        let demand = WTRLMath.clamp01(hypot(axMps2, ayMps2) / limit)
        let slip = WTRLMath.clamp01(slipContribution01)
        let input = WTRLMath.clamp01(inputRateContribution01)
        let total = WTRLMath.clamp01(max(demand, slip) + input * 0.12)
        return .init(normalizedAccelerationDemand01: demand, slipContribution01: slip, inputRateContribution01: input, total01: total)
    }
}
