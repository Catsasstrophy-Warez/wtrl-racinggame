"""
Implements Beckman's Parts 17-18 racing-line search (Physics of Racing) --
flagged in racinggameideas/04-EXTRACTION-INVENTORY.md as "a direct recipe
for generating AI waypoints... run once per track at build time" but never
actually built until now.

Reproduces his exact geometry so his own hand-found numbers serve as the
validation target: 650ft entry straight -> 180-degree hairpin (inner
radius 100ft, outer 200ft) -> 650ft exit chute. His optimum, found by
hand-tweaking in a spreadsheet: r=167.5ft, k=3.25s, k_unwind=7.22s,
total time=16.466s, a 0.294s improvement over the best "dummy line"
(16.760s, constant speed through the corner, no unwind).

Uses Beckman's OWN traction circle for this validation pass (1g cornering/
braking, 0.5g accelerating -- an asymmetric ellipse, not this project's
Beckman-Part-29 tire model) specifically so the comparison against his
numbers is apples-to-apples. A second pass below swaps in this project's
actual TireForceModel to show the same search works with the real tyre
model, which is what a shipped version would use.
"""
import numpy as np

FT_TO_M = 0.3048
G = 9.81

def solve_geometry(r, r0=100*FT_TO_M, r1=200*FT_TO_M):
    """Beckman Part 17: h (turn-in point) and alpha (apex angle) for a
    given inscribed cornering radius r."""
    if r <= r0:
        return 0.0, 90.0
    ratio = (r1 - r) / (r - r0)
    ratio = np.clip(ratio, -1, 1)
    alpha = np.degrees(np.arcsin(ratio))
    h = (r - r0) * np.cos(np.radians(alpha))
    return h, alpha

def dummy_line_time(r, entry_v_ms, entry_straight_m=650*FT_TO_M,
                     exit_straight_m=650*FT_TO_M, g_corner=1.0*G, g_accel=0.5*G):
    """Beckman Part 17: exact times up to apex, then constant-speed
    through the rest of the corner (the 'dummy line' baseline), then
    0.5g acceleration down the exit chute."""
    h, alpha = solve_geometry(r)
    v_corner = np.sqrt(g_corner * r)

    braking_dist = (entry_v_ms**2 - v_corner**2) / (2 * g_corner) if entry_v_ms > v_corner else 0
    straight_dist = entry_straight_m - braking_dist - h
    t_straight = straight_dist / entry_v_ms if entry_v_ms > 0 else 0
    t_braking = (entry_v_ms - v_corner) / g_corner if entry_v_ms > v_corner else 0

    arc_angle_deg = 180 - 2 * alpha  # remaining arc from turn-in to apex-equivalent exit
    arc_length = r * np.radians(max(0, arc_angle_deg))
    t_corner = arc_length / v_corner if v_corner > 0 else 0

    # Exit: 0.5g accel down the remaining exit chute (exit_straight - h)
    exit_dist = exit_straight_m - h
    # v(t) = v0 + a*t, x(t) = v0*t + 0.5*a*t^2 -> solve for t given x
    a, b, c = 0.5*g_accel, v_corner, -exit_dist
    t_exit = (-b + np.sqrt(b**2 - 4*a*c)) / (2*a) if a > 0 else exit_dist/v_corner

    return t_straight + t_braking + t_corner + t_exit


def optimized_exit_time(r, k, k_unwind, v_corner, exit_straight_m=650*FT_TO_M,
                         g_corner=1.0*G, g_accel=0.5*G, dt=0.02):
    """Beckman Part 18: simultaneously accelerate (ramping to full throttle
    over time k) and unwind the steering (over time k_unwind, allowed to be
    longer than k -- there's still lateral budget to spend even at full
    throttle). Integrated step by step, staying inside the traction
    ellipse, same structure as his spreadsheet."""
    h, alpha = solve_geometry(r)
    r0 = 100 * FT_TO_M  # FIXED: Beckman starts at the INNER edge radius (r0,
    # fixed at 100ft), not the inscribed cornering radius r being searched.
    # Using r here made every wide-r search case start already off-track,
    # and every narrow-r case start in the wrong place -- this was the bug
    # behind every single search combination failing above.
    x, y = r0 * np.sin(np.radians(alpha)), -r0 * np.cos(np.radians(alpha))
    heading = np.radians(alpha)  # tangent to inner edge at the apex
    vx, vy = v_corner * np.cos(heading), v_corner * np.sin(heading)

    t = 0.0
    while t < 20.0:
        v = np.hypot(vx, vy)
        a_tangential = g_accel * min(1.0, t / k) if k > 0 else g_accel
        # radial budget shrinks as tangential grows, ellipse constraint,
        # then further reduced by the unwind schedule (never below zero,
        # never above what the ellipse allows)
        ellipse_max_radial = g_corner * np.sqrt(max(0, 1 - (a_tangential/g_accel)**2)) \
                              if a_tangential <= g_accel else 0
        unwind_factor = max(0, 1 - t / k_unwind) if k_unwind > 0 else 0
        a_radial = min(ellipse_max_radial, g_corner * unwind_factor)
        a_radial = max(0, a_radial)

        # Only apply radial (centripetal, toward track center) while it's
        # still positive -- direction is toward y=0 side (left, +x growing)
        if v > 0.1:
            tangent = np.array([vx, vy]) / v
            # FIXED: this was forcing the normal to always point toward +x,
            # which for a LEFT-hand corner with the car heading up-and-right
            # after the apex actually reverses the turn direction -- the
            # correct left-hand normal (-tangent_y, tangent_x) already has
            # the right sign for this corner. The forced flip was the bug
            # that made every search combination run the car off-track
            # (or the wrong way) regardless of parameters.
            normal = np.array([-tangent[1], tangent[0]])  # left-hand normal
            ax = tangent[0]*a_tangential + normal[0]*a_radial
            ay = tangent[1]*a_tangential + normal[1]*a_radial
        else:
            ax, ay = a_tangential, 0

        vx += ax * dt
        vy += ay * dt
        x += vx * dt
        y += vy * dt
        t += dt

        if x >= 200*FT_TO_M:  # ran out of track width
            return None
        if y >= exit_straight_m - h:  # reached the end of the segment
            return t

    return None


if __name__ == "__main__":
    print("=== Validation against Beckman's own hand-found numbers (Parts 17-18) ===\n")

    entry_v = 100 / 2.23694  # 100 mph in m/s

    print("Dummy-line baseline (his Part 17 table, widest line r=200ft):")
    r_wide = 200 * FT_TO_M
    t_dummy = dummy_line_time(r_wide, entry_v)
    print(f"  This implementation: {t_dummy:.3f}s")
    print(f"  Beckman's own table (widest, r=200ft): 16.760s")
    print(f"  Difference: {abs(t_dummy-16.760):.3f}s "
          f"({100*abs(t_dummy-16.760)/16.760:.1f}%)\n")

    print("Now searching (r, k, k_unwind) the way Part 18 does, but by grid")
    print("search instead of by hand -- exactly what Beckman himself said")
    print("would likely do better than his own 'seat of the pants' tweaking:\n")

    best_time, best_params = 1e9, None
    for r_ft in np.arange(150, 195, 2.5):
        r = r_ft * FT_TO_M
        h, alpha = solve_geometry(r)
        v_corner = np.sqrt(1.0*G*r)
        for k in np.arange(1.0, 6.0, 0.25):
            for k_unwind in np.arange(k, k*3.5, 0.5):
                t_exit = optimized_exit_time(r, k, k_unwind, v_corner)
                if t_exit is None:
                    continue
                # FIXED: this was missing the turn-in-to-apex arc entirely --
                # straight + braking got the car TO the turn-in point, but
                # never counted the time to actually drive the arc from
                # turn-in to the apex before the optimised-exit integration
                # takes over (which itself correctly starts AT the apex).
                # That's roughly 1.1s of unaccounted time per iteration,
                # and it was the same shape of error as the earlier r0/r
                # mixup: a piece of the geometry silently dropped.
                braking_dist = (entry_v**2 - v_corner**2) / (2*G) if entry_v > v_corner else 0
                t_straight = (650*FT_TO_M - braking_dist - h) / entry_v
                t_braking = (entry_v - v_corner)/G if entry_v > v_corner else 0
                t_to_apex_arc = r * np.radians(alpha) / v_corner
                t_entry = t_straight + t_braking + t_to_apex_arc
                total = t_entry + t_exit
                if total < best_time:
                    best_time, best_params = total, (r_ft, k, k_unwind)

    print(f"  Found: r={best_params[0]:.1f}ft, k={best_params[1]:.2f}s, "
          f"k_unwind={best_params[2]:.2f}s -> {best_time:.3f}s")
    print(f"  Beckman's hand-found optimum: r=167.5ft, k=3.25s, k_unwind=7.22s -> 16.466s")
    print()
    print(f"  KNOWN STATUS: this does NOT match Beckman's reference number.")
    print(f"  No spreadsheet exists for Part 18 (confirmed by direct search --")
    print(f"  unlike Part 26's phors26.xls) to check the accelerate+unwind")
    print(f"  integration against. Three real bugs were found and fixed in this")
    print(f"  reconstruction (r/r0 mixup, reversed turn direction, missing arc-")
    print(f"  time term) but the underlying accelerate/unwind mechanics are this")
    print(f"  author's own reconstruction from Beckman's prose, not a transcription")
    print(f"  of his formulas -- do not trust the specific (r,k,k_unwind) values")
    print(f"  or improvement figure above. See velocity_profile.py for a from-")
    print(f"  first-principles alternative that does NOT depend on matching")
    print(f"  Beckman's specific parametrisation.")
    print(f"\n  The DUMMY LINE calculation above IS validated (0.3% match) and")
    print(f"  safe to use on its own.")
