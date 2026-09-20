import Foundation

public struct MechanicalTelemetryFrame: Codable, Hashable, Sendable {
    public var sector=0, knockEvents=0
    public var frontBottomed=false
    public var rearTireTempC=80.0, coolantC=90.0, differentialSlipPercent=0.0
    public var steeringCenterOffsetDeg=0.0, wheelRunoutMm=0.0, bearingTempC=40.0, tirePressureKPa=220.0
    public init(){}
}
public struct DiagnosticHypothesis: Codable, Hashable, Sendable { public var title:String,confidence01:Double,evidence:[String],nextMeasurement:String; public init(title:String,confidence01:Double,evidence:[String],nextMeasurement:String){self.title=title;self.confidence01=confidence01;self.evidence=evidence;self.nextMeasurement=nextMeasurement} }
public enum MechanicalTelemetryInferenceAuthority {
    public static func analyze(_ frames:[MechanicalTelemetryFrame])->[DiagnosticHypothesis]{
        guard !frames.isEmpty else{return []}; var h:[DiagnosticHypothesis]=[]
        let knock=frames.filter{$0.knockEvents>3}; if !knock.isEmpty {h.append(.init(title:"combustion knock evidence",confidence01:min(0.92,0.55+Double(knock.count)*0.06),evidence:["repeated knock events under recorded load"],nextMeasurement:"compare fuel quality, commanded timing, mixture and cylinder-specific knock evidence"))}
        let align=frames.filter{abs($0.steeringCenterOffsetDeg)>0.25 || $0.wheelRunoutMm>1.5}; if !align.isEmpty {h.append(.init(title:"impact-related wheel/alignment change",confidence01:min(0.95,0.5+Double(align.count)*0.08),evidence:["steering center shifted or wheel runout increased"],nextMeasurement:"put the car on the alignment rack and measure wheel/tie-rod runout"))}
        let heat=frames.filter{$0.bearingTempC>75}; if !heat.isEmpty {h.append(.init(title:"wheel-bearing friction or damage",confidence01:min(0.9,0.48+Double(heat.count)*0.07),evidence:["localized bearing temperature elevated"],nextMeasurement:"compare corner temperatures, free-play and rotational drag after cooldown"))}
        let pressure=frames.filter{$0.tirePressureKPa<175}; if !pressure.isEmpty {h.append(.init(title:"tire pressure loss",confidence01:min(0.96,0.62+Double(pressure.count)*0.06),evidence:["measured tire pressure below running baseline"],nextMeasurement:"perform pressure-decay and leak-location test"))}
        return h.sorted{$0.confidence01>$1.confidence01}
    }
}
