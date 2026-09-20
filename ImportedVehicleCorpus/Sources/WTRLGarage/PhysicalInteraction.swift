import Foundation
import WTRLCore

public struct Transform3D: Codable, Hashable, Sendable {
    public var position:Vector3D
    public var eulerDegrees:Vector3D
    public init(position:Vector3D = .zero,eulerDegrees:Vector3D = .zero){self.position=position;self.eulerDegrees=eulerDegrees}
}
public struct RemovalConstraint: Codable, Hashable, Sendable {
    public var axis:Vector3D
    public var minimumTravelM:Double
    public var clearanceRadiusM:Double
    public var requiresParentRemoved:[String]
    public init(axis:Vector3D,minimumTravelM:Double,clearanceRadiusM:Double=0.05,requiresParentRemoved:[String]=[]){self.axis=axis;self.minimumTravelM=minimumTravelM;self.clearanceRadiusM=clearanceRadiusM;self.requiresParentRemoved=requiresParentRemoved}
}
public struct PhysicalComponentGeometry: Codable, Hashable, Sendable {
    public var componentId:String
    public var installedTransform:Transform3D
    public var benchTransform:Transform3D
    public var constraint:RemovalConstraint
    public var selectableBoundsM:Vector3D
}
public enum PhysicalInteractionError:Error,Equatable { case blockedBy(String), insufficientTravel, wrongDirection }
public enum PhysicalInteractionMath {
    public static func validateExtraction(component:PhysicalComponentGeometry, removed:Set<String>, dragVector:Vector3D) throws {
        if let block=component.constraint.requiresParentRemoved.first(where:{!removed.contains($0)}) { throw PhysicalInteractionError.blockedBy(block) }
        let a=component.constraint.axis, am=max(0.0001,a.magnitude), dm=dragVector.magnitude
        guard dm >= component.constraint.minimumTravelM else { throw PhysicalInteractionError.insufficientTravel }
        let dot=(a.x*dragVector.x+a.y*dragVector.y+a.z*dragVector.z)/(am*max(0.0001,dm))
        guard dot > 0.70 else { throw PhysicalInteractionError.wrongDirection }
    }
}
