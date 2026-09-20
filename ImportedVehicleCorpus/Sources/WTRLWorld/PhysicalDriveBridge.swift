import Foundation
import WTRLCore
import WTRLVehicle

public struct PhysicalDriveInput:Codable,Hashable,Sendable {public var throttle=0.0,brake=0.0,steering=0.0,clutch=0.0;public var gear=1;public init(){}}
public struct PhysicalDriveTelemetry:Codable,Hashable,Sendable {
    public var speedKph=0.0,rpm=850.0,yawRate=0.0,lateralG=0.0,longitudinalG=0.0
    public var distanceKm=0.0,fuelUsedL=0.0
    public init(){}
}
public enum PhysicalDriveBridge {
    public static func step(_ t:inout PhysicalDriveTelemetry,input:PhysicalDriveInput,route:BlackridgeRouteSpec,dt:Double) {
        let grip=WTRLMath.clamp(route.grip01-route.bumpiness01*0.08,0.35,1)
        let accel=(max(0,input.throttle)*5.0-max(0,input.brake)*9.0)*grip
        t.speedKph=max(0,t.speedKph+accel*dt*3.6)
        t.speedKph=max(0,t.speedKph-t.speedKph*0.0025*dt)
        t.rpm=max(800,min(6500,850+t.speedKph*Double(max(1,input.gear))*34))
        t.yawRate=input.steering*(t.speedKph/100)*grip
        t.lateralG=abs(t.yawRate)*t.speedKph/130
        t.longitudinalG=accel/9.80665
        t.distanceKm += t.speedKph*dt/3600
        t.fuelUsedL += max(0,input.throttle)*dt*(0.0015+t.rpm*0.00000022)
    }
}
