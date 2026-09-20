import Foundation
import WTRLCore
public enum ShopFluid:String,Codable,Sendable {case gearOil, engineOil, coolant, brakeFluid, solvent}
public struct FluidContainer:Codable,Hashable,Sendable,Identifiable {public var id:String;public var fluid:ShopFluid;public var volumeL:Double;public var capacityL:Double}
public struct FluidServiceState:Codable,Hashable,Sendable {public var differentialOilL=0.0;public var drainPanL=0.0;public var spillL=0.0;public var cleanedParts:Set<String>=[];public init(){}}
public enum FluidServiceRuntime {
    public static func drainDifferential(_ s:inout FluidServiceState,capacityL:Double=1.9,panCapacityL:Double=8){
        let drained=min(capacityL,s.differentialOilL);let room=max(0,panCapacityL-s.drainPanL);let captured=min(drained,room)
        s.drainPanL+=captured;s.spillL+=max(0,drained-captured);s.differentialOilL=max(0,s.differentialOilL-drained)
    }
    public static func fillDifferential(_ s:inout FluidServiceState,liters:Double,capacityL:Double=1.9){
        let room=max(0,capacityL-s.differentialOilL);let accepted=min(max(0,liters),room);s.differentialOilL+=accepted;s.spillL+=max(0,liters-accepted)
    }
    public static func wash(partId:String,s:inout FluidServiceState){s.cleanedParts.insert(partId)}
}
