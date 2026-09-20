import Testing
@testable import WTRLVehicle

@Test func bumpExcitesUnsprungAndSprungMasses() {
 var s=CornerSuspensionState(),p=CornerSuspensionParameters()
 for n in 0..<300 { CornerSuspensionAuthority.step(state:&s,roadHeightM:(n>20 && n<35) ? 0.025:0,antiRollForceN:0,p:p,dt:0.001) }
 #expect(abs(s.unsprungPositionM)>0.00001); #expect(abs(s.sprungPositionM)>0.000001)
}
@Test func antiRollCouplesLeftAndRightCorners() {
 var s=FourCornerSuspensionState(),p=SuspensionAxleParameters(),r=RoadCornerHeights();r.frontLeft=0.03
 for _ in 0..<300 { FourCornerSuspensionAuthority.step(state:&s,road:r,p:p,dt:0.001) }
 #expect(s.frontLeft.sprungPositionM != s.frontRight.sprungPositionM)
}
@Test func bumpStopGeneratesProgressiveForce() {
 var s=CornerSuspensionState();s.sprungPositionM=0.10
 CornerSuspensionAuthority.step(state:&s,roadHeightM:0,antiRollForceN:0,p:.init(),dt:0.001)
 #expect(abs(s.bumpStopForceN)>0)
}
@Test func fictionalSpecialsRemainResearchGated() {
 #expect(FictionalLineageSpecialCatalog.specials.count==9)
 #expect(FictionalLineageSpecialCatalog.specials.allSatisfy{$0.sourceStatus.contains("research-gated")})
 #expect(Set(FictionalLineageSpecialCatalog.specials.map{$0.rearArchitecture}).count>=5)
}
@Test func threeBuildPhilosophiesCreateDifferentConsequences() {
 let p=BuildPhilosophyAuthority.assess(.preserved,modernization01:0.05,chassisCuts:0,periodCorrect01:0.95)
 let o=BuildPhilosophyAuthority.assess(.periodOutlaw,modernization01:0.15,chassisCuts:2,periodCorrect01:0.9)
 let l=BuildPhilosophyAuthority.assess(.livingShip,modernization01:0.9,chassisCuts:5,periodCorrect01:0.2)
 #expect(p.historicEligibility01>o.historicEligibility01);#expect(l.modernCapability01>p.modernCapability01);#expect(l.restorationCostMultiplier>o.restorationCostMultiplier)
}
