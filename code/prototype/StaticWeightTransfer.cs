using UnityEngine;

/// <summary>
/// Beckman's closed-form four-corner static weight transfer solution
/// (The Physics of Racing Part 27 -- see racinggameideas/34-PHYSICS-
/// READING.md Part 1e). A four-wheeled car is statically indeterminate:
/// three torque-balance equations, four unknown corner loads. Beckman
/// resolves it with the same "no artificial weight jacking" symmetry
/// assumption already recommended in racinggameideas/25-GARAGE-DESIGN.md
/// S5 -- f1z * f3z = f2z * f4z, the four-corner generalisation of the
/// two-wheel ad = bc condition.
///
/// THIS IS A CROSS-CHECK TOOL, NOT THE PRIMARY LOAD MODEL. The primary
/// recommendation throughout this package is to derive per-wheel load
/// from suspension spring compression (see RaggedEdgeMeter.EstimateLoad
/// and 25-GARAGE-DESIGN.md S5) -- that approach is physically correct,
/// free with RVP's existing raycast suspension, and produces real weight-
/// jacking behaviour as an emergent property rather than an assumption.
///
/// Use this class to sanity-check that emergent behaviour against the
/// closed-form static answer under level-ground, steady-state conditions
/// (no jacking, no elevation change, no banking -- see the limitations
/// noted on Compute() below), or to bootstrap a reasonable static setup
/// before the suspension model has settled.
/// </summary>
public static class StaticWeightTransfer
{
    /// <summary>Per-corner load result, matching RVP's clockwise-from-
    /// right-front numbering convention used elsewhere in this package.</summary>
    public struct CornerLoads
    {
        public float leftFront;
        public float rightFront;
        public float leftRear;
        public float rightRear;

        public float Sum => leftFront + rightFront + leftRear + rightRear;
    }

    /// <summary>
    /// Closed-form solution for level ground, steady state (Beckman's own
    /// stated scope for Part 27 -- he is explicit that banked or cambered
    /// surfaces need the fuller elevation/banking treatment implied by
    /// Part 22's ROAD frames, which this method does not attempt).
    /// </summary>
    /// <param name="massKg">Total vehicle mass.</param>
    /// <param name="cgHeightM">CG height above ground, metres.</param>
    /// <param name="wheelbaseM">a + b: front-axle-to-CG plus CG-to-rear-axle.</param>
    /// <param name="frontTrackM">Full front track width, metres.</param>
    /// <param name="rearTrackM">Full rear track width, metres.</param>
    /// <param name="cgToFrontAxleM">"a" -- longitudinal distance, CG to front axle.</param>
    /// <param name="cgToRearAxleM">"b" -- longitudinal distance, CG to rear axle.</param>
    /// <param name="longitudinalForceN">Fx: positive = braking-direction
    /// force as defined by Beckman's sign convention (SAE frame, X forward)
    /// -- verify sign against your own force convention before trusting
    /// the output; getting this backwards silently swaps front/rear bias.</param>
    /// <param name="lateralForceN">Fy: lateral force, SAE convention
    /// (Y to driver's right).</param>
    public static CornerLoads Compute(
        float massKg, float cgHeightM,
        float cgToFrontAxleM, float cgToRearAxleM,
        float frontTrackM, float rearTrackM,
        float longitudinalForceN, float lateralForceN)
    {
        float mg = massKg * 9.81f;
        float a = cgToFrontAxleM;
        float b = cgToRearAxleM;
        float h = cgHeightM;
        float tf = frontTrackM * 0.5f; // Beckman's tf/tr are half-track
        float tr = rearTrackM * 0.5f;
        float Fx = longitudinalForceN;
        float Fy = lateralForceN;

        float tDeltaF = (b * mg - Fx * h) / 2f;
        float tDeltaR = (a * mg + Fx * h) / 2f;
        float lBar = 1f / Mathf.Max(a + b, 0.001f);

        float rDenominator = h * Fx * (tr - tf) + mg * (a * tr + b * tf);
        float rBarA = Mathf.Abs(rDenominator) > 0.001f ? (h * Fy) / rDenominator : 0f;

        return new CornerLoads
        {
            leftFront = tDeltaF * (lBar + rBarA),
            rightFront = tDeltaF * (lBar - rBarA),
            leftRear = tDeltaR * (lBar + rBarA),
            rightRear = tDeltaR * (lBar - rBarA)
        };
    }

    /// <summary>
    /// The cross-weight ("wedge") term in isolation -- Beckman's R_A,
    /// referenced in 25-GARAGE-DESIGN.md S5 as the cross-weight tuning
    /// knob made explicit. Driven by track-width asymmetry and lateral CG
    /// position; a symmetric car under zero lateral force has R_A = 0.
    /// </summary>
    public static float ComputeCrossWeightTerm(
        float massKg, float cgHeightM,
        float cgToFrontAxleM, float cgToRearAxleM,
        float frontTrackM, float rearTrackM,
        float longitudinalForceN, float lateralForceN)
    {
        float mg = massKg * 9.81f;
        float a = cgToFrontAxleM;
        float b = cgToRearAxleM;
        float h = cgHeightM;
        float tf = frontTrackM * 0.5f;
        float tr = rearTrackM * 0.5f;
        float Fx = longitudinalForceN;
        float Fy = lateralForceN;

        float rDenominator = h * Fx * (tr - tf) + mg * (a * tr + b * tf);
        return Mathf.Abs(rDenominator) > 0.001f ? (h * Fy) / rDenominator : 0f;
    }
}
