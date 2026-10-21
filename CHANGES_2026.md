# Requirements library — changes and additions in 2026

This file summarizes what changed in the Modelica **Requirements** library
(package folder [`Requirements/`](Requirements/)) during 2026. The library went from
**0.7.0** (Feb. 2025) to **0.13.1** (2026-10-21) in eleven releases.

The full release notes are in the library itself, under
`Requirements.UsersGuide.ReleaseNotes`. The same summary is in the library documentation,
under `Requirements.UsersGuide.ReleaseNotes.Summary2026`. The regression baselines and the
tool-by-tool measurements are kept beside the library (see `Requirements.UsersGuide`).

| Version | Date | Theme |
|---|---|---|
| 0.7.1 | 2026-09-14 | Rename, MSL 4.1.0, runs in Modelon Impact, three-tool comparison, MA-HS-CSV reader |
| 0.8.0 | 2026-09-15 | Four-valued logic (`Undefined` added to `Property`) |
| 0.9.0 | 2026-09-15 | `margin` output on every check block |
| 0.9.1 | 2026-09-15 | Bug fix: CSV reader derivative at the file's last row |
| 0.10.0 | 2026-09-16 | Step-response metrics (overshoot, rise time, settling time, …) |
| 0.11.0 | 2026-09-16 | Eigenvalue checks over a linearization (`LinearAnalysis`) |
| 0.11.1 | 2026-10-16 | Steady-state check example; the verdict printed once in every tool; self-contained documentation |
| 0.12.0 | 2026-10-19 | Violation statistics: how often, how long and how badly a requirement was violated |
| 0.12.1 | 2026-10-19 | Bug fix: `DelayedRising` stayed true after its input fell, when the fall coincided with the end of the duration |
| 0.13.0 | 2026-10-20 | Three check blocks ported from the Modelica Buildings_Requirements library: `WithinBand`, `GreaterEqual`, `StableSignal` |
| 0.13.1 | 2026-10-21 | Bug fix: the CSV reader froze every Boolean and Integer column for the rest of a run after two event rows a few ulps apart in time |

No release needs a model conversion. Each one declares `conversion(noneFromVersion=...)`
for the version before it. One exception: from 0.8.0 on, code that reads a stored
`Property` result has to accept the value 4.

---

## Origin and rename (2026-09-14)

- The library was renamed from `Modelica_Requirements` to **`Requirements`**. It is Model
  Based Innovation LLC's derivative of upstream
  [Modelica_Requirements](https://github.com/modelica-3rdparty/Modelica_Requirements) 0.7.1
  (BSD 3-Clause) and now lives in the public repository
  [MBILLC/Requirements](https://github.com/MBILLC/Requirements).
- The license and the original authors' copyright notices are unchanged.
- The additions serve a **two-run verification** workflow. First the plant is simulated
  on its own and its signals are stored in an MA-HS-CSV file. Then the requirement
  checks run on the stored signals in a second run.

## 0.7.1 — Maintenance and multi-tool support

The release made the library run in Modelon Impact. None of its changes alter
requirement semantics.

- **`uses(Modelica(version="4.1.0"))`**. The library needed no change for MSL 4.1.0.
- **`PrintViolations`** has two new Advanced parameters, `useEvaluationTime` and
  `evaluationTime`. Impact evaluates `terminal()` to `false`, so it never printed the
  verdict. Every example now sets `evaluationTime = StopTime`.
- **`FallingEdgeTerminate`** has a new `delay` parameter (default 0). At a `terminate()`
  instant Impact stores only the pre-event state, so without a delay the final verdict
  was missing from the result.
- **`ChecksInFixedWindow_withFFT` now runs in Impact.** Four separate fixes were needed:
  - The local arrays in `Internal.checkDomain` now have explicit sizes.
  - The FFT sampling start is now explicit: `(condition and not pre(condition)) or (initial() and condition)`.
  - The FFT examples use the new terminate delay.
  - The when-clause chains of `WithinRelativeDomain` and `MaxTotalHarmonicDistortion` were
    replaced by single function calls, `Internal.checkRelativeDomain` and `Internal.checkTHD`.
- **`LogicalFunctions.card*`** reductions are now written over indices, because Impact
  failed to scalarize the element form.
- **No more model instances passed to functions.** `Examples.MotorsWithLosses` and
  `SimplePumpingSystem.CheckPumpingSystem` now build their observation records with
  explicit record constructors.
  - The reason: the record cast `R(m)` allowed by MLS 3.6 §12.6.1 is implemented only by Dymola.
  - `MotorData` and `InertiaData` were made public.
  - `SourceObservation_from_PartialSource` and `Records.PartialSource` were removed.
- **New: `Sources.PartialSignalsFromFile`** reads MA-HS-CSV files: Real, Boolean and
  Integer columns by name, with a time event at every change of a discrete column.
  - It is built on `Internal.CSV` and a header-only C89 reader, `Requirements/Resources/Include/RequirementsCsv.h`.
  - The reader is tested against a Python reader in `Requirements/Resources/C-Sources/test/`.
  - Example: `Examples.Elementary.Sources.SignalsFromFile`.
- **Three tools compared** (68 examples, every `*.y` output):

  | Tool | Simulated | Not simulated |
  |---|---|---|
  | Dymola 2026x | 60 | 8 refused by the license |
  | OpenModelica 1.27.1 | 48 | 20 don't build (14 sliding-window, 6 FFT) |
  | Modelon Impact (Sept. 2026) | 68 | — |

  - Impact vs. Dymola/OpenModelica: all 296 signal checks pass.
  - OpenModelica vs. Dymola: continuous signals agree to better than 1e-4 of their
    range, and discrete signals switch at identical instants.

## 0.8.0 — Four-valued logic

This release changes requirement semantics.

- **`Types.Property = enumeration(Violated, Undecided, Satisfied, Undefined)`**.
  - `Undefined` (value 4) means *not applicable*. `Undecided` now means *applicable but
    not yet decided*.
  - The new value is appended at the end, so the stored values 1–3 stay valid.
  - `Types.Boolean4` is an alias, using CRML's name.
- **`LogicalFunctions`**: new `and4`, `or4`, `not4` (truth tables taken from CRML/ETL),
  `and4All`, `or4All` and `cardUndefined`.
  - `Undefined` is the neutral element of *and* and *or*.
  - `forall3` delegates to `and4All`.
  - `during` and `during3` return `Undefined` while their condition is false.
- **`LogicalBlocks`**: `PropertyAnd`, `PropertyOr` and `PropertyNot` delegate to the new functions.
  - An unconnected `PropertyAnd`/`PropertyOr` now gives `Undefined`.
  - `PropertyToBoolean` has a new `undefined` parameter.
  - `PropertyConstant` and `PropertyTable` accept the fourth value.
- **Every `ChecksInFixedWindow` block outputs `Undefined` while its condition is false.**
  The FFT checks output `Undefined` before their first rising edge and `Undecided` until
  the first FFT is computed.
- **`Verify.Requirement` and `PrintViolations`** still reduce everything to three
  verdicts.
  - They report the new count **`attempts`**: the number of phases in which the property
    was applicable.
  - The log file and the HTML report gain an attempts column.
- **New example `Examples.Elementary.LogicalBlocks.PropertyTable4`** tests all 16 pairs of
  each truth table, plus the laws that hold and the laws that fail.
  - Absorption and distributivity fail wherever `Undefined` is involved.
  - Never simplify `Property` expressions with Boolean rewriting.
- The regression baselines were re-stored on OpenModelica, Dymola and Impact. The only
  differences were Undecided → Undefined.

## 0.9.0 — Margins

- Every check block has a new output **`margin` = robustness / `scale`**.
  - Robustness is the signed distance to the limit; it is ≥ 0 exactly when the check holds.
  - `scale` is the requirement's tolerance (default 1).
  - The connector type is the new **`Interfaces.MarginOutput`** (`unit="1"`).
- `PartialCheck` and the sliding-window partials have two new parameters, `scale` and
  `computeMargin`.
- How each block family gets its robustness:
  - **`During` and `When*`**: from a new input `rho`.
  - **Duration blocks**: from the new output `duration`.
  - **Count blocks**: from the count difference. `countRising` is now an output.
  - **`MaxRisingFrequency`, `WithinDomain`, sliding-window and FFT blocks**: from the
    quantity each block already computes.
- **`LogicalFunctions.marginAnd` and `marginOr`** give the minimum and maximum margin over
  the elements that are not `Undefined`.
- The blocks have no accumulators. The worst margin over a run is taken from the stored
  trajectory.
- **New examples `Examples.Elementary.Margin`**: eight of them, one per block family.
  Each checks the margins against closed-form values and checks the sign invariant.
- No existing output changed. Regression results: OpenModelica 316/316, Dymola 336/336,
  Impact 371/371.

## 0.9.1 — CSV reader fix

- `Internal.CSV.getRealDer` returned 0 at the file's last row. Derived signals therefore
  dropped to 0 at the final stored row, which produced a spurious edge.
- At the last row it now returns the slope of the final segment. Beyond the end of the
  file it still returns 0.
- No stored reference changed.

## 0.10.0 — Step-response metrics

- New block **`SignalAnalysis.StepResponse`** computes the running step-response metrics:
  overshoot, undershoot, rise time, delay time, settling time, steady-state error,
  damping ratio and decay ratio.
  - It detects steps, windows them, and interpolates level crossings between samples.
  - It samples at half-periods. When the sample period equals the result grid,
    OpenModelica's CVODE stalls.
- New block **`ChecksInFixedWindow.StepResponseCheck`** bounds one metric and outputs
  `Property` and `margin`.
- New enumerations `Types.StepTarget` and `Types.StepMetric`.
- New examples `Examples.Elementary.StepResponse` (`SecondOrder`, `Disturbance`), checked
  against closed forms.
- The blocks decide a step-response requirement in the simulation itself. Where the same
  metrics are also evaluated on the stored trajectory after the run, the blocks agree with
  that evaluation to one sampling period.
- **Solver choice:** the millisecond sample events make CVode read the peak about 0.2–0.3 %
  low. The regression lists therefore use dassl on OpenModelica and Radau5ODE on Impact.

## 0.11.0 — Eigenvalue checks over a linearization

- **New package `LinearAnalysis`:**
  - `readStateMatrix` reads the A matrix of a linearization from a MATLAB v4 file. The
    linearization itself is done in whatever tool the user has; the package documentation
    describes the routes.
  - `modes` groups the eigenvalues into modes (conjugate pairs folded, an integrator rule,
    a parasitic cut).
  - **`EigenvalueCheck`** bounds real part, damping, frequency or time constant over every
    mode, with an optional frequency band.
  - **`EigenvaluesWithinRegion`** checks that every eigenvalue lies inside a polygon in the
    (Re, Im) plane.
  - Both blocks output `Property` and `margin`.
- New enumeration `Types.EigenMetric`.
- New example `Examples.Elementary.LinearAnalysis.SecondOrder`, with the data file
  `Requirements/Resources/Data/SecondOrderLinearization.mat`.
- The verdict is printed by `PrintViolations` like that of any other requirement.
- By decision, the frequency-response requirements have no Modelica side.

## 0.11.1 — Steady-state check example, printing fix, documentation

- New example **`Examples.SteadyState.CheckHeatExchanger`**: steady-state requirements of the
  MSL heat exchanger, checked and printed in a plain simulation.
  - Each requirement is written as `during(steady, check)`, so the transient does not count.
  - A separate requirement checks that the run has settled.
- **Bug fix:** `PrintViolations` printed every verdict twice in a tool that evaluates the
  verdict's when-equations twice at the same event (Modelon Impact with
  `useEvaluationTime`). The log file and the summary are now written once. The full Impact
  regression suite passed 488/488 checks afterwards.
- The documentation no longer depends on any external tooling or on one Modelica tool.
  - The relation to the verification framework the library is used in is explained once,
    in the User's Guide.
  - `LinearAnalysis` describes how to linearize and export the state matrix in different
    tools.
- The repository [MBILLC/Requirements](https://github.com/MBILLC/Requirements) is public;
  the User's Guide and the Contact page link to it.

## 0.13.1 — CSV reader: event rows a few ulps apart

- **The MA-HS-CSV reader** (`Sources.PartialSignalsFromFile`) treats rows within a relative 1e-10 in time as one event
  group at the first row's time (the tolerance of `Modelica.Blocks.Tables`). A simulator's result can hold two event
  rows a few ulps apart (3.1e-10 s at 28248 s in a year of the TIER plant). As two time events, OCT dropped the second
  as already past, the reader's when-clause never fired again, and every Boolean and Integer column held its value for
  the rest of the run, without an error or a warning.
- The C reader's test checks the new rule against its Python twin, which now lives in Chaperone (`$CHAPERONE_DIR`).

## 0.13.0 — Check blocks from Buildings_Requirements

- Three blocks of LBNL's [Buildings_Requirements](https://github.com/lbl-srg/modelica-buildings-requirements) library are
  ported into `ChecksInFixedWindow`, as check blocks with `Property` and `margin`:
  - `WithinBand`: a Real input within constant limits.
  - `GreaterEqual`: one Real input at least another (a temperature against its set point).
  - `StableSignal`: the moving average of |du/dt| over a window at most a limit; no state events from
    changes of direction.
- Each has a `condition` input and a `delayTime` after each rising edge before the check applies.
- Changes from the originals: check blocks instead of complete requirements; Undefined (not Undecided) while a
  check does not apply; StableSignal's hysteresis a parameter, default 0, so the margin's sign is the verdict; no
  dependency on the Buildings library.
- `MinimumDuration` is not ported: it is `MinDuration(condition = u, check = true)`.
- The originals' validation models are examples now. Run beside the originals in Modelon Impact, all 14
  requirements give the same verdict at 3999 instants each, apart from Undecided → Undefined while inactive.
  `Examples.Elementary.Margin.Gated` and `.StableSignal` assert the margins in closed form. The five examples are
  Impact regression cases.
- The ported code is under the Modelica Buildings library's license (`UsersGuide.BuildingsLicense`, LICENSE).

## 0.12.1 — DelayedRising at coincident events

- **`LogicalBlocks.DelayedRising`** is now `y = u and time >= startTime + duration`. It assigned its output in a
  `when`/`elsewhen` chain; when the input fell at the instant the duration ran out, both branches' conditions became
  true in one event iteration, only the first ran, and the output stayed true until the next rising edge (Modelon
  Impact; the order of the two events decided it). Now it is never true while the input is false.
- `Examples.BackupPowerSupply.MainPowerSupplyRequirements`: R8 is untested on Impact, as documented (it was violated at
  55 s). Its two Impact references were re-stored; the full Impact suite went from 561/563 to 563/563.
- Found by ModCheck's requirements corpus (`TC-SYS-MainPowerSupply`, REQ-8).

## 0.12.0 — Violation statistics

- New block **`Verify.ViolationStatistics`**. From a check's `property` and `margin` it gives:
  - how often the requirement was violated (`nViolations`);
  - for how long in total (`totalDuration`, `violatedFraction`);
  - the longest violation (`longestDuration`, `tLongestStart`);
  - the worst violation and when (`worstMargin`, `tWorst`), also per episode.
- It is meant for long runs such as annual building simulations, where a verdict alone does not say
  enough.
- A violation is a phase with `property = Violated`, so the statistics agree with the verdict.
  `mergeGap` and `minDuration` stop a signal that hovers at its limit from counting as hundreds of
  violations.
- The worst margin is found in one of two ways:
  - The default extends the MSL's `Modelica.Blocks.Math.ContinuousSignalExtrema`, which fires an
    event at every local extremum.
  - A ratchet fires only at a new low, and is cheaper for an oscillating margin: on a year with a
    10-minute ripple it took 31 s against 97 s.
- `Verify.Requirement` and `BooleanRequirement` compute the same statistics when
  `computeStatistics` is set. The statistics are written as a second `Statistics` line in the log
  file and printed by `PrintViolations`.
- The check blocks still have no accumulators. No existing output, log line or regression
  reference changed.
- New examples: `Examples.Elementary.ViolationStatistics`.

---

## Regression baselines

- Case lists generated from the examples' `experiment()` annotations:
  - Dymola 2026x: `regression_cases_requirements.yaml`
  - OpenModelica 1.27.1: `regression_cases_requirements_openmodelica.yaml`
  - Modelon Impact: `Impact/regression_cases_requirements_impact.yaml`
- The Impact list compares against a composite reference: Dymola's results, with
  OpenModelica's filling the gaps. Since 2026-09-15, the 5 cases that neither of those
  tools can run use Impact's own results as reference.
  - The full Impact suite then passed **434/434** with nothing skipped.
- Every new example from 0.8.0–0.11.1 was added as a case. The margin and step-metric
  outputs are stored as references.
