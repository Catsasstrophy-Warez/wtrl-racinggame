import Testing
import WTRLCore
import WTRLVehicle
@testable import WTRLGarage

@Test func coverCannotExtractWithFastenersInstalled() {
    let state=WorkshopState()
    #expect(!WorkshopRuntime.canExtract(componentId:"KR-DIFF-21",state:state))
}
@Test func coverCanExtractAfterPhysicalBoltsRemoved() throws {
    var state=WorkshopState()
    WorkshopRuntime.pickUp(toolId:"tool_ratchet",state:&state)
    for i in 1...10 {
        try WorkshopRuntime.loosen(fastenerId:"cover_bolt_\(i)",state:&state)
        try WorkshopRuntime.remove(fastenerId:"cover_bolt_\(i)",state:&state)
    }
    #expect(WorkshopRuntime.canExtract(componentId:"KR-DIFF-21",state:state))
}
@Test func torqueWrenchRejectsBadTorque() {
    var state=WorkshopState()
    WorkshopRuntime.pickUp(toolId:"tool_torqueWrench",state:&state)
    #expect(throws: WorkshopActionError.torqueOutOfRange) {
        try WorkshopRuntime.torque(fastenerId:"ring_bolt_1",to:50,state:&state)
    }
}
@Test func dialIndicatorRequiresSetup() {
    let tool=WorkshopTool(id:"dial",kind:.dialIndicator)
    #expect(MeasurementRuntime.dialIndicator(kind:.backlash,trueValue:0.19,tool:tool,baseMagneticLocked:false,probeLoaded:true) == nil)
    let reading=MeasurementRuntime.dialIndicator(kind:.backlash,trueValue:0.19,tool:tool,baseMagneticLocked:true,probeLoaded:true)
    #expect(reading?.value == 0.19)
}
@Test func fluidOverflowCreatesSpill() {
    var s=FluidServiceState();s.differentialOilL=1.8
    FluidServiceRuntime.fillDifferential(&s,liters:1.0,capacityL:1.9)
    #expect(s.differentialOilL == 1.9)
    #expect(s.spillL > 0.8)
}
@Test func oneCarContinuityRejectsDifferentVehicle() {
    var s=VehicleContinuityState(vehicleInstanceId:"KR-1")
    #expect(throws: VehicleContinuityError.wrongVehicle) {
        try VehicleContinuityRuntime.move(&s,vehicleId:"OTHER",to:.icehouseGarage)
    }
}
@Test func oneCarMovesCountyToGarageAndAccumulatesMileage() throws {
    var s=VehicleContinuityState(vehicleInstanceId:"KR-1",odometerKm:82000)
    try VehicleContinuityRuntime.move(&s,vehicleId:"KR-1",to:.icehouseGarage,distanceKm:12.5,fuelUsedL:1.7,engineHours:0.3)
    #expect(s.place == .icehouseGarage)
    #expect(s.odometerKm == 82012.5)
}

import WTRLPersistence
import WTRLWorld

@Test func physicalWorkshopAndContinuitySurviveSaveReload() throws {
    var save=SaveEnvelope()
    let id="KR-PERSIST"
    save.garage.vehicles=[VehicleInstance(vehicleInstanceId:id,platformId:"hero_1968_kr")]
    save.garage.activeVehicleInstanceId=id
    var workshop=WorkshopState()
    WorkshopRuntime.pickUp(toolId:"tool_ratchet",state:&workshop)
    try WorkshopRuntime.loosen(fastenerId:"cover_bolt_1",state:&workshop)
    save.garage.workshopStates[id]=workshop
    save.garage.differentialAssemblies[id]=DifferentialAssembly()
    var fluid=FluidServiceState();fluid.differentialOilL=1.9
    save.garage.fluidStates[id]=fluid
    save.world.vehicleContinuity[id]=VehicleContinuityState(vehicleInstanceId:id,place:.icehouseGarage,odometerKm:82000)
    let data=try SaveCodec.encode(save)
    let loaded=try SaveCodec.decode(data)
    #expect(loaded.garage.workshopStates[id]?.fasteners.first?.state == .loosened)
    #expect(loaded.garage.differentialAssemblies[id]?.parts.count == DifferentialPartKind.allCases.count)
    #expect(loaded.garage.fluidStates[id]?.differentialOilL == 1.9)
    #expect(loaded.world.vehicleContinuity[id]?.place == .icehouseGarage)
}
