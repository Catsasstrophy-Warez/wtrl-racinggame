using UnityEngine;

/// <summary>
/// Class brackets (20-CONCEPTS.md S16) and two-axis reputation gating
/// (48-RPG-SYSTEMS-SPEC.md Part 2), implemented together since both
/// answer "what can this player/car access," but deliberately kept as
/// two independent checks -- see PartsGating.CanPurchase() below, which
/// requires BOTH a property-tier check (elsewhere) and a reputation
/// check to pass, matching 48 S2.2's explicit warning against letting
/// these collapse into one meter under different names.
/// </summary>
public static class ClassBracket
{
    public enum Tier { Street, Club, SemiPro, Pro }

    // Class-point ceilings per bracket (20-CONCEPTS.md S16's new table).
    // A build's total class points (summed from 47-PARTS-PRICING.md
    // Part 1's per-part costs) must fall at or under a bracket's
    // ceiling to enter that bracket's events -- Pro has no ceiling.
    public const int StreetCeiling = 15;
    public const int ClubCeiling = 35;
    public const int SemiProCeiling = 60;
    // Pro: no ceiling.

    public static Tier BracketForPoints(int totalClassPoints)
    {
        if (totalClassPoints <= StreetCeiling) return Tier.Street;
        if (totalClassPoints <= ClubCeiling) return Tier.Club;
        if (totalClassPoints <= SemiProCeiling) return Tier.SemiPro;
        return Tier.Pro;
    }

    /// <summary>
    /// Per 20 S16: "A fully maxed car locks itself out of lower
    /// classes." A build can only enter events AT its own bracket, not
    /// below it -- true for every tier including Pro (a Pro-bracket car
    /// cannot enter a Street event either, the constraint runs both
    /// directions).
    /// </summary>
    public static bool QualifiesForBracket(int totalClassPoints, Tier eventBracket)
    {
        return BracketForPoints(totalClassPoints) == eventBracket;
    }
}

/// <summary>
/// Property tiers (25-GARAGE-DESIGN.md Part 7). FIXED: this had never
/// been given a proper type anywhere in the codebase -- PartsGating.cs
/// was using bare string literals ("ProShop", "Warehouse") with no
/// compile-time safety, found during a self-check after the passive-
/// income addition (59-TRENDS-GTA-PASSIVE-INCOME.md) was the first code
/// to actually reference property tier by name. A typo in the old
/// string-literal version would have failed silently at runtime instead
/// of at compile time.
/// </summary>
public enum PropertyTier { Driveway, Garage, ProShop, Warehouse }

/// <summary>
/// Reputation tiers (48 Part 2.4) -- what a shop will SELL, independent
/// of money and independent of property tier (which governs whether the
/// facility can even install the part -- see EngineBayMeshManager.cs's
/// context and 25-GARAGE-DESIGN.md Part 7).
/// </summary>
public enum ReputationTier { Unknown, Known, Respected, Trusted }

/// <summary>
/// Tracks a player's reputation with a specific shop/dealer relationship
/// (48 S2.3) and the resulting parts-catalogue access (48 S2.4).
/// </summary>
public class PartsGating : MonoBehaviour
{
    [Header("Reputation (48 Part 2)")]
    [Tooltip("Accrues from named-rival wins, shop-driver job completion, " +
             "and touge duel wins specifically -- see AddReputationEvent().")]
    public float reputationPoints;

    // Thresholds -- AUDITED in 56-CONTENT-RESOLUTION-PASS-5.md S1.2 and
    // deliberately kept unchanged: no structural anchor exists to pace
    // these against (unlike DriverProgression.cs's Contender threshold,
    // which IS paced against the real 9-year bridge in 33). These
    // remain genuine playtesting targets, not sourced values -- stated
    // explicitly rather than left ambiguous.
    public float knownThreshold = 20f;
    public float respectedThreshold = 60f;
    public float trustedThreshold = 120f;

    public ReputationTier CurrentTier
    {
        get
        {
            if (reputationPoints >= trustedThreshold) return ReputationTier.Trusted;
            if (reputationPoints >= respectedThreshold) return ReputationTier.Respected;
            if (reputationPoints >= knownThreshold) return ReputationTier.Known;
            return ReputationTier.Unknown;
        }
    }

    public enum ReputationEventType
    {
        NamedRivalWin,
        RepeatRivalWinDiminished, // beating the same rival again is worth less (48 S2.3)
        ShopDriverJobComplete,
        TougeDuelWin // weighted higher -- tests skill independent of the build (48 S2.3)
    }

    /// <summary>Call whenever a reputation-worthy event completes.</summary>
    public void AddReputationEvent(ReputationEventType type)
    {
        switch (type)
        {
            case ReputationEventType.NamedRivalWin: reputationPoints += 8f; break;
            case ReputationEventType.RepeatRivalWinDiminished: reputationPoints += 2f; break;
            case ReputationEventType.ShopDriverJobComplete: reputationPoints += 6f; break;
            case ReputationEventType.TougeDuelWin: reputationPoints += 10f; break;
        }
    }

    [Header("Shop passive income (59-TRENDS-GTA-PASSIVE-INCOME.md)")]
    [Tooltip("Set from the garage's current property tier. Now a real " +
             "enum -- see the PropertyTier fix note above this class.")]
    public PropertyTier currentPropertyTier = PropertyTier.Driveway;

    /// <summary>
    /// The passive income rate per session, per 59 S1.3's table. Reads
    /// the SAME reputation tier already used for parts-catalogue gating
    /// above -- no new tracked value, the direct mechanical expression
    /// of the sequencing lesson that motivated this whole addition:
    /// upgrading property without the reputation to match earns nothing.
    /// </summary>
    public float PassiveIncomePerSession()
    {
        bool hasStaff = currentPropertyTier == PropertyTier.ProShop ||
                         currentPropertyTier == PropertyTier.Warehouse;
        if (!hasStaff) return 0f; // Driveway/Garage: no staff exist yet (25 S6.2b)

        if (CurrentTier == ReputationTier.Unknown) return 0f; // staffed, but no customer trusts an unknown shop

        bool isWarehouse = currentPropertyTier == PropertyTier.Warehouse;
        if (CurrentTier >= ReputationTier.Respected && isWarehouse)
            return 25f; // "Meaningful" tier, 59 S1.3 -- the tier this system is built to reward
        if (CurrentTier >= ReputationTier.Known)
            return 6f;  // "Low" tier -- same rate whether ProShop or Warehouse-without-reputation,
                        // the sequencing lesson made concrete: the property upgrade alone changes nothing
        return 0f;
    }

    /// <summary>
    /// The actual gate a purchase should be checked against. Both this
    /// AND a separate property-tier facility check (25-GARAGE-DESIGN.md
    /// Part 7) must pass -- this method only answers the reputation
    /// half, deliberately, per 48 S2.2's three-systems-not-one table.
    /// </summary>
    public bool CanPurchase(PartPriceTier partTier)
    {
        switch (partTier)
        {
            case PartPriceTier.StockReplacement: return true; // Unknown tier already allows this
            case PartPriceTier.Performance: return CurrentTier >= ReputationTier.Known;
            case PartPriceTier.Race: return CurrentTier >= ReputationTier.Respected;
            case PartPriceTier.ForcedInductionOrCrankSwap: return CurrentTier >= ReputationTier.Trusted;
            default: return false;
        }
    }
}

/// <summary>Matches 47-PARTS-PRICING.md Part 1.1's three named tiers,
/// plus the forced-induction/crank-swap category from Part 1.2.</summary>
public enum PartPriceTier { StockReplacement, Performance, Race, ForcedInductionOrCrankSwap }
