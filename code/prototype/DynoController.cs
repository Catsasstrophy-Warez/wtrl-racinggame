using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// The dyno (racinggameideas/31-DYNO-ANALYSIS.md S6, racinggameideas/25-
/// GARAGE-DESIGN.md Part 5). Three jobs, matching the three failure modes
/// documented in 31:
///
/// 1. READ FROM THE ACTUAL PHYSICS MODEL, not a parallel one (S6.1). This
///    is non-negotiable -- Underground 2's stock differential reading as
///    fastest "even though it doesn't make sense" happened precisely
///    because its dyno and its driving used different models (31 S2.3).
///    GetTorqueCurveSample() below reads TORSION's Engine.torqueCurve
///    directly; it does not simulate a separate engine.
///
/// 2. DRAW THE CURVE, don't move sliders (S6.2). GetTorqueCurvePoints()
///    exposes sampled (RPM, torque) pairs for whatever chart UI you build
///    -- Underground 2's bar-graph-by-RPM interface (19-NFS-DOSSIER.md
///    S2.5) is still the reference for how to present this.
///
/// 3. GIVE A BENCHMARK, then let the player beat it (S6.3). CSR2's insight:
///    the dyno number is what a PERFECT run gives you; real driving can be
///    faster, and the gap between the two is driver skill, named
///    explicitly. RunStraightLineBenchmark() below computes that number
///    honestly: it integrates the SAME torque curve and the SAME tyre
///    model the player drives on, using RK4 rather than Euler (34 Part 1c,
///    Finding 2 / Beckman Part 28 -- Euler diverges 60% over 100 seconds
///    on the simplest possible oscillator; RK4 stays stable), and it is
///    driven FROM the torque curve rather than from a smooth velocity
///    ramp (34 Part 1e, Beckman Part 26 -- a smooth ramp produces a fake
///    flat torque curve, which would make the model look right while
///    being wrong).
///
/// This script deliberately does NOT model a physical dynamometer drum
/// (moment of inertia, driveline losses, the 15-20% chassis-vs-test-stand
/// gap from 34 Part 1e / Beckman Part 26). That mechanism is real and
/// worth knowing about, but for a GAME dyno you want ground truth --
/// exactly the numbers the simulation is using -- not an in-fiction
/// measurement error layered on top of it.
/// </summary>
public class DynoController : MonoBehaviour
{
    [Header("Wiring")]
    [Tooltip("TORSION's Engine component -- torqueCurve is read directly, "
           + "never re-simulated.")]
    public Engine engine;

    [Tooltip("The tyre model backing the wheels this benchmark drives on. "
           + "Must be the same asset RVP's wheels use -- see the "
           + "integration note in RaggedEdgeMeter.cs.")]
    public TireForceModel tireModel;

    [Header("Drivetrain, for the benchmark run")]
    [Tooltip("Combined gear ratio x final drive for the gear being "
           + "benchmarked. Extend this to loop across TORSION's Gearbox "
           + "gears for a full multi-gear run; this single-ratio version "
           + "is the minimal correct implementation.")]
    public float effectiveGearRatio = 3.5f;
    public float wheelRadiusMeters = 0.33f;

    [Header("Vehicle, for the benchmark run")]
    public float vehicleMassKg = 1400f;
    public float dragCoefficient = 0.32f;
    public float frontalAreaM2 = 2.1f;
    [Tooltip("Air density, kg/m^3. ~1.225 at sea level.")]
    public float airDensity = 1.225f;
    [Tooltip("Rolling resistance coefficient. Beckman flags this as "
           + "'probably the weakest approximation' in his own straight-"
           + "line model (34 Part 1c, Beckman Part 9) -- treat it as a "
           + "rough constant, not a precise figure.")]
    public float rollingResistanceCoefficient = 0.015f;
    [Tooltip("Static vertical load on the driven axle, for the tyre "
           + "traction cap during launch. A rough constant is fine here; "
           + "this is a benchmark tool, not the live suspension model.")]
    public float drivenAxleLoadN = 6000f;

    // ---------------------------------------------------------------
    // 1 & 2. Read + draw: sample the live torque curve
    // ---------------------------------------------------------------

    /// <summary>
    /// Reads Engine.torqueCurve directly. ASSUMPTION (verify against your
    /// actual TORSION Engine.UpdatePhysics implementation before trusting
    /// this): the curve's X axis is engine RPM and Y axis is torque in Nm,
    /// which is the conventional layout for this kind of AnimationCurve
    /// field. If your build uses a different convention, change only this
    /// one method -- everything downstream treats it as ground truth.
    /// </summary>
    public float GetTorqueCurveSample(float rpm)
    {
        if (engine == null || engine.torqueCurve == null) return 0f;
        return engine.torqueCurve.Evaluate(rpm);
    }

    /// <summary>Sampled (rpm, torque) pairs for a chart UI (31 S6.2).</summary>
    public List<Vector2> GetTorqueCurvePoints(float rpmMin, float rpmMax, int samples = 40)
    {
        var points = new List<Vector2>(samples);
        for (int i = 0; i < samples; i++)
        {
            float rpm = Mathf.Lerp(rpmMin, rpmMax, samples <= 1 ? 0f : (float)i / (samples - 1));
            points.Add(new Vector2(rpm, GetTorqueCurveSample(rpm)));
        }
        return points;
    }

    /// <summary>The RPM at which the current torque curve peaks -- useful
    /// for UI ("power band centred at X RPM") and for the mentor's
    /// diagnostic voice (30-NARRATIVE-DESIGN.md S1.3) to reference by name.</summary>
    public float FindPeakTorqueRPM(float rpmMin, float rpmMax, int samples = 200)
    {
        float bestRpm = rpmMin, bestTorque = float.NegativeInfinity;
        for (int i = 0; i < samples; i++)
        {
            float rpm = Mathf.Lerp(rpmMin, rpmMax, samples <= 1 ? 0f : (float)i / (samples - 1));
            float t = GetTorqueCurveSample(rpm);
            if (t > bestTorque) { bestTorque = t; bestRpm = rpm; }
        }
        return bestRpm;
    }

    // ---------------------------------------------------------------
    // 3. The benchmark: RK4 straight-line integration
    // ---------------------------------------------------------------

    /// <summary>
    /// A single physics state for the benchmark integrator: position (m)
    /// and velocity (m/s) along the straight line being simulated.
    /// </summary>
    private struct State
    {
        public float position;
        public float velocity;
        public State(float p, float v) { position = p; velocity = v; }
        public static State operator +(State a, State b) =>
            new State(a.position + b.position, a.velocity + b.velocity);
        public static State operator *(State s, float k) =>
            new State(s.position * k, s.velocity * k);
    }

    /// <summary>
    /// Derivative function for the RK4 integrator (34 Part 1c, Finding 2 --
    /// use a proper integrator, not Euler). Drive force comes FROM the
    /// torque curve, capped by tyre traction at the driven axle's current
    /// load -- never the reverse (34 Part 1e, Beckman Part 26's flat-
    /// torque-curve artefact warning: a smooth velocity ramp would produce
    /// a fake flat curve regardless of what the engine is actually doing).
    /// </summary>
    private State Derivative(State s)
    {
        float wheelAngularVel = s.velocity / Mathf.Max(wheelRadiusMeters, 0.01f);
        float engineRpm = wheelAngularVel * effectiveGearRatio * 60f / (2f * Mathf.PI);

        float engineTorque = GetTorqueCurveSample(engineRpm);
        float wheelTorque = engineTorque * effectiveGearRatio;
        float driveForceUncapped = wheelTorque / Mathf.Max(wheelRadiusMeters, 0.01f);

        // Cap by tyre traction at the driven axle -- this is the launch
        // mechanic from 34 Part 1c (Beckman Part 3): early on, the tyre
        // limits you, not the engine.
        float slipRatio = tireModel != null
            ? TireForceModel.RawSlipRatio(wheelAngularVel, wheelRadiusMeters, s.velocity)
            : 0f;
        float lowSpeedBlend = tireModel != null ? tireModel.LowSpeedBlend(s.velocity) : 1f;
        float blendedSlip = slipRatio * lowSpeedBlend;

        float tractionLimit = tireModel != null
            ? tireModel.PeakLongitudinal(drivenAxleLoadN)
            : float.PositiveInfinity;

        float driveForce = Mathf.Clamp(driveForceUncapped, -tractionLimit, tractionLimit);

        // Aerodynamic drag: F = 1/2 * Cd * A * rho * v^2 (34 Part 1c, Beckman Part 6).
        float drag = 0.5f * dragCoefficient * frontalAreaM2 * airDensity
                     * s.velocity * Mathf.Abs(s.velocity);

        // Rolling resistance, approximately proportional to velocity
        // (34 Part 1c, Beckman Part 9 -- flagged by Beckman himself as the
        // weakest approximation in his own model; treat accordingly).
        float rolling = rollingResistanceCoefficient * vehicleMassKg * 9.81f
                        * Mathf.Sign(s.velocity);

        float netForce = driveForce - drag - rolling;
        float acceleration = netForce / Mathf.Max(vehicleMassKg, 1f);

        return new State(s.velocity, acceleration);
    }

    /// <summary>Classic 4th-order Runge-Kutta step (34 Part 1c, Finding 2).</summary>
    private State RK4Step(State s, float dt)
    {
        State k1 = Derivative(s);
        State k2 = Derivative(s + k1 * (dt * 0.5f));
        State k3 = Derivative(s + k2 * (dt * 0.5f));
        State k4 = Derivative(s + k3 * dt);
        return s + (k1 + k2 * 2f + k3 * 2f + k4) * (dt / 6f);
    }

    /// <summary>
    /// Result of a benchmark run: this IS the CSR2-style "what a perfect
    /// run gives you" number (31 S6.3). The player's actual driven time
    /// can beat it through better shift points, launch technique, or a
    /// setup the driven test hasn't captured -- the gap between this
    /// number and what the player actually achieves on track is the
    /// number worth surfacing to them.
    /// </summary>
    public struct BenchmarkResult
    {
        public float timeToTargetSpeed;
        public bool reachedTarget;
        public float finalVelocity;
    }

    /// <summary>
    /// Integrates a straight-line launch from rest to targetSpeedMs using
    /// the live torque curve and tyre model. dt is fixed and small
    /// (default matches a typical physics tick) -- per 34 Part 1c Finding
    /// 2, the choice of step size and integrator both matter, and this
    /// method exists specifically so you are not tempted to reach for
    /// Euler "just for the benchmark."
    /// </summary>
    public BenchmarkResult RunStraightLineBenchmark(
        float targetSpeedMs, float dt = 0.02f, float maxSimSeconds = 30f)
    {
        var state = new State(0f, 0f);
        float t = 0f;
        while (t < maxSimSeconds)
        {
            state = RK4Step(state, dt);
            t += dt;
            if (state.velocity >= targetSpeedMs)
            {
                return new BenchmarkResult
                {
                    timeToTargetSpeed = t,
                    reachedTarget = true,
                    finalVelocity = state.velocity
                };
            }
        }
        return new BenchmarkResult
        {
            timeToTargetSpeed = maxSimSeconds,
            reachedTarget = false,
            finalVelocity = state.velocity
        };
    }
}
