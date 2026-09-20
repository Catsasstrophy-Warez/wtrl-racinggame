import Foundation
import WTRLCore
import WTRLVehicle

public enum BlackridgeRoute:String,Codable,CaseIterable,Sendable { case icehouseToRedline, redlineToHarrow, harrowToBriar, briarToIcehouse, blackridgeMountainLoop }
public struct BlackridgeRouteSpec:Codable,Hashable,Sendable {
    public var route:BlackridgeRoute; public var distanceKm:Double; public var elevationGainM:Double; public var grip01:Double; public var bumpiness01:Double; public var brakeDemand01:Double; public var coolingDemand01:Double
}
public enum BlackridgeCatalog {
    public static let routes:[BlackridgeRoute:BlackridgeRouteSpec] = [
        .icehouseToRedline:.init(route:.icehouseToRedline,distanceKm:8.4,elevationGainM:55,grip01:0.94,bumpiness01:0.18,brakeDemand01:0.22,coolingDemand01:0.32),
        .redlineToHarrow:.init(route:.redlineToHarrow,distanceKm:17.8,elevationGainM:130,grip01:0.91,bumpiness01:0.26,brakeDemand01:0.45,coolingDemand01:0.48),
        .harrowToBriar:.init(route:.harrowToBriar,distanceKm:12.2,elevationGainM:40,grip01:0.96,bumpiness01:0.12,brakeDemand01:0.18,coolingDemand01:0.38),
        .briarToIcehouse:.init(route:.briarToIcehouse,distanceKm:21.4,elevationGainM:175,grip01:0.90,bumpiness01:0.31,brakeDemand01:0.52,coolingDemand01:0.57),
        .blackridgeMountainLoop:.init(route:.blackridgeMountainLoop,distanceKm:31.7,elevationGainM:820,grip01:0.87,bumpiness01:0.38,brakeDemand01:0.88,coolingDemand01:0.82)
    ]
}
public struct BlackridgeDriveState:Codable,Hashable,Sendable { public var route:BlackridgeRoute; public var progress01=0.0; public var speedKph=0.0; public var fuelUsedL=0.0; public var brakeHeat01=0.0; public var coolantC=82.0; public var differentialC=55.0; public var completed=false; public init(route:BlackridgeRoute){self.route=route} }
public enum BlackridgeDriveRuntime {
    public static func step(_ state:inout BlackridgeDriveState, throttle:Double, brake:Double, dt:Double) {
        guard let r=BlackridgeCatalog.routes[state.route], !state.completed else { return }
        let target=max(0,throttle)*145*(0.75+0.25*r.grip01)
        state.speedKph += (target-state.speedKph)*min(1,dt*0.9)
        state.speedKph=max(0,state.speedKph-max(0,brake)*dt*110)
        let mps=state.speedKph/3.6
        state.progress01 += mps*dt/(r.distanceKm*1000)
        state.fuelUsedL += max(0,throttle)*dt*(0.0018+state.speedKph*0.000006)
        state.brakeHeat01=WTRLMath.clamp01(state.brakeHeat01+max(0,brake)*dt*0.08*r.brakeDemand01-dt*0.008)
        state.coolantC += max(0,throttle)*dt*0.04*r.coolingDemand01-dt*0.012
        state.differentialC += max(0,throttle)*dt*0.025-dt*0.006
        if state.progress01 >= 1 { state.progress01=1; state.completed=true }
    }
}
