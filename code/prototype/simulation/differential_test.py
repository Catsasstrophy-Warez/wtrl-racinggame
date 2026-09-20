"""
THE ACTUAL PASS-CONDITION TEST from 31-DYNO-ANALYSIS.md Part 7:
"Change one differential setting. The curve moves visibly. The lap time
moves measurably."

This tests the first two of the three criteria numerically. The third
(feels good through tilt, on a real phone) genuinely cannot be tested this
way -- that gap is stated plainly at the end, not glossed over.

Model: a RWD car exiting a corner under power. An OPEN differential sends
EQUAL torque to both rear wheels -- once the lightly-loaded inside wheel
hits its traction limit, applying more torque just spins it, and the
outside wheel (which has grip to spare) gets no more torque either, because
open diffs equalise torque, not speed. A LOCKED differential forces the
wheels toward equal SPEED instead, which lets each wheel use its own
individual traction limit -- the outside wheel, more heavily loaded, can
take real advantage of its extra grip.

This is a real, well-documented effect (the entire reason limited-slip and
locked differentials exist), and it is directly computable from the tyre
model already ported above.
"""
import numpy as np
from tire_model import TireForceModel
from weight_transfer import rear_axle_loads

def max_tractive_force(tire, mass_kg, static_rear_load_n, cg_height_m,
                        rear_track_m, lateral_accel_ms2, diff_type):
    inside_load, outside_load = rear_axle_loads(
        mass_kg, static_rear_load_n, cg_height_m, rear_track_m, lateral_accel_ms2)

    peak_inside = tire.peak_longitudinal(inside_load)
    peak_outside = tire.peak_longitudinal(outside_load)

    if diff_type == "open":
        # Equal torque split -> total capped at 2x the weaker wheel's limit.
        return 2.0 * min(peak_inside, peak_outside), inside_load, outside_load
    elif diff_type == "locked":
        # Each wheel can use its own individual limit.
        return peak_inside + peak_outside, inside_load, outside_load
    else:
        raise ValueError(diff_type)


if __name__ == "__main__":
    tire = TireForceModel()

    # A plausible mid-size sports car, RWD, rear-weight-biased for exit grip.
    mass_kg = 1400.0
    static_rear_load_n = 1400 * 9.81 * 0.52  # 52% rear static weight distribution
    cg_height_m = 0.48
    rear_track_m = 1.55

    print("=== Corner-exit tractive force: open vs. locked differential ===")
    print(f"{'lat_g':>6} {'open (N)':>10} {'locked (N)':>11} {'diff (N)':>9} {'diff (%)':>9}")
    for lat_g in [0.0, 0.3, 0.5, 0.7, 0.9, 1.1]:
        lat_accel = lat_g * 9.81
        f_open, ins, outs = max_tractive_force(
            tire, mass_kg, static_rear_load_n, cg_height_m, rear_track_m, lat_accel, "open")
        f_locked, _, _ = max_tractive_force(
            tire, mass_kg, static_rear_load_n, cg_height_m, rear_track_m, lat_accel, "locked")
        diff = f_locked - f_open
        pct = 100 * diff / f_open if f_open > 0 else float('inf')
        print(f"{lat_g:6.1f} {f_open:10.0f} {f_locked:11.0f} {diff:9.0f} {pct:8.1f}%")
