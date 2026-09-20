"""
Simplified lateral weight transfer for a cornering RWD car, used to drive
the differential comparison. Not the full closed-form from
StaticWeightTransfer.cs (Beckman Part 27) -- that's the static, level-ground,
all-four-corners solution. This is the reduced two-wheel (one axle) version,
sufficient to show inside/outside load split during a corner, which is all
the differential comparison needs.
"""

def rear_axle_loads(mass_kg, static_rear_load_n, cg_height_m, rear_track_m, lateral_accel_ms2):
    """Returns (inside_load_N, outside_load_N) for the rear axle in a
    left-hand corner (inside = left, outside = right), using the standard
    single-axle load-transfer equation: delta_W = (m * a_y * h) / track."""
    transfer = (mass_kg * lateral_accel_ms2 * cg_height_m) / rear_track_m
    inside = max(0.0, static_rear_load_n / 2.0 - transfer / 2.0)
    outside = static_rear_load_n / 2.0 + transfer / 2.0
    return inside, outside
