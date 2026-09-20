import Foundation
import WTRLCore

public struct DriverInputSample:Codable,Hashable,Sendable {public var steering=0.0,throttle=0.0,brake=0.0;public init(){}}
public struct InputJerkState:Codable,Hashable,Sendable {public var previous=DriverInputSample();public var oscillation01=0.0;public init(){}}
public enum InputJerkModel {
    public static func update(_ state:inout InputJerkState,current:DriverInputSample,dt:Double)->Double {
        let d=max(dt,0.001)
        let rate=sqrt(pow((current.steering-state.previous.steering)/d,2)+pow((current.throttle-state.previous.throttle)/d,2)+pow((current.brake-state.previous.brake)/d,2))
        let excitation=WTRLMath.clamp01(rate/8)
        let decay=exp(-d*4.0)
        state.oscillation01=WTRLMath.clamp01(state.oscillation01*decay+excitation*(1-decay))
        state.previous=current
        return state.oscillation01
    }
}
