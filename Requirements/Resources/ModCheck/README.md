# ModCheck baselines for Requirements

> The library was `Modelica_Requirements` until 2026-09-14, when it was renamed `Requirements` and moved to the private repo `MBILLC/Requirements`; the case names below keep their `MR_` prefix, only the `model:` paths changed.

Regression baselines for the library's `Examples`, established with
[ModCheck](https://github.com/MBILLC/ModCheck) on 2026-09-13 by two Modelica
tools. Both case lists were generated from the models' own `experiment()`
annotations (`generate_cases_from_experiment.py`, `--variables '*.y'`: every
block output, which for this library is the requirement `Property` signals);
the two baselines share `ReferenceResults/` under different case-name prefixes.

| file | tool | cases | stored | not stored |
|---|---|---|---|---|
| `regression_cases_requirements.yaml` | Dymola 2026x, Cvode | 68 | 60 | 8 refused by the Dymola license ("too complex for the current license"), reported SKIPPED |
| `regression_cases_requirements_openmodelica.yaml` | OpenModelica 1.27.1, cvode | 68 | 48 | 20 do not build in omc — disabled with omc's words: the `SlidingWindow.push()` buffer record (14), the FFT checks (6). Two more (`CheckMotorWithLosses`, `CheckPumpingSystem`) were unblocked on 2026-09-14, `DEVMI_DIFFERENCES.md` §5 |
| `Impact/regression_cases_requirements_impact.yaml` | Modelon Impact (Sept. 2026), cvode | 68 | — | runs against the composite reference in `Impact/ReferenceResults/`: Dymola's 60 references plus OpenModelica's for the three cases Dymola's license refuses and omc builds (`LimitedCabinAltitudeRateOfChange`, `CheckMotorWithLosses`, `CheckPumpingSystem`) plus, since 2026-09-15, Impact's own references for the 5 cases neither tool can produce (`reference_from: impact` in the manifest), so no case is SKIPPED any more |
| `Impact/ImpactOnly/regression_cases_requirements_impact_only.yaml` | Modelon Impact (Sept. 2026), cvode | 5 | 5 | the five cases above with no Dymola or OpenModelica reference (`MainPowerSupplyRequirements`, four FFT examples), checked against Impact's own stored result in `Impact/ImpactOnly/ReferenceResults/`: 63/63 at the 100× spread. Kept as the historical record; the composite list now carries the same five with Impact's own references |

Both suites pass at ModCheck's 100× rtol spread. One case is hand-tuned in
each list — `SimplePumpingSystem.Components.PumpingSystem`, an on-off pressure
controller over 2000 s whose switching instants move with tolerance; its relay
signals are checked by accumulated |difference| at a measured tolerance.

## Modelon Impact

**Impact as its own reference, 2026-09-15 (evening).** The five cases the composite suite reported
"not run here" -- `MainPowerSupplyRequirements` and the four FFT examples above Dymola's license cap,
which OpenModelica does not build -- now have Impact's own references in `Impact/ReferenceResults/`
(`--store --case` on the composite list, `reference_from: impact` in the manifest): the composite
report has no SKIPPED card any more, every case of the list has a reference, and the full suite
afterwards passes **434/434** at the 100× spread with 0 skipped. Impact is a sound baseline
for these: its results matched the Dymola references exactly on every case both could run (below).

The fork's library (upstream's sliding-window refactor, `uses Modelica 4.1.0`)
imports into an Impact workspace as a project and its sliding-window examples
run there with results matching the Dymola baseline — see
`DEVMI_DIFFERENCES.md` §2 for the measurement. Impact evaluates `terminal()`
to `false`, so a requirement model there needs
`printViolations(useEvaluationTime=true)` to print its verdict; every example
carries `evaluationTime = StopTime` for that purpose. The FFT checks needed
four separate fixes to run there (`DEVMI_DIFFERENCES.md` §3a) and now do; the
examples that stop through `FallingEdgeTerminate` need `terminate1.delay > 0`
for Impact to record their final verdict, which the Impact case list sets as a
modifier on the two examples concerned.

**Re-baseline for version 0.8.0, 2026-09-15** (the four-valued `Property`): the three
suites were compared against the 0.7.1 baselines first — omc 263/271, Dymola 278/284, Impact
composite 314/322, Impact-only 59/63 — and every failed check was a Property output moving
from Undecided (2) to Undefined (4) where a check block's condition is false or its first
phase has not started (`During`, `MinDuration`, `BandDuration`, `FixedRising`,
`MaxRisingFrequency`, the `during` blocks of `Verify.Requirement`, `SignalsFromFile` and
`MainPowerSupplyRequirements`); nothing else changed, the FFT examples included. All four
baselines were then re-stored (omc, Dymola, the composite refreshed from both, Impact-only),
with the new `Examples.Elementary.LogicalBlocks.PropertyTable4` as a case in the three lists
(omc, Dymola and the composite carry its reference). The numbers below are the 0.7.1
measurement and stand as history.

**Version 0.10.0, 2026-09-16** (the step-response blocks, ModCheck plan phase 15b): the two examples of
`Examples.Elementary.StepResponse` are cases in the three lists with `variables: [time, "*.y", "*.margin", "*.value"]`,
so the blocks' running metrics are references too. Stored on OpenModelica (both) and Dymola (`Disturbance`;
`SecondOrder`'s ten check blocks make 759 unknowns and the license refuses it, as it refuses the other eight), the
composite carrying Dymola's `Disturbance` and OpenModelica's `SecondOrder` (81 entries). Measured on the way: the
sampled blocks restart OpenModelica's cvode at every millisecond sample and its accumulated error reads the
second-order example's peak 0.2 % low (16.27 % for 16.30) and moves with the tolerance, where dassl and ida reproduce
the closed form at 1e-6 and 1e-8 alike -- the OpenModelica list runs the two cases with `solver: dassl`, a per-case
override the ModCheck harness gained for it; and a sampled block whose period equals the result grid makes omc's
cvode runtime stall on a sample and an output point 1e-14 s apart, so the blocks sample at the half-periods. On
Modelon Impact OCT's cvode has the same restart error (the peak 0.3 % low at 1e-6, 0.9 % at the comparison run's
1e-4) and no other solver can be chosen through the dynamic custom function, so `SecondOrder` is disabled in the
Impact list with that reason (28/44 checks against the dassl reference); `Disturbance` (a pure function of time)
passes there. Impact's evidence for the blocks is ModCheck's corpus cross-check, where the block reads the plant's
stored file with no solver between them: 100/100 agreements with `step_checks.py`. No existing reference changed
(no existing block changed).

**Version 0.9.0, 2026-09-15** (the margin outputs, ModCheck plan phase 12): the eight examples of
`Examples.Elementary.Margin` are cases in the three lists with `variables: [time, "*.y", "*.margin"]`, so the
margins are references too. Stored on OpenModelica (7: the FFT example does not build there, as the other FFT
examples) and Dymola (all 8, the FFT one included), the Dymola references copied into the composite (79 entries).
No existing reference changed: every block's `y` is as in 0.8.0, the new `margin`, `duration` and `countRising`
outputs are not in the older cases' `*.y` filter: the full suites afterwards pass **omc 316/316** (21 disabled) and
**Dymola 336/336** (9 skipped). The examples assert inside `when sample(0, dt)` clauses with `noEvent` conditions:
Modelon Impact keeps an event-generating relation such as `abs(margin) < 1e-9` frozen between events and does not
re-evaluate it after a discrete jump of a count, and a `noEvent` assert outside a `when` is evaluated during solver
trial steps too (Dymola's root finder then fails on a stale `y` beside a crossed margin) -- at the sample instants
every value is settled on every tool. The Impact composite suite afterwards: **371/371** (5 skipped); the
`RisingFrequency` case stores `maxFrequency1.y` and the margins only, because the plant's 2 Hz edges land
exactly on its sample grid, where two tools store opposite sides of an event.

**Full run, 2026-09-14** (`Impact/`, against the composite Dymola + OpenModelica
reference): **296/296 checks pass** on the 63 cases with a reference — every
funnel error exactly 0, 205 of 208 final values identical and the other three
within 5e-9, `PumpingSystem`'s relay signals within their integral tolerance.
Impact simulates all 68 examples. Two of them, `CheckMotorWithLosses` and
`CheckPumpingSystem`, did not compile in Impact (nor build in OpenModelica)
until the library stopped passing model instances to functions the same day;
their references are OpenModelica's, and `DEVMI_DIFFERENCES.md` §5 has the
tool-by-form measurement behind the fix — the Modelica-legal record cast
`R(m)` is implemented by Dymola alone. The 5 examples with no reference
(`MainPowerSupplyRequirements` and the four FFT examples above Dymola's
license cap) have their own list, `Impact/ImpactOnly/`, with Impact as its own
baseline: 63/63 checks at the 100× spread, so a change in the library or in
Impact that moves them is caught even without a second tool. The library
changes this took are listed in the library's own release notes,
`UsersGuide.ReleaseNotes.Version_0_7_1`.

## OpenModelica vs Dymola

`cross_engine_openmodelica_vs_dymola.txt` is the comparison of the **45 cases
both tools run**, every variable on the `ncp` grid, produced by

    python3 cross_engine.py --config regression_cases_requirements_openmodelica.yaml \
        --sources default,dymola

What it says:

* Every continuous signal agrees to better than **1e-4 of its range**
  (worst: `SignalAnalysis.MovingAverage` at 9.4e-5; most at 1e-13 or exactly 0).
* Every discrete signal — the Boolean conditions and checks, the `Property`
  outputs — has **identical switch instants** in both tools. The grid points
  that differ (1 to 27 per case) are exactly those instants, where the two
  tools sample opposite sides of the event; the `points_off` column counts
  them, and a switch that lands on a round time in a 0.01-step grid is why
  the `…Rising` examples show more of them than the others.
* `Components.PumpingSystem` differs at 91 of 5001 grid points: the relay
  controller's switching, tolerance-sensitive within one tool and between
  two, as its hand-tuned cases record.

No verdict is issued by that comparison — there is no reference, only two
runs — but nothing in it points at a disagreement about the models.

Rendered reports (`HtmlReports*/`) are gitignored. To read the two tools'
reports side by side, render both with `--aligned-batches`: pages are then cut
by each case's slot in the list, so the same model sits on the same page at
the same position in both, with a DISABLED or SKIPPED card where one tool
could not run it:

    python3 regression_testing.py --config regression_cases_requirements.yaml \
        --aligned-batches --html-report-dir HtmlReports
    python3 regression_testing.py --config regression_cases_requirements_openmodelica.yaml \
        --aligned-batches --html-report-dir HtmlReports_OpenModelica
    python3 regression_testing.py --config Impact/regression_cases_requirements_impact.yaml \
        --aligned-batches --html-report-dir Impact/HtmlReports
    python3 regression_testing.py --config Impact/ImpactOnly/regression_cases_requirements_impact_only.yaml         --html-report-dir Impact/ImpactOnly/HtmlReports

## Branches

`modcheck-baseline` (this branch) carries the library plus this folder.
`upstream-pr` is the same library without `Resources/ModCheck/` — only
Modelica code and Modelica documentation, on top of `upstream/master`, for
a pull request upstream. Library changes are committed on `upstream-pr` and
merged into `modcheck-baseline`; the two differ only by this folder.
