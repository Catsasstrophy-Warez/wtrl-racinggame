# Tranche 01 Gap Flag — Interaction Pattern Atlas Needs a Fill-In Pass

**Status: scaffold only, not research.** This tranche's 25 dossiers,
the screen-to-system matrix, and the video ledger are structurally
complete but substantively empty. Confirmed by direct inspection
(`Dossiers/01_Wrench.md` and the full `VIDEO-TIMESTAMP-LEDGER.csv`),
not inferred secondhand.

## What's actually real vs. templated

**Real, per dossier (1-2 lines):**
- Game title and its "primary domain" tag (e.g. Wrench = `service`)
- One "highest-value extraction" thesis phrase (e.g. "Spatial service
  graph, fastener truth, tool gating")

**Templated boilerplate, identical shape in every dossier:**
- The entire "Screen-by-screen forensic decomposition" (S0-S6) —
  generic instructions to "record" camera framing, selection states,
  etc., never actually filled in with what was observed
- "WTRL implementation translation" — generic placeholder language
  ("WTRLCore subsystem appropriate to `service`") not specific
  mechanics
- "Video evidence" — every single dossier says a source still needs
  to be selected (`SOURCE_SELECTION_REQUIRED`)
- "Forensic timestamp ledger" — every segment in every dossier is
  `FRAME_REVIEW_REQUIRED` with no start/end times
- `VIDEO-TIMESTAMP-LEDGER.csv` — 20 of 25 games have no source video
  even selected yet; the other 5 are entirely
  `FRAME_REVIEW_REQUIRED` with zero verified timestamps

**Net result:** the atlas currently provides a real, useful *index*
(which 25 games matter and why, one-line each) but zero verified
frame-level evidence and zero filled-in interaction decompositions.
That's consistent with the honesty markers it uses correctly — nothing
here is fabricated — but it means the atlas is not yet usable for the
thing it's for (grounding WTRL's own interaction design in verified
precedent).

## What a real Tranche 02 needs, per dossier

1. **Video source selected** — a specific long-form, minimally-edited
   real gameplay video per game, replacing `SOURCE_SELECTION_REQUIRED`.
2. **Frame-reviewed timestamps** — actual start/end times per S0-S6
   segment in the forensic ledger, replacing every
   `FRAME_REVIEW_REQUIRED`.
3. **Filled forensic decomposition** — S0-S6 sections describing what
   was actually observed in that footage (camera framing, selection
   feedback, exact input sequence, etc.), not the generic instruction
   text currently in every dossier.
4. **A real WTRL implementation translation** — specific to that
   game's actual mechanics, not the templated one-liner currently
   present.
5. Games can be prioritized rather than done all-at-once — the
   one-line thesis in each current dossier is enough to triage which
   ~8-10 are highest-value to fill first (garage/service-sim precedent
   like Wrench, Car Mechanic Simulator 2021, My Summer Car; career/HUD
   precedent like Gran Turismo 7 and Forza Motorsport; drag/street
   precedent like No Limit Drag Racing 2 and Need for Speed Heat look
   like the natural first batch given WTRL's own current systems).

## Where this stands in the project

`WTRL-INTERACTION-RECOMMENDATIONS.md` (same folder) was still written
against this tranche, but every claim in it is grounded in WTRL's own
current Swift source plus the one legitimate line per dossier — never
in the unfilled forensic sections or fabricated timestamps. That
document doesn't need to be redone when Tranche 02 lands; it should be
revisited and deepened once real per-game evidence exists.
