import Foundation
import WTRLVehicle

public enum TacticalTrackingState:String,Codable,Sendable { case clear, visual, occluded, searching }
public struct PursuitSystemsState:Codable,Hashable,Sendable { public var tracking:TacticalTrackingState = .clear, cooldownS=0.0, roadblockRequested=false, airSupportActive=false; public init(){} }
public enum PursuitSystemsAuthority {
    public static func step(state:inout PursuitSystemsState,heat:PursuitHeatLevel,visible:Bool,occluded:Bool,speedMps:Double,dt:Double){
        if visible { state.tracking = .visual; state.cooldownS=30 } else if occluded { state.tracking = .occluded; state.cooldownS=max(0,state.cooldownS-dt) } else { state.tracking = .searching; state.cooldownS=max(0,state.cooldownS-dt) }
        state.roadblockRequested = heat.rawValue >= 4 && speedMps > 12
        state.airSupportActive = heat.rawValue >= 4
        if state.cooldownS == 0 && !visible { state.tracking = .clear }
    }
}

public struct RotorWashField:Codable,Hashable,Sendable { public var strength01=0.0,lateralWindMps=0.0,verticalWindMps=0.0; public init(){} }
public enum RotorWashAuthority { public static func field(horizontalDistanceM:Double,altitudeM:Double)->RotorWashField { var f=RotorWashField(); guard altitudeM>6,horizontalDistanceM<45 else{return f};f.strength01=max(0,min(1,(45-horizontalDistanceM)/45*(28-altitudeM)/22));f.lateralWindMps=5*f.strength01;f.verticalWindMps = -8*f.strength01;return f } }

public enum VehicleRecoveryStatus:String,Codable,Sendable { case owned, held, released, auctionEligible }
public struct VehicleRecoveryLedger:Codable,Hashable,Sendable { public var vehicleId:String,status:VehicleRecoveryStatus = .owned,seizures=0,feesCredits=0,storageDays=0; public init(vehicleId:String){self.vehicleId=vehicleId} }
public enum VehicleRecoveryAuthority {
    public static func placeHold(_ l:inout VehicleRecoveryLedger,heat:Int,days:Int){l.status = .held;l.seizures += 1;l.storageDays += max(0,days);l.feesCredits += 300+max(0,heat)*125+max(0,days)*65;if l.seizures>=3{l.status = .auctionEligible}}
    public static func lawfulRelease(_ l:inout VehicleRecoveryLedger,paymentCredits:Int)->Bool {guard l.status == .held, paymentCredits>=l.feesCredits else{return false};l.status = .released;l.feesCredits=0;return true}
}

public struct WorldCommerceState:Codable,Hashable,Sendable { public var workshopTier=1,inventorySlots=8,partsDeliveryHours=48.0,salvageReputation=0.0; public init(){} }
public enum WorldCommerceAuthority { public static func upgrade(_ s:inout WorldCommerceState,to tier:Int){let t=max(1,min(5,tier));s.workshopTier=t;s.inventorySlots=[0,8,24,48,96,180][t];s.partsDeliveryHours=[0,48,12,6,2,0.5][t]} }
