import Foundation

public struct ImpactBody2D: Codable, Hashable, Sendable {
    public var velocityX: Double
    public var velocityY: Double
    public var yawRateRadPerSec: Double
    public var massKg: Double
    public var yawInertiaKgM2: Double
}
public struct ContactImpulseResult: Codable, Hashable, Sendable {
    public var normalImpulseNs: Double
    public var applied: Bool
}
public enum KineticImpactAuthority {
    /// Frictionless 2D normal impulse against a second translating body. Contact normal must point from target toward striker.
    public static func resolve(target:inout ImpactBody2D, strikerVelocityX:Double, strikerVelocityY:Double, strikerMassKg:Double,
                               contactXFromTargetCG:Double, contactYFromTargetCG:Double, normalX:Double, normalY:Double,
                               restitution:Double=0.28)->ContactImpulseResult {
        let nLen=hypot(normalX,normalY); guard nLen>0.000001,target.massKg>0,strikerMassKg>0,target.yawInertiaKgM2>0 else{return .init(normalImpulseNs:0,applied:false)}
        let nx=normalX/nLen, ny=normalY/nLen
        let contactVX=target.velocityX - target.yawRateRadPerSec*contactYFromTargetCG
        let contactVY=target.velocityY + target.yawRateRadPerSec*contactXFromTargetCG
        let relX=strikerVelocityX-contactVX, relY=strikerVelocityY-contactVY
        let closing=relX*nx+relY*ny
        guard closing>0 else{return .init(normalImpulseNs:0,applied:false)}
        let rCrossN=contactXFromTargetCG*ny-contactYFromTargetCG*nx
        let denom=1/target.massKg+1/strikerMassKg+(rCrossN*rCrossN)/target.yawInertiaKgM2
        let j=(1+max(0,min(1,restitution)))*closing/denom
        target.velocityX += nx*j/target.massKg
        target.velocityY += ny*j/target.massKg
        target.yawRateRadPerSec += rCrossN*j/target.yawInertiaKgM2
        return .init(normalImpulseNs:j,applied:true)
    }
}
