using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// The ragged-edge instability meter (racinggameideas/20-CONCEPTS.md S1,
/// racinggameideas/11-SYSTEMS-SPEC.md S2.3). Not an authored abstraction --
/// it is a readout of two real, independently-sourced quantities:
///
/// 1. FILL LEVEL -- how close each wheel is to Beckman's traction circle
///    boundary (34-PHYSICS-READING.md Part 1c, Part 7). Because different
///    axles/compounds can have different longitudinal vs lateral peaks,
///    this generalises Beckman's circle into the "egg" shape he describes
///    for asymmetric tyres, rather than assuming a circle.
///
/// 2. LOSS-OF-CONTROL TRIGGER -- a precise, cheap, independently-sourced
///    criterion from a 2025 academic paper on the Milliken Moment Method
///    (35-EXTENDED-SOURCES.md S3.1):
///
///        |a_y - v * yawRate| > epsilon_threshold
///
///    Once actual lateral acceleration diverges from what the current yaw
///    rate would predict in a stable turn, the car has started rotating
///    faster than its lateral acceleration suggests -- the exact moment
///    oversteer becomes unrecoverable. Cheap: one multiply, one subtract,
///    one absolute value, using quantities the physics engine already
///    produces every tick.
///
/// The two signals answer different questions. FillLevel01 answers "how
/// hard is the player pushing." OnLostControl answers "has the car actually
/// let go." Wire FillLevel01 to the visual meter and the three-tyre-sound
/// audio crossfade (10-AUDIO-DESIGN.md S4); wire OnLostControl to whatever
/// should happen at the moment of an actual spin.
///
/// INTEGRATION NOTE (important -- read before wiring this up): for the
/// meter to be honest, the "current force" it reads and the "peak force"
/// it compares against must come from the SAME tyre model. If RVP's wheels
/// compute fX/fY from their own authored friction curves while this script
/// asks TireForceModel for a *different* peak estimate, you reproduce
/// exactly the failure flagged in 31-DYNO-ANALYSIS.md S2.3 -- Underground
/// 2's stock differential reading as fastest "even though it doesn't make
/// sense," because the tuning layer and the driving layer disagreed. Either
/// wire RVP's per-wheel force computation to call into TireForceModel
/// directly, or set TireForceModel's peaks to match whatever curves RVP is
/// already using. One canonical model, used by both the dyno and the car.
/// </summary>
public class RaggedEdgeMeter : MonoBehaviour
{
    [Header("Wiring")]
    [Tooltip("The car's rigidbody. Used for velocity, yaw rate, and lateral acceleration.")]
    public Rigidbody vehicleBody;

    [Tooltip("RVP Wheel components. fX/fY are read as the CURRENT force each "
           + "wheel is producing; restLength/currentLength/springStiffness "
           + "give a load (Fz) estimate without a separate statics solve, "
           + "per racinggameideas/25-GARAGE-DESIGN.md S5.")]
    public List<Wheel> wheels = new List<Wheel>();

    [Tooltip("The same tyre model backing the wheels' own force computation "
           + "-- see the integration note above.")]
    public TireForceModel tireModel;

    [Header("Fill level")]
    [Range(0f, 1f)] public float fillLevel01;

    [Tooltip("How fast the meter empties when driving well inside the "
           + "limit. This is the 'handling rating determines how fast you "
           + "shed it' parameter from 11-SYSTEMS-SPEC.md S2.3.")]
    public float decayRatePerSecond = 1.2f;

    [Tooltip("How fast the meter fills when at or past the limit.")]
    public float fillRatePerSecond = 2.5f;

    [Header("Input jerk (34 Part 1d, Beckman Part 14 -- corrected in Part 26)")]
    [Tooltip("Suspension and tyres behave as damped harmonic oscillators. "
           + "Beckman's original figure (4 Hz) was later corrected by his "
           + "own errata to a units slip -- the real figure is closer to "
           + "0.64 Hz (one oscillation per ~1.6s). Smooth (sinusoidal) "
           + "inputs match this response; step inputs excite it. This is "
           + "the physical basis for 'smooth is fast': a jerky driver "
           + "loses grip at the SAME cornering load a smooth driver "
           + "survives. Do not hard-code 4 Hz here -- that number was "
           + "wrong even in Beckman's own later account, and your "
           + "suspension's real frequency should be measured from your "
           + "own spring rate and sprung mass, not assumed.")]
    public float suspensionNaturalFrequencyHz = 0.64f;

    [Tooltip("How strongly jerky (high rate-of-change) inputs add to the "
           + "fill level on top of raw cornering load.")]
    public float jerkContribution = 0.5f;

    [Header("Loss-of-control trigger (35 S3.1)")]
    [Tooltip("Threshold on |a_y - v*yawRate| above which the car is judged "
           + "to have started rotating faster than a stable turn would "
           + "predict. Tune per vehicle class -- a twitchy car should have "
           + "a lower threshold than a stable one.")]
    public float oversteerThreshold = 3.0f; // m/s^2, start point -- tune per car

    /// <summary>Fires the instant the oversteer criterion trips. Payload is
    /// the current |a_y - v*yawRate| value at the moment of the trip, for
    /// logging/telemetry (07 S1.1, 20 S5 -- feeds post-race diagnosis).</summary>
    public event Action<float> OnLostControl;

    private Vector3 _prevVelocity;
    private Vector3 _prevInputVector; // (steer, throttle, brake)
    private bool _hasPrevVelocity;
    private bool _wasOverThreshold;

    private void FixedUpdate()
    {
        if (vehicleBody == null) return;

        float dt = Time.fixedDeltaTime;
        if (dt <= 0f) return;

        // --- 1. Fill level: the "egg" traction budget, aggregated across wheels ---
        float worstRatio = 0f;
        foreach (var w in wheels)
        {
            if (w == null || !w.isGrounded) continue;

            float Fz = EstimateLoad(w);
            if (Fz <= 0.01f) continue;

            float peakLong = tireModel != null ? tireModel.PeakLongitudinal(Fz) : 1f;
            float peakLat = tireModel != null ? tireModel.PeakLateral(Fz) : 1f;
            if (peakLong <= 0.01f) peakLong = 0.01f;
            if (peakLat <= 0.01f) peakLat = 0.01f;

            // w.fX / w.fY are the wheel's ACTUAL current longitudinal/lateral
            // force, already produced by RVP's own physics this tick.
            float normLong = w.fX.magnitude / peakLong;
            float normLat = w.fY.magnitude / peakLat;
            float ratio = Mathf.Sqrt(normLong * normLong + normLat * normLat);

            if (ratio > worstRatio) worstRatio = ratio;
        }

        // --- 2. Input jerk contribution (Beckman Part 14) ---
        Vector3 currentInput = ReadCurrentInputVector();
        float jerk = 0f;
        if (_hasPrevVelocity) // reuse this flag as "have we run once"
        {
            jerk = (currentInput - _prevInputVector).magnitude / dt;
        }
        _prevInputVector = currentInput;

        // Normalise jerk against the suspension's own natural frequency:
        // an input changing at roughly the natural frequency or faster is
        // "step-like" and should excite the oscillator; slower changes are
        // "sinusoidal" and should not.
        float jerkNormalised = suspensionNaturalFrequencyHz > 0f
            ? Mathf.Clamp01(jerk / (suspensionNaturalFrequencyHz * 4f))
            : 0f;

        float targetFill = Mathf.Clamp01(worstRatio + jerkContribution * jerkNormalised);

        // --- 3. Integrate the meter toward the target, fill fast / decay slow ---
        float rate = targetFill > fillLevel01 ? fillRatePerSecond : decayRatePerSecond;
        fillLevel01 = Mathf.MoveTowards(fillLevel01, targetFill, rate * dt);

        // --- 4. Loss-of-control trigger: |a_y - v*yawRate| > threshold ---
        Vector3 velocity = vehicleBody.linearVelocity;
        Vector3 localVelocity = vehicleBody.transform.InverseTransformDirection(velocity);
        float forwardSpeed = localVelocity.z;

        float lateralAccel;
        if (_hasPrevVelocity)
        {
            Vector3 accel = (velocity - _prevVelocity) / dt;
            lateralAccel = Vector3.Dot(accel, vehicleBody.transform.right);
        }
        else
        {
            lateralAccel = 0f;
        }
        _prevVelocity = velocity;
        _hasPrevVelocity = true;

        // Yaw rate about the car's local up axis (assumes Y-up).
        float yawRate = vehicleBody.transform.InverseTransformDirection(
            vehicleBody.angularVelocity).y;

        float predictedLateralAccel = forwardSpeed * yawRate;
        float divergence = Mathf.Abs(lateralAccel - predictedLateralAccel);

        bool overThreshold = divergence > oversteerThreshold;
        if (overThreshold && !_wasOverThreshold)
        {
            OnLostControl?.Invoke(divergence);
            fillLevel01 = 1f; // an actual spin fills the meter immediately
        }
        _wasOverThreshold = overThreshold;
    }

    /// <summary>
    /// Estimate vertical load from suspension compression rather than a
    /// four-wheel statics solve -- this is deliberate (25-GARAGE-DESIGN.md
    /// S5): a four-wheeled car is statically indeterminate (34 Part 1d,
    /// Beckman Part 20), and resolving that through spring compression is
    /// both physically correct and what RVP's own raycast suspension
    /// already computes. See StaticWeightTransfer.cs for the closed-form
    /// alternative (Beckman Part 27) if you want a from-first-principles
    /// cross-check instead.
    /// </summary>
    private static float EstimateLoad(Wheel w)
    {
        float compression = w.restLength - w.currentLength;
        if (compression <= 0f) return 0f;
        return w.springStiffness * compression;
    }

    /// <summary>
    /// Override or replace this with your actual input system. Vector3 here
    /// is (steer, throttle, brake) purely as a compact carrier for the
    /// jerk calculation -- it is not a physical vector.
    /// </summary>
    protected virtual Vector3 ReadCurrentInputVector()
    {
        return new Vector3(
            Input.GetAxis("Horizontal"),
            Mathf.Max(0f, Input.GetAxis("Vertical")),
            Mathf.Max(0f, -Input.GetAxis("Vertical")));
    }
}
