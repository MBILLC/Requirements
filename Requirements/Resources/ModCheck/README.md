# ModCheck baselines for Requirements

> The library's regression suites live with the library, in this folder: case lists, stored
> references and results, and the manual Impact workflow (`.github/workflows/regression.yml` of
> [MBILLC/Requirements](https://github.com/MBILLC/Requirements)). They moved back from ModCheck on
> 2026-11-18 (they were in MBILLC/ModCheck, `ModCheck/Resources/Suites/RequirementsLibrary/`, from
> 2026-10-22), so that ModCheck depends on no other project. The library itself still does not depend
> on ModCheck: only this folder uses it, as the test harness. The Dymola and OpenModelica case lists
> load the library as `../../package.mo`; the case names carry the prefix `MR_`.

Regression baselines for the library's `Examples`, established with
[ModCheck](https://github.com/MBILLC/ModCheck) by two Modelica
tools. Both case lists were generated from the models' own `experiment()`
annotations (`generate_cases_from_experiment.py`, `--variables '*.y'`: every
block output, which for this library is the requirement `Property` signals);
the two baselines share `ReferenceResults/` under different case-name prefixes.

| file | tool | cases | stored | not stored |
|---|---|---|---|---|
| `regression_cases_requirements.yaml` | Dymola 2026x, Cvode | 92 (91 enabled) | 71 Dymola + 20 Impact | none: the 8 the Dymola license refuses ("too complex for the current license", reported SKIPPED on such a license), `SignalsFromFile`, `StepResponse_SecondOrder`, `CheckHeatExchanger` and the 9 examples of 0.12.0/0.13.0 carry Modelon Impact's reference (`reference_from: impact`). `YearSmooth` is disabled, as in every list |
| `regression_cases_requirements_openmodelica.yaml` | OpenModelica 1.27.1, cvode | 92 (91 enabled) | 60 omc + 31 Impact | none: the 21 examples omc 1.27.1 builds only with the library's omc-fixes (the `SlidingWindow.push()` buffer record, 14; the FFT checks, 7), `CheckHeatExchanger` and the 9 examples of 0.12.0/0.13.0 carry Modelon Impact's reference (`reference_from: impact`) and are enabled. `YearSmooth` is disabled, as in every list |
| `Impact/regression_cases_requirements_impact.yaml` | Modelon Impact (Sept. 2026), cvode | 68 | — | runs against the composite reference in `Impact/ReferenceResults/`: Dymola's 60 references plus OpenModelica's for the three cases Dymola's license refuses and omc builds (`LimitedCabinAltitudeRateOfChange`, `CheckMotorWithLosses`, `CheckPumpingSystem`) plus Impact's own references for the 5 cases neither tool can produce (`reference_from: impact` in the manifest), so no case is SKIPPED |
| `Impact/ImpactOnly/regression_cases_requirements_impact_only.yaml` | Modelon Impact (Sept. 2026), cvode | 5 | 5 | the five cases above with no Dymola or OpenModelica reference (`MainPowerSupplyRequirements`, four FFT examples), checked against Impact's own stored result in `Impact/ImpactOnly/ReferenceResults/`: 63/63 at the 100× spread. The composite list carries the same five with Impact's own references |

Both suites pass at ModCheck's 100× rtol spread. One case is hand-tuned in
each list — `SimplePumpingSystem.Components.PumpingSystem`, an on-off pressure
controller over 2000 s whose switching instants move with tolerance; its relay
signals are checked by accumulated |difference| at a measured tolerance.

## What a pass means here

These suites test the library, not a plant, and they are regression checks. Each case
compares the examples' recorded signals, mostly the `Property` outputs of the requirement
blocks, with a stored reference. A PASS means the signal is unchanged since the reference,
within the tolerance. It does not mean the requirement is satisfied: an example whose
requirement is violated, and stays violated, passes. ModCheck does not read a requirement
verdict from these signals, or from the tool's log. *Violated / untested / satisfied* with
a margin, from requirements written as text, is Chaperone (`MBILLC/Chaperone`), which uses
ModCheck as its runner.

## The references for other tools

The npz references here are ModCheck's format. `../Testing/` exports them, on demand and
without ModCheck, for csv-compare (the MSL's `ReferenceResults` layout) and OpenModelica's
LibraryTesting, under the library's license: `python3 ../Testing/export_references.py`.
Its `README.md` explains the files and what a pass there means. The export goes to the
git-ignored `../Testing/Export/`.

## Modelon Impact

**Every example builds on OpenModelica, and every tool has a reference (measured 2026-10-23).** The library's
`omc-fixes` (MBILLC/Requirements: the `ChecksInSlidingWindow` when-clauses that assign the buffer
record, and the FFT-computation when-clause of `ChecksInFixedWindow_withFFT.Internal.FFT`, in
algorithm sections) lets OpenModelica 1.27.1 build and simulate the 21 examples, with the
new and the old frontend. On Modelon Impact it changes nothing: the full suite passes **649/649** checks
(91 cases, 100x spread) on the library with and without the change, in two throwaway workspaces
created by `CI/impact_ci_workspace.py` from the two commits, and the two runs' trajectories are
**bit-identical** on all 91 cases. Every case of the Dymola and OpenModelica lists with no
reference of its own tool has Modelon Impact's, stored at the case's rtol with the Impact list's
settings for the same model (`--store`, `reference_from: impact` in `ReferenceResults/manifest.json`;
the descriptor names the throwaway workspace `omcfixes-check`): 31 in the OpenModelica list, 20 in the
Dymola list; re-simulated at the 100x spread on Impact they pass 292/292 and 301/301 checks. Both lists carry the 9 examples of 0.12.0/0.13.0. Two
OpenModelica FFT cases (`WithinAbsoluteDomain1`, `WithinRelativeDomain1`) take the Impact list's
`terminate1.delay = 0.01`, so both tools run the setup the reference was taken with. Not yet run here:
the OpenModelica and Dymola lists against these references (neither tool is in this container).

**Impact as its own reference.** `MainPowerSupplyRequirements` and the four FFT examples above Dymola's
license cap, which have no Dymola or OpenModelica reference, have Impact's own references in
`Impact/ReferenceResults/` (`--store --case` on the composite list, `reference_from: impact` in the
manifest). Impact is a sound baseline for these: its results match the Dymola references exactly on
every case both can run (below).

**Impact against the composite Dymola + OpenModelica reference, measured 2026-09-14:**
**296/296 checks pass** on the 63 cases with a reference — every
funnel error exactly 0, 205 of 208 final values identical and the other three
within 5e-9, `PumpingSystem`'s relay signals within their integral tolerance.

**What Impact needs.** Impact evaluates `terminal()`
to `false`, so a requirement model there needs
`printViolations(useEvaluationTime=true)` to print its verdict; every example
carries `evaluationTime = StopTime` for that purpose. The
examples that stop through `FallingEdgeTerminate` need `terminate1.delay > 0`
for Impact to record their final verdict, which the Impact case list sets as a
modifier on the two examples concerned. The measurements are in `DEVMI_DIFFERENCES.md`, in
MBILLC/Requirements: `git show 6461488:Requirements/Resources/ModCheck/DEVMI_DIFFERENCES.md`.

**Violation statistics.** `Examples.Elementary.ViolationStatistics.Sine`, `Episodes`, `Gating` and
`RequirementLog` have Impact's own references (`reference_from: impact`, 149 kB together): the
statistics outputs are stored, so a count, a duration or a worst margin that moves is caught like a
verdict. Two instants are not compared, `tLongestStart` and `tWorst` of the sine examples: their four
episodes are equally long and their maxima equally deep, so which one is reported moves by a period
at the 100x rtol re-simulation (the examples assert both modulo the period). `YearSmooth` is in the list
but `enabled: false`: a stored result keeps every event row, and its reference would be 805 kB.

**Steady-state check example.** `Examples.SteadyState.CheckHeatExchanger`
is a case in the three lists with its variables named one by one (the three requirement properties, the outlet and
wall temperatures, the transferred heat, the two filtered rates that define "settled", `printViolations.satisfaction`):
a `"*.y"` glob would sweep in the heat exchanger's internals. Its reference is Impact's
(`reference_from: impact`, 11 variables, 27 kB).

**Step-response blocks.** The two examples of
`Examples.Elementary.StepResponse` are cases in the three lists with `variables: [time, "*.y", "*.margin", "*.value"]`,
so the blocks' running metrics are references too. `SecondOrder`'s ten check blocks make 759 unknowns,
and the Dymola license refuses it. Measured: the
sampled blocks restart OpenModelica's cvode at every millisecond sample and its accumulated error reads the
second-order example's peak 0.2 % low (16.27 % for 16.30) and moves with the tolerance, where dassl and ida reproduce
the closed form at 1e-6 and 1e-8 alike -- the OpenModelica list runs the two cases with `solver: dassl`;
and a sampled block whose period equals the result grid makes omc's
cvode runtime stall on a sample and an output point 1e-14 s apart, so the blocks sample at the half-periods. On
Modelon Impact's CVode has the same restart error (the peak 0.3 % low at 1e-6, 0.9 % at the comparison run's
1e-4: 28/44 checks against the dassl reference), Radau5ODE none at any tolerance -- the solver is a simulation option
of Impact's dynamic custom function, so the Impact list runs both cases with `solver: Radau5ODE` at rtol 1e-8
(44/44 against the composite's dassl reference for `SecondOrder`, Dymola's for `Disturbance`). The example's two
states carry `nominal` values (0.1 and 0.5) so the absolute tolerance is scaled to the step;
it helps CVode a little at 1e-6 and not at 1e-4.

**Margin outputs.** The eight examples of
`Examples.Elementary.Margin` are cases in the three lists with `variables: [time, "*.y", "*.margin"]`, so the
margins are references too. The examples assert inside `when sample(0, dt)` clauses with `noEvent` conditions:
Modelon Impact keeps an event-generating relation such as `abs(margin) < 1e-9` frozen between events and does not
re-evaluate it after a discrete jump of a count, and a `noEvent` assert outside a `when` is evaluated during solver
trial steps too (Dymola's root finder then fails on a stale `y` beside a crossed margin) -- at the sample instants
every value is settled on every tool. The
`RisingFrequency` case stores `maxFrequency1.y` and the margins only, because the plant's 2 Hz edges land
exactly on its sample grid, where two tools store opposite sides of an event.

## OpenModelica vs Dymola

`cross_engine_openmodelica_vs_dymola.txt` is the comparison of the **45 cases
both tools run**, every variable on the `ncp` grid, produced from `ModCheck/Resources` of a
ModCheck checkout (`R` is this folder) by

    python3 ModCheck/cross_engine.py --config $R/regression_cases_requirements_openmodelica.yaml \
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

    R=<this folder>      # Requirements/Resources/ModCheck; run from ModCheck/Resources of a ModCheck checkout
    python3 ModCheck/regression_testing.py --config $R/regression_cases_requirements.yaml \
        --aligned-batches --html-report-dir $R/HtmlReports
    python3 ModCheck/regression_testing.py --config $R/regression_cases_requirements_openmodelica.yaml \
        --aligned-batches --html-report-dir $R/HtmlReports_OpenModelica
    python3 ModCheck/regression_testing.py --config $R/Impact/regression_cases_requirements_impact.yaml \
        --aligned-batches --html-report-dir $R/Impact/HtmlReports
    python3 ModCheck/regression_testing.py --config $R/Impact/ImpactOnly/regression_cases_requirements_impact_only.yaml \
        --html-report-dir $R/Impact/ImpactOnly/HtmlReports

## Branches of the library

The library's `upstream-pr` branch is the library on top of `upstream/master`, for a pull request
upstream; every branch of MBILLC/Requirements is Modelica code, documentation
and this folder. The Impact suite runs by hand from this repository's Actions tab
(`regression` -> Run workflow), on the commit it is started on, with ModCheck at the ref it is given.
