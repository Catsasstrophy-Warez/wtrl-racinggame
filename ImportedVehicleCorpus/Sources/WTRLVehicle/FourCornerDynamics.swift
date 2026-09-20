import Foundation

public enum VehicleCorner:String,Codable,CaseIterable,Sendable { case frontLeft,frontRight,rearLeft,rearRight }
public struct VehicleGeometry:Codable,Hashable,Sendable {
    public var massKg=1450.0, wheelbaseM=2.70, frontTrackM=1.56, rearTrackM=1.56, cgHeightM=0.52, frontStaticWeightFraction=0.54
    public init(){}
}
public struct FourCornerLoads:Codable,Hashable,Sendable {
    public var frontLeftN=0.0,frontRightN=0.0,rearLeftN=0.0,rearRightN=0.0
    public init(){}
    public subscript(_ c:VehicleCorner)->Double {
        get { switch c {case .frontLeft:return frontLeftN;case .frontRight:return frontRightN;case .rearLeft:return rearLeftN;case .rearRight:return rearRightN} }
        set { switch c {case .frontLeft:frontLeftN=newValue;case .frontRight:frontRightN=newValue;case .rearLeft:rearLeftN=newValue;case .rearRight:rearRightN=newValue} }
    }
}
public enum FourCornerLoadAuthority {
    /// Quasi-static load transfer authority. Positive longitudinal acceleration transfers load rearward.
    /// Positive lateral acceleration transfers load to the right side.
    public static func evaluate(geometry g:VehicleGeometry,longitudinalAccelerationMps2 ax:Double,lateralAccelerationMps2 ay:Double)->FourCornerLoads {
        let gravity=9.80665,total=g.massKg*gravity
        let frontStatic=total*g.frontStaticWeightFraction,rearStatic=total-frontStatic
        let longitudinal=g.massKg*ax*g.cgHeightM/max(g.wheelbaseM,0.1)
        let front=max(0,frontStatic-longitudinal),rear=max(0,rearStatic+longitudinal)
        let frontLat=g.massKg*ay*g.cgHeightM*g.frontStaticWeightFraction/max(g.frontTrackM,0.1)
        let rearLat=g.massKg*ay*g.cgHeightM*(1-g.frontStaticWeightFraction)/max(g.rearTrackM,0.1)
        var result=FourCornerLoads()
        result.frontLeftN=max(0,front*0.5-frontLat*0.5)
        result.frontRightN=max(0,front*0.5+frontLat*0.5)
        result.rearLeftN=max(0,rear*0.5-rearLat*0.5)
        result.rearRightN=max(0,rear*0.5+rearLat*0.5)
        return result
    }
}

public struct TireCornerState:Codable,Hashable,Sendable {
    public var wheelOmegaRadPerSec=0.0,slipRatio=0.0,slipAngleDeg=0.0,temperatureC=82.0,wear01=0.0
    public var longitudinalForceN=0.0,lateralForceN=0.0,normalLoadN=0.0,utilization01=0.0,verticalDeflectionM=0.0
    public init(){}
}
public struct FourCornerTireState:Codable,Hashable,Sendable {
    public var frontLeft=TireCornerState(),frontRight=TireCornerState(),rearLeft=TireCornerState(),rearRight=TireCornerState()
    public init(){}
    public subscript(_ c:VehicleCorner)->TireCornerState {
        get { switch c {case .frontLeft:return frontLeft;case .frontRight:return frontRight;case .rearLeft:return rearLeft;case .rearRight:return rearRight} }
        set { switch c {case .frontLeft:frontLeft=newValue;case .frontRight:frontRight=newValue;case .rearLeft:rearLeft=newValue;case .rearRight:rearRight=newValue} }
    }
}
public struct FourCornerTireInput:Sendable {
    public var speedMps=0.0,longitudinalAccelerationMps2=0.0,lateralAccelerationMps2=0.0,steeringSlipAngleDeg=0.0
    public var rearDriveTorqueNm=0.0,wheelRadiusM=0.33,surfaceGrip01=1.0,water01=0.0,pressureKpa=220.0
    public var geometry=VehicleGeometry(),coefficients=EmpiricalTireCoefficients(),dt=0.01
    public init(){}
}
public struct FourCornerTireOutput:Sendable {
    public var totalLongitudinalN=0.0,totalLateralN=0.0,rearSlipDifference=0.0,maxUtilization01=0.0
    public var loads=FourCornerLoads()
    public init(){}
}
public enum FourCornerTireAuthority {
    public static func step(state:inout FourCornerTireState,input i:FourCornerTireInput)->FourCornerTireOutput {
        let loads=FourCornerLoadAuthority.evaluate(geometry:i.geometry,longitudinalAccelerationMps2:i.longitudinalAccelerationMps2,lateralAccelerationMps2:i.lateralAccelerationMps2)
        var output=FourCornerTireOutput(); output.loads=loads
        for corner in VehicleCorner.allCases {
            var s=state[corner]; s.normalLoadN=loads[corner]
            let rear = corner == .rearLeft || corner == .rearRight
            if rear {
                let torquePerWheel=i.rearDriveTorqueNm*0.5
                s.wheelOmegaRadPerSec += torquePerWheel/max(1.6,0.5*s.normalLoadN*i.wheelRadiusM*i.wheelRadiusM/9.80665)*i.dt
            } else { s.wheelOmegaRadPerSec=i.speedMps/max(i.wheelRadiusM,0.05) }
            let wheelLinear=s.wheelOmegaRadPerSec*i.wheelRadiusM
            s.slipRatio=(wheelLinear-i.speedMps)/max(abs(i.speedMps),2)
            s.slipAngleDeg = rear ? -0.35*i.steeringSlipAngleDeg : i.steeringSlipAngleDeg
            var ti=EmpiricalTireInput(); ti.coefficients=i.coefficients;ti.normalLoadN=s.normalLoadN;ti.speedMps=i.speedMps;ti.slipRatio=s.slipRatio;ti.slipAngleDeg=s.slipAngleDeg;ti.pressureKpa=i.pressureKpa;ti.temperatureC=s.temperatureC;ti.wear01=s.wear01;ti.surfaceGrip01=i.surfaceGrip01;ti.water01=i.water01;ti.previousLongitudinalN=s.longitudinalForceN;ti.previousLateralN=s.lateralForceN;ti.deltaTime=i.dt
            let r=EmpiricalTireModel.evaluate(ti)
            s.longitudinalForceN=r.longitudinalN;s.lateralForceN=r.lateralN;s.utilization01=r.utilization01;s.verticalDeflectionM=r.verticalDeflectionM
            let slipEnergy=abs(r.longitudinalN*s.slipRatio*i.speedMps)+abs(r.lateralN*tan(s.slipAngleDeg*Double.pi/180)*i.speedMps)
            s.temperatureC += slipEnergy/65_000*i.dt+(35-s.temperatureC)*0.003*i.dt
            s.wear01=min(1,s.wear01+slipEnergy*i.dt/1_200_000_000)
            state[corner]=s
            output.totalLongitudinalN += r.longitudinalN;output.totalLateralN += r.lateralN;output.maxUtilization01=max(output.maxUtilization01,r.utilization01)
        }
        output.rearSlipDifference=abs(state.rearLeft.slipRatio-state.rearRight.slipRatio)
        return output
    }
}

public struct AxleHopObserverState:Codable,Hashable,Sendable {
    public var filteredRearLoadN=0.0,previousRearLoadN=0.0,oscillationEnergy=0.0,frequencyHz=0.0,confidence01=0.0
    public init(){}
}
public enum AxleHopObserver {
    public static func step(state:inout AxleHopObserverState,rearLoadN:Double,drivelineTwistRad:Double,rearSlipDifference:Double,dt:Double) {
        let alpha=min(1,dt*30); state.filteredRearLoadN += (rearLoadN-state.filteredRearLoadN)*alpha
        let derivative=(state.filteredRearLoadN-state.previousRearLoadN)/max(dt,0.0001);state.previousRearLoadN=state.filteredRearLoadN
        let excitation=abs(derivative)*0.00003+abs(drivelineTwistRad)*28+rearSlipDifference*0.8
        state.oscillationEnergy += (excitation-state.oscillationEnergy)*min(1,dt*12)
        state.frequencyHz=min(30,max(0,6+state.oscillationEnergy*5))
        let band = state.frequencyHz >= 8 && state.frequencyHz <= 20 ? 1.0 : 0.25
        state.confidence01=min(1,state.oscillationEnergy*band)
    }
}
