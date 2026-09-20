using UnityEngine;

/// <summary>
/// Beckman's three-parameter tyre force approximation ("The Magical Trick",
/// The Physics of Racing Part 29). See racinggameideas/34-PHYSICS-READING.md
/// Part 1e and racinggameideas/31-DYNO-ANALYSIS.md S6.0b for the full
/// derivation and the rationale for choosing this over full Pacejka.
///
///     F = B * Fz * alpha / (1 + |A * alpha|^P)
///
/// Differs from the full Magic Formula (Parts 21-22) by under 10% almost
/// everywhere for a well-fitted (A,B,P) triple, at three tunable numbers
/// per axis instead of eleven-to-fifteen, and with no transcendental
/// (sin/arctan) chain to evaluate every wheel, every tick. Beckman built
/// this specifically for real-time game simulation and said so.
///
/// One asset per tyre compound. Longitudinal (slip ratio) and lateral
/// (slip angle, degrees) axes are fitted independently -- their slip units
/// are not commensurable, which is exactly why Combined() below has to
/// normalise before combining (Beckman Parts 24-25).
/// </summary>
[CreateAssetMenu(fileName = "TireCompound", menuName = "Vehicle/Tire Force Model (Beckman)")]
public class TireForceModel : ScriptableObject
{
    [Header("Longitudinal axis -- slip ratio, dimensionless")]
    [Tooltip("Beckman's own reference fit against Genta's Ferrari data: "
           + "A=9.625, B=31.0, P=2.375. Treat as a starting point, not a "
           + "target -- fit your own compound against RVP's authored curves "
           + "or real data using FindPeakSlipRatio() below.")]
    public float longA = 9.625f;
    public float longB = 31.0f;
    public float longP = 2.375f;

    [Header("Lateral axis -- slip angle, degrees")]
    [Tooltip("No reference triple published for this axis in Part 29 -- "
           + "fit against your own curve. Beckman's full Pacejka lateral "
           + "fit (Part 22) peaks around 4 degrees; use that as a sanity "
           + "check, not a value to copy blindly.\n\n"
           + "FIXED 2026: the original placeholder here (latB=10.0) "
           + "produced an implied peak friction coefficient of ~8.9 -- "
           + "physically absurd; real tyres run roughly 1.0-1.7. This was "
           + "found by code/prototype/simulation/tire_model.py actually "
           + "running numbers through the shipped defaults, not by code "
           + "review. B is a pure linear multiplier on output force, so "
           + "rescaling it rescales peak force proportionally with no "
           + "other side effects -- confirmed algebraically and in the "
           + "simulation. Recalibrated to mu~1.2 (a grippy road/sport "
           + "tyre). Still a placeholder -- fit against your own curve "
           + "before shipping -- but now a physically plausible one.")]
    public float latA = 0.5f;
    public float latB = 1.35f; // was 10.0f -- see tooltip
    public float latP = 1.8f;

    [Header("Peak location (fill in via FindPeak* before shipping)")]
    [Tooltip("Beckman's own longitudinal fit peaks at sigma ~= 0.08.")]
    public float maxSlipRatio = 0.08f;
    [Tooltip("Beckman's lateral (full Pacejka) fit peaks at ~4 degrees.")]
    public float maxSlipAngleDeg = 4.0f;

    [Header("Low-speed safety (34 S1c Finding 2 -- Pacejka-family divergence)")]
    [Tooltip("Slip *ratio* has forward speed in its denominator and blows "
           + "up near a standstill -- this is a property of the slip "
           + "calculation, not of the force formula. Blend the computed "
           + "ratio toward zero between these two speeds (m/s).")]
    public float lowSpeedBlendStart = 0.5f;
    public float lowSpeedBlendEnd = 2.0f;

    // ---------------------------------------------------------------
    // Core formula
    // ---------------------------------------------------------------

    /// <summary>Raw single-axis force from the three-parameter formula.</summary>
    private static float MagicalTrick(float alpha, float Fz, float A, float B, float P)
    {
        float denom = 1f + Mathf.Pow(Mathf.Abs(A * alpha), P);
        return B * Fz * alpha / denom;
    }

    /// <summary>Longitudinal force for a given slip ratio and vertical load.</summary>
    public float Longitudinal(float slipRatio, float Fz) =>
        MagicalTrick(slipRatio, Fz, longA, longB, longP);

    /// <summary>Lateral force for a given slip angle (degrees) and vertical load.</summary>
    public float Lateral(float slipAngleDeg, float Fz) =>
        MagicalTrick(slipAngleDeg, Fz, latA, latB, latP);

    /// <summary>
    /// Combined slip (34 Part 1e, Beckman Parts 24-25). Slip ratio (a
    /// fraction of unity) and slip angle (degrees) are not commensurable --
    /// you cannot add them directly. The fix: normalise each by its own
    /// peak, combine the normalised values by Pythagoras, then scale each
    /// axis's *output* force by its share of the combined magnitude.
    ///
    /// This is the same method the public-domain reference implementation
    /// in code/pacejka-reference/pacejka.py uses for full Pacejka, ported
    /// here to the cheaper three-parameter formula.
    /// </summary>
    public Vector2 Combined(float slipRatio, float slipAngleDeg, float Fz)
    {
        float S = maxSlipRatio > 0f ? slipRatio / maxSlipRatio : 0f;
        float A = maxSlipAngleDeg > 0f ? slipAngleDeg / maxSlipAngleDeg : 0f;
        float p = Mathf.Sqrt(S * S + A * A);
        if (p < 1e-5f) return Vector2.zero;

        float fx = (S / p) * Longitudinal(p * maxSlipRatio, Fz);
        float fy = (A / p) * Lateral(p * maxSlipAngleDeg, Fz);
        return new Vector2(fx, fy);
    }

    /// <summary>
    /// The theoretical peak force this axle/tyre can produce at the given
    /// load, independent of current slip -- used by RaggedEdgeMeter as the
    /// denominator of "how close to the limit are we." Not a circle in
    /// general: if longitudinal and lateral peaks differ (a tyre that grips
    /// harder one way than the other), the true combined-force boundary is
    /// Beckman's "egg" shape (34 Part 1c, Part 7), not a circle. See
    /// RaggedEdgeMeter.FillLevel01() for how this is used.
    /// </summary>
    public float PeakLongitudinal(float Fz) => Mathf.Abs(Longitudinal(maxSlipRatio, Fz));
    public float PeakLateral(float Fz) => Mathf.Abs(Lateral(maxSlipAngleDeg, Fz));

    // ---------------------------------------------------------------
    // Slip ratio, with the low-speed guard
    // ---------------------------------------------------------------

    /// <summary>
    /// sigma = (omega * Re - V) / V (34 S1e, Beckman Part 21). Free-rolling
    /// is 0; a locked wheel under braking is -1. The V in the denominator
    /// is exactly the term that diverges near zero speed -- callers should
    /// scale the *result* of this by LowSpeedBlend() before feeding it into
    /// Longitudinal()/Combined(), rather than trusting the raw value below
    /// walking pace.
    /// </summary>
    public static float RawSlipRatio(float wheelAngularVel, float wheelRadius, float forwardSpeed)
    {
        float speedForDivision = Mathf.Max(Mathf.Abs(forwardSpeed), 0.01f);
        return (wheelAngularVel * wheelRadius - forwardSpeed) / speedForDivision;
    }

    /// <summary>0 well below lowSpeedBlendStart, 1 at/above lowSpeedBlendEnd.</summary>
    public float LowSpeedBlend(float forwardSpeed) =>
        Mathf.InverseLerp(lowSpeedBlendStart, lowSpeedBlendEnd, Mathf.Abs(forwardSpeed));

    // ---------------------------------------------------------------
    // Authoring tools -- measure a curve's own peak rather than trusting
    // Beckman's reference numbers for a different tyre (31 S6.2).
    // ---------------------------------------------------------------

    public float FindPeakSlipRatio(float Fz, int samples = 400, float maxSearch = 0.5f)
    {
        float best = 0f, bestF = 0f;
        for (int i = 1; i <= samples; i++)
        {
            float s = maxSearch * i / samples;
            float f = Mathf.Abs(Longitudinal(s, Fz));
            if (f > bestF) { bestF = f; best = s; }
        }
        return best;
    }

    public float FindPeakSlipAngleDeg(float Fz, int samples = 400, float maxSearchDeg = 20f)
    {
        float best = 0f, bestF = 0f;
        for (int i = 1; i <= samples; i++)
        {
            float a = maxSearchDeg * i / samples;
            float f = Mathf.Abs(Lateral(a, Fz));
            if (f > bestF) { bestF = f; best = a; }
        }
        return best;
    }

#if UNITY_EDITOR
    [ContextMenu("Measure peaks at Fz = 4000 N and fill in maxSlipRatio/maxSlipAngleDeg")]
    private void MeasureAndFillPeaks()
    {
        const float refFz = 4000f;
        maxSlipRatio = FindPeakSlipRatio(refFz);
        maxSlipAngleDeg = FindPeakSlipAngleDeg(refFz);
        UnityEditor.EditorUtility.SetDirty(this);
        Debug.Log($"{name}: measured maxSlipRatio={maxSlipRatio:F4}, " +
                  $"maxSlipAngleDeg={maxSlipAngleDeg:F2} at Fz={refFz} N");
    }
#endif
}
