using UnityEngine;

/// <summary>
/// Diagnostic skill (49-PLAYER-CHARACTER-RPG.md Part 2) -- deepens
/// through actual use of three systems already built (rival inspection,
/// post-race telemetry, the dyno), not through a skill-point menu. Per
/// 49 S2.2: "No menu, no allocation. The game tracks a simple use-count
/// per system."
/// </summary>
public class DiagnosticSkill : MonoBehaviour
{
    [Header("Use counts -- the only thing this system tracks")]
    public int rivalInspectionUses;
    public int telemetryReadUses;
    public int dynoSessionUses;

    [Header("Thresholds for each depth tier (tune during production)")]
    public int inspectionDepthThreshold = 10;
    public int telemetryDepthThreshold = 8;
    public int dynoDepthThreshold = 6;

    /// <summary>Call from the rival inspection system (25 S4.5b) each
    /// time the player walks a rival's car at a meet.</summary>
    public void RecordRivalInspection() => rivalInspectionUses++;

    /// <summary>Call from the post-race telemetry system (20 S5) each
    /// time the player reviews a result.</summary>
    public void RecordTelemetryRead() => telemetryReadUses++;

    /// <summary>Call from DynoController each time a session completes.</summary>
    public void RecordDynoSession() => dynoSessionUses++;

    /// <summary>
    /// Whether rival inspection should show specific tells (a worn
    /// part, an unusual tune) rather than just broad stats -- 49 S2.2's
    /// table, first row.
    /// </summary>
    public bool ShowsDetailedRivalTells => rivalInspectionUses >= inspectionDepthThreshold;

    /// <summary>
    /// Whether post-race telemetry should surface secondary,
    /// compounding faults rather than just the one primary fault (20
    /// S5's original spec) -- 49 S2.2's table, second row.
    /// </summary>
    public bool ShowsCompoundingFaults => telemetryReadUses >= telemetryDepthThreshold;

    /// <summary>
    /// Whether the dyno should annotate likely causes directly on the
    /// curve, rather than showing the raw graph only -- 49 S2.2's
    /// table, third row.
    /// </summary>
    public bool AnnotatesDynoCurve => dynoSessionUses >= dynoDepthThreshold;

    /// <summary>
    /// The single most important connection in this whole system (49
    /// S2.3): a normalised 0-1 value representing how much of the
    /// mentor's installation commentary should be SKIPPED because the
    /// player would already have caught the thing he's about to say.
    /// Wire this into the installation-sequence dialogue system so his
    /// lines genuinely shorten over a career, rather than firing on a
    /// fixed story timestamp.
    /// </summary>
    public float MentorPreemptionFactor01
    {
        get
        {
            float inspectionProgress = Mathf.Clamp01((float)rivalInspectionUses / inspectionDepthThreshold);
            float telemetryProgress = Mathf.Clamp01((float)telemetryReadUses / telemetryDepthThreshold);
            float dynoProgress = Mathf.Clamp01((float)dynoSessionUses / dynoDepthThreshold);
            return (inspectionProgress + telemetryProgress + dynoProgress) / 3f;
        }
    }
}
