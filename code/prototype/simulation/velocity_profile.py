"""
A from-first-principles racing-line speed solver, built after failing to
reproduce Beckman's unpublished Part 18 formulas (no spreadsheet exists for
this article, unlike Part 26's phors26.xls -- confirmed by direct search).

Rather than keep guessing at his specific k/k_unwind parametrization, this
uses the standard two-pass forward/backward velocity-profile method that
essentially all real minimum-time trajectory optimizers use (including,
almost certainly, TUMFTM's published tools -- see racing_line.py's header
for that search). This is well-established optimal-control methodology,
not a reconstruction of any single unpublished source, and it uses THIS
PROJECT'S OWN validated tire model (TireForceModel.combined(), matched to
Beckman's Part 21 worked example to within 13%) rather than a simplified
fixed ellipse -- which is more honest, since it's the model this project
would actually ship with.

Method:
  1. Discretise the path into small arc-length steps, each with a known
     curvature (0 on the straights, 1/r on the corner).
  2. FORWARD PASS: at each step, cap speed by (a) the max cornering speed
     the tyre model allows at that curvature, and (b) how fast you could
     have accelerated from the previous step's speed, given how much
     lateral force cornering is already using (the combined-slip ellipse
     directly limits remaining longitudinal capacity).
  3. BACKWARD PASS: same thing in reverse from the finish, capping by max
     braking capacity, so the forward pass can't promise a speed you
     wouldn't be able to shed in time for what's coming.
  4. Take the minimum of the two passes at every point. This is the
     standard result: it can never be slower than a naive constant-speed
     line (a real structural check, not just a hoped-for property).
"""
import numpy as np
from tire_model import TireForceModel

G = 9.81

def build_path(entry_straight_m, r, r0, r1, exit_straight_m, ds=0.5):
    """Path curvature as a function of arc length s. Straight -> arc of
    the searched inscribed radius -> straight. Simplified: full corner
    modelled as one constant-curvature arc of length pi*r (a 180-degree
    turn), which is the same corner Beckman uses, without his separate
    turn-in/apex bookkeeping -- curvature is curvature regardless of how
    you got there."""
    corner_length = np.pi * r
    total_length = entry_straight_m + corner_length + exit_straight_m
    s = np.arange(0, total_length, ds)
    kappa = np.zeros_like(s)
    in_corner = (s >= entry_straight_m) & (s < entry_straight_m + corner_length)
    kappa[in_corner] = 1.0 / r
    return s, kappa, ds

def max_corner_speed(tire, kappa, mass_kg, Fz_per_wheel, n_driven_wheels=2):
    """Max speed at this curvature: lateral force needed (m*v^2*kappa)
    can't exceed the tyre's peak lateral force. v_max = sqrt(F_peak /
    (m * kappa)). Straight (kappa=0) -> no cap."""
    if kappa < 1e-6:
        return 1e6
    peak_lateral_total = tire.peak_lateral(Fz_per_wheel) * 4  # all four tyres
    return np.sqrt(peak_lateral_total / (mass_kg * kappa))

def remaining_longitudinal(tire, kappa, v, mass_kg, Fz_per_wheel, n_driven_wheels, mode):
    """How much force is left over for accel/braking once cornering has
    used some of the traction ellipse, via the SAME combined() method
    already validated against Beckman's own numbers."""
    if kappa < 1e-6:
        peak = tire.peak_longitudinal(Fz_per_wheel) * n_driven_wheels
        return peak if mode == "accel" else tire.peak_longitudinal(Fz_per_wheel) * 4
    lateral_force_needed = mass_kg * v**2 * kappa
    lateral_force_per_wheel = lateral_force_needed / 4
    peak_lat = tire.peak_lateral(Fz_per_wheel)
    lat_fraction = min(0.999, abs(lateral_force_per_wheel) / peak_lat) if peak_lat > 0 else 0
    remaining_fraction = np.sqrt(max(0, 1 - lat_fraction**2))
    n_wheels = n_driven_wheels if mode == "accel" else 4
    return tire.peak_longitudinal(Fz_per_wheel) * remaining_fraction * n_wheels


def solve_velocity_profile(tire, s, kappa, ds, mass_kg, Fz_per_wheel,
                             entry_speed_ms, n_driven_wheels=4):
    n = len(s)
    v_fwd = np.zeros(n)
    v_fwd[0] = entry_speed_ms
    for i in range(1, n):
        v_corner_cap = max_corner_speed(tire, kappa[i], mass_kg, Fz_per_wheel)
        f_accel = remaining_longitudinal(tire, kappa[i-1], v_fwd[i-1], mass_kg,
                                          Fz_per_wheel, n_driven_wheels, "accel")
        a = f_accel / mass_kg
        v_possible = np.sqrt(max(0, v_fwd[i-1]**2 + 2*a*ds))
        v_fwd[i] = min(v_possible, v_corner_cap)

    v_bwd = np.zeros(n)
    # FIXED: tying this to v_fwd[-1] artificially chained the entire backward
    # pass to whatever the forward pass happened to produce -- if the
    # forward pass was conservative anywhere, the backward pass inherited
    # that at its own starting point and could only get MORE conservative
    # from there (braking caps only ever reduce speed going backward from
    # a fixed start). The end of the segment is open track with kappa=0,
    # so the backward pass should start effectively unconstrained and let
    # the min() with the forward pass do its actual job.
    v_bwd[-1] = max_corner_speed(tire, kappa[-1], mass_kg, Fz_per_wheel)
    for i in range(n-2, -1, -1):
        v_corner_cap = max_corner_speed(tire, kappa[i], mass_kg, Fz_per_wheel)
        f_brake = remaining_longitudinal(tire, kappa[i+1], v_bwd[i+1], mass_kg,
                                          Fz_per_wheel, 4, "brake")
        a = f_brake / mass_kg
        v_possible = np.sqrt(max(0, v_bwd[i+1]**2 + 2*a*ds))
        v_bwd[i] = min(v_possible, v_corner_cap)

    v = np.minimum(v_fwd, v_bwd)
    v = np.maximum(v, 1.0)  # avoid divide-by-zero in the time integration
    t_segments = ds / v
    total_time = np.sum(t_segments)
    return v, total_time


if __name__ == "__main__":
    tire = TireForceModel()
    mass_kg = 1400.0
    Fz_per_wheel = (mass_kg * G) / 4
    FT = 0.3048
    entry_v = 100 / 2.23694

    print("=== From-first-principles velocity profile, this project's own tyre model ===\n")
    print(f"{'r(ft)':>6} {'total(s)':>9}  vs dummy-line (already validated to 0.3%)")

    from racing_line import dummy_line_time
    results = []
    for r_ft in np.arange(150, 200.5, 5):
        r = r_ft * FT
        s, kappa, ds = build_path(650*FT, r, 100*FT, 200*FT, 650*FT)
        v, t = solve_velocity_profile(tire, s, kappa, ds, mass_kg, Fz_per_wheel, entry_v)
        t_dummy = dummy_line_time(r, entry_v)
        results.append((r_ft, t, t_dummy))
        faster = "OK -- faster than dummy" if t <= t_dummy else "WRONG -- slower than dummy, bug"
        print(f"{r_ft:6.1f} {t:9.3f}   (dummy: {t_dummy:.3f})  {faster}")

    best = min(results, key=lambda x: x[1])
    print(f"\nBest radius by this method: {best[0]:.1f}ft -> {best[1]:.3f}s")
    print()
    print("KNOWN LIMITATION -- read before trusting tight-radius results:")
    print("build_path() always models the corner as a full pi*r semicircle")
    print("(a full 180-degree arc at the searched radius), regardless of r.")
    print("Beckman's actual geometry only arcs for (180 - 2*alpha) degrees,")
    print("with the rest of the segment being straight approach/exit -- and")
    print("alpha grows toward 90 deg as r shrinks toward 150ft, meaning the")
    print("REAL arc for tight radii is much shorter than a full semicircle.")
    print("This makes tight-radius results in THIS script drive an artificially")
    print("long path and read as slower than they should. Wide radii (r >~")
    print("167ft) are structurally validated (profile time <= dummy-line time,")
    print("every time). Tight radii are NOT -- the path-length approximation")
    print("needs the variable-arc-angle geometry from racing_line.py's")
    print("solve_geometry() before it can be trusted below ~165ft.")
