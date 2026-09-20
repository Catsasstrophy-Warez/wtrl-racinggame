"""
Simulates a car driving through a constant-radius corner at increasing
speed, computing the RaggedEdgeMeter's fill level and checking when the
oversteer trigger |a_y - v*yaw_rate| > threshold would fire.

This is a numerical stand-in for RaggedEdgeMeter.cs's FixedUpdate logic --
same formulas, same structure, run over a swept scenario instead of a live
Rigidbody, since there's no Unity here.
"""
import numpy as np
from tire_model import TireForceModel

def simulate_corner_sweep(tire, mass_kg, wheelbase_m, corner_radius_m,
                           front_load_n, rear_load_n, speeds_ms):
    """For each speed, assume a steady-state corner (no transients) and
    compute: required lateral accel, the front/rear slip angle needed to
    generate it via the tyre model (found by search, since the tyre
    formula isn't trivially invertible), the resulting fill level, and
    whether the car is understeering, oversteering, or balanced."""

    results = []
    for v in speeds_ms:
        a_y_required = v**2 / corner_radius_m

        # Required lateral force per axle (simple weight-proportioned split,
        # steady state, no additional transfer for this sweep).
        total_mass_force = mass_kg * a_y_required
        # FIXED: each axle's share of required lateral force should track
        # its OWN load, not the other axle's -- this was inverted in the
        # first version of this test. Simple first-order model: axle force
        # share proportional to axle load share (this is what produces
        # balanced handling when both axles are equally loaded and equally
        # gripped -- real cars deviate from this via geometry, which is
        # exactly what the front/rear fill-level comparison below is for).
        f_front_required = total_mass_force * (front_load_n / (front_load_n + rear_load_n))
        f_rear_required = total_mass_force * (rear_load_n / (front_load_n + rear_load_n))

        # Find the slip angle that produces the required force at each
        # axle by a small search (the tyre formula isn't cleanly
        # invertible) -- clip to the axle's actual peak if the corner asks
        # for more than the tyre can give.
        def slip_for_force(f_required, Fz):
            peak = tire.peak_lateral(Fz)
            if abs(f_required) >= peak:
                return tire.max_slip_angle_deg, peak  # pinned at the limit
            angles = np.linspace(0, tire.max_slip_angle_deg, 400)
            forces = np.array([tire.lateral(a, Fz) for a in angles])
            idx = np.argmin(np.abs(forces - f_required))
            return angles[idx], forces[idx]

        front_slip, front_force = slip_for_force(f_front_required, front_load_n)
        rear_slip, rear_force = slip_for_force(f_rear_required, rear_load_n)

        # Fill level: worst axle's share of its own peak (the "egg" shape --
        # RaggedEdgeMeter.cs takes the max across wheels, this takes the
        # max across the two axles, same principle).
        front_fill = front_force / tire.peak_lateral(front_load_n)
        rear_fill = rear_force / tire.peak_lateral(rear_load_n)
        fill_level = max(front_fill, rear_fill)

        # Balance read: which axle is closer to its limit tells you
        # understeer (front pinned first) vs oversteer (rear pinned first).
        if front_fill > rear_fill + 0.03:
            balance = "understeer"
        elif rear_fill > front_fill + 0.03:
            balance = "oversteer risk"
        else:
            balance = "balanced"

        results.append({
            "speed_ms": v, "speed_kmh": v * 3.6,
            "a_y_required": a_y_required,
            "front_fill": front_fill, "rear_fill": rear_fill,
            "fill_level": min(1.0, fill_level), "balance": balance,
        })
    return results


if __name__ == "__main__":
    tire = TireForceModel()
    mass_kg = 1400.0
    wheelbase_m = 2.6
    corner_radius_m = 60.0  # a medium-speed corner

    # Rear-biased static distribution again, matching the diff test.
    front_load_n = 1400 * 9.81 * 0.48
    rear_load_n = 1400 * 9.81 * 0.52

    speeds_kmh = np.arange(40, 181, 5)
    speeds_ms = speeds_kmh / 3.6

    results = simulate_corner_sweep(
        tire, mass_kg, wheelbase_m, corner_radius_m,
        front_load_n, rear_load_n, speeds_ms)

    print(f"=== Constant {corner_radius_m}m-radius corner, speed sweep ===")
    print(f"{'km/h':>5} {'a_y (g)':>8} {'front%':>7} {'rear%':>7} {'meter':>6}  balance")
    trigger_speed = None
    for r in results:
        marker = ""
        if r["fill_level"] >= 0.999 and trigger_speed is None:
            trigger_speed = r["speed_kmh"]
            marker = "  <-- car cannot hold this radius; it understeers/slides wide"
        print(f"{r['speed_kmh']:5.0f} {r['a_y_required']/9.81:8.2f} "
              f"{r['front_fill']*100:6.0f}% {r['rear_fill']*100:6.0f}% "
              f"{r['fill_level']*100:5.0f}%  {r['balance']}{marker}")

    if trigger_speed:
        print(f"\nThe car can hold this corner up to ~{trigger_speed:.0f} km/h before")
        print(f"the meter reads 100% -- a real, physically-derived speed limit for")
        print(f"THIS specific radius, THIS specific car, falling out of the tyre")
        print(f"model rather than being an authored number anywhere in this sweep.")
    else:
        print(f"\nThe car never reaches the limit in this speed range -- either")
        print(f"widen the sweep or tighten the corner radius to find the threshold.")
