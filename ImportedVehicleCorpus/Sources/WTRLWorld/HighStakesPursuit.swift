import Foundation
import WTRLCore
import WTRLVehicle

public enum EnforcementTier:Int,Codable,CaseIterable,Sendable { case county=1, highway, heavyContainment, specialInterdiction, stateHunter }
public struct EnforcementUnitProfile:Codable,Hashable,Sendable {
 public var id:String,tier:EnforcementTier,massKg:Double,powerKW:Double,maxSpeedMps:Double,cornering01:Double,containment01:Double
 public init(id:String,tier:EnforcementTier,massKg:Double,powerKW:Double,maxSpeedMps:Double,cornering01:Double,containment01:Double){self.id=id;self.tier=tier;self.massKg=massKg;self.powerKW=powerKW;self.maxSpeedMps=maxSpeedMps;self.cornering01=cornering01;self.containment01=containment01}
}
public enum EnforcementFleetAuthority {
 public static let profiles:[EnforcementUnitProfile] = [
  .init(id:"sentinel_v8",tier:.county,massKg:1880,powerKW:186,maxSpeedMps:55,cornering01:0.42,containment01:0.55),
  .init(id:"vector_interceptor",tier:.highway,massKg:1640,powerKW:362,maxSpeedMps:72,cornering01:0.70,containment01:0.62),
  .init(id:"rhino_containment",tier:.heavyContainment,massKg:4200,powerKW:447,maxSpeedMps:48,cornering01:0.28,containment01:0.96),
  .init(id:"phantom_special",tier:.specialInterdiction,massKg:1480,powerKW:410,maxSpeedMps:78,cornering01:0.91,containment01:0.60),
  .init(id:"apex_state_hunter",tier:.stateHunter,massKg:1580,powerKW:560,maxSpeedMps:84,cornering01:0.94,containment01:0.78)]
 public static func eligible(heat:PursuitHeatLevel,zone:SanTrianaZone?)->[EnforcementUnitProfile] { profiles.filter { p in p.tier.rawValue <= max(1,heat.rawValue) && (p.tier != .specialInterdiction || zone == .crest) } }
}

public struct PursuitTetherState:Codable,Hashable,Sendable { public var attached=false,restLengthM=14.0,stiffnessNPerM=32000.0,dampingNsPerM=2600.0,breakForceN=48000.0,lastLengthM=14.0; public init(){} }
public struct PursuitTetherOutput:Codable,Hashable,Sendable { public var tensionN:Double, forceX:Double, forceZ:Double, snapped:Bool; public init(tensionN:Double=0,forceX:Double=0,forceZ:Double=0,snapped:Bool=false){self.tensionN=tensionN;self.forceX=forceX;self.forceZ=forceZ;self.snapped=snapped} }
public enum PursuitTetherAuthority {
 public static func step(state: inout PursuitTetherState, playerX: Double, playerZ: Double, anchorX: Double, anchorZ: Double, dt: Double) -> PursuitTetherOutput {
  guard state.attached else { return PursuitTetherOutput() }
  let dx = anchorX - playerX
  let dz = anchorZ - playerZ
  let length = max(0.001, hypot(dx, dz))
  let extensionM = max(0, length - state.restLengthM)
  let rate = (length - state.lastLengthM) / max(0.001, dt)
  state.lastLengthM = length
  let spring = state.stiffnessNPerM * extensionM
  let damper = state.dampingNsPerM * rate
  let tension = max(0, spring + damper)
  if tension >= state.breakForceN { state.attached = false; return PursuitTetherOutput(tensionN:tension,snapped:true) }
  let fx = dx / length * tension
  let fz = dz / length * tension
  return PursuitTetherOutput(tensionN:tension,forceX:fx,forceZ:fz)
 }
}

public struct TirePunctureState:Codable,Hashable,Sendable { public var pressureKPa:[Double]=Array(repeating:220.6,count:4),targetKPa:[Double]=Array(repeating:220.6,count:4),leakTimeConstantS:[Double]=Array(repeating:999,count:4);public init(){} }
public enum TirePunctureAuthority {
 public static func puncture(_ index:Int,state:inout TirePunctureState,severity01:Double=1){guard state.pressureKPa.indices.contains(index) else{return};let s=max(0.05,min(1,severity01));state.targetKPa[index]=max(27.6,80*(1-s));state.leakTimeConstantS[index]=max(0.35,1.2/s)}
 public static func step(state:inout TirePunctureState,dt:Double){for i in state.pressureKPa.indices {let tau=max(0.05,state.leakTimeConstantS[i]);state.pressureKPa[i] += (state.targetKPa[i]-state.pressureKPa[i])*(1-exp(-max(0,dt)/tau))}}
 public static func gripMultiplier(pressureKPa:Double,nominalKPa:Double=220.6)->Double {let r=max(0,pressureKPa/max(1,nominalKPa));return max(0.16,min(1,0.12+0.88*pow(r,0.72)))}
}

public struct PursuitObserver:Codable,Hashable,Sendable { public var id:String,x:Double,z:Double,headingRad:Double,rangeM:Double=180,halfFOVRad:Double=Double.pi/3,isAirSupport=false;public init(id:String,x:Double,z:Double,headingRad:Double){self.id=id;self.x=x;self.z=z;self.headingRad=headingRad} }
public struct OcclusionSegment:Codable,Hashable,Sendable {public var ax:Double,az:Double,bx:Double,bz:Double;public init(ax:Double,az:Double,bx:Double,bz:Double){self.ax=ax;self.az=az;self.bx=bx;self.bz=bz}}
public enum PursuitVisibilityAuthority {
 static func ccw(_ ax:Double,_ az:Double,_ bx:Double,_ bz:Double,_ cx:Double,_ cz:Double)->Bool {(cz-az)*(bx-ax) > (bz-az)*(cx-ax)}
 static func intersects(_ a:(Double,Double),_ b:(Double,Double),_ c:(Double,Double),_ d:(Double,Double))->Bool {ccw(a.0,a.1,c.0,c.1,d.0,d.1) != ccw(b.0,b.1,c.0,c.1,d.0,d.1) && ccw(a.0,a.1,b.0,b.1,c.0,c.1) != ccw(a.0,a.1,b.0,b.1,d.0,d.1)}
 public static func canSee(observer:PursuitObserver,targetX:Double,targetZ:Double,occluders:[OcclusionSegment])->Bool {let dx=targetX-observer.x,dz=targetZ-observer.z,d=hypot(dx,dz);guard d<=observer.rangeM else{return false};let bearing=atan2(dx,dz),delta=atan2(sin(bearing-observer.headingRad),cos(bearing-observer.headingRad));guard abs(delta)<=observer.halfFOVRad else{return false};return !occluders.contains{intersects((observer.x,observer.z),(targetX,targetZ),($0.ax,$0.az),($0.bx,$0.bz))}}
}

public enum PursuitLifecyclePhase:String,Codable,Sendable {case cruising,active,lineOfSightLost,cooldown,escaped,contained}
public struct PursuitLifecycleState:Codable,Hashable,Sendable {public var phase:PursuitLifecyclePhase = .cruising,heat:PursuitHeatLevel = .none,cooldownRemainingS=0.0,retainedHeat01=0.0;public init(){} }
public enum PursuitLifecycleAuthority {
 public static func step(state:inout PursuitLifecycleState,observed:Bool,concealment01:Double,vehiclePowered:Bool,dt:Double){if observed {state.phase = .active;state.cooldownRemainingS=30;return};guard state.heat != .none else{state.phase = .escaped;return};if state.phase == .active {state.phase = .lineOfSightLost;state.cooldownRemainingS=30};let multiplier=1+2*max(0,min(1,concealment01))+(vehiclePowered ? 0:0.5);state.phase = .cooldown;state.cooldownRemainingS=max(0,state.cooldownRemainingS-max(0,dt)*multiplier);if state.cooldownRemainingS<=0 {state.phase = .escaped;state.retainedHeat01=max(state.retainedHeat01,Double(state.heat.rawValue)/6)}}
}

public struct ImpoundLiability:Codable,Hashable,Sendable {public var vehicleId:String,seizureCount:Int=0,towingCredits:Int=0,storageCredits:Int=0,evidenceHold=false;public init(vehicleId:String){self.vehicleId=vehicleId}}
public enum ImpoundAuthority { public static func impound(_ l:inout ImpoundLiability,heat:PursuitHeatLevel,days:Int){l.seizureCount += 1;l.towingCredits += 350+heat.rawValue*125;l.storageCredits += max(0,days)*(55+heat.rawValue*10);l.evidenceHold = heat.rawValue>=4} }

public struct PursuitMechanicalEvidence:Codable,Hashable,Sendable {public var records:[EvidenceRecord]=[];public init(){} }
public enum PursuitEvidenceAuthority { public static func capture(tether:PursuitTetherOutput,tires:TirePunctureState,subjectId:String)->PursuitMechanicalEvidence {var e=PursuitMechanicalEvidence();if tether.snapped {e.records.append(.init(authority:"PursuitTetherAuthority",kind:"tether_fracture",subjectId:subjectId,notes:"Cable tension exceeded calibrated break force."))};for (i,p) in tires.pressureKPa.enumerated() where p < 120 {e.records.append(.init(authority:"TirePunctureAuthority",kind:"rapid_pressure_loss",subjectId:subjectId,notes:"Corner \(i) pressure \(Int(p)) kPa."))};return e} }
