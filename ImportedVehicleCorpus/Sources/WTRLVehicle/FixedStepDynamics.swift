import Foundation
import WTRLCore

public struct DynamicState:Codable,Hashable,Sendable {
    public var positionM=0.0, velocityMps=0.0, tireTemperatureC=25.0
    public init(){}
}
public struct DynamicsInput:Codable,Hashable,Sendable {
    public var driveAccelerationMps2=0.0, dragCoefficient=0.015, ambientC=25.0, tireHeatRate=0.4
    public init(){}
}
public enum RK4Dynamics {
    private struct Derivative {var dx:Double;var dv:Double;var dT:Double}
    private static func d(_ s:DynamicState,_ u:DynamicsInput)->Derivative {
        let drag=u.dragCoefficient*s.velocityMps*abs(s.velocityMps)
        return .init(dx:s.velocityMps,dv:u.driveAccelerationMps2-drag,dT:u.tireHeatRate*abs(s.velocityMps)-(s.tireTemperatureC-u.ambientC)*0.035)
    }
    private static func shifted(_ s:DynamicState,_ k:Derivative,_ dt:Double)->DynamicState {
        var n=s;n.positionM += k.dx*dt;n.velocityMps += k.dv*dt;n.tireTemperatureC += k.dT*dt;return n
    }
    public static func step(_ s:inout DynamicState,input u:DynamicsInput,dt:Double) {
        let k1=d(s,u),k2=d(shifted(s,k1,dt*0.5),u),k3=d(shifted(s,k2,dt*0.5),u),k4=d(shifted(s,k3,dt),u)
        s.positionM += dt*(k1.dx+2*k2.dx+2*k3.dx+k4.dx)/6
        s.velocityMps=max(0,s.velocityMps+dt*(k1.dv+2*k2.dv+2*k3.dv+k4.dv)/6)
        s.tireTemperatureC += dt*(k1.dT+2*k2.dT+2*k3.dT+k4.dT)/6
    }
}
public struct FixedStepClock:Codable,Hashable,Sendable {
    public var physicsHz:Double=120
    public var accumulator=0.0
    public var maximumStepsPerFrame=8
    public init(){}
    public mutating func consume(frameDelta:Double,step:(Double)->Void)->Int {
        accumulator += min(max(frameDelta,0),0.25)
        let dt=1/physicsHz;var count=0
        while accumulator>=dt && count<maximumStepsPerFrame {step(dt);accumulator-=dt;count+=1}
        if count==maximumStepsPerFrame {accumulator=min(accumulator,dt)}
        return count
    }
}
public struct TireForceLUT:Codable,Hashable,Sendable {
    public var minimum:Double, maximum:Double, values:[Double]
    public func sample(_ x:Double)->Double {
        guard values.count>1 else{return values.first ?? 0}
        let n=WTRLMath.clamp01((x-minimum)/max(maximum-minimum,0.000001))
        let p=n*Double(values.count-1),i=min(values.count-2,Int(p)),f=p-Double(i)
        return values[i]+(values[i+1]-values[i])*f
    }
}
