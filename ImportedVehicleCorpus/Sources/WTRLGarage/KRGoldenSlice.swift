import Foundation
import WTRLCore
import WTRLVehicle

public enum KRGoldenStage: String, Codable, CaseIterable, Sendable {
    case found, listingInspected, purchased, transported, garageReceived, initialInspection, diagnosed, workOrderCreated, serviceAccessEstablished, disassembled, removedPartsInspected, inventoryReconciled, repaired, machineWorkResolved, modifiedOrTuned, reassembled, fluidsRestored, adjusted, commissioned, diagnosticVerificationPassed, physicalDynoCompleted, certified, blackridgeDriven, briarArrived, burnoutCompleted, preStaged, staged, treeArmed, launched, quarterMileCompleted, mechanicalConsequencesRecorded, postRunForensicsCompleted, postRunRepairCompleted, saved, reloadContinuityVerified
}
public struct KRGoldenMilestone: Codable, Hashable, Sendable { public var stage:KRGoldenStage; public var timestamp:Date; public var evidenceId:String; public var authority:String }
public struct KRGoldenSliceProgress: Codable, Hashable, Sendable {
    public var vehicleInstanceId:String; public var milestones:[KRGoldenMilestone]=[]
    public init(vehicleInstanceId:String){self.vehicleInstanceId=vehicleInstanceId}
    public var nextStage: KRGoldenStage? { let done=Set(milestones.map(\.stage)); return KRGoldenStage.allCases.first(where:{!done.contains($0)}) }
    public mutating func record(_ stage:KRGoldenStage, vehicleId:String, authority:String, evidenceId:String) -> Bool {
        guard vehicleId==vehicleInstanceId, !authority.isEmpty, !evidenceId.isEmpty, nextStage==stage else { return false }
        milestones.append(.init(stage:stage,timestamp:Date(),evidenceId:evidenceId,authority:authority)); return true
    }
    public var isComplete:Bool { nextStage == nil }
}

public enum KRServiceCatalog {
    public static let differential:[String:ServiceAccessNode] = {
        let nodes:[ServiceAccessNode] = [
            .init(id:"battery_disconnect"),
            .init(id:"vehicle_support", prerequisites:["battery_disconnect"]),
            .init(id:"rear_wheels_remove", prerequisites:["vehicle_support"], requiredSafety:[.vehicleSupported], requiredTools:["lug_socket"]),
            .init(id:"differential_drain", prerequisites:["vehicle_support"], requiredSafety:[.vehicleSupported], requiredTools:["drain_pan"]),
            .init(id:"driveshaft_disconnect", prerequisites:["differential_drain"], requiredSafety:[.vehicleSupported], requiredTools:["ratchet"]),
            .init(id:"axle_access", prerequisites:["rear_wheels_remove","differential_drain"], requiredSafety:[.vehicleSupported], requiredTools:["ratchet"]),
            .init(id:"differential_remove", prerequisites:["driveshaft_disconnect","axle_access"], requiredSafety:[.vehicleSupported], requiredTools:["transmission_jack"], componentSlot:"differential")
        ]; return Dictionary(uniqueKeysWithValues:nodes.map{($0.id,$0)})
    }()
}
