using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// The family/variant engine data model — implementing the pattern
/// racinggameideas/39-MECHANIC-GAMES-SPECTRUM.md Part 4.2 found confirmed
/// three independent times: real Ford engineering history
/// (37-FORD-V8-AUDIO.md — one firing-order "family" spans five of the hero
/// car's seven generations), Car Mechanic Simulator's engine-matched parts
/// (38-CMS-PARTS-TAXONOMY.md S1.4 — a gearbox literally tagged "V8 OHV,"
/// compatible with that family only), and Automation's own design-tool
/// architecture (39 S4.1-4.2 — a fixed "family," many tunable "variants").
///
/// EngineFamily = the fixed architecture. Firing order, cylinder layout,
/// block material, valve architecture. Does not change within a family.
///
/// EngineVariant = a specific tune within a family. Displacement, cam
/// profile, compression, induction, output figures, redline, and the
/// TireForceModel-adjacent audio/torque data for that specific build.
/// Many variants per family.
///
/// For the hero car specifically (32-HERO-CAR.md S7.1): five of the seven
/// generations (1965 through early-2000s-equivalent) are EngineVariants of
/// ONE EngineFamily. The final two generations (mid-2010s, 2022) are
/// EngineVariants of a SECOND EngineFamily -- the one real acoustic and
/// mechanical discontinuity in the whole sixty-year lineage
/// (37-FORD-V8-AUDIO.md Part 5-6).
/// </summary>
[CreateAssetMenu(fileName = "EngineFamily", menuName = "Vehicle/Engine Family")]
public class EngineFamily : ScriptableObject
{
    [Header("Identity")]
    public string familyName; // e.g. "Windsor-lineage" or "Coyote-lineage" (fictional analog naming -- see 12-DERIVATION-METHOD.md)

    [Header("Fixed architecture -- does not vary within this family")]
    [Tooltip("The combustion rhythm. Changing this is what defines a NEW " +
             "family, not a variant, per 37-FORD-V8-AUDIO.md Part 5-6.")]
    public string firingOrderDescription; // human-readable, e.g. "1-5-4-2-6-3-7-8"

    public enum ValveArchitecture { PushrodOHV, SOHC, DOHC }
    [Tooltip("Can vary WITHIN a family in real history (37 Part 5 -- the " +
             "modular V8 kept the small-block firing order despite moving " +
             "to SOHC), so this is per-family default, not a hard rule. " +
             "Individual variants may override it -- see EngineVariant.")]
    public ValveArchitecture defaultValveArchitecture;

    public enum BlockMaterial { CastIron, Aluminum }
    public BlockMaterial blockMaterial;

    [Header("Compatible parts (38-CMS-PARTS-TAXONOMY.md S1.4)")]
    [Tooltip("Gearboxes, starters, and other drivetrain parts tagged to " +
             "this family only -- a part from a different family should " +
             "not be installable, mirroring CMS's engine-matched parts " +
             "(e.g. 'Gearbox V8 OHV').")]
    public List<string> compatiblePartTags = new List<string>();

    /// <summary>
    /// Whether a part tagged for a given family can be installed on an
    /// engine belonging to THIS family. Call from the parts-wall / garage
    /// install logic (25-GARAGE-DESIGN.md Part 4.2) before allowing a
    /// purchase or installation to proceed.
    /// </summary>
    public bool AcceptsPartTag(string partFamilyTag)
    {
        return compatiblePartTags.Contains(partFamilyTag);
    }
}

/// <summary>
/// A specific tune within an EngineFamily. This is the thing the player
/// actually owns and drives -- one per hero-car generation, at minimum,
/// per 32-HERO-CAR.md S7.1.
/// </summary>
[CreateAssetMenu(fileName = "EngineVariant", menuName = "Vehicle/Engine Variant")]
public class EngineVariant : ScriptableObject
{
    [Header("Family membership")]
    [Tooltip("Which EngineFamily this variant belongs to. Determines part " +
             "compatibility (EngineFamily.AcceptsPartTag) and which " +
             "acoustic core-loop set this variant draws from " +
             "(37-FORD-V8-AUDIO.md Part 8 -- 'texture layered on a shared " +
             "family loop set,' not a from-scratch build per variant).")]
    public EngineFamily family;

    [Header("Identity")]
    public string variantName; // e.g. era label, matching 32 S7.1's generation table
    [Tooltip("Which hero-car generation this variant represents, for " +
              "direct lookup against 32-HERO-CAR.md's era table.")]
    public string generationEra;

    [Header("This variant's specific tune")]
    [Tooltip("Overrides the family default only if this specific variant " +
             "genuinely differs (37 Part 5's modular-V8 case: SOHC variant, " +
             "same family as the pushrod variants before it).")]
    public EngineFamily.ValveArchitecture valveArchitectureOverride;
    public bool useOverride;

    [Header("Crank type (racinggameideas/40-FORCED-INDUCTION-DRIVETRAIN.md Part 2)")]
    public enum CrankType { CrossPlane, FlatPlane }
    [Tooltip("Variant-level, NOT family-level. The real flat-plane engine " +
             "this is modelled on shares its block heritage with the " +
             "standard cross-plane version of the same family -- period " +
             "camshafts exist for running flat-plane heads on a cross-" +
             "plane bottom end, confirming the two are interchangeable at " +
             "the variant level, not a family split. Default CrossPlane; " +
             "reserve FlatPlane for a rare, high-performance variant in " +
             "the final engine family only, matching real history where " +
             "it never appeared in the earlier pushrod/SOHC lineage.")]
    public CrankType crankType = CrankType.CrossPlane;
    [Tooltip("Overrides the family's firingOrderDescription when crankType " +
             "is FlatPlane -- flat-plane fires every 180 degrees instead " +
             "of cross-plane's every 90, a genuinely different combustion " +
             "rhythm worth its own acoustic texture tag even though it " +
             "doesn't warrant a new EngineFamily.")]
    public string flatPlaneFiringOrderDescription;

    [Header("Forced induction (40 Part 1)")]
    public enum ForcedInduction { None, PeriodSupercharger, ModernSupercharger, AftermarketTurbo }
    [Tooltip("None across the middle generations is historically correct, " +
             "not a content gap -- no factory turbo V8 exists in the real " +
             "reference lineage at any point. PeriodSupercharger is valid " +
             "from generation one (a real 1965-72 dealer-adjacent option); " +
             "AftermarketTurbo should read as a tuner-shop path throughout, " +
             "never a factory one, matching the real distinction.")]
    public ForcedInduction forcedInduction = ForcedInduction.None;
    [Tooltip("True whenever forcedInduction is a supercharger option " +
             "(period installs used a compressor bypass valve -- the " +
             "direct mechanical ancestor of a BOV -- so this can be true " +
             "even for PeriodSupercharger, as flavour rather than a " +
             "separate purchasable part). See hasBlowOffValve for the " +
             "turbo-specific case.")]
    public bool hasIntercooler;
    [Tooltip("Compressor surge is a turbo-specific problem -- true only " +
             "for AftermarketTurbo in the strict sense, though a period " +
             "supercharger's compressor bypass valve is the same function " +
             "under a different name if you want to expose it identically.")]
    public bool hasBlowOffValve;

    public float displacementLiters;
    [Tooltip("Peak power, hp -- for reference/UI. The actual torque curve " +
             "used by TORSION's Engine.cs and this project's " +
             "DynoController.cs is the field below.")]
    public float peakPowerHp;
    public float redlineRPM; // matches TORSION Engine.cs's redlineRPM field directly

    [Header("The actual simulation data")]
    [Tooltip("Assign the AnimationCurve this variant should drive on " +
             "TORSION's Engine.torqueCurve when installed -- see " +
             "ApplyToEngine() below.")]
    public AnimationCurve torqueCurve;

    [Tooltip("The tyre-model-adjacent audio texture this variant layers " +
             "onto its family's shared core loops (37 Part 8) -- carb " +
             "roughness, EFI smoothness, emissions muffling, SOHC/DOHC " +
             "tonal shift. Not a full audio asset reference here, just the " +
             "identifying tag your audio system keys off.")]
    public string acousticTextureTag;

    [Header("Repairable vs. replace-only (38-CMS-PARTS-TAXONOMY.md S1.3)")]
    [Tooltip("Per 39-MECHANIC-GAMES-SPECTRUM.md Part 6: most components " +
             "should be repairable. A small, deliberate set (gearbox, " +
             "clutch plate in CMS's own example) should not be -- gives " +
             "the mentor's diagnostic voice (30-NARRATIVE-DESIGN.md S1.3) " +
             "something concrete and true to say.")]
    public List<string> replaceOnlyPartTags = new List<string>();

    public bool IsRepairable(string partTag)
    {
        return !replaceOnlyPartTags.Contains(partTag);
    }

    /// <summary>
    /// Applies this variant's tune to a live TORSION Engine component --
    /// the actual point where the family/variant data model meets the
    /// physics simulation. Call when the player installs this variant
    /// (initial hero-car build, or a variant swap within a compatible
    /// family).
    /// </summary>
    public void ApplyToEngine(Engine targetEngine)
    {
        if (targetEngine == null) return;
        targetEngine.torqueCurve = torqueCurve;
        targetEngine.redlineRPM = redlineRPM;
    }

    /// <summary>
    /// Checks whether a candidate replacement part is installable on this
    /// variant, both via the family's compatible-tag list and this
    /// variant's own repairable/replace-only distinction. Wire into the
    /// parts-wall purchase flow (25-GARAGE-DESIGN.md S4.2) before allowing
    /// a transaction.
    /// </summary>
    public bool CanInstallPart(string partFamilyTag)
    {
        return family != null && family.AcceptsPartTag(partFamilyTag);
    }
}
