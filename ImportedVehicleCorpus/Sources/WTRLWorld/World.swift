import Foundation
import WTRLCore
import WTRLVehicle

public struct WorldState: Codable, Hashable, Sendable {
    public var locationId="icehouse_garage"
    public var elapsedHours=0.0
    public var weatherId="clear"
    public var vehicleContinuity:[String:VehicleContinuityState]=[:]
    public var persistentVehicleDamage:[String:PersistentVehicleDamageState]=[:]
    public init(){}
    enum CodingKeys:String,CodingKey {case locationId,elapsedHours,weatherId,vehicleContinuity,persistentVehicleDamage}
    public init(from decoder:Decoder)throws {
        let c=try decoder.container(keyedBy:CodingKeys.self)
        locationId=try c.decodeIfPresent(String.self,forKey:.locationId) ?? "icehouse_garage"
        elapsedHours=try c.decodeIfPresent(Double.self,forKey:.elapsedHours) ?? 0
        weatherId=try c.decodeIfPresent(String.self,forKey:.weatherId) ?? "clear"
        vehicleContinuity=try c.decodeIfPresent([String:VehicleContinuityState].self,forKey:.vehicleContinuity) ?? [:]
        persistentVehicleDamage=try c.decodeIfPresent([String:PersistentVehicleDamageState].self,forKey:.persistentVehicleDamage) ?? [:]
    }
}
public struct RoadTripResult: Codable, Hashable, Sendable { public var distanceKm:Double; public var fuelUsedLiters:Double; public var evidence:EvidenceRecord }
