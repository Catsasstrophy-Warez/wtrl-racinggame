# Platform Notes: iOS, Windows, Linux

## The hard constraint

Four things exist only on macOS, with no legal workaround:

1. **Xcode and the iOS SDK** — no Windows or Linux port
2. **Code signing** (`codesign`, provisioning profiles) and App Store Connect upload
3. **The iOS Simulator**
4. **Instruments and the Metal GPU frame debugger**

Apple's macOS licence also forbids running macOS on non-Apple hardware. That's
why cloud-Mac providers must allocate physical Apple machines rather than spin
up VMs on demand.

**Moving floor:** App Store uploads must use Xcode 26+ with an iOS 26 SDK as of
28 Apr 2026. Xcode chases macOS (26.6 needs macOS Tahoe 26.2). An old Mac is not
a permanent solution.

## Device fragmentation exists within iOS alone, not just Android

Added after research into ProMotion specifically (`36` Part 2). The
Android-fragmentation discussion below has an iOS-side counterpart that is
easy to miss: **120Hz display refresh (ProMotion) is Pro-tier only, from
the iPhone 13 Pro onward** — non-Pro iPhones cap at 60Hz. One frame at
120Hz is 8ms; at 60Hz it's 16ms, confirmed directly from Apple's own
developer material.

**This matters specifically for `31` Part 7's pass condition** — a
differential-setting change may be perceptible at 8ms of latency and not
at 16ms, same physics, different device tier. Run the prototype test on
both a Pro-tier and a base-tier device before trusting a single result.

## Android — decided: yes, eventually

**iOS ships first. Android is a planned second platform, not a day-one
parallel launch.** This is a real decision with consequences, not a deferral.

**What stays the same regardless of when Android ships:**
- Every architecture decision in this package (Unity, TORSION, RVP, the
  physics model) is engine-level, not iOS-specific — nothing here needs
  unwinding to support Android later
- The Android sidecar device recommended throughout this package (`02`, for
  IL2CPP/AOT testing during iOS development) was never *just* a debugging
  proxy — it is now explicitly **the first unit of the platform you will
  actually ship on**, which raises the bar on what "good enough for testing"
  means. Treat its thermal and performance behaviour as product data worth
  keeping, not disposable debug output.

**What changes once Android moves from "eventually" to "now":**

- **Device fragmentation is categorically wider than iOS.** iOS gives you a
  small, well-characterised set of GPU/thermal profiles across a handful of
  chip generations. Android does not — the low end and high end of Android
  hardware are further apart than the entire iOS device range this package's
  thermal guidance was written against (`03` above, `31` Part 7's warm-device
  pass condition).
- **A single quality tier likely will not hold across that range.** Where the
  iOS-first build can target one performance envelope, the Android port
  should expect to need at least a **low/high quality preset split** —
  texture resolution, shadow quality, particle density, possibly LOD bias —
  rather than one configuration for every device.
- **Play Store submission is a separate process from App Store**, with its
  own asset and metadata requirements — not covered in this package and worth
  its own pass when the port is actually scheduled, not before.
- **The thermal and frame-pacing warnings in this document were written and
  measured against iOS hardware specifically.** They almost certainly transfer
  in *kind* to Android (throttling is throttling), but the *specific* numbers
  — when it kicks in, how it degrades physics accuracy (`34` Part 1c, Finding
  2) — need their own measurement pass on real Android hardware before the
  port ships, not an assumption that iOS numbers carry over.

**The practical upshot for right now:** nothing in the current build plan
changes. The decision matters starting at the point where Android moves from
"the sidecar device" to "the next thing being shipped" — at which point this
section is the checklist for what needs re-verifying, not re-deciding.

## Platform summary

| | Windows | Mac | Linux |
|---|---|---|---|
| Unity editor | Best supported | Fully supported | Least-supported tier |
| iOS Build Support module | Yes (generates Xcode project) | Yes | Unreliable/absent — verify in Hub |
| Compile + sign `.ipa` | No | Yes | No |
| iOS Simulator | No | Yes | No |
| Metal profiling | No | Yes (needs tethered device) | No |
| GPU tooling | Nvidia/RTX, RenderDoc | Metal debugger | Limited |
| Asset Store / middleware compat | Widest | Good | Weakest |

Unity on Windows *generates* the Xcode project; Xcode on a Mac compiles it into
the final application. Linux loses the same capabilities as Windows without
gaining Windows' compensating advantages.

---

## IL2CPP: the surprise class

iOS forbids JIT, so Unity builds iOS through IL2CPP — C# transpiled to C++, then
compiled ahead of time. The Windows editor runs Mono with JIT. Differences only
surface in a build.

- **Generic virtual methods.** AOT can't generate code for instantiations it
  can't see. Runtime crash: "no ahead-of-time code was generated for this
  method." Common in generic repository and event-bus patterns — which
  progression systems accumulate.
- **Managed code stripping.** The linker removes types nothing appears to
  reference. Anything reflection-based (most JSON serializers, Odin) breaks.
  Fix with `link.xml` entries and `[Preserve]`, discovered one crash at a time.
- **Build times.** 20–60 minutes per build on a project of this size. Brutal when
  chasing a crash that only reproduces in an IL2CPP build over a network.

**Mitigation that actually works:** build Android with IL2CPP, ARM64, and the
same stripping level you'll ship on iOS. Catches most of this class on a device
you can physically reach. Won't catch everything (iOS defaults differ) but
converts most Xcode-stage mysteries into Android-stage bugs.

---

## The profiling blind spot

**A cloud Mac has no iPhone plugged into it.** It solves compilation, signing,
and submission. It does not solve:

- **Metal GPU frame capture** — per-draw-call timing, shader cost, bandwidth per
  render pass. Apple GPUs are tile-based deferred renderers with on-chip tile
  memory and hardware hidden-surface removal. A pass that's cheap on Adreno can
  be expensive on Apple silicon and vice versa. Overdraw from particles, tire
  smoke, and transparent UI over a 3D scene is exactly where this bites.
- **Instruments** — Time Profiler, Allocations, Energy Log, Metal System Trace,
  thermal state.

**Partial workaround:** once a development build is on the device, Unity's own
profiler connects over the network from the Windows editor. Gives CPU-side
timings and rough GPU frame time. Set this up. It will not give Metal-level
shader or bandwidth detail — the data you need when GPU-bound rather than CPU-bound.

---

## Thermals and frame pacing — the racing-game killers

Cannot be faked, cannot be measured remotely.

- **Thermal throttling.** A full-physics racer holding 60fps heats a phone.
  Somewhere around 8–15 minutes in, iOS throttles CPU and GPU and frame rate
  collapses. Race sessions plus menu time land squarely in that window. Your
  first three minutes look great; minute twelve doesn't. You can read
  `ProcessInfo.thermalState` and degrade quality in response, but designing and
  validating that ramp requires holding a warm phone.
- **Thermal throttling also degrades physics accuracy, not just frame rate.**
  When Δt grows, **numerical integration error grows with it** (`34` Part 1b,
  Beckman Part 28). Euler integration on an undamped oscillator diverges 60% over
  100 seconds and grows without bound; RK4 stays stable. **The handling model
  itself gets worse at minute twelve than at minute one**, independently of how it
  looks. Mitigate with a fixed physics timestep decoupled from rendering, and
  **configurable substeps tied to thermal state.**
- **Fixed timestep under load.** Full physics means fixed timestep. When a
  throttled device can't complete physics steps inside the frame budget, Unity
  clamps at `Time.maximumDeltaTime` and the simulation slows or spirals catching
  up. Never happens on desktop. Routine on a hot iPhone. Feels like the car went
  unresponsive.
- **Frame pacing.** Steering makes players far more sensitive to frame-time
  jitter than passive gameplay. Jittery 60 feels worse than locked 30. Add
  ProMotion (120Hz on Pro, 60Hz otherwise) and you're tuning
  `Application.targetFrameRate` and display-link behaviour per device class.

---

## Platform plumbing (Xcode-stage failures, invisible from Windows)

- Game Center leaderboards and achievements
- StoreKit for IAP
- iCloud save sync
- CocoaPods and Xcode post-processing — ad/analytics/IAP plugins generate
  Podfiles and mutate the Xcode project; conflicts surface on the Mac
- Privacy manifests for third-party SDKs (required at submission)
- App thinning, asset catalogs, cellular download limits — a car- and
  track-heavy racer hits these
- TestFlight

---

## Recommended split

Windows for authoring. Android device for early IL2CPP and touch validation.
Mac + one real iPhone for profiling and thermal work.

The cloud-Mac-only path ships a game you have never properly measured on the
hardware it's for. For a physics racer, frame pacing and thermal behaviour are
not end-stage polish — they're the difference between a game that feels good and
one that doesn't, and they only reveal themselves after ten minutes on a warm device.
