using UnityEngine;

/// <summary>
/// The four AI intimidation parameters specified in racinggameideas/32-
/// HERO-CAR.md S5.3 and racinggameideas/45-RIVAL-DEVELOPMENT.md Part 1 --
/// specified in full, including per-rival personality tuning, but never
/// actually implemented as code until this file. Found missing during
/// the research-vs-current-state comparison that also flagged the RPG
/// and action systems as design-only.
///
/// All four parameters default to zero. Per 32 S5.3: "Intimidation is
/// earned, not innate" -- a rival who has never raced the player should
/// show none of this behaviour. Values rise only through tracked history
/// with THIS SPECIFIC rival, driven externally (ReputationTraits.cs,
/// race-result tracking) rather than by this component itself, which
/// only holds and applies the current values.
/// </summary>
public class RivalAI : MonoBehaviour
{
    [Header("Identity")]
    [Tooltip("Matches the rival's name in 45-RIVAL-DEVELOPMENT.md -- " +
             "Reyes, Kade, Vogel, Duquesne, Osei, or Marsh.")]
    public string rivalName;

    [Header("Intimidation parameters (32 S5.3) -- current values")]
    [Tooltip("Metres earlier this rival begins braking when the player " +
             "is alongside.")]
    [Range(0f, 1f)] public float brakePointBias;

    [Tooltip("Probability this rival abandons a pass attempt it would " +
             "otherwise make.")]
    [Range(0f, 1f)] public float passAttemptSuppression;

    [Tooltip("Lateral jitter added to this rival's blocking line -- " +
             "larger error, easier to pass.")]
    [Range(0f, 1f)] public float defensivePositionError;

    [Tooltip("Extra milliseconds before this rival's throttle input at " +
             "the start.")]
    [Range(0f, 500f)] public float launchReactionDelayMs;

    [Header("Per-rival ceilings (45-RIVAL-DEVELOPMENT.md Part 1)")]
    [Tooltip("The maximum each parameter can reach for this specific " +
             "rival, even at full earned history. Personality-driven -- " +
             "e.g. Reyes has a LOW passAttemptSuppression ceiling even " +
             "at high reputation (he doesn't back off from fear, he " +
             "backs off because the numbers say the pass doesn't work), " +
             "while Duquesne's ceiling for the same parameter is near " +
             "zero (he never stops trying optimistic passes, ever).")]
    public float brakePointBiasCeiling = 1f;
    public float passAttemptSuppressionCeiling = 1f;
    public float defensivePositionErrorCeiling = 1f;
    public float launchReactionDelayCeilingMs = 300f;

    /// <summary>
    /// Call after any tracked event that should move this rival's
    /// intimidation parameters (a race result, a clean vs. dirty
    /// encounter -- see ReputationTraits.cs for the player-history side
    /// of this). Values are clamped to this rival's own ceilings, never
    /// exceeding personality-defined limits regardless of how much
    /// history accumulates.
    /// </summary>
    public void ApplyDelta(float brakeDelta, float passSuppressDelta,
                            float posErrorDelta, float launchDelayDeltaMs)
    {
        brakePointBias = Mathf.Clamp(brakePointBias + brakeDelta, 0f, brakePointBiasCeiling);
        passAttemptSuppression = Mathf.Clamp(passAttemptSuppression + passSuppressDelta, 0f, passAttemptSuppressionCeiling);
        defensivePositionError = Mathf.Clamp(defensivePositionError + posErrorDelta, 0f, defensivePositionErrorCeiling);
        launchReactionDelayMs = Mathf.Clamp(launchReactionDelayMs + launchDelayDeltaMs, 0f, launchReactionDelayCeilingMs);
    }

    /// <summary>
    /// Resets all four parameters to zero -- for a rival the player has
    /// never raced (32 S5.4: "A rival who has never raced the player:
    /// all four parameters at zero").
    /// </summary>
    public void ResetToUnearned()
    {
        brakePointBias = 0f;
        passAttemptSuppression = 0f;
        defensivePositionError = 0f;
        launchReactionDelayMs = 0f;
    }

    [Header("Format-conditional override (45-RIVAL-DEVELOPMENT.md S1.5, Osei)")]
    [Tooltip("Most rivals are format-agnostic -- their ceilings apply " +
             "everywhere. Osei is the one exception: 'near-zero in short " +
             "events and rise sharply in endurance-format events " +
             "specifically' (45 S1.5), which a flat ceiling can't " +
             "express. When true, all four ceilings above are treated " +
             "as the ENDURANCE-format values, and effectiveCeilingMultiplier " +
             "scales them down for every other format.")]
    public bool hasEnduranceSpecificBehaviour;
    [Range(0f, 1f)] public float shortEventCeilingMultiplier = 0.1f;

    /// <summary>
    /// Returns the actual ceiling to use for a given parameter this race,
    /// accounting for Osei's format-conditional behaviour. For every
    /// other rival (hasEnduranceSpecificBehaviour == false) this just
    /// returns the base ceiling unchanged.
    /// </summary>
    public float EffectiveCeiling(float baseCeiling, bool isEnduranceFormat)
    {
        if (!hasEnduranceSpecificBehaviour || isEnduranceFormat) return baseCeiling;
        return baseCeiling * shortEventCeilingMultiplier;
    }
}
