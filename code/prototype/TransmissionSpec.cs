using UnityEngine;

/// <summary>
/// Transmission data model, structurally parallel to EngineVariant.cs --
/// one asset per hero-car generation's gearbox, populated from real
/// historical Ford/Mustang transmission data
/// (racinggameideas/40-FORCED-INDUCTION-DRIVETRAIN.md Part 3).
///
/// Real reference progression across the seven generations, automatics
/// alone: 3 -> 3 -> 4 -> 4 -> 5 -> 6 -> 10 speeds. This is genuine
/// engineering escalation from actual transmission history, not an
/// invented curve for range -- see 40 Part 3 for the full table and the
/// real per-gear ratio sets this can be populated from.
/// </summary>
[CreateAssetMenu(fileName = "TransmissionSpec", menuName = "Vehicle/Transmission Spec")]
public class TransmissionSpec : ScriptableObject
{
    [Header("Identity")]
    public string transmissionName; // fictional analog naming -- see 12-DERIVATION-METHOD.md
    [Tooltip("Which hero-car generation this matches, for direct lookup " +
             "against 32-HERO-CAR.md's era table and EngineVariant's " +
             "generationEra field.")]
    public string generationEra;

    public enum TransmissionType { Manual, Automatic }
    public TransmissionType type;

    [Header("Gearing")]
    [Tooltip("3 through 10, per the real historical progression in " +
             "40 Part 3. Should equal gearRatios.Length.")]
    public int speedCount;

    [Tooltip("One ratio per forward gear, in order. Populate from real " +
             "reference data for authenticity (e.g. the Top Loader " +
             "4-speed close-ratio set: 2.32/1.69/1.29/1.00) or use as a " +
             "plausible starting point for a fictional analog's own " +
             "numbers -- either is fine, this field doesn't care which.")]
    public float[] gearRatios;

    [Tooltip("Reverse gear ratio, separate from the forward array since " +
             "it doesn't participate in shift-point logic.")]
    public float reverseRatio;

    [Header("Final drive")]
    [Tooltip("Multiplies with the selected gear ratio for overall " +
             "reduction -- kept separate since final drive is commonly " +
             "swapped independently of the gearbox itself (25-GARAGE-" +
             "DESIGN.md Part 5: 'Transmission | Gearset, clutch | Final " +
             "drive, ratios').")]
    public float finalDriveRatio = 3.55f;

    [Header("The top-trim exception (40 §1.3, §3.3)")]
    [Tooltip("The real reference top trim pairs its supercharged engine " +
             "with a real Tremec TR-9070 7-speed DCT (900Nm/664lb-ft " +
             "capacity, ratios 3.14/2.05/1.43/1.10/0.86/0.68/0.56 per " +
             "TREMEC's own product sheet) and NO manual option " +
             "at all -- a genuine trade-off (outright speed vs. driver " +
             "engagement), not a strict upgrade. If this transmission " +
             "represents that configuration, flag it here so garage/" +
             "parts-wall logic can enforce the exclusivity rather than " +
             "silently allowing a manual to be paired with an engine " +
             "variant that shouldn't offer one.")]
    public bool isExclusiveToTopTrim;
    [Tooltip("If isExclusiveToTopTrim, the specific EngineVariant this " +
             "transmission requires -- leave null otherwise.")]
    public EngineVariant requiredEngineVariant;

    /// <summary>
    /// Computes overall gear reduction (gear ratio x final drive) for a
    /// given forward gear index (0-based). Feed this into TORSION's
    /// gearbox/differential chain the same way EngineVariant.ApplyToEngine()
    /// feeds the torque curve into Engine.
    /// </summary>
    public float OverallRatio(int gearIndex)
    {
        if (gearRatios == null || gearIndex < 0 || gearIndex >= gearRatios.Length)
            return 0f;
        return gearRatios[gearIndex] * finalDriveRatio;
    }

    /// <summary>
    /// Validates this spec against a candidate engine variant before
    /// allowing installation -- call from the parts-wall / garage flow
    /// (25-GARAGE-DESIGN.md §4.2) alongside EngineFamily.AcceptsPartTag().
    /// </summary>
    public bool CompatibleWith(EngineVariant candidateEngine)
    {
        if (isExclusiveToTopTrim)
            return candidateEngine == requiredEngineVariant;
        return true; // non-exclusive transmissions are assumed broadly compatible;
                      // extend with family/tag checks if a specific project needs them
    }

#if UNITY_EDITOR
    [ContextMenu("Validate speedCount matches gearRatios.Length")]
    private void ValidateSpeedCount()
    {
        int actual = gearRatios != null ? gearRatios.Length : 0;
        if (actual != speedCount)
        {
            Debug.LogWarning($"{name}: speedCount is {speedCount} but " +
                              $"gearRatios has {actual} entries. Fix one " +
                              $"or the other before shipping this asset.");
        }
        else
        {
            Debug.Log($"{name}: OK, {speedCount}-speed matches gearRatios.Length.");
        }
    }
#endif
}
