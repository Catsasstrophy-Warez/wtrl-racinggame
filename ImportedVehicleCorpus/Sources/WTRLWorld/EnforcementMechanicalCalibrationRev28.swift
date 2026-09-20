import Foundation
import WTRLVehicle

public enum EnforcementMechanicalCalibrationRev28 {
    public static let calibrations:[VehicleMechanicalCalibration] = VehicleMechanicalCalibrationRosterRev28.enforcement(EnforcementProductionRosterRev27.vehicles.map(\.platform))
    public static func calibration(for enforcementId:String)->VehicleMechanicalCalibration? {
        guard let vehicle=EnforcementProductionRosterRev27.vehicle(enforcementId) else{return nil}
        return calibrations.first{$0.vehicleId == vehicle.platform.id}
    }
}
