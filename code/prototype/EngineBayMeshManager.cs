using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Merges the engine bay's individually-modelled part meshes into a
/// consolidated mesh after the installation sequence finishes, and splits
/// back apart only when a sequence needs to play again.
///
/// This exists because of a real, measured bug found in Automation's own
/// player community (racinggameideas/39-MECHANIC-GAMES-SPECTRUM.md S4.3):
/// exporting an engine as many separate small meshes rather than one
/// joined mesh produced roughly 2.5x the render draw calls of a
/// comparable native car (13,416 events against 5,392 in one measured
/// case), traced specifically to the unmerged engine.
///
/// 25-GARAGE-DESIGN.md Part 6 already specifies the installation sequence
/// as tightly-framed, showing individual parts going in one at a time --
/// which is exactly the structure that caused Automation's problem. This
/// component is the fix, made explicit rather than left as an implied
/// consequence of the "tight framing" art-direction note.
///
/// RULE: full mesh separation ONLY during an active installation
/// sequence, where the camera is tightly framed and the part count on
/// screen is deliberately small. Merged for every other context --
/// ordinary garage viewing, driving, the dyno, anywhere the engine bay is
/// visible but not the specific focus of a vignette.
/// </summary>
public class EngineBayMeshManager : MonoBehaviour
{
    [System.Serializable]
    public struct PartMeshEntry
    {
        public string partTag; // matches EngineVariant's replaceOnlyPartTags / family tags
        public MeshFilter meshFilter;
        public MeshRenderer meshRenderer;
    }

    [Header("Wiring")]
    [Tooltip("Every individually-modelled engine bay part. Populate once " +
             "per hero-car generation's engine bay prefab.")]
    public List<PartMeshEntry> partMeshes = new List<PartMeshEntry>();

    [Tooltip("The single consolidated renderer used for normal (non-" +
             "installation-sequence) viewing. Assign an empty GameObject " +
             "with a MeshFilter + MeshRenderer as the merge target.")]
    public MeshFilter mergedMeshFilter;
    public MeshRenderer mergedMeshRenderer;

    [Tooltip("Material used for the merged mesh. Should match (or closely " +
             "approximate) the individual parts' shared material family " +
             "per 08-ART-DIRECTION.md's trim-sheet guidance.")]
    public Material mergedMaterial;

    private bool _isMerged;

    private void Start()
    {
        // Default state: merged. Only split apart when a sequence needs it.
        MergeForNormalRendering();
    }

    /// <summary>
    /// Call this when a part's installation sequence is about to play
    /// (25-GARAGE-DESIGN.md Part 6). Splits the merged mesh back into
    /// individual part meshes so the sequence can animate one part going
    /// in without needing to touch the others.
    /// </summary>
    public void PrepareForInstallationSequence()
    {
        if (!_isMerged) return; // already split, nothing to do

        if (mergedMeshRenderer != null) mergedMeshRenderer.enabled = false;
        foreach (var entry in partMeshes)
        {
            if (entry.meshRenderer != null) entry.meshRenderer.enabled = true;
        }
        _isMerged = false;
    }

    /// <summary>
    /// Call this once the installation sequence finishes (whether played
    /// in full or skipped -- 25-GARAGE-DESIGN.md S6.2 specifies skipping
    /// is always available and remembered). Rebuilds and shows the
    /// consolidated mesh, hides the individual part renderers.
    ///
    /// This is the actual fix for the Automation draw-call problem: from
    /// this point until the next installation sequence, the engine bay
    /// renders as ONE mesh (or a small number of material-grouped
    /// meshes), not N individually-drawn parts.
    /// </summary>
    public void MergeForNormalRendering()
    {
        if (_isMerged) return; // already merged, nothing to do

        var combineInstances = new List<CombineInstance>();
        foreach (var entry in partMeshes)
        {
            if (entry.meshFilter == null || entry.meshFilter.sharedMesh == null)
                continue;

            combineInstances.Add(new CombineInstance
            {
                mesh = entry.meshFilter.sharedMesh,
                transform = entry.meshFilter.transform.localToWorldMatrix
            });

            if (entry.meshRenderer != null) entry.meshRenderer.enabled = false;
        }

        if (combineInstances.Count > 0 && mergedMeshFilter != null)
        {
            var combined = new Mesh();
            // NOTE: default Mesh index format is 16-bit (65,535 vertex
            // limit). If the hero car's full engine bay part set exceeds
            // that combined, set combined.indexFormat =
            // UnityEngine.Rendering.IndexFormat.UInt32 before
            // CombineMeshes -- verify against your actual part count
            // before shipping; this is flagged rather than assumed.
            combined.CombineMeshes(combineInstances.ToArray());
            mergedMeshFilter.mesh = combined;

            if (mergedMeshRenderer != null)
            {
                mergedMeshRenderer.enabled = true;
                if (mergedMaterial != null)
                    mergedMeshRenderer.sharedMaterial = mergedMaterial;
            }
        }

        _isMerged = true;
    }

    /// <summary>
    /// Call after a part is actually replaced (post-purchase, post-
    /// installation-sequence) so the merged mesh reflects the new part
    /// rather than a stale combined mesh. Cheap to call unconditionally
    /// after MergeForNormalRendering() at the end of an install --
    /// CombineMeshes rebuilds from current mesh filter state each time,
    /// so a changed part mesh is picked up automatically on the next
    /// merge.
    /// </summary>
    public void OnPartReplaced(string partTag, Mesh newMesh)
    {
        for (int i = 0; i < partMeshes.Count; i++)
        {
            if (partMeshes[i].partTag == partTag)
            {
                var entry = partMeshes[i];
                if (entry.meshFilter != null) entry.meshFilter.sharedMesh = newMesh;
                partMeshes[i] = entry;
                break;
            }
        }
        // Re-merge to pick up the change -- safe to call even if already
        // merged, since MergeForNormalRendering() early-returns only when
        // no rebuild is needed; force a rebuild here specifically.
        _isMerged = false;
        MergeForNormalRendering();
    }
}
