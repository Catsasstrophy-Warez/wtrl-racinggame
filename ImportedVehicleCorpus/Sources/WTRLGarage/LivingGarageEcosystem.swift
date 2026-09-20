import Foundation
import WTRLVehicle

public enum WorkshopTier: Int, Codable, CaseIterable, Sendable { case barn = 1, commercial, speedLab, paddock, empire }
public enum WorkshopCapability: String, Codable, CaseIterable, Sendable { case handTools, timingBench, lift, alignmentRack, tireMachine, chassisDyno, flowBench, tigWelder, machining, cornerScales, telemetryRoom, compositeFabrication, multiBayInventory }
public enum WorkshopTierAuthority {
    public static func capabilities(_ tier: WorkshopTier) -> Set<WorkshopCapability> {
        switch tier {
        case .barn: return [.handTools,.timingBench]
        case .commercial: return [.handTools,.timingBench,.lift,.alignmentRack,.tireMachine]
        case .speedLab: return [.handTools,.timingBench,.lift,.alignmentRack,.tireMachine,.chassisDyno,.flowBench,.tigWelder,.machining]
        case .paddock: return [.handTools,.timingBench,.lift,.alignmentRack,.tireMachine,.chassisDyno,.flowBench,.tigWelder,.machining,.cornerScales,.telemetryRoom,.compositeFabrication]
        case .empire: return Set(WorkshopCapability.allCases)
        }
    }
}

public enum DiagnosticEra: String, Codable, Sendable { case analog, earlyElectronic, networked }
public enum DiagnosticTool: String, Codable, CaseIterable, Sendable { case vacuumGauge, dwellMeter, timingLight, carburetorJetKit, oscilloscope, diagnosticJumper, scanTool, canMonitor, ecuCalibrationLaptop }
public enum DiagnosticBenchAuthority {
    public static func tools(for era: DiagnosticEra) -> Set<DiagnosticTool> {
        switch era { case .analog:return [.vacuumGauge,.dwellMeter,.timingLight,.carburetorJetKit]; case .earlyElectronic:return [.vacuumGauge,.timingLight,.oscilloscope,.diagnosticJumper]; case .networked:return [.oscilloscope,.scanTool,.canMonitor,.ecuCalibrationLaptop] }
    }
}

public struct AlignmentAdjustment: Codable, Hashable, Sendable { public var toeDeltaDeg=0.0, camberDeltaDeg=0.0, rideHeightDeltaM=0.0; public init(){} }
public enum AlignmentDeckAuthority {
    public static func apply(_ adjustment: AlignmentAdjustment, to curve: inout SuspensionAlignmentCurve) { curve.staticToeDeg += adjustment.toeDeltaDeg; curve.staticCamberDeg += adjustment.camberDeltaDeg }
}

public struct FlowBenchState: Codable, Hashable, Sendable { public var intakeFlowCFM=220.0, exhaustFlowCFM=160.0, portingRemovalGrams=0.0, wallRisk01=0.0; public init(){} }
public enum FlowBenchAuthority {
    public static func handPort(_ s: inout FlowBenchState, removalGrams: Double) { let d=max(0,removalGrams);s.portingRemovalGrams += d;s.intakeFlowCFM += d*0.11;s.exhaustFlowCFM += d*0.06;s.wallRisk01=max(0,min(1,(s.portingRemovalGrams-85)/90)) }
}

public struct WorkshopWearLedger: Codable, Hashable, Sendable { public var chassisSet01=0.0, oilHours=0.0, frontPadMM=12.0, rearPadMM=10.0, plugFouling01=0.0, tireWearFL=0.0,tireWearFR=0.0,tireWearRL=0.0,tireWearRR=0.0; public init(){} }
public struct ServiceInvoiceLine: Codable, Hashable, Sendable { public var description:String,costCredits:Int,hours:Double; public init(description:String,costCredits:Int,hours:Double){self.description=description;self.costCredits=costCredits;self.hours=hours} }
public enum WorkshopInvoiceAuthority {
    public static func invoice(_ w:WorkshopWearLedger)->[ServiceInvoiceLine] { var x:[ServiceInvoiceLine]=[];if w.chassisSet01>0.12{x.append(.init(description:"Chassis measurement and straightening",costCredits:Int(600+w.chassisSet01*1800),hours:4))};if w.oilHours>15{x.append(.init(description:"Oil and filter service",costCredits:160,hours:0.5))};if w.frontPadMM<3{x.append(.init(description:"Front brake service",costCredits:420,hours:1.5))};if w.plugFouling01>0.4{x.append(.init(description:"Spark plug diagnosis and replacement",costCredits:120,hours:0.5))};if max(w.tireWearRL,w.tireWearRR)>0.85{x.append(.init(description:"Rear tire pair",costCredits:680,hours:1))};return x }
}
