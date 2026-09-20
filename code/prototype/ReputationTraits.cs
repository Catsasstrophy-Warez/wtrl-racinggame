using UnityEngine;

/// <summary>
/// Emergent reputation traits (49-PLAYER-CHARACTER-RPG.md Part 3). No
/// trait menu -- reads histories already tracked by SafetyRating and
/// PartsGating, and modifies RivalAI parameters on rivals the player
/// encounters. Per 49 S3.2: "Every trait above is a read of an existing
/// tracked history, not a new currency."
/// </summary>
public class ReputationTraits : MonoBehaviour
{
    [Header("Source data (assign the player's tracked components)")]
    public SafetyRating safetyRating;
    public DiagnosticSkill diagnosticSkill;

    [Header("Career-length history, for the 'reads a car fast' trait")]
    [Tooltip("Total events completed, for comparing diagnostic-skill " +
             "use count against career length (49 S3.1's third row).")]
    public int totalEventsCompleted;

    [Header("Thresholds (tune during production)")]
    public float cleanRacerAverageSafetyThreshold = 80f;
    public int noStrangerToContactMinimumEvents = 15;
    public float noStrangerToContactMaxAverageSafety = 60f;

    // Running average, updated by whatever calls RecordEventOutcome --
    // a simple running mean, not a snapshot of current rating alone,
    // since traits should read sustained pattern, not the last result.
    private float _runningSafetyAverage = 100f;
    private int _safetyResultsCounted;

    public void RecordEventOutcome(float resultSafetyRating)
    {
        _safetyResultsCounted++;
        _runningSafetyAverage += (resultSafetyRating - _runningSafetyAverage) / _safetyResultsCounted;
        totalEventsCompleted++;
    }

    public bool HasCleanRacerTrait => _runningSafetyAverage >= cleanRacerAverageSafetyThreshold;

    public bool HasNoStrangerToContactTrait =>
        totalEventsCompleted >= noStrangerToContactMinimumEvents &&
        _runningSafetyAverage <= noStrangerToContactMaxAverageSafety;

    public bool HasReadsACarFastTrait =>
        diagnosticSkill != null && totalEventsCompleted > 0 &&
        (float)diagnosticSkill.rivalInspectionUses / totalEventsCompleted > 0.5f;

    /// <summary>
    /// Applies the current traits to a specific rival's RivalAI
    /// component, per 49 S3.1's table. Call when a race against this
    /// rival is about to start, so their behaviour reflects the
    /// player's actual history rather than a fixed difficulty.
    /// </summary>
    public void ApplyTraitsToRival(RivalAI rival)
    {
        if (rival == null) return;

        if (HasCleanRacerTrait)
        {
            // A rival respects a clean driver's pressure differently --
            // pass suppression rises FASTER when intimidated (49 S3.1,
            // row 1), not just higher in general.
            rival.ApplyDelta(0f, 0.05f, 0f, 0f);
        }

        if (HasNoStrangerToContactTrait)
        {
            // Matches the wary-not-scared distinction already
            // established for Vogel specifically (45 S1.3) -- rivals
            // defend HARDER against a known-aggressive player, not
            // softer.
            rival.ApplyDelta(0f, 0f, -0.03f, 0f); // note: negative delta
                                                    // REDUCES defensivePositionError,
                                                    // meaning tighter, more careful defending
        }

        // HasReadsACarFastTrait affects the rival-inspection UI directly
        // (25 S4.5b), not RivalAI -- no call needed here; check the
        // trait property directly from the inspection UI code instead.
    }
}
