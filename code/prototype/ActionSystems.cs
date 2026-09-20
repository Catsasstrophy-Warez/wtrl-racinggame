using UnityEngine;

/// <summary>
/// The aggression economy (50-ACTION-PILLAR-EXPANDED.md Part 1). Three
/// triggers, each feeding nitrous (the real reward) and SafetyRating
/// (the real cost) in opposite directions -- deliberately never a free
/// resource.
/// </summary>
public class AggressionEconomy : MonoBehaviour
{
    [Header("Wiring")]
    public SafetyRating safetyRating;
    public NitrousSystem nitrous;

    public enum Trigger { ForcedError, TakedownAdjacent, HeldUnderPressure }

    /// <summary>Call from collision/contact detection with the
    /// classified trigger type.</summary>
    public void RecordTrigger(Trigger trigger)
    {
        float nitrousGain;
        SafetyRating.SafetyEvent safetyEvent;

        switch (trigger)
        {
            case Trigger.ForcedError:
                nitrousGain = 15f;
                safetyEvent = SafetyRating.SafetyEvent.OffTrackCutForAdvantage; // closest existing category
                break;
            case Trigger.TakedownAdjacent:
                nitrousGain = 30f;
                safetyEvent = SafetyRating.SafetyEvent.CausedRivalSpinOrRetire;
                break;
            case Trigger.HeldUnderPressure:
                nitrousGain = 10f;
                safetyEvent = SafetyRating.SafetyEvent.DefensiveHoldNoContact;
                break;
            default:
                return;
        }

        if (nitrous != null) nitrous.AddCharge(nitrousGain);
        if (safetyRating != null) safetyRating.RecordEvent(safetyEvent);
    }
}

/// <summary>
/// Nitrous as a real mechanical resource (50 Part 2.3), not a flat speed
/// multiplier. Temporarily raises the traction ceiling
/// TireForceModel.PeakLongitudinal() allows, the same way
/// DynoController.cs already computes traction-limited drive force.
/// </summary>
public class NitrousSystem : MonoBehaviour
{
    [Header("Charge")]
    [Range(0f, 100f)] public float charge;

    [Header("Effect while active")]
    [Tooltip("Multiplier applied to TireForceModel.PeakLongitudinal() " +
             "while nitrous is active and charge > 0 -- NOT a flat " +
             "speed multiplier; it raises the traction ceiling, which " +
             "the existing tyre-limited launch physics (34 Part 1c) " +
             "then applies normally.")]
    public float tractionCeilingMultiplier = 1.15f; // TESTED (58-TEST-
    // EVALUATION-PASS.md Part 3): implies mu~1.85 at full charge against
    // the validated tire model (baseline mu~1.61). Not physically absurd,
    // but near the plausible upper edge -- flagged as a production-tuning
    // target to revisit once real device testing exists, not a bug.
    [Tooltip("Charge consumed per second while active.")]
    public float drainPerSecond = 20f;

    public bool IsActive { get; private set; }

    public void AddCharge(float amount) => charge = Mathf.Clamp(charge + amount, 0f, 100f);

    public void SetActive(bool active) => IsActive = active && charge > 0f;

    private void Update()
    {
        if (IsActive)
        {
            charge = Mathf.Max(0f, charge - drainPerSecond * Time.deltaTime);
            if (charge <= 0f) IsActive = false;
        }
    }

    /// <summary>Call from wherever drive force is computed (mirrors
    /// DynoController.cs's traction-limited force calc) to get the
    /// current effective ceiling.</summary>
    public float EffectiveCeiling(float basePeakLongitudinal)
    {
        return IsActive ? basePeakLongitudinal * tractionCeilingMultiplier : basePeakLongitudinal;
    }
}

/// <summary>
/// Stunt scoring (50 Part 2) -- drift chains and jump distance are
/// RVP's existing StuntManager/StuntDetect logic, unmodified. Close
/// calls are new, and built free from RaggedEdgeMeter's existing
/// fillLevel01 -- a close call is simply a high-fill-level moment near
/// a wall or rival that resolves WITHOUT contact.
/// </summary>
public class StuntSystem : MonoBehaviour
{
    [Header("Wiring")]
    [Tooltip("The player's own instability meter -- reused, not duplicated.")]
    public RaggedEdgeMeter raggedEdgeMeter;
    public NitrousSystem nitrous;

    [Header("Close-call detection (new stunt type, 50 S2.2)")]
    [Tooltip("Minimum fillLevel01 to register as a close call.")]
    [Range(0f, 1f)] public float closeCallFillThreshold = 0.85f;
    [Tooltip("Maximum distance to a wall/rival for the fill level to count.")]
    public float closeCallProximityMetres = 0.5f;
    public float closeCallNitrousReward = 12f;

    private bool _wasAboveThreshold;

    private void Update()
    {
        if (raggedEdgeMeter == null) return;

        bool isAboveThreshold = raggedEdgeMeter.fillLevel01 >= closeCallFillThreshold;

        // Fires once per crossing, not continuously -- same debounce
        // discipline already established for the oversteer trigger in
        // RaggedEdgeMeter itself (20 S1).
        if (isAboveThreshold && !_wasAboveThreshold && WithinProximityOfHazard())
        {
            RegisterCloseCall();
        }
        _wasAboveThreshold = isAboveThreshold;
    }

    private bool WithinProximityOfHazard()
    {
        // Placeholder for actual wall/rival proximity raycast --
        // implementation depends on the specific scene's hazard
        // representation, not something this prototype can determine
        // without a real Unity scene to query. Wire to a proximity
        // check against nearby colliders tagged as walls or rivals.
        return true; // stub -- replace with a real proximity check
    }

    private void RegisterCloseCall()
    {
        if (nitrous != null) nitrous.AddCharge(closeCallNitrousReward);
        // Hook combo/score display here, matching StuntManager's
        // existing connect-delay and combo-cancel-on-crash logic (04
        // S"Scoring").
    }

    /// <summary>
    /// Whether stunt scoring should be active at all -- 50 S2.4's
    /// table. Call this before registering ANY stunt (drift, jump, or
    /// close call), not just close calls, so the format restriction
    /// applies uniformly.
    /// </summary>
    public static bool IsActiveInFormat(RaceFormat format)
    {
        return format == RaceFormat.Outrun || format == RaceFormat.FreeRoam;
    }
}

/// <summary>Race formats (41-RACE-FORMATS-GHOSTS-OBJECTIVES.md Part 1,
/// extended by 50 Part 3's pursuit/escape).</summary>
public enum RaceFormat { Outrun, TougeDuel, Knockout, Pursuit, Escape, FreeRoam }

/// <summary>
/// Pursuit and escape (50 Part 3) -- the fourth race format. Two
/// variants sharing one component: Pursuit (close and hold proximity to
/// a fleeing rival) and Escape (survive a duration/distance while being
/// chased, with the aggression economy fully active for the pursuer).
/// </summary>
public class PursuitEscapeEvent : MonoBehaviour
{
    public enum Variant { Pursuit, Escape }
    public Variant variant;

    [Header("Pursuit variant settings")]
    public float pursuitCaptureProximityMetres = 5f;
    public float pursuitHoldDurationSeconds = 3f;
    private float _withinRangeTimer;

    [Header("Escape variant settings")]
    public float escapeSurvivalDurationSeconds = 90f;
    public float escapeSurvivalDistanceMetres = 3000f;
    private float _escapeTimer;
    private float _escapeDistanceCovered;

    [Header("Result")]
    public bool IsComplete { get; private set; }
    public bool PlayerWon { get; private set; }

    /// <summary>Call every tick with the current gap to the other car
    /// (rival being chased in Pursuit, or player fleeing in Escape).</summary>
    public void Tick(float currentGapMetres, float deltaTime, bool playerWasCaught)
    {
        if (IsComplete) return;

        if (variant == Variant.Pursuit)
        {
            if (currentGapMetres <= pursuitCaptureProximityMetres)
            {
                _withinRangeTimer += deltaTime;
                if (_withinRangeTimer >= pursuitHoldDurationSeconds)
                {
                    IsComplete = true;
                    PlayerWon = true;
                }
            }
            else
            {
                _withinRangeTimer = 0f; // must be a SUSTAINED hold, not cumulative
            }
        }
        else // Escape
        {
            if (playerWasCaught)
            {
                IsComplete = true;
                PlayerWon = false;
                return;
            }
            _escapeTimer += deltaTime;
            if (_escapeTimer >= escapeSurvivalDurationSeconds ||
                _escapeDistanceCovered >= escapeSurvivalDistanceMetres)
            {
                IsComplete = true;
                PlayerWon = true;
            }
        }
    }

    /// <summary>Call alongside Tick() with distance covered this frame,
    /// for the Escape variant's distance-based win condition.</summary>
    public void AccumulateDistance(float metresThisFrame)
    {
        if (variant == Variant.Escape) _escapeDistanceCovered += metresThisFrame;
    }
}
