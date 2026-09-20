import Foundation
import WTRLCore
import WTRLVehicle

public struct RoadControlPoint:Codable,Hashable,Sendable {
    public var position:Vector3D
    public var widthM:Double
    public var grip01:Double
    public var camberDegrees:Double
}
public struct BlackridgeSceneRoute:Codable,Hashable,Sendable {
    public var route:BlackridgeRoute
    public var points:[RoadControlPoint]
}
public enum BlackridgeSceneCatalog {
    public static func route(_ r:BlackridgeRoute)->BlackridgeSceneRoute {
        let spec=BlackridgeCatalog.routes[r]!
        let count=max(8,Int(spec.distanceKm*2))
        let pts=(0..<count).map { i -> RoadControlPoint in
            let t=Double(i)/Double(max(1,count-1))
            let elevation=sin(t*Double.pi*2)*spec.elevationGainM*0.22 + t*spec.elevationGainM*0.35
            return .init(position:Vector3D(t*spec.distanceKm*1000,elevation,sin(t*Double.pi*4)*90),
                         widthM:r == .blackridgeMountainLoop ? 7.2:8.5,
                         grip01:spec.grip01,camberDegrees:sin(t*Double.pi*6)*2.5)
        }
        return .init(route:r,points:pts)
    }
}
public struct MobileDrivingRuntimeState:Codable,Hashable,Sendable {
    public var input=PhysicalDriveInput()
    public var telemetry=PhysicalDriveTelemetry()
    public var cameraMode="chase"
    public var hudSpeedKph=0.0
    public var hudRPM=850.0
    public init(){}
    public mutating func synchronizeHUD(){hudSpeedKph=telemetry.speedKph;hudRPM=telemetry.rpm}
}
