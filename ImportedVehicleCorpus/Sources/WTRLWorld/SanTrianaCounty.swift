import Foundation
import WTRLCore
import WTRLVehicle

public enum OpenWorldCountyID:String,Codable,CaseIterable,Sendable { case blackridge, sanTriana }
public struct CountyTravelLink:Codable,Hashable,Sendable { public var from:OpenWorldCountyID,to:OpenWorldCountyID,distanceKm:Double,travelHours:Double; public init(from:OpenWorldCountyID,to:OpenWorldCountyID,distanceKm:Double,travelHours:Double){self.from=from;self.to=to;self.distanceKm=distanceKm;self.travelHours=travelHours} }
public enum SanTrianaZone:String,Codable,CaseIterable,Sendable { case crest, foundryRow, maritimeDocks, riverInterchange, oldTown }
public struct SanTrianaZoneProfile:Codable,Hashable,Sendable { public var zone:SanTrianaZone,surface:RoadSurfaceKind,elevationM:Double,ambientOffsetC:Double,moistureBias01:Double,trafficDensity01:Double; public init(zone:SanTrianaZone,surface:RoadSurfaceKind,elevationM:Double,ambientOffsetC:Double,moistureBias01:Double,trafficDensity01:Double){self.zone=zone;self.surface=surface;self.elevationM=elevationM;self.ambientOffsetC=ambientOffsetC;self.moistureBias01=moistureBias01;self.trafficDensity01=trafficDensity01} }
public enum SanTrianaCountyAuthority {
    public static let zones:[SanTrianaZoneProfile] = [
        .init(zone:.crest,surface:.tarChip,elevationM:720,ambientOffsetC:-9,moistureBias01:0.25,trafficDensity01:0.25),
        .init(zone:.foundryRow,surface:.urbanAsphalt,elevationM:55,ambientOffsetC:2,moistureBias01:0.45,trafficDensity01:0.72),
        .init(zone:.maritimeDocks,surface:.marineConcrete,elevationM:4,ambientOffsetC:0,moistureBias01:0.85,trafficDensity01:0.78),
        .init(zone:.riverInterchange,surface:.urbanAsphalt,elevationM:30,ambientOffsetC:1,moistureBias01:0.55,trafficDensity01:0.90),
        .init(zone:.oldTown,surface:.roadPaint,elevationM:80,ambientOffsetC:1,moistureBias01:0.40,trafficDensity01:0.60)]
    public static let blackridgeConnection=CountyTravelLink(from:.blackridge,to:.sanTriana,distanceKm:118,travelHours:1.65)
    public static func airDensityKgM3(ambientC:Double,elevationM:Double,relativeHumidity01:Double)->Double { let t=ambientC+273.15;let p=101325*pow(max(0.1,1-2.25577e-5*elevationM),5.25588);let vapor=SurfaceClimateAuthority.vaporPressureKPa(ambientC:ambientC,humidity01:relativeHumidity01)*1000;return max(0.7,(p-vapor)/(287.05*t)+vapor/(461.5*t)) }
}
public struct TrafficGridPolicy:Codable,Hashable,Sendable { public var cellSizeM=80.0,fullPhysicsRadiusM=65.0,demotionRadiusM=82.0,maxFullPhysicsActors=16,maxFarKinematicActors=256;public init(){} }
public enum TrafficSimulationTier:String,Codable,Sendable { case dormant, kinematic, fullPhysics }
public enum SanTrianaTrafficAuthority { public static func tier(distanceM:Double,currentlyFullPhysics:Bool,policy:TrafficGridPolicy = .init())->TrafficSimulationTier { if currentlyFullPhysics && distanceM<policy.demotionRadiusM{return .fullPhysics};if distanceM<policy.fullPhysicsRadiusM{return .fullPhysics};if distanceM<650{return .kinematic};return .dormant } }
