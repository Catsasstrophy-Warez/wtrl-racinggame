import Foundation

public struct AerodynamicTrimProfile: Codable, Hashable, Sendable {
    public var frontalAreaM2=2.15, baseCd=0.38, frontClA=0.42, rearClA=0.65, underbodyClA=0.55, drsDragReduction01=0.25
    public var referenceWheelbaseM=2.75, optimumFrontRideHeightM=0.045, stallRideHeightM=0.020
    public init(){}
}
public struct AerodynamicForceOutput: Codable, Hashable, Sendable {
    public var dragN:Double; public var frontDownforceN:Double; public var rearDownforceN:Double; public var underbodyEfficiency01:Double; public var stalled:Bool
}
public enum AerodynamicDynamicsAuthority {
    public static func evaluate(_ p:AerodynamicTrimProfile = .init(),speedMps:Double,frontRideHeightM:Double,rearRideHeightM:Double,drs:Bool,airDensity:Double=1.225)->AerodynamicForceOutput {
        let v=max(0,speedMps), q=0.5*max(0.7,airDensity)*v*v
        let h=max(0.001,frontRideHeightM), stall=h<p.stallRideHeightM
        let distance=abs(h-p.optimumFrontRideHeightM)
        var efficiency=max(0.30,1.0-distance/0.09)
        if stall { efficiency*=0.32 }
        let rake=(rearRideHeightM-frontRideHeightM)/max(p.referenceWheelbaseM,0.5)
        let rakeGain=max(0.72,min(1.28,1+rake*6.0))
        let drsFactor=drs ? max(0.55,1-p.drsDragReduction01) : 1
        let drag=q*p.frontalAreaM2*p.baseCd*drsFactor
        let under=q*p.underbodyClA*efficiency
        let front=q*p.frontClA*rakeGain + under*0.42
        let rear=q*p.rearClA*(drs ? 0.62:1.0) + under*0.58
        return .init(dragN:drag,frontDownforceN:front,rearDownforceN:rear,underbodyEfficiency01:efficiency,stalled:stall)
    }
}
