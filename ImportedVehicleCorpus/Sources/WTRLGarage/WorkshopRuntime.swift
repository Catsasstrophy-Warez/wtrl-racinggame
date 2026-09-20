import Foundation
import WTRLCore
import WTRLVehicle

public enum WorkshopToolKind: String, Codable, CaseIterable, Sendable {
    case ratchet, breakerBar, torqueWrench, dialIndicator, bearingPuller, bearingPress
    case deadBlowHammer, pryBar, drainPan, markingCompound, caliper, micrometer
    case partsWasher, oilBottle, shopLight
}

public struct WorkshopTool: Codable, Hashable, Sendable, Identifiable {
    public var id: String
    public var kind: WorkshopToolKind
    public var condition01: Double
    public var calibrationError01: Double
    public var held: Bool
    public init(id: String, kind: WorkshopToolKind, condition01: Double = 1, calibrationError01: Double = 0, held: Bool = false) {
        self.id=id; self.kind=kind; self.condition01=condition01; self.calibrationError01=calibrationError01; self.held=held
    }
}

public enum FastenerState: String, Codable, Sendable { case installed, loosened, removed, torqued }
public struct PhysicalFastener: Codable, Hashable, Sendable, Identifiable {
    public var id:String
    public var parentComponentId:String
    public var targetTorqueNm:Double
    public var appliedTorqueNm:Double
    public var state:FastenerState
    public var position:Vector3D
    public init(id:String,parentComponentId:String,targetTorqueNm:Double,position:Vector3D) {
        self.id=id; self.parentComponentId=parentComponentId; self.targetTorqueNm=targetTorqueNm
        self.appliedTorqueNm=0; self.state = .installed; self.position=position
    }
}

public enum WorkshopActionError: Error, Equatable {
    case wrongTool, fastenerNotReady, torqueOutOfRange, toolNotCalibrated, componentStillFastened, invalidMeasurementSetup
}

public struct WorkshopState: Codable, Hashable, Sendable {
    public var tools:[WorkshopTool]
    public var fasteners:[PhysicalFastener]
    public var removedComponents:Set<String>
    public var selectedComponentId:String?
    public var heldToolId:String?
    public var fluidSpillLiters:Double
    public init(tools:[WorkshopTool]=WorkshopCatalog.defaultTools, fasteners:[PhysicalFastener]=WorkshopCatalog.krDifferentialFasteners) {
        self.tools=tools; self.fasteners=fasteners; self.removedComponents=[]; self.fluidSpillLiters=0
    }
}

public enum WorkshopCatalog {
    public static let defaultTools:[WorkshopTool] = WorkshopToolKind.allCases.map { WorkshopTool(id:"tool_\($0.rawValue)",kind:$0) }
    public static let krDifferentialFasteners:[PhysicalFastener] = {
        var a:[PhysicalFastener]=[]
        for i in 0..<10 { a.append(.init(id:"cover_bolt_\(i+1)",parentComponentId:"KR-DIFF-21",targetTorqueNm:34,position:Vector3D(Double(i%5)*0.04-0.08,Double(i/5)*0.12-0.06,0.18))) }
        for i in 0..<10 { a.append(.init(id:"ring_bolt_\(i+1)",parentComponentId:"KR-DIFF-03",targetTorqueNm:115,position:Vector3D(0.11,0,Double(i)*0.01))) }
        a.append(.init(id:"pinion_nut",parentComponentId:"KR-DIFF-04",targetTorqueNm:245,position:Vector3D(0,0,0.24)))
        return a
    }()
}

public enum WorkshopRuntime {
    public static func pickUp(toolId:String,state:inout WorkshopState) {
        for i in state.tools.indices { state.tools[i].held = state.tools[i].id == toolId }
        state.heldToolId=toolId
    }
    public static func loosen(fastenerId:String,state:inout WorkshopState)throws {
        guard let tool=state.tools.first(where:{$0.id==state.heldToolId}), [.ratchet,.breakerBar,.torqueWrench].contains(tool.kind) else {throw WorkshopActionError.wrongTool}
        guard let i=state.fasteners.firstIndex(where:{$0.id==fastenerId}), state.fasteners[i].state == .installed || state.fasteners[i].state == .torqued else {throw WorkshopActionError.fastenerNotReady}
        state.fasteners[i].state = .loosened
    }
    public static func remove(fastenerId:String,state:inout WorkshopState)throws {
        guard let i=state.fasteners.firstIndex(where:{$0.id==fastenerId}), state.fasteners[i].state == .loosened else {throw WorkshopActionError.fastenerNotReady}
        state.fasteners[i].state = .removed
    }
    public static func torque(fastenerId:String,to torqueNm:Double,state:inout WorkshopState)throws {
        guard let tool=state.tools.first(where:{$0.id==state.heldToolId}), tool.kind == .torqueWrench else {throw WorkshopActionError.wrongTool}
        guard tool.calibrationError01 <= 0.05 else {throw WorkshopActionError.toolNotCalibrated}
        guard let i=state.fasteners.firstIndex(where:{$0.id==fastenerId}) else {throw WorkshopActionError.fastenerNotReady}
        let target=state.fasteners[i].targetTorqueNm
        guard abs(torqueNm-target) <= max(2,target*0.05) else {throw WorkshopActionError.torqueOutOfRange}
        state.fasteners[i].appliedTorqueNm=torqueNm; state.fasteners[i].state = .torqued
    }
    public static func canExtract(componentId:String,state:WorkshopState)->Bool {
        !state.fasteners.contains(where:{$0.parentComponentId==componentId && $0.state != .removed})
    }
}
