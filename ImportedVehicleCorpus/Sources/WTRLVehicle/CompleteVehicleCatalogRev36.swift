import Foundation
public enum VehicleCatalogClassRev36:String,Codable,Sendable { case productionHero, heritageReference, mustangHeritageReference, fictionalSpecial, secretEndgame }
public struct VehicleCatalogEntryRev36:Codable,Hashable,Sendable,Identifiable { public var id:String; public var displayName:String; public var group:String; public var catalogClass:VehicleCatalogClassRev36; public var playerFacing:Bool; public var researchGated:Bool }
public enum CompleteVehicleCatalogRev36 {
 public static let entries:[VehicleCatalogEntryRev36] = {
  let heroes=HeroProductionRosterRev27.vehicles.map{VehicleCatalogEntryRev36(id:$0.id,displayName:$0.displayName,group:"Crownfire / Legend production heroes",catalogClass:.productionHero,playerFacing:true,researchGated:false)}
  let heritage=HeritageLineageEngineeringRev29.allVehicles.map{VehicleCatalogEntryRev36(id:$0.id,displayName:$0.displayName,group:$0.lineageId,catalogClass:.heritageReference,playerFacing:true,researchGated:true)}
  let mustang=MustangHeritageRev33.vehicles.map{VehicleCatalogEntryRev36(id:$0.id,displayName:$0.displayName,group:"Mustang Performance Heritage",catalogClass:.mustangHeritageReference,playerFacing:true,researchGated:true)}
  let specials=FictionalLineageSpecialCatalog.specials.map{VehicleCatalogEntryRev36(id:$0.id,displayName:$0.name,group:"Vanguard lineage specials",catalogClass:.fictionalSpecial,playerFacing:true,researchGated:false)}
  let secret=VehicleCatalogEntryRev36(id:SecretApexVehicleRev34.platformId,displayName:"Apex Revenant",group:"Secret endgame",catalogClass:.secretEndgame,playerFacing:true,researchGated:false)
  return heroes+heritage+mustang+specials+[secret]
 }()
 public static var playerFacingCount:Int { entries.filter(\.playerFacing).count }
 public static var uniqueIDs:Bool { Set(entries.map(\.id)).count == entries.count }
}
