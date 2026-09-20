import Foundation

public struct MechanicalConsequenceState:Codable,Hashable,Sendable {
    public var differentialTemperatureC=45.0
    public var differentialWear01=0.0
    public var gearNoise01=0.0
    public var oilDebris01=0.0
    public var chassisTwistRad=0.0
    public var alignmentErrorDegrees=0.0
    public init(){}
}
public struct DifferentialSetupQuality:Codable,Hashable,Sendable {
    public var backlashError01:Double
    public var preloadError01:Double
    public var patternError01:Double
    public var fluidFill01:Double
    public init(backlashError01:Double=0,preloadError01:Double=0,patternError01:Double=0,fluidFill01:Double=1){self.backlashError01=backlashError01;self.preloadError01=preloadError01;self.patternError01=patternError01;self.fluidFill01=fluidFill01}
}
public enum MechanicalConsequenceAuthority {
    public static func step(state:inout MechanicalConsequenceState,wheelTorqueNm:Double,differentialSpeedRadPerSec:Double,setup:DifferentialSetupQuality,chassisRigidity01:Double,dt:Double) {
        let setupLoss=0.01+0.055*setup.backlashError01+0.07*setup.preloadError01+0.06*setup.patternError01+0.12*max(0,1-setup.fluidFill01)
        let heatW=abs(wheelTorqueNm*differentialSpeedRadPerSec)*setupLoss
        state.differentialTemperatureC += heatW/18_000*dt + (40-state.differentialTemperatureC)*0.006*dt
        let severity=min(1,setup.backlashError01+setup.preloadError01+setup.patternError01+max(0,1-setup.fluidFill01))
        state.differentialWear01=min(1,state.differentialWear01+severity*abs(wheelTorqueNm)*dt/28_000_000)
        state.gearNoise01=min(1,0.65*setup.backlashError01+0.55*setup.patternError01+0.35*state.differentialWear01)
        state.oilDebris01=min(1,state.oilDebris01+state.differentialWear01*dt*0.0006)
        state.chassisTwistRad=wheelTorqueNm/max(35_000,180_000*max(0.15,chassisRigidity01))
        state.alignmentErrorDegrees=abs(state.chassisTwistRad)*9.5
    }
}
