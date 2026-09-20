import Foundation
import WTRLCore

public struct WorldPoint2D: Codable, Hashable, Sendable {
    public var x: Double
    public var y: Double
    public init(_ x: Double, _ y: Double) { self.x=x; self.y=y }
    public func distanceSquared(to o: Self) -> Double { let dx=x-o.x, dy=y-o.y; return dx*dx+dy*dy }
}

public enum WorldSimulationTier: String, Codable, Hashable, Sendable {
    case dormant, farKinematic, nearInteractive
}

public struct WorldStreamingCell: Codable, Hashable, Sendable {
    public var id: String
    public var center: WorldPoint2D
    public var halfExtentM: Double
    public var tier: WorldSimulationTier
    public init(id:String, center:WorldPoint2D, halfExtentM:Double, tier:WorldSimulationTier = .dormant) {
        self.id=id; self.center=center; self.halfExtentM=halfExtentM; self.tier=tier
    }
}

public struct WorldStreamingPolicy: Codable, Hashable, Sendable {
    public var interactiveRadiusM = 180.0
    public var kinematicRadiusM = 900.0
    public var hysteresisM = 40.0
    public init() {}
}

public enum WorldStreamingAuthority {
    public static func update(cells: inout [WorldStreamingCell], player: WorldPoint2D, policy p: WorldStreamingPolicy = .init()) {
        let nearIn = p.interactiveRadiusM
        let nearOut = p.interactiveRadiusM + p.hysteresisM
        let farIn = p.kinematicRadiusM
        let farOut = p.kinematicRadiusM + p.hysteresisM
        for i in cells.indices {
            let d2 = cells[i].center.distanceSquared(to: player)
            switch cells[i].tier {
            case .nearInteractive:
                if d2 > nearOut*nearOut {
                    cells[i].tier = d2 <= farOut*farOut ? .farKinematic : .dormant
                }
            case .farKinematic:
                if d2 <= nearIn*nearIn { cells[i].tier = .nearInteractive }
                else if d2 > farOut*farOut { cells[i].tier = .dormant }
            case .dormant:
                if d2 <= nearIn*nearIn { cells[i].tier = .nearInteractive }
                else if d2 <= farIn*farIn { cells[i].tier = .farKinematic }
            }
        }
    }
}

public struct AmbientTrafficAgent: Codable, Hashable, Sendable {
    public var id: UInt32
    public var position: WorldPoint2D
    public var speedMps: Double
    public var laneTargetIndex: Int
    public var tier: WorldSimulationTier
    public var brakeLightActive: Bool
    public init(id:UInt32, position:WorldPoint2D, speedMps:Double=0, laneTargetIndex:Int=0, tier:WorldSimulationTier = .farKinematic, brakeLightActive:Bool=false) {
        self.id=id;self.position=position;self.speedMps=speedMps;self.laneTargetIndex=laneTargetIndex;self.tier=tier;self.brakeLightActive=brakeLightActive
    }
}

public struct TrafficLODPolicy: Codable, Hashable, Sendable {
    public var promoteRadiusM = 65.0
    public var demoteRadiusM = 82.0
    public var maximumInteractiveAgents = 16
    public init() {}
}

public enum AmbientTrafficAuthority {
    /// Mutates tiers in place. It intentionally avoids remove/append churn in the hot update path.
    public static func update(agents: inout [AmbientTrafficAgent], player: WorldPoint2D, policy p: TrafficLODPolicy = .init()) {
        var nearCount = agents.reduce(0) { $0 + ($1.tier == .nearInteractive ? 1 : 0) }
        let promote2=p.promoteRadiusM*p.promoteRadiusM, demote2=p.demoteRadiusM*p.demoteRadiusM
        for i in agents.indices where agents[i].tier == .nearInteractive {
            if agents[i].position.distanceSquared(to: player) > demote2 {
                agents[i].tier = .farKinematic; nearCount -= 1
            }
        }
        guard nearCount < p.maximumInteractiveAgents else { return }
        let candidates = agents.indices
            .filter { agents[$0].tier != .nearInteractive && agents[$0].position.distanceSquared(to: player) <= promote2 }
            .sorted { agents[$0].position.distanceSquared(to: player) < agents[$1].position.distanceSquared(to: player) }
        for i in candidates.prefix(max(0,p.maximumInteractiveAgents-nearCount)) { agents[i].tier = .nearInteractive }
    }
}
