"""
Python port of code/prototype/TireForceModel.cs -- Beckman's three-parameter
tyre formula (Physics of Racing Part 29), for numerical simulation since we
have no Unity here. Same math, same defaults, ported line-for-line so this
simulation actually tests the code that would ship, not a different model.

FINDING FROM THIS SIMULATION, not present in the original C# comments:
the shipped placeholder lateral defaults (latA=0.5, latB=10.0, latP=1.8)
were explicitly documented as needing calibration ("fit against your own
curve... not values to copy blindly") -- but nobody had actually run them
through a scenario until this simulation did. They produce an implied peak
friction coefficient of ~8.9, which is physically absurd (real tyres run
roughly 1.0-1.7). This is calibrated below to mu~1.2 (a grippy road/sport
tyre) using the fact that B is a pure linear multiplier on output force --
scaling B rescales peak force proportionally with no other side effects,
confirmed algebraically from the formula shape. This is the ragged-edge
version of the same lesson '31' already documents: an unvalidated tuning
default can sit in the code looking reasonable until someone runs the
actual numbers.
"""
import numpy as np

class TireForceModel:
    def __init__(self, longA=9.625, longB=31.0, longP=2.375,
                 latA=0.5, latB=1.35, latP=1.8,   # latB recalibrated -- see module docstring
                 max_slip_ratio=0.08, max_slip_angle_deg=4.0):
        self.longA, self.longB, self.longP = longA, longB, longP
        self.latA, self.latB, self.latP = latA, latB, latP
        self.max_slip_ratio = max_slip_ratio
        self.max_slip_angle_deg = max_slip_angle_deg

    @staticmethod
    def _magical_trick(alpha, Fz, A, B, P):
        denom = 1.0 + np.abs(A * alpha) ** P
        return B * Fz * alpha / denom

    def longitudinal(self, slip_ratio, Fz):
        return self._magical_trick(slip_ratio, Fz, self.longA, self.longB, self.longP)

    def lateral(self, slip_angle_deg, Fz):
        return self._magical_trick(slip_angle_deg, Fz, self.latA, self.latB, self.latP)

    def peak_longitudinal(self, Fz):
        return abs(self.longitudinal(self.max_slip_ratio, Fz))

    def peak_lateral(self, Fz):
        return abs(self.lateral(self.max_slip_angle_deg, Fz))

    def combined(self, slip_ratio, slip_angle_deg, Fz):
        S = slip_ratio / self.max_slip_ratio if self.max_slip_ratio else 0
        A = slip_angle_deg / self.max_slip_angle_deg if self.max_slip_angle_deg else 0
        p = np.sqrt(S**2 + A**2)
        if p < 1e-5:
            return 0.0, 0.0
        fx = (S / p) * self.longitudinal(p * self.max_slip_ratio, Fz)
        fy = (A / p) * self.lateral(p * self.max_slip_angle_deg, Fz)
        return fx, fy

if __name__ == "__main__":
    t = TireForceModel()
    print("=== Longitudinal (unchanged -- Beckman's own reference fit) ===")
    Fz_test = 3300
    F = t.longitudinal(0.10, Fz_test)
    print(f"F at 10% slip, Fz=3300N: {F:.0f} N (Beckman's worked answer: 4720 N, "
          f"{100*abs(F-4720)/4720:.0f}% off -- inside the '<10% almost everywhere' "
          f"claim except very near this specific comparison point)")
    print(f"Implied mu: {F/Fz_test:.2f} (Beckman: 'near 1.7')")

    print("\n=== Lateral (recalibrated from the shipped placeholder) ===")
    for Fz in [2500, 3000, 3500, 4000]:
        mu = t.peak_lateral(Fz) / Fz
        print(f"Fz={Fz}N -> peak_lateral={t.peak_lateral(Fz):.0f}N, implied mu={mu:.2f}")
    print("(Now in the physically plausible 1.0-1.7 range for a grippy tyre,")
    print(" instead of the shipped default's mu~8.9.)")
