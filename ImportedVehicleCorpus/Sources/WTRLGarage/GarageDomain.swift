import Foundation
import WTRLCore
import WTRLVehicle

public enum ServiceSafetyState: String, Codable, Hashable, Sendable { case batteryDisconnected, vehicleSupported, fuelPressureRelieved, coolantDrained, oilDrained }
public struct ServiceAccessNode: Codable, Hashable, Sendable { public var id:String; public var prerequisites:[String]; public var requiredSafety:Set<ServiceSafetyState>; public var requiredTools:Set<String>; public var componentSlot:String?; public init(id:String,prerequisites:[String]=[],requiredSafety:Set<ServiceSafetyState>=[],requiredTools:Set<String>=[],componentSlot:String?=nil){self.id=id;self.prerequisites=prerequisites;self.requiredSafety=requiredSafety;self.requiredTools=requiredTools;self.componentSlot=componentSlot} }
public struct ServiceAccessState: Codable, Hashable, Sendable { public var completed:Set<String>=[]; public var safety:Set<ServiceSafetyState>=[]; public init(){} }
public enum ServiceAccessError: Error, Equatable { case unknownNode, missingPrerequisite(String), missingSafety(ServiceSafetyState), missingTool(String) }
public enum ServiceAccessService {
    public static func perform(_ nodeId:String,catalog:[String:ServiceAccessNode],state:inout ServiceAccessState,ownedTools:Set<String>) throws {
        guard let node=catalog[nodeId] else { throw ServiceAccessError.unknownNode }
        if let missing=node.prerequisites.first(where:{!state.completed.contains($0)}) { throw ServiceAccessError.missingPrerequisite(missing) }
        if let missing=node.requiredSafety.first(where:{!state.safety.contains($0)}) { throw ServiceAccessError.missingSafety(missing) }
        if let missing=node.requiredTools.first(where:{!ownedTools.contains($0)}) { throw ServiceAccessError.missingTool(missing) }
        state.completed.insert(nodeId)
    }
}

public enum PhysicalPartLocation: String, Codable, Hashable, Sendable { case installed, extracting, removed, staged, onBench, storage }
public struct PhysicalPartState: Codable, Hashable, Sendable { public var componentInstanceId:String; public var anchorId:String; public var location:PhysicalPartLocation; public var localPosition:Vector3D; public var localEulerDegrees:Vector3D; public init(componentInstanceId:String,anchorId:String,location:PhysicalPartLocation,localPosition: Vector3D = .zero,localEulerDegrees: Vector3D = .zero){self.componentInstanceId=componentInstanceId;self.anchorId=anchorId;self.location=location;self.localPosition=localPosition;self.localEulerDegrees=localEulerDegrees} }

public struct GarageState: Codable, Hashable, Sendable {
    public var activeVehicleInstanceId:String?
    public var vehicles:[VehicleInstance]=[]
    public var components:[ComponentInstance]=[]
    public var serviceAccess:[String:ServiceAccessState]=[:]
    public var physicalParts:[String:PhysicalPartState]=[:]
    public var differentialAssemblies:[String:DifferentialAssembly]=[:]
    public var workshopStates:[String:WorkshopState]=[:]
    public var fluidStates:[String:FluidServiceState]=[:]
    public var evidence:[EvidenceRecord]=[]
    public var vehiclePhysicalTruth:[String:UnifiedBlackridgeVehicleState]=[:]
    public var damageLedgers:[String:PersistentDamageLedger]=[:]
    public var workshopMeasurements:[String:[WorkshopMeasurementEvidence]]=[:]
    public var serviceHistory:[String:[ServiceHistoryRecord]]=[:]
    public init(){}
    enum CodingKeys:String,CodingKey {case activeVehicleInstanceId,vehicles,components,serviceAccess,physicalParts,differentialAssemblies,workshopStates,fluidStates,evidence,vehiclePhysicalTruth,damageLedgers,workshopMeasurements,serviceHistory}
    public init(from decoder:Decoder)throws {
        let c=try decoder.container(keyedBy:CodingKeys.self)
        activeVehicleInstanceId=try c.decodeIfPresent(String.self,forKey:.activeVehicleInstanceId)
        vehicles=try c.decodeIfPresent([VehicleInstance].self,forKey:.vehicles) ?? []
        components=try c.decodeIfPresent([ComponentInstance].self,forKey:.components) ?? []
        serviceAccess=try c.decodeIfPresent([String:ServiceAccessState].self,forKey:.serviceAccess) ?? [:]
        physicalParts=try c.decodeIfPresent([String:PhysicalPartState].self,forKey:.physicalParts) ?? [:]
        differentialAssemblies=try c.decodeIfPresent([String:DifferentialAssembly].self,forKey:.differentialAssemblies) ?? [:]
        workshopStates=try c.decodeIfPresent([String:WorkshopState].self,forKey:.workshopStates) ?? [:]
        fluidStates=try c.decodeIfPresent([String:FluidServiceState].self,forKey:.fluidStates) ?? [:]
        evidence=try c.decodeIfPresent([EvidenceRecord].self,forKey:.evidence) ?? []
        vehiclePhysicalTruth=try c.decodeIfPresent([String:UnifiedBlackridgeVehicleState].self,forKey:.vehiclePhysicalTruth) ?? [:]
        damageLedgers=try c.decodeIfPresent([String:PersistentDamageLedger].self,forKey:.damageLedgers) ?? [:]
        workshopMeasurements=try c.decodeIfPresent([String:[WorkshopMeasurementEvidence]].self,forKey:.workshopMeasurements) ?? [:]
        serviceHistory=try c.decodeIfPresent([String:[ServiceHistoryRecord]].self,forKey:.serviceHistory) ?? [:]
    }
}
