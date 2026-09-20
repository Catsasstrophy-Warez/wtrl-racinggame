import Foundation

public struct AeroMechanicalState: Codable, Hashable, Sendable {
    public var suspension = FourCornerSuspensionState()
    public var attitude = BodyAttitudeState()
    public var aero = AerodynamicForceOutput(dragN: 0, frontDownforceN: 0, rearDownforceN: 0, underbodyEfficiency01: 1, stalled: false)
    public var loads = FourCornerLoads()
    public var frontRideHeightM = 0.11
    public var rearRideHeightM = 0.12
    public var splitterBottoming01 = 0.0
    public var alignmentError01 = 0.0
    public init() {}
}

public struct AeroMechanicalInput: Sendable {
    public var speedMps = 0.0
    public var longitudinalAccelerationMps2 = 0.0
    public var lateralAccelerationMps2 = 0.0
    public var road = RoadCornerHeights()
    public var geometry = VehicleGeometry()
    public var suspension = SuspensionAxleParameters()
    public var aero = AerodynamicTrimProfile()
    public var frontStaticRideHeightM = 0.11
    public var rearStaticRideHeightM = 0.12
    public var chassisRigidity01 = 0.75
    public var structuralSet01 = 0.0
    public var drs = false
    public var airDensity = 1.225
    public var dt = 1.0 / 120.0
    public init() {}
}

public enum AeroMechanicalClosureAuthority {
    public static func step(state: inout AeroMechanicalState, input i: AeroMechanicalInput) {
        // Iterate the aero/suspension loop twice. This is a stable reduced-order closure, not CFD/FEM.
        for _ in 0..<2 {
            state.attitude = SuspensionTireCouplingAuthority.attitude(suspension: state.suspension, geometry: i.geometry)
            state.frontRideHeightM = max(0.008, i.frontStaticRideHeightM - 0.5 * (state.suspension.frontLeft.sprungPositionM + state.suspension.frontRight.sprungPositionM))
            state.rearRideHeightM = max(0.008, i.rearStaticRideHeightM - 0.5 * (state.suspension.rearLeft.sprungPositionM + state.suspension.rearRight.sprungPositionM))
            state.aero = AerodynamicDynamicsAuthority.evaluate(i.aero, speedMps: i.speedMps, frontRideHeightM: state.frontRideHeightM, rearRideHeightM: state.rearRideHeightM, drs: i.drs, airDensity: i.airDensity)
            var road = i.road
            // Aero force compresses the sprung structure. Convert force to a small equivalent road displacement so
            // the existing corner solver remains the single suspension integrator.
            let frontK = max(10_000, i.suspension.front.springRateNPerM)
            let rearK = max(10_000, i.suspension.rear.springRateNPerM)
            let frontEq = state.aero.frontDownforceN * 0.5 / frontK
            let rearEq = state.aero.rearDownforceN * 0.5 / rearK
            road.frontLeft += frontEq; road.frontRight += frontEq
            road.rearLeft += rearEq; road.rearRight += rearEq
            FourCornerSuspensionAuthority.step(state: &state.suspension, road: road, p: i.suspension, dt: i.dt * 0.5)
        }
        let quasi = FourCornerLoadAuthority.evaluate(geometry: i.geometry, longitudinalAccelerationMps2: i.longitudinalAccelerationMps2, lateralAccelerationMps2: i.lateralAccelerationMps2)
        state.loads = SuspensionTireCouplingAuthority.dynamicLoads(suspension: state.suspension, quasiStatic: quasi)
        state.loads.frontLeftN += state.aero.frontDownforceN * 0.5; state.loads.frontRightN += state.aero.frontDownforceN * 0.5
        state.loads.rearLeftN += state.aero.rearDownforceN * 0.5; state.loads.rearRightN += state.aero.rearDownforceN * 0.5
        state.splitterBottoming01 = max(0, min(1, (0.025 - state.frontRideHeightM) / 0.017))
        let compliance = (1 - max(0.05, min(1, i.chassisRigidity01))) * 0.55 + max(0, min(1, i.structuralSet01)) * 0.65
        state.alignmentError01 = max(0, min(1, compliance * (abs(i.lateralAccelerationMps2) / 12.0 + state.splitterBottoming01 * 0.6)))
    }
}
