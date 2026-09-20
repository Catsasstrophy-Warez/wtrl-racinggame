import Foundation
import WTRLCore

public enum VehiclePlace:String,Codable,CaseIterable,Sendable { case countyMotors, icehouseGarage, icehouseDyno, redlineJunction, blackridgeRoad, harrowPark, briarField }
public struct VehicleContinuityState:Codable,Hashable,Sendable {
    public var vehicleInstanceId:String
    public var place:VehiclePlace
    public var odometerKm:Double
    public var engineHours:Double
    public var tripFuelUsedL:Double
    public var lastEvidenceId:String?
    public init(vehicleInstanceId:String,place:VehiclePlace = .countyMotors,odometerKm:Double=0,engineHours:Double=0,tripFuelUsedL:Double=0,lastEvidenceId:String?=nil){
        self.vehicleInstanceId=vehicleInstanceId;self.place=place;self.odometerKm=odometerKm;self.engineHours=engineHours;self.tripFuelUsedL=tripFuelUsedL;self.lastEvidenceId=lastEvidenceId
    }
}
public enum VehicleContinuityError:Error,Equatable {case wrongVehicle, invalidTransition}
public enum VehicleContinuityRuntime {
    public static func move(_ state:inout VehicleContinuityState,vehicleId:String,to place:VehiclePlace,distanceKm:Double=0,fuelUsedL:Double=0,engineHours:Double=0)throws {
        guard state.vehicleInstanceId==vehicleId else{throw VehicleContinuityError.wrongVehicle}
        let allowed:[VehiclePlace:Set<VehiclePlace>] = [
            .countyMotors:[.icehouseGarage],
            .icehouseGarage:[.icehouseDyno,.redlineJunction,.blackridgeRoad],
            .icehouseDyno:[.icehouseGarage],
            .redlineJunction:[.icehouseGarage,.blackridgeRoad,.harrowPark],
            .blackridgeRoad:[.icehouseGarage,.redlineJunction,.harrowPark,.briarField],
            .harrowPark:[.blackridgeRoad,.redlineJunction,.briarField],
            .briarField:[.blackridgeRoad,.icehouseGarage,.harrowPark]
        ]
        guard allowed[state.place]?.contains(place)==true else{throw VehicleContinuityError.invalidTransition}
        state.place=place;state.odometerKm+=max(0,distanceKm);state.tripFuelUsedL+=max(0,fuelUsedL);state.engineHours+=max(0,engineHours)
    }
}
