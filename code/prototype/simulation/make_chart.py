import numpy as np
import matplotlib.pyplot as plt
from tire_model import TireForceModel
from differential_test import max_tractive_force
from weight_transfer import rear_axle_loads
from ragged_edge_test import simulate_corner_sweep

tire = TireForceModel()
mass_kg = 1400.0
static_rear_load_n = 1400 * 9.81 * 0.52
front_load_n = 1400 * 9.81 * 0.48
cg_height_m = 0.48
rear_track_m = 1.55
wheelbase_m = 2.6

fig, axes = plt.subplots(2, 2, figsize=(13, 10))
fig.suptitle("Racing game physics prototype — numerical validation (Python port of the C# code)",
             fontsize=13, fontweight='bold')

# --- Panel 1: tire force curves at three loads (criterion 1: does the curve move) ---
ax = axes[0, 0]
slip_ratios = np.linspace(-0.15, 0.15, 300)
for Fz, style in [(2500, '--'), (3300, '-'), (4200, ':')]:
    F = tire.longitudinal(slip_ratios, Fz)
    ax.plot(slip_ratios * 100, F, style, label=f'Fz = {Fz} N', linewidth=2)
ax.axvline(tire.max_slip_ratio*100, color='gray', alpha=0.4, linestyle=':')
ax.axvline(-tire.max_slip_ratio*100, color='gray', alpha=0.4, linestyle=':')
ax.set_xlabel('Slip ratio (%)')
ax.set_ylabel('Longitudinal force (N)')
ax.set_title('Tire curve moves with load (dyno readout, §6.2)')
ax.legend(fontsize=9)
ax.grid(alpha=0.3)

# --- Panel 2: open vs locked diff force vs lateral g ---
ax = axes[0, 1]
lat_gs = np.linspace(0, 1.1, 40)
open_forces, locked_forces = [], []
for g in lat_gs:
    fo, _, _ = max_tractive_force(tire, mass_kg, static_rear_load_n, cg_height_m,
                                    rear_track_m, g*9.81, "open")
    fl, _, _ = max_tractive_force(tire, mass_kg, static_rear_load_n, cg_height_m,
                                    rear_track_m, g*9.81, "locked")
    open_forces.append(fo); locked_forces.append(fl)
ax.plot(lat_gs, open_forces, label='Open differential', linewidth=2.5, color='#c0392b')
ax.plot(lat_gs, locked_forces, label='Locked differential', linewidth=2.5, color='#27ae60')
ax.fill_between(lat_gs, open_forces, locked_forces, alpha=0.15, color='green')
ax.axvline(0.7, color='gray', linestyle='--', alpha=0.5)
ax.annotate('the corner-exit test\n(panel 4)', xy=(0.7, 6717), xytext=(0.75, 9500),
            fontsize=8, arrowprops=dict(arrowstyle='->', alpha=0.6))
ax.set_xlabel('Lateral load during corner exit (g)')
ax.set_ylabel('Max available tractive force (N)')
ax.set_title('PASS CONDITION #1: the curve moves visibly\n(one differential setting, everything else identical)')
ax.legend(fontsize=9)
ax.grid(alpha=0.3)

# --- Panel 3: instability meter fill level vs speed ---
ax = axes[1, 0]
speeds_kmh = np.arange(20, 121, 2)
speeds_ms = speeds_kmh / 3.6
results = simulate_corner_sweep(tire, mass_kg, wheelbase_m, 60.0,
                                  front_load_n, static_rear_load_n, speeds_ms)
fills = [r['fill_level']*100 for r in results]
ax.plot(speeds_kmh, fills, linewidth=2.5, color='#e67e22')
ax.axhline(100, color='red', linestyle='--', alpha=0.5, label='meter ceiling')
limit_idx = next((i for i,f in enumerate(fills) if f>=99.9), None)
if limit_idx:
    ax.axvline(speeds_kmh[limit_idx], color='gray', linestyle=':', alpha=0.6)
    ax.annotate(f'~{speeds_kmh[limit_idx]:.0f} km/h limit\n(derived, not authored)',
                xy=(speeds_kmh[limit_idx], 95), fontsize=9)
ax.set_xlabel('Speed through a 60m-radius corner (km/h)')
ax.set_ylabel('Instability meter fill level (%)')
ax.set_title('The ragged-edge meter (20 §1) — a real derived limit')
ax.legend(fontsize=9)
ax.grid(alpha=0.3)

# --- Panel 4: corner exit time comparison ---
ax = axes[1, 1]
from rk4_benchmark import rk4_straight_line
force_open, _, _ = max_tractive_force(tire, mass_kg, static_rear_load_n, cg_height_m,
                                        rear_track_m, 0.7*9.81, "open")
force_locked, _, _ = max_tractive_force(tire, mass_kg, static_rear_load_n, cg_height_m,
                                          rear_track_m, 0.7*9.81, "locked")
t_open, _, _ = rk4_straight_line(mass_kg, 0.32, 2.0, 1.225, 0.015, force_open, 25.0)
t_locked, _, _ = rk4_straight_line(mass_kg, 0.32, 2.0, 1.225, 0.015, force_locked, 25.0)
bars = ax.bar(['Open\ndifferential', 'Locked\ndifferential'], [t_open, t_locked],
               color=['#c0392b', '#27ae60'], width=0.5)
for bar, t in zip(bars, [t_open, t_locked]):
    ax.text(bar.get_x()+bar.get_width()/2, t+0.1, f'{t:.2f}s', ha='center', fontweight='bold')
ax.set_ylabel('Time to reach 25 m/s from corner-exit point (s)')
ax.set_title(f'PASS CONDITION #2: the lap time moves measurably\n'
             f'{t_open-t_locked:.2f}s difference ({100*(t_open-t_locked)/t_open:.0f}% faster), same car, same driver')
ax.grid(alpha=0.3, axis='y')

plt.tight_layout()
plt.savefig('/home/claude/sim/simulation_results.png', dpi=140, bbox_inches='tight')
print("Chart saved.")
print(f"\nSummary numbers for the writeup:")
print(f"  Corner-exit force delta at 0.7g: {force_locked-force_open:.0f} N ({100*(force_locked-force_open)/force_open:.0f}%)")
print(f"  Corner-exit time delta: {t_open-t_locked:.2f}s ({100*(t_open-t_locked)/t_open:.0f}%)")
print(f"  Instability meter derived limit for this car/corner: ~{speeds_kmh[limit_idx]:.0f} km/h")
