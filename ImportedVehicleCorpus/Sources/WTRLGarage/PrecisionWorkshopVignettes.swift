import Foundation

public struct ValveLashState:Codable,Hashable,Sendable { public var measuredMm=0.55,targetMm=0.30,toleranceMm=0.04,locked=false,safeRpmCeiling=5200.0; public init(){} }
public enum ValveLashResult:Equatable,Sendable { case tooTight,tooLoose,withinSpec }
public enum PrecisionValveLashAuthority {
 public static func adjust(state:inout ValveLashState,deltaMm:Double)->ValveLashResult { guard !state.locked else{return abs(state.measuredMm-state.targetMm)<=state.toleranceMm ? .withinSpec : (state.measuredMm<state.targetMm ? .tooTight:.tooLoose)};state.measuredMm=max(0.05,state.measuredMm+deltaMm);let e=state.measuredMm-state.targetMm;if e < -state.toleranceMm {state.safeRpmCeiling=4800;return .tooTight};if e > state.toleranceMm {state.safeRpmCeiling=5200;return .tooLoose};state.safeRpmCeiling=6800;return .withinSpec }
 public static func lock(state:inout ValveLashState)->Bool {guard abs(state.measuredMm-state.targetMm)<=state.toleranceMm else{return false};state.locked=true;return true}
}
public struct DwellCalibrationState:Codable,Hashable,Sendable {public var pointGapMm=0.55,dwellDeg=22.0,coilTemperatureC=35.0;public init(){}}
public enum DwellCalibrationAuthority {public static func setGap(state:inout DwellCalibrationState,gapMm:Double){state.pointGapMm=max(0.1,min(1,gapMm));state.dwellDeg=max(12,min(42,39-state.pointGapMm*30))};public static func step(state:inout DwellCalibrationState,rpm:Double,dt:Double){let excess=max(0,state.dwellDeg-32);state.coilTemperatureC += (excess*0.08 + rpm/7000*0.03)*dt}}
