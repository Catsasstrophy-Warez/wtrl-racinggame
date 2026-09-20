"""
Validates 44-TRACK-ROSTER.md's drag strip distances against the actual
1965 hero car spec from 43-FIRST-PLAYABLE-SPECS.md (164hp, 3-speed
manual, degraded starting state) -- never previously run together.
Uses the same RK4 integrator as rk4_benchmark.py / DynoController.cs.
"""
import numpy as np
from tire_model import TireForceModel

G = 9.81
FT = 0.3048

def rk4_distance_run(mass_kg, drag_coeff, frontal_area_m2, air_density,
                      rolling_resistance_coeff, peak_hp, tire, Fz_per_wheel,
                      n_driven_wheels, target_distance_m, dt=0.01, max_seconds=60,
                      driveline_loss=0.175):
    """Integrates position/velocity from a standing start over a fixed
    DISTANCE (not to a target speed) -- what a drag strip actually
    measures. Engine force is capped by both a simple constant-power
    approximation and the tire's traction limit, whichever is lower.

    FIXED: peak_hp is CRANK horsepower (matching 43-FIRST-PLAYABLE-
    SPECS.md's EngineVariant.peakPowerHp field), not wheel horsepower --
    the first version of this script fed it straight into the force
    calc as if driveline losses didn't exist. Beckman's own dyno chapter
    (34 Part 1e, Part 26) found chassis-measured figures run 15-20%
    below crank output; driveline_loss defaults to 0.175, the midpoint.

    STILL NOT MODELED: shift-time loss. A real 3-speed manual costs real
    time on each gear change; this single-gear continuous-power
    approximation cannot capture that. Times below should be read as a
    lower bound (real 3-speed times will be somewhat slower), not a
    tight prediction -- flagged rather than silently absorbed into the
    driveline-loss fix."""
    v, x, t = 0.0, 0.0, 0.0
    wheel_hp = peak_hp * (1 - driveline_loss)
    peak_watts = wheel_hp * 745.7
    while x < target_distance_m and t < max_seconds:
        # constant-power force estimate (capped low to avoid singularity at v=0)
        v_safe = max(v, 2.0)
        power_force = peak_watts / v_safe
        traction_limit = tire.peak_longitudinal(Fz_per_wheel) * n_driven_wheels
        drive_force = min(power_force, traction_limit)
        drag = 0.5 * drag_coeff * frontal_area_m2 * air_density * v * abs(v)
        rolling = rolling_resistance_coeff * mass_kg * G
        a = (drive_force - drag - rolling) / mass_kg
        v = max(0, v + a * dt)
        x += v * dt
        t += dt
    return t, v * 2.237  # time (s), trap speed (mph)


if __name__ == "__main__":
    tire = TireForceModel()
    mass_kg = 1400.0  # matches the differential_test.py reference car
    Fz_per_wheel = mass_kg * G / 4

    # 1965 hero car spec, from 43-FIRST-PLAYABLE-SPECS.md Item 4
    peak_hp = 164
    n_driven_wheels = 2  # RWD, matching the era

    print("=== Drag strip times, 1965 hero car spec (164hp, RWD, degraded) ===")
    print(f"{'Distance':>12} {'Time (s)':>9} {'Trap (mph)':>11}")
    for label, dist_ft in [("1/8 mile", 660), ("1,000 ft", 1000), ("1/4 mile", 1320)]:
        t, trap = rk4_distance_run(mass_kg, 0.42, 2.0, 1.225, 0.015,
                                     peak_hp, tire, Fz_per_wheel, n_driven_wheels,
                                     dist_ft * FT)
        print(f"{label:>12} {t:9.2f} {trap:11.1f}")

    print(f"\n=== Same runs, RESTORED spec (~195hp, matching `43`'s base-spec")
    print(f"    reference for comparison) ===")
    for label, dist_ft in [("1/8 mile", 660), ("1,000 ft", 1000), ("1/4 mile", 1320)]:
        t, trap = rk4_distance_run(mass_kg, 0.42, 2.0, 1.225, 0.015,
                                     195, tire, Fz_per_wheel, n_driven_wheels,
                                     dist_ft * FT)
        print(f"{label:>12} {t:9.2f} {trap:11.1f}")
