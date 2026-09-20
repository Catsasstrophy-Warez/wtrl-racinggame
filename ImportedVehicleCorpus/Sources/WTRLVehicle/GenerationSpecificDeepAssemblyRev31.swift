import Foundation

public enum DeepAssemblyInterfaceKindRev31:String,Codable,Sendable { case fastener, spline, flange, hose, hardLine, electrical, belt, chain, bushing, bearing, bonded, hydraulic }
public struct DeepAssemblyInterfaceRev31:Codable,Hashable,Sendable { public var id:String; public var kind:DeepAssemblyInterfaceKindRev31; public var hostId:String; public var guestId:String; public var verification:String; public var researchGated:Bool }
public struct GenerationSpecificDeepAssemblyRev31:Codable,Hashable,Sendable {
 public var vehicleId:String; public var generation:Int; public var architectureSignature:String; public var nodes:[HeritageAssemblyNodeRev30]; public var interfaces:[DeepAssemblyInterfaceRev31]
 public func validationIssues()->[String]{
  let graph=HeritageAssemblyGraphRev30(vehicleId:vehicleId,nodes:nodes); var issues=graph.validationIssues(); let ids=Set(nodes.map(\.id));
  for i in interfaces { if !ids.contains(i.hostId){issues.append("missing interface host \(i.hostId)")}; if !ids.contains(i.guestId){issues.append("missing interface guest \(i.guestId)")} }
  if nodes.count < 34 {issues.append("assembly not deep enough")}; if architectureSignature.isEmpty {issues.append("missing architecture signature")}; return issues
 }
}

/// Converts the authored generation architecture into a serviceable physical graph. IDs are simultaneously physics, workshop and render identities.
public enum GenerationSpecificDeepAssemblyAuthorityRev31 {
 public static func assembly(for v:HeritageVehicleEngineeringProfile)->GenerationSpecificDeepAssemblyRev31 {
  let base=HeritageAssemblyAuthorityRev30.graph(for:v)
  var nodes=base.nodes
  var interfaces:[DeepAssemblyInterfaceRev31]=[]
  func add(_ id:String,_ name:String,_ subsystem:HeritageAssemblySubsystemRev30,_ parent:String,_ prereq:[String]=[],_ failures:[String]=[]) {
   guard !nodes.contains(where:{$0.id==id}) else{return}
   nodes.append(.init(id:id,name:name,subsystem:subsystem,parentId:parent,removalPrerequisites:prereq,visualBindingId:id,physicsBindingId:id,failureModes:failures,researchGates:["exact OEM geometry","exact OEM fastener/torque data","option-specific routing"])); interfaces.append(.init(id:"if.\(id)",kind:.fastener,hostId:parent,guestId:id,verification:"service procedure + provenance",researchGated:true))
  }
  add("body.front_structure","Front structure",.structure,"body.shell",["hood"],["datum shift","fatigue"]); add("body.rear_structure","Rear structure",.structure,"body.shell",[],["datum shift","fatigue"])
  add("steering.column","Steering column",.steering,"body.shell",[],["joint play","bearing wear"]); add("steering.link.left","Left steering link",.steering,"steering.gear",[],["free play","bend"]); add("steering.link.right","Right steering link",.steering,"steering.gear",[],["free play","bend"])
  for corner in ["fl","fr","rl","rr"] { let axle = corner.hasPrefix("f") ? "front" : "rear"; add("hub.\(corner)","\(corner.uppercased()) hub/bearing",.suspension,"suspension.\(axle)",[],["bearing wear","runout","heat"]); add("damper.\(corner)","\(corner.uppercased()) spring/damper",.suspension,"suspension.\(axle)",[],["leak","fade","bushing wear"]); add("brake.\(corner)","\(corner.uppercased()) brake corner",.brakes,"hub.\(corner)",[],["runout","pad wear","thermal saturation"]); interfaces.append(.init(id:"if.wheel.\(corner)",kind:.fastener,hostId:"hub.\(corner)",guestId:"wheel.\(corner)",verification:"wheel retention provenance",researchGated:true)) }
  add("engine.accessory_drive","Accessory drive",.engine,"engine.longblock",["hood"],["belt slip","bearing wear"]); add("engine.mount.left","Left powertrain mount",.engine,"body.front_structure",[],["collapse","tear"]); add("engine.mount.right","Right powertrain mount",.engine,"body.front_structure",[],["collapse","tear"])
  add("cooling.pump","Coolant pump",.cooling,"engine.longblock",["hood"],["seal leak","impeller loss"]); add("cooling.thermostat","Thermostat/housing",.cooling,"engine.longblock",["hood"],["stuck open","stuck closed"])
  add("fuel.tank","Fuel tank",.fuel,"body.rear_structure",[],["leak","vent restriction"]); add("fuel.delivery_line","Fuel delivery line",.fuel,"body.shell",[],["restriction","leak"])
  add("electrical.power_distribution","Power distribution",.electrical,"body.shell",[],["voltage drop","terminal heat"]); add("electrical.main_harness","Main harness",.electrical,"body.shell",[],["open circuit","short","connector resistance"])
  add("driveline.output_joint","Transmission output joint",.driveline,"transmission.case",[],["lash","wear"]); add("differential.mount","Differential/axle mounting",.differential,"body.rear_structure",[],["bushing compliance","fastener movement"])

  let f=v.frontKinematics.lowercased(), r=v.rearKinematics.lowercased(), fuel=v.fuelMetering.lowercased(), ind=v.induction.lowercased(), steer=v.steering.lowercased()
  if f.contains("wishbone") || f.contains("double") { add("suspension.front.upper_arm.left","FL upper arm",.suspension,"suspension.front",[],["ball joint wear","bushing compliance"]); add("suspension.front.upper_arm.right","FR upper arm",.suspension,"suspension.front",[],["ball joint wear","bushing compliance"]); add("suspension.front.lower_arm.left","FL lower arm",.suspension,"suspension.front",[],["ball joint wear","bushing compliance"]); add("suspension.front.lower_arm.right","FR lower arm",.suspension,"suspension.front",[],["ball joint wear","bushing compliance"]) }
  if f.contains("macpherson") || f.contains("strut") { add("suspension.front.strut.left","FL strut assembly",.suspension,"suspension.front",[],["damper fade","top mount play"]); add("suspension.front.strut.right","FR strut assembly",.suspension,"suspension.front",[],["damper fade","top mount play"]) }
  if f.contains("torsion") { add("suspension.front.torsion.left","Left torsion spring",.suspension,"suspension.front",[],["index error","fatigue"]); add("suspension.front.torsion.right","Right torsion spring",.suspension,"suspension.front",[],["index error","fatigue"]) }
  if r.contains("leaf") { add("suspension.rear.leaf.left","Left rear leaf pack",.suspension,"suspension.rear",[],["axle windup","bushing wear"]); add("suspension.rear.leaf.right","Right rear leaf pack",.suspension,"suspension.rear",[],["axle windup","bushing wear"]) }
  if r.contains("panhard") { add("suspension.rear.panhard","Rear Panhard locator",.suspension,"suspension.rear",[],["lateral migration","bushing compliance"]) }
  if r.contains("semi-trailing") { add("suspension.rear.trailing.left","Left semi-trailing arm",.suspension,"suspension.rear",[],["dynamic toe","bushing compliance"]); add("suspension.rear.trailing.right","Right semi-trailing arm",.suspension,"suspension.rear",[],["dynamic toe","bushing compliance"]) }
  if r.contains("multi-link") || r.contains("independent") || r.contains("wishbone") { for side in ["left","right"] { add("suspension.rear.link.upper.\(side)","Rear upper link \(side)",.suspension,"suspension.rear",[],["bushing compliance","dynamic toe"]); add("suspension.rear.link.lower.\(side)","Rear lower link \(side)",.suspension,"suspension.rear",[],["bushing compliance","dynamic camber"]) } }
  if fuel.contains("carb") || fuel.contains("weber") || fuel.contains("holley") { add("fuel.float_metering","Float/jet metering hardware",.fuel,nodes.contains(where:{$0.id=="fuel.carburetor"}) ? "fuel.carburetor":"engine.longblock",["hood"],["float error","jet restriction","linkage mismatch"]) }
  if fuel.contains("direct") { add("fuel.high_pressure_pump","High-pressure fuel pump",.fuel,"engine.longblock",["hood"],["pressure loss","cam follower wear"]); add("fuel.high_pressure_rail","High-pressure rail",.fuel,"engine.longblock",["hood"],["pressure decay","injector imbalance"]) }
  if ind.contains("turbo") { add("induction.turbo","Turbocharger assembly",.induction,"engine.longblock",["hood"],["bearing wear","wastegate fault","oil leak"]); add("induction.wastegate","Boost control actuator",.induction,"induction.turbo",["hood"],["stiction","diaphragm/actuator fault"]) }
  if ind.contains("super") { add("induction.supercharger","Supercharger assembly",.induction,"engine.longblock",["hood"],["belt slip","bearing wear","bypass fault"]); add("induction.bypass","Supercharger bypass",.induction,"induction.supercharger",["hood"],["stuck closed","vacuum/actuator fault"]) }
  if steer.contains("rear") || v.dynamicMechanisms.joined().lowercased().contains("rear-steer") { add("steering.rear_actuator","Rear-steer actuator",.steering,"suspension.rear",[],["center error","hydraulic/electrical fault"]) }
  if v.dynamicMechanisms.joined().lowercased().contains("aero") { add("aero.front","Front aero hardware",.aero,"body.front_structure",[],["mount damage","ride-height sensitivity"]); add("aero.rear","Rear aero hardware",.aero,"body.rear_structure",[],["mount damage","actuator fault"]) }
  let signature=[v.powertrainArchitecture,v.fuelMetering,v.induction,v.frontKinematics,v.rearKinematics,v.steering].joined(separator:" | ")
  return .init(vehicleId:v.id,generation:v.era,architectureSignature:signature,nodes:nodes,interfaces:interfaces)
 }
}
