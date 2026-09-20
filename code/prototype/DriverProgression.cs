using UnityEngine;

/// <summary>
/// The Safety Rating (48-RPG-SYSTEMS-SPEC.md Part 3) and Driver License
/// Grade (49-PLAYER-CHARACTER-RPG.md Part 1), implemented together
/// because license progression reads the rating directly (49 S1.2:
/// "Club: a set number of clean results... Safety Rating above
/// threshold during the result").
/// </summary>
public class SafetyRating : MonoBehaviour
{
    [Header("The rating (48 S3.2) -- bounded, not unbounded")]
    [Range(0f, 100f)] public float rating = 100f; // starts clean

    public enum SafetyEvent
    {
        PlayerCausedContact,
        OffTrackCutForAdvantage,
        CausedRivalSpinOrRetire,
        CleanOvertakeNoContact,
        EventCompletedZeroIncidents,
        DefensiveHoldNoContact
    }

    /// <summary>
    /// Call from collision/track-limit detection. Deliberately does NOT
    /// react to RaggedEdgeMeter.OnLostControl -- 48 S3.4 is explicit
    /// that losing grip and recovering clean is physics, not conduct,
    /// and must never move this rating. Only wire this method to
    /// contact and track-limit events, never to the instability meter.
    /// </summary>
    public void RecordEvent(SafetyEvent evt)
    {
        float delta = evt switch
        {
            SafetyEvent.PlayerCausedContact => -8f,
            SafetyEvent.OffTrackCutForAdvantage => -4f,
            SafetyEvent.CausedRivalSpinOrRetire => -15f,
            SafetyEvent.CleanOvertakeNoContact => 1f,
            SafetyEvent.EventCompletedZeroIncidents => 3f,
            SafetyEvent.DefensiveHoldNoContact => 1f,
            _ => 0f
        };
        rating = Mathf.Clamp(rating + delta, 0f, 100f);
    }

    [Header("Result cleanliness check, for license progression (49 S1.2)")]
    public float cleanResultThreshold = 85f;
    public bool WasResultClean => rating >= cleanResultThreshold;
}

/// <summary>
/// Driver License Grade (49-PLAYER-CHARACTER-RPG.md Part 1). Tracks the
/// PERSON's proven ability -- deliberately distinct from ClassBracket
/// (the car's qualification) and PartsGating's ReputationTier (shop
/// trust). See 49 S1.1's table: three different questions, three
/// different systems.
/// </summary>
public class DriverLicense : MonoBehaviour
{
    public enum Grade { Provisional, Club, Contender, Licensed }

    [Header("Current state")]
    public Grade currentGrade = Grade.Provisional;

    [Header("Progress tracking")]
    [Tooltip("Clean results at street tier, toward Club grade.")]
    public int cleanStreetResults;
    public int cleanStreetResultsRequired = 8; // reasoned in 56-CONTENT-RESOLUTION-PASS-5.md S1.2

    [Tooltip("Distinct job TYPES completed cleanly during the shop-" +
             "driver bridge (33 S2.3) -- Contender requires proof " +
             "across different kinds of driving, not repetition of " +
             "one (49 S1.2), so this tracks unique types, not a count.")]
    public System.Collections.Generic.HashSet<string> cleanJobTypesCompleted =
        new System.Collections.Generic.HashSet<string>();
    public int distinctJobTypesRequired = 4; // out of the 5 in 33 S2.3

    [Tooltip("Sustained clean results at Contender grade, toward Licensed.")]
    public int sustainedContenderResults;
    public int sustainedContenderResultsRequired = 12; // paced against the real 9-year bridge, 56 S1.2

    [Header("Regression (49 S1.2 -- 'a real license can be suspended')")]
    [Tooltip("A dirty result at the current grade counts against this " +
             "many-in-a-row before demotion.")]
    public int dirtyResultsBeforeDemotion = 3; // UNJUSTIFIED -- genuine playtesting target, not a reasoned value; see 56 S1.2
    private int _consecutiveDirtyResults;

    /// <summary>Call after every race result, win or loss, with whether
    /// the SafetyRating for that specific result was clean.</summary>
    public void RecordResult(bool wasClean, string jobTypeIfShopDriver = null)
    {
        if (!wasClean)
        {
            _consecutiveDirtyResults++;
            if (_consecutiveDirtyResults >= dirtyResultsBeforeDemotion)
            {
                Demote();
                _consecutiveDirtyResults = 0;
            }
            return;
        }

        _consecutiveDirtyResults = 0;

        switch (currentGrade)
        {
            case Grade.Provisional:
                cleanStreetResults++;
                if (cleanStreetResults >= cleanStreetResultsRequired)
                    Promote();
                break;

            case Grade.Club:
                if (jobTypeIfShopDriver != null)
                    cleanJobTypesCompleted.Add(jobTypeIfShopDriver);
                if (cleanJobTypesCompleted.Count >= distinctJobTypesRequired)
                    Promote();
                break;

            case Grade.Contender:
                sustainedContenderResults++;
                if (sustainedContenderResults >= sustainedContenderResultsRequired)
                    Promote();
                break;

            case Grade.Licensed:
                break; // ceiling reached -- 49 S1.2: "the ceiling is the car and the player now"
        }
    }

    private void Promote()
    {
        if (currentGrade < Grade.Licensed) currentGrade++;
    }

    private void Demote()
    {
        if (currentGrade > Grade.Provisional) currentGrade--;
    }

    /// <summary>
    /// Whether this license grade permits entry to a given event tier --
    /// per 49 S1.1's table (Provisional: street only; Club: club events +
    /// touge; Contender: professional entry + knockout; Licensed: no
    /// further gate).
    /// </summary>
    public bool PermitsEntry(ClassBracket.Tier eventBracket)
    {
        return eventBracket switch
        {
            ClassBracket.Tier.Street => true,
            ClassBracket.Tier.Club => currentGrade >= Grade.Club,
            ClassBracket.Tier.SemiPro => currentGrade >= Grade.Contender,
            ClassBracket.Tier.Pro => currentGrade >= Grade.Contender,
            _ => false
        };
    }
}
