"""
Python port of code/prototype/DynoController.cs's RK4 straight-line
integrator (34 Part 1c Finding 2 -- RK4, not Euler, because Euler diverges
60% over 100s on the simplest possible oscillator per Beckman Part 28).

Extended here to accept a variable traction ceiling, so a corner-exit run
can be simulated with the open-diff vs locked-diff force limit computed in
differential_test.py substituted in directly.
"""
import numpy as np

def rk4_straight_line(mass_kg, drag_coeff, frontal_area_m2, air_density,
                       rolling_resistance_coeff, drive_force_n_capped,
                       target_speed_ms, dt=0.005, max_seconds=15.0):
    """Integrates from rest. drive_force_n_capped is a CONSTANT ceiling here
    (unlike DynoController.cs, which samples an actual torque curve) --
    appropriate for this test, since we're isolating the differential's
    effect on available traction, not re-testing the engine/gearing."""

    def derivative(v):
        drag = 0.5 * drag_coeff * frontal_area_m2 * air_density * v * abs(v)
        rolling = rolling_resistance_coeff * mass_kg * 9.81 * np.sign(v) if v != 0 else 0
        net = drive_force_n_capped - drag - rolling
        return net / mass_kg

    v, x, t = 0.0, 0.0, 0.0
    while t < max_seconds:
        k1 = derivative(v)
        k2 = derivative(v + k1 * dt / 2)
        k3 = derivative(v + k2 * dt / 2)
        k4 = derivative(v + k3 * dt)
        v += (k1 + 2*k2 + 2*k3 + k4) * dt / 6
        x += v * dt
        t += dt
        if v >= target_speed_ms:
            return t, x, v
    return max_seconds, x, v


if __name__ == "__main__":
    from tire_model import TireForceModel
    from differential_test import max_tractive_force

    tire = TireForceModel()
    mass_kg = 1400.0
    static_rear_load_n = 1400 * 9.81 * 0.52
    cg_height_m = 0.48
    rear_track_m = 1.55

    # A representative mid-speed corner exit: car is at 0.7g lateral load
    # (a real, moderate corner) when the driver gets back on the power, and
    # we measure time to accelerate from that point up to 25 m/s (~90 km/h,
    # a plausible corner-exit target speed) using ONLY the traction-limited
    # force computed above -- i.e. this isolates exactly the differential's
    # effect, with nothing else in the model changed.
    lat_g = 0.7
    lat_accel = lat_g * 9.81

    print("=== Same corner exit, same car, same driver input. Only the")
    print("    differential type changes. ===\n")

    results = {}
    for diff_type in ["open", "locked"]:
        force_n, inside_load, outside_load = max_tractive_force(
            tire, mass_kg, static_rear_load_n, cg_height_m, rear_track_m,
            lat_accel, diff_type)

        t, x, v = rk4_straight_line(
            mass_kg=mass_kg, drag_coeff=0.32, frontal_area_m2=2.0,
            air_density=1.225, rolling_resistance_coeff=0.015,
            drive_force_n_capped=force_n, target_speed_ms=25.0)

        results[diff_type] = t
        print(f"{diff_type.upper():>7} diff: {force_n:6.0f} N available "
              f"-> {t:5.2f} s to reach 25 m/s (covered {x:5.1f} m)")

    delta = results["open"] - results["locked"]
    pct = 100 * delta / results["open"]
    print(f"\nTime saved by the locked differential: {delta:.2f} s "
          f"({pct:.1f}% faster corner exit)")
    print(f"\nAt a rough 90 seconds/lap on a technical circuit with, say, six")
    print(f"corner exits of similar severity, this single tuning change is")
    print(f"worth roughly {delta*6:.1f}s a lap on its own -- squarely in the")
    print(f"range that separates a good driver from a great one, from a")
    print(f"single differential setting, with nothing else touched.")
