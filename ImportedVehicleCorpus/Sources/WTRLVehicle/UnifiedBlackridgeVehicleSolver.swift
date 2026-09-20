import Foundation

public struct WheelEnvironmentInput: Codable, Hashable, Sendable {
    public var roadHeightM = 0.0
    public var effectiveMu = 0.94
    public var roughness01 = 0.04
    public var waterFilmMm = 0.0
    public var ambientC = 22.0
    public init() {}
}

public struct FourWheelEnvironmentInput: Codable, Hashable, Sendable {
    public var frontLeft=WheelEnvironmentInput(), frontRight=WheelEnvironmentInput(), rearLeft=WheelEnvironmentInput(), rearRight=WheelEnvironmentInput()
    public init() {}
    public subscript(_ c: VehicleCorner) -> WheelEnvironmentInput {
        get { switch c { case .frontLeft:return frontLeft; case .frontRight:return frontRight; case .rearLeft:return rearLeft; case .rearRight:return rearRight } }
        set { switch c { case .frontLeft:frontLeft=newValue; case .frontRight:frontRight=newValue; case .rearLeft:rearLeft=newValue; case .rearRight:rearRight=newValue } }
    }
}

public struct UnifiedBlackridgeVehicleInput: Sendable {
    public var throttle=0.0, brake01=0.0, engineRPM=900.0, gearboxOutputOmega=0.0, pinionOmega=0.0
    public var steeringSlipAngleDeg=0.0, chassisRigidity01=0.5, tirePressureKPa=220.0
    public var geometry=VehicleGeometry(), tireCoefficients=EmpiricalTireCoefficients(), suspension=SuspensionAxleParameters()
    public var frontAlignment=SuspensionAlignmentCurve(), rearAlignment=SuspensionAlignmentCurve(), lsd=LimitedSlipParameters()
    public var environment=FourWheelEnvironmentInput()
    public var persistentDamage=PersistentVehicleDamageState()
    public init() {}
}

public struct UnifiedBlackridgeVehicleState: Codable, Hashable, Sendable {
    public var powertrain=UnifiedPowertrainState(), tires=FourCornerTireState(), suspension=FourCornerSuspensionState()
    public var chassis=ChassisStructureState(), cooling=CoolingThermalState(), brakes=BrakeThermalState(), vibration=VibrationFatigueState()
    public var hubFrontLeft=HubBearingState(), hubFrontRight=HubBearingState(), hubRearLeft=HubBearingState(), hubRearRight=HubBearingState()
    public var damperFrontLeft=DamperThermalState(), damperFrontRight=DamperThermalState(), damperRearLeft=DamperThermalState(), damperRearRight=DamperThermalState()
    public var axleHop=WheelHopSpectralObserver(), body=BodyAttitudeState()
    public var speedMps=0.0, longitudinalAccelerationMps2=0.0, lateralAccelerationMps2=0.0, distanceM=0.0
    public var lastChassisFlex=ChassisFlexResult(), lastDifferentialSplit=AxleTorqueSplit(), lastMaxTireUtilization01=0.0, diagnosticSeverity01=0.0
    public init() {}
    public subscript(hub c:VehicleCorner)->HubBearingState { get { switch c {case .frontLeft:return hubFrontLeft;case .frontRight:return hubFrontRight;case .rearLeft:return hubRearLeft;case .rearRight:return hubRearRight} } set { switch c {case .frontLeft:hubFrontLeft=newValue;case .frontRight:hubFrontRight=newValue;case .rearLeft:hubRearLeft=newValue;case .rearRight:hubRearRight=newValue} } }
    public subscript(damper c:VehicleCorner)->DamperThermalState { get { switch c {case .frontLeft:return damperFrontLeft;case .frontRight:return damperFrontRight;case .rearLeft:return damperRearLeft;case .rearRight:return damperRearRight} } set { switch c {case .frontLeft:damperFrontLeft=newValue;case .frontRight:damperFrontRight=newValue;case .rearLeft:damperRearLeft=newValue;case .rearRight:damperRearRight=newValue} } }
}

public struct UnifiedBlackridgeVehicleOutput: Sendable {
    public var totalLongitudinalForceN=0.0, totalLateralForceN=0.0, maxTireUtilization01=0.0, wheelHopFrequencyHz=0.0
    public var chassisTwistDeg=0.0, coolantC=0.0, clutchC=0.0, evidence:[String]=[]
    public init() {}
}

public enum UnifiedBlackridgeVehicleAuthority {
    public static func step(state s: inout UnifiedBlackridgeVehicleState, input i: UnifiedBlackridgeVehicleInput, differentialSetup: DifferentialSetupQuality, powertrain p: UnifiedPowertrainParameters = .init(), chassisSpec: ChassisStructureSpec = .init(), dt: Double) -> UnifiedBlackridgeVehicleOutput {
        let h=max(1.0/1000.0,dt)
        var road=RoadCornerHeights(); for c in VehicleCorner.allCases { road[c]=i.environment[c].roadHeightM }
        FourCornerSuspensionAuthority.step(state:&s.suspension,road:road,p:i.suspension,dt:h)
        let quasi=FourCornerLoadAuthority.evaluate(geometry:i.geometry,longitudinalAccelerationMps2:s.longitudinalAccelerationMps2,lateralAccelerationMps2:s.lateralAccelerationMps2)
        let loads=SuspensionTireCouplingAuthority.dynamicLoads(suspension:s.suspension,quasiStatic:quasi)
        s.body=SuspensionTireCouplingAuthority.attitude(suspension:s.suspension,geometry:i.geometry)
        let lateralTorque=i.geometry.massKg*s.lateralAccelerationMps2*i.geometry.cgHeightM
        s.lastChassisFlex=StructuralFatigueAuthority.step(state:&s.chassis,spec:chassisSpec,drivelineReactionNm:s.powertrain.wheelTorqueNm/max(p.finalDriveRatio,0.1),lateralLoadTransferTorqueNm:lateralTorque,dt:h)
        s.powertrain.engineRPM=i.engineRPM
        let drive=UnifiedPowertrainAuthority.step(state:&s.powertrain,throttle:i.throttle,gearboxOutputOmega:i.gearboxOutputOmega,pinionOmega:i.pinionOmega,dt:h,p:p)
        s.lastDifferentialSplit=LimitedSlipDifferentialAuthority.split(inputTorqueNm:drive.wheelTorqueNm,leftOmega:s.tires.rearLeft.wheelOmegaRadPerSec,rightOmega:s.tires.rearRight.wheelOmegaRadPerSec,p:i.lsd)
        var totalX=0.0,totalY=0.0,maxUtil=0.0,rearSlip:[Double]=[]
        for c in VehicleCorner.allCases {
            var tire=s.tires[c]; let rear=(c == .rearLeft || c == .rearRight)
            let torque = rear ? (c == .rearLeft ? s.lastDifferentialSplit.leftNm:s.lastDifferentialSplit.rightNm) : 0
            if rear { tire.wheelOmegaRadPerSec += torque/max(1.5,0.45*loads[c]*p.wheelRadiusM*p.wheelRadiusM/9.80665)*h } else { tire.wheelOmegaRadPerSec=s.speedMps/max(p.wheelRadiusM,0.05) }
            tire.normalLoadN=loads[c]; tire.slipRatio=(tire.wheelOmegaRadPerSec*p.wheelRadiusM-s.speedMps)/max(abs(s.speedMps),2)
            tire.slipAngleDeg=rear ? -0.35*i.steeringSlipAngleDeg:i.steeringSlipAngleDeg
            let geometricAlign=SuspensionTireCouplingAuthority.alignment(corner:c,suspension:s.suspension,front:i.frontAlignment,rear:i.rearAlignment)
            let cornerDamage=i.persistentDamage[c]
            let baseAlign=PersistentMechanicalDamageAuthority.adjustedAlignment(base:geometricAlign,damage:cornerDamage)
            let side=(c == .frontLeft || c == .rearLeft) ? 1.0:-1.0
            let flexCamber=(c == .frontLeft || c == .frontRight) ? s.lastChassisFlex.frontCamberDistortionDeg*side:0
            var ti=EmpiricalTireInput();ti.coefficients=i.tireCoefficients;ti.normalLoadN=loads[c];ti.speedMps=s.speedMps;ti.slipRatio=tire.slipRatio;ti.slipAngleDeg=tire.slipAngleDeg;ti.camberDeg=baseAlign.camberDeg+flexCamber;ti.pressureKpa=min(i.tirePressureKPa,cornerDamage.tirePressureKPa);ti.temperatureC=tire.temperatureC;ti.wear01=tire.wear01;ti.surfaceGrip01=i.environment[c].effectiveMu*PersistentMechanicalDamageAuthority.pressureGripScale(cornerDamage);ti.water01=min(1,i.environment[c].waterFilmMm/8);ti.previousLongitudinalN=tire.longitudinalForceN;ti.previousLateralN=tire.lateralForceN;ti.deltaTime=h
            let r=EmpiricalTireModel.evaluate(ti);tire.longitudinalForceN=r.longitudinalN;tire.lateralForceN=r.lateralN;tire.utilization01=r.utilization01;tire.verticalDeflectionM=r.verticalDeflectionM
            let slipEnergy=abs(r.longitudinalN*tire.slipRatio*s.speedMps)+abs(r.lateralN*tan(tire.slipAngleDeg*Double.pi/180)*s.speedMps);tire.temperatureC += slipEnergy/65_000*h+(i.environment[c].ambientC-tire.temperatureC)*0.003*h;tire.wear01=min(1,tire.wear01+slipEnergy*h/1_200_000_000)
            s.tires[c]=tire;totalX += r.longitudinalN;totalY += r.lateralN;maxUtil=max(maxUtil,r.utilization01);if rear {rearSlip.append(tire.slipRatio)}
            var hub=s[hub:c];HubBearingAuthority.step(state:&hub,radialLoadN:loads[c],lateralLoadN:abs(r.lateralN),misalignmentDeg:abs(baseAlign.toeDeg)+abs(s.lastChassisFlex.rearToeDistortionDeg),dt:h);s[hub:c]=hub
            var damper=s[damper:c];let cs=s.suspension[c];DamperThermalAuthority.step(state:&damper,damperForceN:cs.damperForceN,shaftVelocityMps:cs.sprungVelocityMps-cs.unsprungVelocityMps,ambientC:i.environment[c].ambientC,dt:h);s[damper:c]=damper
        }
        let brakeCapacity=max(0,i.brake01)*i.geometry.massKg*9.80665*max(0.2,min(1.3,(i.environment.frontLeft.effectiveMu+i.environment.frontRight.effectiveMu)*0.5))
        let rolling=0.012*i.geometry.massKg*9.80665;let net=totalX-brakeCapacity-rolling;let old=s.speedMps;s.longitudinalAccelerationMps2=net/max(i.geometry.massKg,1);s.lateralAccelerationMps2=totalY/max(i.geometry.massKg,1);s.speedMps=max(0,s.speedMps+s.longitudinalAccelerationMps2*h);s.distanceM += s.speedMps*h
        BrakeThermalAuthority.step(state:&s.brakes,vehicleMassKg:i.geometry.massKg,speedBeforeMps:old,speedAfterMps:s.speedMps,frontBias01:0.68,thermalCapacityJPerK:120_000,cooling01:min(1,0.25+s.speedMps/35),dt:h)
        CoolingThermalAuthority.step(state:&s.cooling,engineWasteHeatKW:drive.engineTorqueNm*max(0,i.engineRPM)*2*Double.pi/60/1000*0.62,airSpeedMps:s.speedMps,ambientC:i.environment.frontLeft.ambientC,radiatorCapacityKWPerC:0.42,dt:h)
        let hopSignal=(rearSlip.count==2 ? rearSlip[0]-rearSlip[1]:0)+s.powertrain.driveline.relativeTwistRad*2;s.axleHop.append(hopSignal);let hopHz=s.axleHop.dominantFrequencyHz()
        VibrationFatigueAuthority.step(state:&s.vibration,rpm:i.engineRPM,vibrationG:0.2+(hopHz>0 ? 1.0:0),componentAge01:0.55,fastenerRetention01:0.72,dt:h)
        s.lastMaxTireUtilization01=maxUtil;s.diagnosticSeverity01=min(1,max(maxUtil,max(s.chassis.fatigueDamage01,s.cooling.heatSoak01)))
        var out=UnifiedBlackridgeVehicleOutput();out.totalLongitudinalForceN=totalX;out.totalLateralForceN=totalY;out.maxTireUtilization01=maxUtil;out.wheelHopFrequencyHz=hopHz;out.chassisTwistDeg=s.lastChassisFlex.twistDeg;out.coolantC=s.cooling.coolantC;out.clutchC=s.powertrain.clutchTemperatureC
        if s.cooling.heatSoak01>0.4 {out.evidence.append("Cooling heat soak is reducing thermal margin.")};if s.chassis.fatigueDamage01>0.2 {out.evidence.append("Persistent chassis fatigue is affecting structural stiffness.")};if hopHz>=6 && hopHz<=25 {out.evidence.append("Rear driveline/suspension oscillation is present in the wheel-hop band.")};if maxUtil>0.95 {out.evidence.append("At least one tire is operating at the current traction boundary.")}
        return out
    }
}
