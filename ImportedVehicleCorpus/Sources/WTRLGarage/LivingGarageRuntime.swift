import Foundation
import WTRLCore
import WTRLVehicle

public enum LiftPosition:String,Codable,Sendable {case floor, approach, service, underbody}
public struct LiftState:Codable,Hashable,Sendable {
    public var position:LiftPosition = .floor
    public var heightM=0.0
    public var locksEngaged=true
    public var vehicleCentered=false
    public var armPadsEngaged=false
    public init(){}
}
public enum LiftError:Error,Equatable {case vehicleNotCentered, padsNotEngaged, locksEngaged, unsafeHeight}
public enum LiftRuntime {
    public static func setVehicleCentered(_ v:Bool,state:inout LiftState){state.vehicleCentered=v}
    public static func engagePads(_ v:Bool,state:inout LiftState){state.armPadsEngaged=v}
    public static func raise(to target:LiftPosition,state:inout LiftState)throws {
        guard state.vehicleCentered else{throw LiftError.vehicleNotCentered}
        guard state.armPadsEngaged else{throw LiftError.padsNotEngaged}
        state.position=target
        state.heightM = target == .floor ? 0 : target == .approach ? 0.18 : target == .service ? 1.15 : 1.75
        state.locksEngaged = target != .floor
    }
    public static func releaseLocks(state:inout LiftState){state.locksEngaged=false}
    public static func lower(state:inout LiftState)throws {
        guard !state.locksEngaged else{throw LiftError.locksEngaged}
        state.heightM=max(0,state.heightM-0.25)
        if state.heightM == 0 {state.position = .floor;state.locksEngaged=true}
    }
}

public struct ToolContact:Codable,Hashable,Sendable {
    public var toolId:String
    public var fastenerId:String
    public var distanceM:Double
    public var angularAlignment01:Double
}
public enum ToolHitTest {
    public static func accepts(_ contact:ToolContact,maxDistanceM:Double=0.035)->Bool {
        contact.distanceM <= maxDistanceM && contact.angularAlignment01 >= 0.82
    }
}

public struct ExtractionSession:Codable,Hashable,Sendable {
    public var componentId:String
    public var travelM=0.0
    public var completed=false
    public init(componentId:String){self.componentId=componentId}
}
public enum ExtractionRuntime {
    public static func drag(_ session:inout ExtractionSession,geometry:PhysicalComponentGeometry,removed:Set<String>,dragVector:Vector3D)throws {
        try PhysicalInteractionMath.validateExtraction(component:geometry,removed:removed,dragVector:dragVector)
        session.travelM += dragVector.magnitude
        session.completed = session.travelM >= geometry.constraint.minimumTravelM
    }
}
