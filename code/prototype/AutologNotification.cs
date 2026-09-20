using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// The Autolog notification layer (41-RACE-FORMATS-GHOSTS-OBJECTIVES.md
/// S2.3) -- the first code written for it. Originally specified as
/// non-blocking "X beat your time by Y" messages sourced from ghosts;
/// extended here to carry a second message source (passive income,
/// 59-TRENDS-GTA-PASSIVE-INCOME.md) through the same shared shape,
/// rather than building a second notification system for a second
/// message type.
///
/// Deliberately NOT a live leaderboard the player checks (41 S2.3) --
/// notifications queue and surface on return, the player doesn't go
/// looking for them.
/// </summary>
public class AutologNotification : MonoBehaviour
{
    public enum SourceType { GhostBeaten, RivalResult, PassiveIncome }

    [System.Serializable]
    public struct Entry
    {
        public SourceType source;
        public string message;
        public float value; // margin (seconds) for ghost/rival, or amount for passive income
    }

    private readonly Queue<Entry> _pending = new Queue<Entry>();

    /// <summary>Call from the ghost/rival result comparison (41 S2.3's
    /// original spec) when the player is beaten by a recorded time.</summary>
    public void QueueGhostBeaten(string rivalName, float marginSeconds)
    {
        _pending.Enqueue(new Entry
        {
            source = SourceType.GhostBeaten,
            message = $"{rivalName} beat your time by {marginSeconds:F1}s",
            value = marginSeconds
        });
    }

    /// <summary>
    /// Call on session start with whatever PartsGating.PassiveIncomePerSession()
    /// returned, if greater than zero -- the "welcome-back payout" idle-
    /// game design treats as near-universal (59 S1b), riding this same
    /// shared notification shape rather than a separate one.
    /// </summary>
    public void QueuePassiveIncome(float amount)
    {
        if (amount <= 0f) return; // per 59's own rule -- zero income is not a notification-worthy event
        _pending.Enqueue(new Entry
        {
            source = SourceType.PassiveIncome,
            message = $"The shop earned {amount:F0} while you were away",
            value = amount
        });
    }

    /// <summary>
    /// Call once per session, on the first frame the player is actually
    /// looking at the garage (not mid-race, not mid-load) -- surfaces
    /// everything queued since the last call. Returns the entries so the
    /// UI layer can display them non-blockingly (41 S2.3: never a modal
    /// the player must dismiss before continuing).
    /// </summary>
    public List<Entry> DrainPendingForDisplay()
    {
        var result = new List<Entry>(_pending);
        _pending.Clear();
        return result;
    }

    public bool HasPending => _pending.Count > 0;
}
