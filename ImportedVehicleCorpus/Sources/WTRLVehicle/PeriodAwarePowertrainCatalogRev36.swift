import Foundation

public enum CatalogAvailabilityKindRev36:String,Codable,Sendable,CaseIterable { case periodCorrectOEM, periodCorrectCompetition, usedOriginal, newOldStock, reproduction, modernAftermarket, salvage, engineeredSwap, prototypeRaceOnly }
public enum PowertrainPartKindRev36:String,Codable,Sendable { case engine, transmission, transaxle }
public enum PowertrainArchitectureRev36:String,Codable,Sendable { case flatheadV8, pushrodV8, sohcV8, dohcV8, inline6, turboInline6, turboInline4, turboV6, inline3, dct, automatic, manual, rearTransaxle, transverseTransaxle }
public struct PeriodAwarePowertrainPartRev36:Codable,Hashable,Sendable,Identifiable {
 public var id:String; public var displayName:String; public var kind:PowertrainPartKindRev36; public var introducedYear:Int; public var productionEndYear:Int?; public var architecture:PowertrainArchitectureRev36
 public var interfaces:[String]; public var requiredSystems:[String]; public var failurePhysics:[String]; public var serviceProcedures:[String]; public var provenance:EngineeringProvenance; public var researchGates:[String]
}
public struct CatalogAvailabilityRev36:Codable,Hashable,Sendable { public var available:Bool; public var kinds:[CatalogAvailabilityKindRev36]; public var reason:String }
public struct SwapCompatibilityRev36:Codable,Hashable,Sendable { public var directFit:Bool; public var requirements:[String]; public var hardConflicts:[String] }

/// Time-aware catalog. Historical names are reference labels. Exact specifications and application claims remain research-gated until verified.
public enum PeriodAwarePowertrainCatalogRev36 {
 private static func e(_ id:String,_ name:String,_ start:Int,_ end:Int?,_ arch:PowertrainArchitectureRev36,_ systems:[String],_ physics:[String],_ service:[String])->PeriodAwarePowertrainPartRev36 { .init(id:id,displayName:name,kind:.engine,introducedYear:start,productionEndYear:end,architecture:arch,interfaces:["engine mounts","driveline interface","cooling","fuel","exhaust","electrical/control"],requiredSystems:systems,failurePhysics:physics,serviceProcedures:service,provenance:.researchPending,researchGates:["exact OEM output","exact dimensions/mass","factory clearances and torque","option/application history","calibration maps"]) }
 private static func t(_ id:String,_ name:String,_ start:Int,_ end:Int?,_ kind:PowertrainPartKindRev36,_ arch:PowertrainArchitectureRev36,_ systems:[String],_ physics:[String],_ service:[String])->PeriodAwarePowertrainPartRev36 { .init(id:id,displayName:name,kind:kind,introducedYear:start,productionEndYear:end,architecture:arch,interfaces:["bellhousing or torque input","mount/crossmember","output/driveshaft or halfshafts","shifter/control","lubrication/cooling"],requiredSystems:systems,failurePhysics:physics,serviceProcedures:service,provenance:.researchPending,researchGates:["exact gear ratios","exact torque capacity","factory fluid specification","exact endplay/backlash","application-year verification"]) }
 public static let engines:[PeriodAwarePowertrainPartRev36] = [
  e("eng_427_cammer","427 SOHC Cammer V8 reference",1964,1970,.sohcV8,["carbureted fuel","high-capacity oiling","large-bay packaging"],["long timing-drive torsional dynamics","high-rpm valvetrain load"],["timing-drive inspection","oil delivery proof","carburetor synchronization"]),
  e("eng_boss429","Boss 429 V8 reference",1969,1970,.pushrodV8,["large-bay packaging","carbureted fuel","high-capacity cooling"],["large-port low-speed charge behavior","engine-bay heat density"],["valvetrain inspection","cooling proof","mount/clearance inspection"]),
  e("eng_voodoo52","5.2L high-rev flat-plane V8 reference",2015,2020,.dohcV8,["modern EFI","CAN control","track cooling"],["high-order crank vibration","high-rpm oil/thermal demand"],["vibration-order analysis","oil-pressure proof","valvetrain inspection"]),
  e("eng_barra40","4.0L Barra DOHC I6 reference",2002,2016,.turboInline6,["EFI","turbo oil/coolant","long-engine packaging"],["boost thermal load","cylinder-pressure driveline load"],["boost-leak test","compression/leakdown","fuel-pressure proof"]),
  e("eng_ecoboost35ho","3.5L high-output EcoBoost V6 reference",2017,nil,.turboV6,["direct/port injection","twin turbo cooling","CAN control"],["charge heat soak","turbo transient","high-pressure fuel demand"],["charge-air pressure test","HP fuel diagnosis","turbo actuator sweep"]),
  e("eng_coyote50","5.0L Coyote DOHC V8 reference",2011,nil,.dohcV8,["modern EFI","variable cam control","CAN control"],["cam-phasing response","high-rpm thermal load"],["cam command/response test","oil-pressure proof","fuel trim analysis"]),
  e("eng_427_side_oiler","427 FE Side-Oiler V8 reference",1965,1968,.pushrodV8,["carbureted fuel","endurance oiling","large-bay packaging"],["main-bearing oil demand","endurance heat rejection"],["oil-pressure mapping","bearing inspection","cooling proof"]),
  e("eng_dfv30","Cosworth DFV 3.0L V8 reference",1967,1983,.dohcV8,["competition fuel system","dry-sump compatible","stressed-installation support"],["high-rpm valvetrain load","structural mount load"],["valve-clearance inspection","dry-sump proof","mount/structure NDT"]),
  e("eng_trinity58","5.8L Trinity supercharged V8 reference",2013,2014,.dohcV8,["EFI","supercharger/charge cooling","CAN control"],["charge heat soak","belt slip","high driveline torque"],["charge-cooler test","belt inspection","fuel-pressure proof"]),
  e("eng_cosworth_yb20","2.0L Cosworth YB turbo I4 reference",1986,1996,.turboInline4,["EFI","turbo oil/coolant","intercooler"],["boost threshold","turbo heat","fuel-delivery demand"],["boost-leak test","injector waveform","turbo shaft inspection"]),
  e("eng_flathead_v8","Flathead V8 reference",1932,1953,.flatheadV8,["carbureted fuel","period ignition","period cooling"],["exhaust-path thermal concentration","breathing limitation"],["compression test","cooling-system inspection","ignition/carburetor tune"]),
  e("eng_351_cleveland","351 Cleveland V8 reference",1970,1974,.pushrodV8,["carbureted fuel","period ignition","high-flow intake"],["large-port low-speed charge dropout","valvetrain load"],["vacuum/fuel-film diagnosis","valve-train inspection","carburetor tune"]),
  e("eng_modular54sc","5.4L supercharged Modular V8 reference",2005,2006,.dohcV8,["EFI","supercharger cooling","dry-sump capable installation"],["charge heat soak","belt drive load","oil-control demand"],["charge-cooler proof","belt inspection","oil-system prime"]),
  e("eng_lima23t","2.3L Lima Turbo I4 reference",1984,1988,.turboInline4,["early EFI","turbo oiling","intercooler where configured"],["boost lag","knock/charge temperature sensitivity"],["wastegate test","boost leak test","fuel-pressure check"]),
  e("eng_ecoboost10","1.0L EcoBoost I3 reference",2012,nil,.inline3,["direct injection","turbo control","modern ECU"],["three-cylinder torsional/NVH behavior","small-system thermal density"],["mount/NVH diagnosis","boost test","cooling pressure test"])
 ]
 public static let transmissions:[PeriodAwarePowertrainPartRev36] = [
  t("tx_toploader4","Toploader 4-speed manual reference",1964,1973,.transmission,.manual,["clutch","longitudinal driveshaft"],["synchro wear","gear/bearing heat"],["endplay inspection","synchro/gear inspection","shift-linkage adjustment"]),
  t("tx_tr9070","Tremec TR-9070 7-speed DCT reference",2020,nil,.transmission,.dct,["wet-clutch hydraulics","CAN/mechatronics","cooling circuit"],["clutch thermal saturation","hydraulic/mechatronic fault"],["clutch thermal proof","actuator sweep","fluid/debris inspection"]),
  t("tx_c6","C6 3-speed automatic reference",1966,1996,.transmission,.automatic,["torque converter","ATF cooling","longitudinal driveshaft"],["converter heat","clutch/band wear","fluid thermal breakdown"],["line-pressure test","stall/thermal test","fluid/debris inspection"]),
  t("tx_10r80","10R80 10-speed automatic reference",2017,nil,.transmission,.automatic,["electronic control","ATF cooling","longitudinal driveline"],["shift-energy heat","clutch adaptation","hydraulic control faults"],["adaptive shift evidence","line-pressure test","thermal proof"]),
  t("tx_tr3160","Tremec TR-3160 6-speed manual reference",2015,nil,.transmission,.manual,["clutch","cooling where configured","longitudinal driveshaft"],["synchro heat/wear","clutch thermal load"],["shift-effort test","fluid inspection","clutch release measurement"]),
  t("tx_t44","Kar-Kraft T-44 4-speed transaxle reference",1966,1967,.transaxle,.rearTransaxle,["rear transaxle mounts","halfshafts","external oil cooling"],["ring-and-pinion thermal stress","bearing/endplay wear"],["backlash/contact pattern","oil-temperature proof","bearing inspection"]),
  t("tx_ricardo6","Ricardo 6-speed transaxle reference",2005,2006,.transaxle,.rearTransaxle,["rear transaxle mounts","halfshafts","cooling"],["half-shaft joint load","gear/bearing thermal load"],["fastener provenance","backlash/endplay","fluid/debris inspection"]),
  t("tx_t5","BorgWarner/Tremec T-5 5-speed manual reference",1983,2010,.transmission,.manual,["clutch","longitudinal driveshaft"],["synchro wear","gear tooth overload"],["endplay inspection","shift-fork inspection","fluid debris check"]),
  t("tx_mtx75","MTX-75 5-speed transverse manual reference",1992,2011,.transaxle,.transverseTransaxle,["FWD clutch","halfshafts","transverse mounts"],["differential/bearing load","synchro wear"],["differential bearing inspection","shift linkage","fluid debris check"]),
  t("tx_zf_truck5","ZF heavy-duty Ford truck 5-speed reference",1987,1997,.transmission,.manual,["heavy clutch","longitudinal driveshaft","truck crossmember"],["bearing load","synchronizer wear","lubricant heat"],["endplay inspection","clutch release test","fluid/debris inspection"]),
  t("tx_zf_pantera5","ZF Pantera-style 5-speed transaxle reference",1971,1992,.transaxle,.rearTransaxle,["mid-engine linkage","halfshafts","rear transaxle mounts"],["linkage misalignment","gear/bearing thermal load"],["dogleg linkage alignment","backlash/endplay","fluid/debris inspection"])
 ]
 public static let all = engines + transmissions
 public static func availability(of part:PeriodAwarePowertrainPartRev36, inYear year:Int)->CatalogAvailabilityRev36 {
  guard year >= part.introducedYear else { return .init(available:false,kinds:[],reason:"Technology has not entered the career timeline yet") }
  if let end=part.productionEndYear, year > end {
   var kinds:[CatalogAvailabilityKindRev36] = [.usedOriginal,.salvage,.reproduction,.engineeredSwap]
   if year <= end + 12 { kinds.insert(.newOldStock,at:1) }
   return .init(available:true,kinds:kinds,reason:"Out of original production; available through historical/aftermarket channels")
  }
  let competition = part.displayName.localizedCaseInsensitiveContains("Cosworth") || part.displayName.localizedCaseInsensitiveContains("T-44") || part.displayName.localizedCaseInsensitiveContains("Cammer")
  return .init(available:true,kinds:competition ? [.periodCorrectCompetition,.periodCorrectOEM,.engineeredSwap] : [.periodCorrectOEM,.modernAftermarket,.engineeredSwap],reason:"Available in the current career year")
 }
 public static func compatibility(part:PeriodAwarePowertrainPartRev36, vehicleYear:Int, vehicleArchitecture:String)->SwapCompatibilityRev36 {
  var req=part.requiredSystems
  var conflicts:[String]=[]
  if part.introducedYear > vehicleYear { req += ["later-era wiring/control integration","period-authenticity waiver"] }
  if part.kind == .transaxle { req += ["transaxle-specific rear structure","halfshafts","shifter/control reroute"] }
  if part.architecture == .transverseTransaxle && !vehicleArchitecture.lowercased().contains("front") { conflicts.append("transverse powertrain geometry conflicts with longitudinal chassis without major fabrication") }
  if [.dohcV8,.sohcV8,.turboInline6].contains(part.architecture) { req += ["engine-bay clearance survey","mount/crossmember engineering"] }
  return .init(directFit:req.count <= part.requiredSystems.count && conflicts.isEmpty,requirements:Array(Set(req)).sorted(),hardConflicts:conflicts)
 }
}
