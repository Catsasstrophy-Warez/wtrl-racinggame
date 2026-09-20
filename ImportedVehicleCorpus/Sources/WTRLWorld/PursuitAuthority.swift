import Foundation
import WTRLCore

public enum PursuitHeatLevel: Int, Codable, CaseIterable, Sendable { case none=0, patrol=1, active=2, interceptor=3, containment=4, critical=5 }
public struct PursuitState: Codable, Hashable, Sendable {
    public var heat: PursuitHeatLevel = .none
    public var observedViolationPoints = 0.0
    public var lineOfSightLostSeconds = 0.0
    public var outstandingFineCredits = 0.0
    public var impoundRisk01 = 0.0
    public init() {}
}
public enum PursuitAuthority {
    public static func recordObservedViolation(points:Double, repairOrPropertyLiabilityCredits:Double, state:inout PursuitState) {
        state.observedViolationPoints=max(0,state.observedViolationPoints+points)
        state.outstandingFineCredits += max(0,repairOrPropertyLiabilityCredits)
        let level = min(5, Int(state.observedViolationPoints / 20.0) + (state.observedViolationPoints > 0 ? 1 : 0))
        state.heat=PursuitHeatLevel(rawValue:level) ?? .critical
        state.impoundRisk01=WTRLMath.clamp01(Double(max(0,level-2))/3)
        state.lineOfSightLostSeconds=0
    }
    public static func updateVisibility(isObserved:Bool, dt:Double, state:inout PursuitState) {
        if isObserved { state.lineOfSightLostSeconds=0; return }
        state.lineOfSightLostSeconds += max(dt,0)
        if state.lineOfSightLostSeconds >= 20, state.heat.rawValue > 0 {
            state.heat=PursuitHeatLevel(rawValue:state.heat.rawValue-1) ?? .none
            state.lineOfSightLostSeconds=0
        }
    }
}
