using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Named build recipes -- racinggameideas/48-RPG-SYSTEMS-SPEC.md Part 1.
/// A saved snapshot of the seven-subsystem tuning table
/// (25-GARAGE-DESIGN.md Part 5), player-named, storable and reloadable
/// from the garage's Desk station.
///
/// Two types: free-form (no target, organisational only) and target
/// recipes (a defined build brief with real checkable thresholds,
/// rewarding a title and optional livery on completion).
/// </summary>
[CreateAssetMenu(fileName = "BuildRecipe", menuName = "Vehicle/Build Recipe")]
public class BuildRecipe : ScriptableObject
{
    [Header("Identity")]
    [Tooltip("Player-chosen name for free-form recipes; a fixed brief " +
             "name for target recipes (e.g. 'The Canyon Carver').")]
    public string recipeName;

    public enum RecipeType { FreeForm, Target }
    public RecipeType recipeType;

    [Header("The snapshot")]
    public EngineVariant engineVariant;
    public TransmissionSpec transmission;
    public TireForceModel tireCompound;
    [Tooltip("Free-text summary of suspension/aero/differential state -- " +
             "expand into dedicated ScriptableObjects per subsystem as " +
             "those get built out; this field exists so a recipe can be " +
             "meaningfully saved and compared before that work is done.")]
    public string otherSubsystemsSummary;

    [Header("Repairable/replace-only status at save time (38 S1.3)")]
    [Tooltip("Parts flagged here were due for replacement when this " +
             "recipe was saved. Surfaced again on load so switching to " +
             "an old recipe doesn't silently hand the player a worn " +
             "build (48 S1.4).")]
    public List<string> partsNeedingReplacementAtSaveTime = new List<string>();

    [Header("Target recipe brief (only used if recipeType == Target)")]
    public float targetWeightToPowerMin;
    public float targetWeightToPowerMax;
    public float targetMinDownforceN;
    [Tooltip("Empty means no differential requirement for this target.")]
    public string requiredDifferentialType;

    [Header("Reward on completion (target recipes only)")]
    public string unlockedTitle;
    public string unlockedLiveryId;

    /// <summary>
    /// Checks whether the current snapshot satisfies this recipe's
    /// target brief. Only meaningful for Target-type recipes -- always
    /// returns true for FreeForm recipes, since they have no brief to
    /// satisfy.
    /// </summary>
    public bool SatisfiesTarget(float currentWeightKg, float currentPowerHp,
                                  float currentDownforceN, string currentDifferentialType)
    {
        if (recipeType == RecipeType.FreeForm) return true;

        float weightToPower = currentPowerHp > 0f ? currentWeightKg / currentPowerHp : float.MaxValue;
        bool weightOk = weightToPower >= targetWeightToPowerMin && weightToPower <= targetWeightToPowerMax;
        bool downforceOk = currentDownforceN >= targetMinDownforceN;
        bool diffOk = string.IsNullOrEmpty(requiredDifferentialType) ||
                      requiredDifferentialType == currentDifferentialType;

        return weightOk && downforceOk && diffOk;
    }

    /// <summary>
    /// Which class bracket (20-CONCEPTS.md S16) this recipe's snapshot
    /// currently qualifies for. FIXED: this originally duplicated
    /// ClassBracket.BracketForPoints() with a broken signature (using
    /// the static ClassBracket class as if it were an instance type --
    /// caught immediately when PartsGating.cs, written right after this
    /// file, defined ClassBracket properly and the mismatch became
    /// obvious). Delegates to the real implementation instead of
    /// duplicating it.
    /// </summary>
    public static ClassBracket.Tier BracketForPoints(int totalClassPoints)
    {
        return ClassBracket.BracketForPoints(totalClassPoints);
    }
}
