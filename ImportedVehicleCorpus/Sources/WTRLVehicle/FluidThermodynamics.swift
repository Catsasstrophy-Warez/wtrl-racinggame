import Foundation

public struct EngineFluidThermalSpec: Codable, Hashable, Sendable {
    public var blockHeatCapacityJK=82_800.0, coolantHeatCapacityJK=45_120.0, oilHeatCapacityJK=11_000.0
    public var blockCoolantConductanceWK=420.0, blockOilConductanceWK=180.0
    public var radiatorAreaM2=0.45, radiatorEffectiveness=0.72, oilCoolingBaseWK=15.0
    public var pressureCapGaugeKPa=96.5
    public init(){}
}
public struct EngineFluidThermalState: Codable, Hashable, Sendable {
    public var blockC=85.0, coolantC=82.0, oilC=90.0, oilPressureKPa=380.0, coolantGaugePressureKPa=96.5
    public var cavitationRisk01=0.0, bearingDamage01=0.0, vaporLockRisk01=0.0
    public init(){}
}
public struct EngineFluidThermalInput: Codable, Hashable, Sendable {
    public var rpm=900.0, load01=0.1, vehicleSpeedMps=0.0, ambientC=22.0, ambientPressureKPa=101.3, fuelLineC=30.0, dt=1.0/120.0
    public init(){}
}
public enum EngineFluidThermalAuthority {
    public static func step(state: inout EngineFluidThermalState, spec: EngineFluidThermalSpec = .init(), input: EngineFluidThermalInput) {
        let dt=max(0,min(0.1,input.dt)), rpm01=max(0,min(1.5,input.rpm/6500)), load=max(0,min(1.2,input.load01))
        let wasteHeatW=18_000 + 175_000*load*rpm01
        let qBC=spec.blockCoolantConductanceWK*(state.blockC-state.coolantC), qBO=spec.blockOilConductanceWK*(state.blockC-state.oilC)
        let airSpeed=max(1.5,input.vehicleSpeedMps), airMassFlow=airSpeed*spec.radiatorAreaM2*1.184
        let qRad=airMassFlow*1005*spec.radiatorEffectiveness*max(0,state.coolantC-input.ambientC)
        let qOil=(spec.oilCoolingBaseWK+airSpeed*2.2)*max(0,state.oilC-input.ambientC)
        state.blockC += ((wasteHeatW-qBC-qBO)/spec.blockHeatCapacityJK)*dt
        state.coolantC += ((qBC-qRad)/spec.coolantHeatCapacityJK)*dt
        state.oilC += ((qBO-qOil)/spec.oilHeatCapacityJK)*dt
        // Reduced-order calibration: pressure-cap margin, coolant composition and pump inlet pressure belong in vehicle-specific data.
        let boilMarginC=100.0 + max(0,state.coolantGaugePressureKPa)*0.075
        state.cavitationRisk01=max(0,min(1,(state.coolantC-boilMarginC)/18.0))*max(0,min(1,(input.rpm-4500)/1800))
        let viscosityRatio=exp(-0.018*max(-30,min(90,state.oilC-90)))
        state.oilPressureKPa=max(55,(70 + input.rpm*0.055)*viscosityRatio)
        if state.oilPressureKPa < 140 && input.rpm > 3000 { state.bearingDamage01=min(1,state.bearingDamage01+(140-state.oilPressureKPa)/140*input.rpm/6500*dt/900) }
        let fuelVolatilityTemp=55.0 + max(0,input.ambientPressureKPa-80)*0.15
        state.vaporLockRisk01=max(0,min(1,(input.fuelLineC-fuelVolatilityTemp)/20.0))
    }
}
