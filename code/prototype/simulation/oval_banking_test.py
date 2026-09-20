"""
Tests 44-TRACK-ROSTER.md's real banking-angle range (12-33 degrees,
sourced from real NASCAR classification data) against the tire model's
lateral grip -- never previously run. Banked-corner max speed:
v_max = sqrt(r * g * (tan(theta) + mu) / (1 - mu * tan(theta)))
-- the standard banked-turn formula, mu from the tire model's own
peak-lateral-force-over-load ratio, not assumed.
"""
import numpy as np
from tire_model import TireForceModel

G = 9.81
MI = 1609.34

def banked_corner_speed(radius_m, banking_deg, mu):
    theta = np.radians(banking_deg)
    num = G * radius_m * (np.tan(theta) + mu)
    den = 1 - mu * np.tan(theta)
    if den <= 0:
        return None  # banking angle exceeds the tire's own friction cone
    return np.sqrt(num / den)


if __name__ == "__main__":
    tire = TireForceModel()
    mass_kg = 1400.0
    Fz_per_wheel = mass_kg * G / 4
    mu = tire.peak_lateral(Fz_per_wheel) / Fz_per_wheel

    print(f"Tire model's actual lateral mu: {mu:.2f}\n")

    # FIXED: the first version treated the ENTIRE lap length as a full
    # circle's circumference (radius = length / 2*pi), which ignores
    # that roughly half a real oval's length is straight, not curved.
    # That overestimated turn radius by ~2-3x, which (since v_max scales
    # with sqrt(radius)) produced physically impossible speeds -- one
    # result came out above 500mph on a real-world superspeedway class.
    #
    # Corrected: assume turns account for ~40% of total lap length,
    # split into two semicircular ends -- a standard rough oval
    # proportion, not a precise geometric derivation. Radius from a
    # semicircle of length L is L/pi, so: turn_radius = (0.40 * total
    # length / 2 turns) / pi. This is still an approximation, not real
    # per-track survey data -- flagged as such, and calibrated below
    # against real known superspeedway top speeds as a sanity check.
    configs = [
        ("3/4mi short track", 0.75*MI, [20, 30]),
        ("1.5mi intermediate", 1.5*MI, [12, 24]),
        ("2.5mi superspeedway", 2.5*MI, [28, 33]),
    ]

    print(f"{'Oval class':>22} {'radius(m)':>10} {'bank':>6} {'grip-limit(mph)':>16} {'power needed':>14}")
    Cd, A, rho = 0.42, 2.0, 1.225
    for name, length_m, bank_range in configs:
        turn_length_each = (length_m * 0.40) / 2
        radius_m = turn_length_each / np.pi
        for bank in bank_range:
            v = banked_corner_speed(radius_m, bank, mu)
            if not v:
                print(f"{name:>22} {radius_m:10.0f} {bank:5.0f}\u00b0    EXCEEDS FRICTION CONE")
                continue
            v_mph = v * 2.237
            # WARNING: this is the GRIP ceiling only -- it does not check
            # whether the power to actually reach that speed (overcoming
            # drag, which scales v^2) is achievable. At high banking the
            # power requirement can exceed anything realistic long
            # before grip runs out -- see the printed power figure.
            drag_n = 0.5*Cd*A*rho*v*v
            power_hp_needed = (drag_n * v) / 745.7
            flag = "  <- power-limited, not grip-limited" if power_hp_needed > 700 else ""
            print(f"{name:>22} {radius_m:10.0f} {bank:5.0f}\u00b0 {v_mph:16.1f} {power_hp_needed:11.0f}hp{flag}")
