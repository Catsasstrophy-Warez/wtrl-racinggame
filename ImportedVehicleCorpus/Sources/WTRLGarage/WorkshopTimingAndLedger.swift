import Foundation
import WTRLVehicle

public struct IgnitionTimingState:Codable,Hashable,Sendable {public var clampTight=false,timingLightOnCylinderOne=false,engineRunning=false,initialAdvanceDeg=6.0,knockEvents=0;public init(){}}
public enum TimingFeedback:Codable,Hashable,Sendable {case clampLocked,connectTimingLight,startEngine,retarded(Double),advancedRisk(Double),withinCalibrationWindow}
public enum IgnitionTimingAuthority {
    public static func adjust(_ s:inout IgnitionTimingState,deltaDeg:Double,targetDeg:Double,toleranceDeg:Double=1.5)->TimingFeedback {
        guard !s.clampTight else{return .clampLocked};s.initialAdvanceDeg=max(-15,min(30,s.initialAdvanceDeg+deltaDeg));guard s.timingLightOnCylinderOne else{return .connectTimingLight};guard s.engineRunning else{return .startEngine}
        let e=s.initialAdvanceDeg-targetDeg;if e < -toleranceDeg{return .retarded(abs(e))};if e > toleranceDeg {if e>4{s.knockEvents += 1};return .advancedRisk(e)};return .withinCalibrationWindow
    }
}
public struct PersistentDamageLedger:Codable,Hashable,Sendable {public var bumperDamage01=0.0,radiatorDamage01=0.0,headGasketDamage01=0.0,rightFrontArmDamage01=0.0,clutchWear01=0.0,chassisSet01=0.0;public var paidRepairCredits=0;public init(){};public var estimatedRepairCredits:Int {Int(bumperDamage01*450+radiatorDamage01*620+headGasketDamage01*1200+rightFrontArmDamage01*540+clutchWear01*880+chassisSet01*1800)}}
public struct CompetitionBracket:Codable,Hashable,Sendable {public var id:String;public var maximumPowerKW:Double,minimumMassKg:Double,maximumTireWidthMM:Double,forcedInductionAllowed:Bool,maximumBuildCredits:Int;public init(id:String,maximumPowerKW:Double,minimumMassKg:Double,maximumTireWidthMM:Double,forcedInductionAllowed:Bool,maximumBuildCredits:Int){self.id=id;self.maximumPowerKW=maximumPowerKW;self.minimumMassKg=minimumMassKg;self.maximumTireWidthMM=maximumTireWidthMM;self.forcedInductionAllowed=forcedInductionAllowed;self.maximumBuildCredits=maximumBuildCredits}}
public enum BracketAuditAuthority {public static func reasons(powerKW:Double,massKg:Double,tireWidthMM:Double,forcedInduction:Bool,buildCredits:Int,bracket b:CompetitionBracket)->[String]{var r:[String]=[];if powerKW>b.maximumPowerKW{r.append("power")};if massKg<b.minimumMassKg{r.append("mass")};if tireWidthMM>b.maximumTireWidthMM{r.append("tireWidth")};if forcedInduction && !b.forcedInductionAllowed{r.append("forcedInduction")};if buildCredits>b.maximumBuildCredits{r.append("budget")};return r}}
