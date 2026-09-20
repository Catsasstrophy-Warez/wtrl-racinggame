import Testing
import WTRLCore
import WTRLVehicle
import WTRLRacing
import WTRLGarage
import WTRLWorld
@Suite("Rev19 advanced expansion") struct Rev19AdvancedExpansionTests {
 @Test func aeroStallReducesUnderbodyEfficiency(){let a=AerodynamicDynamicsAuthority.evaluate(speedMps:60,frontRideHeightM:0.045,rearRideHeightM:0.065,drs:false);let b=AerodynamicDynamicsAuthority.evaluate(speedMps:60,frontRideHeightM:0.012,rearRideHeightM:0.065,drs:false);#expect(!a.stalled);#expect(b.stalled);#expect(a.frontDownforceN>b.frontDownforceN)}
 @Test func drsReducesDrag(){let a=AerodynamicDynamicsAuthority.evaluate(speedMps:55,frontRideHeightM:0.045,rearRideHeightM:0.06,drs:false);let b=AerodynamicDynamicsAuthority.evaluate(speedMps:55,frontRideHeightM:0.045,rearRideHeightM:0.06,drs:true);#expect(b.dragN<a.dragN)}
 @Test func ghostInterpolatesAndWrapsYaw(){let f=[QuantizedGhostKeyframe(time:0,position:.init(0,0,0),yawRad:6.2,steer01:0,brake:false,smoke:false),QuantizedGhostKeyframe(time:0.1,position:.init(20,0,0),yawRad:0.1,steer01:0.2,brake:true,smoke:true)];let s=CompactGhostAuthority.sample(time:0.05,frames:f)!;#expect(abs(s.position.x-10)<0.02);#expect(s.brake && s.smoke)}
 @Test func rotisserieRequiresRustRepairBeforePrimer(){var s=RotisserieRestorationState();#expect(RotisserieRestorationAuthority.advance(&s,to:.stripped));#expect(RotisserieRestorationAuthority.advance(&s,to:.mediaBlasted));#expect(RotisserieRestorationAuthority.advance(&s,to:.metalRepair));#expect(RotisserieRestorationAuthority.advance(&s,to:.structuralMeasurement));#expect(RotisserieRestorationAuthority.advance(&s,to:.fabrication));#expect(!RotisserieRestorationAuthority.advance(&s,to:.primer));s.rust01=0.04;#expect(RotisserieRestorationAuthority.advance(&s,to:.primer))}
 @Test func pursuitNeverCommandsCollision(){let d=PursuitTacticalAuthority.resolve(heat01:1,playerSpeedMps:40,distanceM:4);#expect(d.requestRoadblock);#expect(!d.contactInterventionAllowed)}
 @Test func unifiedClutchCanGlaze(){var s=UnifiedPowertrainState();s.engineRPM=6200;s.clutchTemperatureC=275;let p=UnifiedPowertrainParameters();_ = UnifiedPowertrainAuthority.step(state:&s,throttle:1,gearboxOutputOmega:10,pinionOmega:0,dt:0.1,clutchEngagement01:0.6,p:p);#expect(s.clutchGlazed)}
}
