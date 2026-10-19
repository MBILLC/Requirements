within ;
package Requirements "Requirements (Version 0.12.0) - Defining requirements formally and checking them when simulating"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

package ReleaseNotes "Release notes"
  extends Modelica.Icons.ReleaseNotes;

  class Summary2026 "Summary of changes and additions in 2026"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
In 2026 the library went from version 0.7.0 (Feb. 2025) to <b>0.12.0</b> (2026-10-19) in eight
releases. This page summarizes them; the release note of each version has the details.
The same summary is kept as Markdown in
<a href=\"https://github.com/MBILLC/Requirements/blob/HEAD/CHANGES_2026.md\">CHANGES_2026.md</a>
at the top level of the library's repository (beside the <code>Requirements</code> package folder).
The regression baselines and the tool-by-tool measurements are kept beside the library (see the
<a href=\"modelica://Requirements.UsersGuide\">User's Guide</a>).
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Version</th><th>Date</th><th>Theme</th></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_7_1\">0.7.1</a></td><td>2026-09-14</td>
    <td>Rename, MSL 4.1.0, runs in Modelon Impact, three-tool comparison, MA-HS-CSV reader</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_8_0\">0.8.0</a></td><td>2026-09-15</td>
    <td>Four-valued logic (<code>Undefined</code> added to <code>Property</code>)</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_9_0\">0.9.0</a></td><td>2026-09-15</td>
    <td><code>margin</code> output on every check block</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_9_1\">0.9.1</a></td><td>2026-09-15</td>
    <td>Bug fix: CSV reader derivative at the file's last row</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_10_0\">0.10.0</a></td><td>2026-09-16</td>
    <td>Step-response metrics (overshoot, rise time, settling time, ...)</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_11_0\">0.11.0</a></td><td>2026-09-16</td>
    <td>Eigenvalue checks over a linearization (<code>LinearAnalysis</code>)</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_11_1\">0.11.1</a></td><td>2026-10-16</td>
    <td>Steady-state check example; the verdict printed once in every tool; self-contained documentation</td></tr>
<tr><td><a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Version_0_12_0\">0.12.0</a></td><td>2026-10-19</td>
    <td>Violation statistics: how often, how long and how badly a requirement was violated</td></tr>
</table>

<p>
No release needs a model conversion. Each one declares <code>conversion(noneFromVersion=...)</code> for the
version before it. One exception: from 0.8.0 on, code that reads a stored <code>Property</code> result
has to accept the value 4.
</p>

<h4>Origin and rename (2026-09-14)</h4>
<ul>
<li> The library was renamed from <code>Modelica_Requirements</code> to <b>Requirements</b>. It is Model
     Based Innovation LLC's derivative of upstream
     <a href=\"https://github.com/modelica-3rdparty/Modelica_Requirements\">Modelica_Requirements</a> 0.7.1
     (BSD 3-Clause) and now lives in the public repository
     <a href=\"https://github.com/MBILLC/Requirements\">MBILLC/Requirements</a>.</li>
<li> The license and the original authors' copyright notices are unchanged.</li>
<li> The additions serve a <b>two-run verification</b> workflow. First the plant is simulated on its own
     and its signals are stored in an MA-HS-CSV file. Then the requirement checks run on the stored
     signals in a second run.</li>
</ul>

<h4>0.7.1 &mdash; Maintenance and multi-tool support</h4>
<p>
The release made the library run in Modelon Impact. None of its changes alter requirement semantics.
</p>
<ul>
<li> <code>uses(Modelica(version=\"4.1.0\"))</code>. The library needed no change for MSL 4.1.0.</li>
<li> <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> has two new Advanced
     parameters, <code>useEvaluationTime</code> and <code>evaluationTime</code>. Impact evaluates
     <code>terminal()</code> to <code>false</code>, so it never printed the verdict. Every example now sets
     <code>evaluationTime = StopTime</code>.</li>
<li> <a href=\"modelica://Requirements.LogicalBlocks.FallingEdgeTerminate\">FallingEdgeTerminate</a> has a new
     <code>delay</code> parameter (default 0). At a <code>terminate()</code> instant Impact stores only the
     pre-event state, so without a delay the final verdict was missing from the result.</li>
<li> <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a> now runs
     in Impact. Four separate fixes were needed:
     <ul>
     <li>The local arrays in <code>Internal.checkDomain</code> now have explicit sizes.</li>
     <li>The FFT sampling start is now explicit:
         <code>(condition and not pre(condition)) or (initial() and condition)</code>.</li>
     <li>The FFT examples use the new terminate delay.</li>
     <li>The when-clause chains of <code>WithinRelativeDomain</code> and <code>MaxTotalHarmonicDistortion</code>
         were replaced by single function calls, <code>Internal.checkRelativeDomain</code> and
         <code>Internal.checkTHD</code>.</li>
     </ul></li>
<li> The <code>LogicalFunctions.card*</code> reductions are now written over indices, because Impact
     failed to scalarize the element form.</li>
<li> No more model instances passed to functions. <code>Examples.MotorsWithLosses</code> and
     <code>SimplePumpingSystem.CheckPumpingSystem</code> now build their observation records with explicit
     record constructors.
     <ul>
     <li>The reason: the record cast <code>R(m)</code> allowed by MLS 3.6 &sect;12.6.1 is implemented only by Dymola.</li>
     <li><code>MotorData</code> and <code>InertiaData</code> were made public.</li>
     <li><code>SourceObservation_from_PartialSource</code> and <code>Records.PartialSource</code> were removed.</li>
     </ul></li>
<li> New: <a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">Sources.PartialSignalsFromFile</a>
     reads MA-HS-CSV files: Real, Boolean and Integer columns by name, with a time event at every change of
     a discrete column.
     <ul>
     <li>It is built on <a href=\"modelica://Requirements.Internal.CSV\">Internal.CSV</a> and a header-only
         C89 reader, <code>Resources/Include/RequirementsCsv.h</code>.</li>
     <li>The reader is tested against a Python reader in <code>Resources/C-Sources/test/</code>.</li>
     <li>Example: <a href=\"modelica://Requirements.Examples.Elementary.Sources.SignalsFromFile\">Examples.Elementary.Sources.SignalsFromFile</a>.</li>
     </ul></li>
<li> Three tools compared (68 examples, every <code>*.y</code> output):
     <table border=1 cellspacing=0 cellpadding=2>
     <tr><th>Tool</th><th>Simulated</th><th>Not simulated</th></tr>
     <tr><td>Dymola 2026x</td><td>60</td><td>8 refused by the license</td></tr>
     <tr><td>OpenModelica 1.27.1</td><td>48</td><td>20 don't build (14 sliding-window, 6 FFT)</td></tr>
     <tr><td>Modelon Impact (Sept. 2026)</td><td>68</td><td>&mdash;</td></tr>
     </table>
     <ul>
     <li>Impact vs. Dymola/OpenModelica: all 296 signal checks pass.</li>
     <li>OpenModelica vs. Dymola: continuous signals agree to better than 1e-4 of their range, and
         discrete signals switch at identical instants.</li>
     </ul></li>
</ul>

<h4>0.8.0 &mdash; Four-valued logic</h4>
<p>
This release changes requirement semantics.
</p>
<ul>
<li> <a href=\"modelica://Requirements.Types.Property\">Types.Property</a> =
     <code>enumeration(Violated, Undecided, Satisfied, Undefined)</code>.
     <ul>
     <li><code>Undefined</code> (value 4) means <em>not applicable</em>. <code>Undecided</code> now means
         <em>applicable but not yet decided</em>.</li>
     <li>The new value is appended at the end, so the stored values 1&ndash;3 stay valid.</li>
     <li><code>Types.Boolean4</code> is an alias, using CRML's name.</li>
     </ul></li>
<li> <a href=\"modelica://Requirements.LogicalFunctions\">LogicalFunctions</a>: new <code>and4</code>,
     <code>or4</code>, <code>not4</code> (truth tables taken from CRML/ETL), <code>and4All</code>,
     <code>or4All</code> and <code>cardUndefined</code>.
     <ul>
     <li><code>Undefined</code> is the neutral element of <em>and</em> and <em>or</em>.</li>
     <li><code>forall3</code> delegates to <code>and4All</code>.</li>
     <li><code>during</code> and <code>during3</code> return <code>Undefined</code> while their condition is false.</li>
     </ul></li>
<li> <a href=\"modelica://Requirements.LogicalBlocks\">LogicalBlocks</a>: <code>PropertyAnd</code>,
     <code>PropertyOr</code> and <code>PropertyNot</code> delegate to the new functions.
     <ul>
     <li>An unconnected <code>PropertyAnd</code>/<code>PropertyOr</code> now gives <code>Undefined</code>.</li>
     <li><code>PropertyToBoolean</code> has a new <code>undefined</code> parameter.</li>
     <li><code>PropertyConstant</code> and <code>PropertyTable</code> accept the fourth value.</li>
     </ul></li>
<li> Every <a href=\"modelica://Requirements.ChecksInFixedWindow\">ChecksInFixedWindow</a> block outputs
     <code>Undefined</code> while its condition is false. The FFT checks output <code>Undefined</code> before
     their first rising edge and <code>Undecided</code> until the first FFT is computed.</li>
<li> <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> and
     <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> still reduce everything to
     three verdicts.
     <ul>
     <li>They report the new count <b>attempts</b>: the number of phases in which the property was applicable.</li>
     <li>The log file and the HTML report gain an attempts column.</li>
     </ul></li>
<li> New example <a href=\"modelica://Requirements.Examples.Elementary.LogicalBlocks.PropertyTable4\">Examples.Elementary.LogicalBlocks.PropertyTable4</a>
     tests all 16 pairs of each truth table, plus the laws that hold and the laws that fail.
     <ul>
     <li>Absorption and distributivity fail wherever <code>Undefined</code> is involved.</li>
     <li>Never simplify <code>Property</code> expressions with Boolean rewriting.</li>
     </ul></li>
<li> The regression baselines were re-stored on OpenModelica, Dymola and Impact. The only differences were
     Undecided &rarr; Undefined.</li>
</ul>

<h4>0.9.0 &mdash; Margins</h4>
<ul>
<li> Every check block has a new output <b>margin</b> = robustness / <code>scale</code>.
     <ul>
     <li>Robustness is the signed distance to the limit; it is &ge; 0 exactly when the check holds.</li>
     <li><code>scale</code> is the requirement's tolerance (default 1).</li>
     <li>The connector type is the new <a href=\"modelica://Requirements.Interfaces.MarginOutput\">Interfaces.MarginOutput</a>
         (<code>unit=\"1\"</code>).</li>
     </ul></li>
<li> <a href=\"modelica://Requirements.Interfaces.PartialCheck\">PartialCheck</a> and the sliding-window partials
     have two new parameters, <code>scale</code> and <code>computeMargin</code>.</li>
<li> How each block family gets its robustness:
     <ul>
     <li><code>During</code> and <code>When*</code>: from a new input <code>rho</code>.</li>
     <li>Duration blocks: from the new output <code>duration</code>.</li>
     <li>Count blocks: from the count difference. <code>countRising</code> is now an output.</li>
     <li><code>MaxRisingFrequency</code>, <code>WithinDomain</code>, sliding-window and FFT blocks: from the
         quantity each block already computes.</li>
     </ul></li>
<li> <a href=\"modelica://Requirements.LogicalFunctions.marginAnd\">LogicalFunctions.marginAnd</a> and
     <a href=\"modelica://Requirements.LogicalFunctions.marginOr\">marginOr</a> give the minimum and maximum
     margin over the elements that are not <code>Undefined</code>.</li>
<li> The blocks have no accumulators. The worst margin over a run is taken from the stored trajectory
     (or, since 0.12.0, computed during the run by the separate, opt-in
     <a href=\"modelica://Requirements.Verify.ViolationStatistics\">Verify.ViolationStatistics</a>).</li>
<li> New examples <a href=\"modelica://Requirements.Examples.Elementary.Margin\">Examples.Elementary.Margin</a>:
     eight of them, one per block family. Each checks the margins against closed-form values and checks
     the sign invariant.</li>
<li> No existing output changed. Regression results: OpenModelica 316/316, Dymola 336/336, Impact 371/371.</li>
</ul>

<h4>0.9.1 &mdash; CSV reader fix</h4>
<ul>
<li> <a href=\"modelica://Requirements.Internal.CSV.getRealDer\">Internal.CSV.getRealDer</a> returned 0 at the
     file's last row. Derived signals therefore dropped to 0 at the final stored row, which produced a
     spurious edge.</li>
<li> At the last row it now returns the slope of the final segment. Beyond the end of the file it still
     returns 0.</li>
<li> No stored reference changed.</li>
</ul>

<h4>0.10.0 &mdash; Step-response metrics</h4>
<ul>
<li> New block <a href=\"modelica://Requirements.SignalAnalysis.StepResponse\">SignalAnalysis.StepResponse</a>
     computes the running step-response metrics: overshoot, undershoot, rise time, delay time, settling
     time, steady-state error, damping ratio and decay ratio.
     <ul>
     <li>It detects steps, windows them, and interpolates level crossings between samples.</li>
     <li>It samples at half-periods. When the sample period equals the result grid, OpenModelica's CVODE stalls.</li>
     </ul></li>
<li> New block <a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">ChecksInFixedWindow.StepResponseCheck</a>
     bounds one metric and outputs <code>Property</code> and <code>margin</code>.</li>
<li> New enumerations <code>Types.StepTarget</code> and <code>Types.StepMetric</code>.</li>
<li> New examples <a href=\"modelica://Requirements.Examples.Elementary.StepResponse\">Examples.Elementary.StepResponse</a>
     (<code>SecondOrder</code>, <code>Disturbance</code>), checked against closed forms.</li>
<li> The blocks decide a step-response requirement in the simulation itself. Where the same metrics are
     also evaluated on the stored trajectory after the run, the blocks agree with that evaluation to one
     sampling period.</li>
<li> Solver choice: the millisecond sample events make CVode read the peak about 0.2&ndash;0.3 % low. The
     regression lists therefore use dassl on OpenModelica and Radau5ODE on Impact.</li>
</ul>

<h4>0.11.0 &mdash; Eigenvalue checks over a linearization</h4>
<ul>
<li> New package <a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a>:
     <ul>
     <li><code>readStateMatrix</code> reads the A matrix of a linearization from a MATLAB v4 file. The
         linearization itself is done in whatever tool the user has; the package documentation describes
         the routes.</li>
     <li><code>modes</code> groups the eigenvalues into modes (conjugate pairs folded, an integrator rule, a
         parasitic cut).</li>
     <li><a href=\"modelica://Requirements.LinearAnalysis.EigenvalueCheck\">EigenvalueCheck</a> bounds real part,
         damping, frequency or time constant over every mode, with an optional frequency band.</li>
     <li><a href=\"modelica://Requirements.LinearAnalysis.EigenvaluesWithinRegion\">EigenvaluesWithinRegion</a>
         checks that every eigenvalue lies inside a polygon in the (Re, Im) plane.</li>
     <li>Both blocks output <code>Property</code> and <code>margin</code>.</li>
     </ul></li>
<li> New enumeration <code>Types.EigenMetric</code>.</li>
<li> New example <a href=\"modelica://Requirements.Examples.Elementary.LinearAnalysis\">Examples.Elementary.LinearAnalysis</a>
     (<code>SecondOrder</code>), with the data file <code>Resources/Data/SecondOrderLinearization.mat</code>.</li>
<li> The verdict is printed by <code>PrintViolations</code> like that of any other requirement.</li>
<li> By decision, the frequency-response requirements have no Modelica side.</li>
</ul>

<h4>0.11.1 &mdash; Steady-state check example, printing fix, documentation</h4>
<ul>
<li> New example <a href=\"modelica://Requirements.Examples.SteadyState.CheckHeatExchanger\">Examples.SteadyState.CheckHeatExchanger</a>:
     steady-state requirements of the MSL heat exchanger, checked and printed in a plain simulation.
     <ul>
     <li>Each requirement is written as <code>during(steady, check)</code>, so the transient does not count.</li>
     <li>A separate requirement checks that the run has settled.</li>
     </ul></li>
<li> Bug fix: <code>PrintViolations</code> printed every verdict twice in a tool that evaluates the
     verdict's when-equations twice at the same event (Modelon Impact with <code>useEvaluationTime</code>).
     The log file and the summary are now written once. The full Impact regression suite passed 488/488
     checks afterwards.</li>
<li> The documentation no longer depends on any external tooling or on one Modelica tool.
     <ul>
     <li>The relation to the verification framework the library is used in is explained once, in the
         <a href=\"modelica://Requirements.UsersGuide\">User's Guide</a>.</li>
     <li><a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a> describes how to linearize and export the state matrix
         in different tools.</li>
     </ul></li>
</ul>

<h4>0.12.0 &mdash; Violation statistics</h4>
<ul>
<li> New block <a href=\"modelica://Requirements.Verify.ViolationStatistics\">Verify.ViolationStatistics</a>. From a
     check's <code>property</code> and <code>margin</code> it gives how often the requirement was violated, for how long
     in total, the longest violation, and the worst violation and when. Meant for long runs such as annual building
     simulations, where a verdict alone does not say enough.</li>
<li> The worst margin is found with
     <a href=\"modelica://Modelica.Blocks.Math.ContinuousSignalExtrema\">Modelica.Blocks.Math.ContinuousSignalExtrema</a>,
     which the block extends, or with a cheaper ratchet for a margin that oscillates.</li>
<li> <code>Verify.Requirement</code> and <code>BooleanRequirement</code> compute the same statistics when
     <code>computeStatistics</code> is set. They are written to the log file and printed in the summary.</li>
<li> The check blocks still have no accumulators, and every existing output and log line is unchanged.</li>
</ul>

<h4>Regression baselines</h4>
<ul>
<li> Case lists generated from the examples' <code>experiment()</code> annotations:
     <ul>
     <li>Dymola 2026x: <code>regression_cases_requirements.yaml</code></li>
     <li>OpenModelica 1.27.1: <code>regression_cases_requirements_openmodelica.yaml</code></li>
     <li>Modelon Impact: <code>Impact/regression_cases_requirements_impact.yaml</code></li>
     </ul></li>
<li> The Impact list compares against a composite reference: Dymola's results, with OpenModelica's filling
     the gaps. Since 2026-09-15, the 5 cases that neither of those tools can run use Impact's own results as
     reference. The full Impact suite then passed <b>434/434</b> with nothing skipped.</li>
<li> Every new example from 0.8.0&ndash;0.11.1 was added as a case. The margin and step-metric outputs are
     stored as references.</li>
</ul>
</html>"));
  end Summary2026;

  class Version_0_12_0 "Version 0.12.0 (Oct. 19, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>Violation statistics.</b> For a long run a verdict is not enough: a requirement violated once for a second and one
violated every summer afternoon are both <em>violated</em>. The new block
<a href=\"modelica://Requirements.Verify.ViolationStatistics\">Verify.ViolationStatistics</a> answers three questions per
requirement: how often was it violated, what was the worst violation and when, and what was the longest violation.
No existing output, log line or regression reference changed.
</p>
<h4>The block</h4>
<ul>
<li> Inputs: the check's <code>property</code>, and optionally its <code>margin</code> (new connector
     <a href=\"modelica://Requirements.Interfaces.MarginInput\">Interfaces.MarginInput</a>).</li>
<li> Outputs: <code>nViolations</code>, <code>totalDuration</code>, <code>violatedFraction</code>,
     <code>longestDuration</code> and <code>tLongestStart</code>, <code>worstMargin</code> and <code>tWorst</code>, the same
     for the current episode, and <code>currentDuration</code>. Every output holds its final value without
     <code>terminal()</code>.</li>
<li> A violation is a phase with <code>property = Violated</code>, not one with a negative margin. A margin is
     provisional while the check is <code>Undecided</code>, so the worst margin is taken over the decided phases only.
     This is the rule the verdict follows.</li>
<li> <code>mergeGap</code> and <code>minDuration</code> stop a signal that hovers at its limit from counting as hundreds
     of violations. They change the count and the longest episode, never the total.</li>
<li> Counting and timing cost no extra events: the property only changes at events the check produces anyway.</li>
</ul>
<h4>The worst margin</h4>
<ul>
<li> <b>Continuous</b> (default): <a href=\"modelica://Requirements.Internal.ContinuousWorst\">Internal.ContinuousWorst</a>
     extends <a href=\"modelica://Modelica.Blocks.Math.ContinuousSignalExtrema\">Modelica.Blocks.Math.ContinuousSignalExtrema</a>.
     A state event fires at every local extremum of the margin, without sampling. Three changes from the MSL block:
     <ul>
     <li>only the decided phases count;</li>
     <li>the worst value is also tracked per episode;</li>
     <li>the final value does not depend on <code>terminal()</code>, which Modelon Impact evaluates to false.</li>
     </ul>
     The filter time constant <code>T</code> defaults to 0.01 s, not the MSL block's 1 &micro;s. At 1 &micro;s the
     event indicator near an extremum is below the solver tolerance, and the solver reports chattering. Choose
     <code>T</code> as about a thousandth of the margin's time scale (60 s for a year).</li>
<li> <b>Ratchet</b>: an event only when the margin falls a <code>resolution</code> (default 0.01) below the least value
     so far. The result is within <code>resolution</code> of the exact value.
     <a href=\"modelica://Modelica.Blocks.Math.SignalExtrema\">Modelica.Blocks.Math.SignalExtrema</a> was considered and
     not used: it samples, and is no more accurate than the stored result.</li>
<li> Measured on Impact, a year with hourly output and a 0.1 K, 10-minute ripple on a room temperature
     (<code>Examples.Elementary.ViolationStatistics.YearRipple*</code>):
     <table border=1 cellspacing=0 cellpadding=2>
     <tr><th>Model</th><th>Run time</th><th>State events</th><th>Episodes</th><th>Worst margin</th></tr>
     <tr><td>no statistics</td><td>9.0 s</td><td>2,804</td><td>&mdash;</td><td>&mdash;</td></tr>
     <tr><td>continuous</td><td>96.7 s</td><td>219,103</td><td>374</td><td>&minus;3.0844</td></tr>
     <tr><td>ratchet</td><td>31.1 s</td><td>64,991</td><td>374</td><td>&minus;3.0800</td></tr>
     </table>
     On a smooth margin the continuous method is cheap: two events a day. On an oscillating one the ratchet is three
     times cheaper.</li>
</ul>
<h4>Statistics in the log</h4>
<ul>
<li> <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> and
     <a href=\"modelica://Requirements.Verify.BooleanRequirement\">BooleanRequirement</a> have a new tab Statistics:
     <code>computeStatistics</code> (default false), <code>useMargin</code> with a conditional <code>margin</code>
     input, and the block's parameters.</li>
<li> A requirement with statistics writes a second line to the log file beside its verdict:
     <code>Statistics,&lt;observation&gt;,&lt;requirement&gt;,&lt;n&gt;,&lt;total&gt;,&lt;fraction&gt;,&lt;longest&gt;,&lt;longest
     from&gt;,&lt;worst&gt;,&lt;worst at&gt;,&lt;minDuration&gt;,&lt;mergeGap&gt;</code>. The worst-margin fields are empty without
     margin. The two filters are included so that a reader can recompute the statistics from the stored result. It is a separate line, not columns added to the verdict line,
     because the verdict line ends with free text, and a reader would take any added columns for part of the text.</li>
<li> <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> prints a <em>Violation
     statistics</em> section in its summary, on the console and in the HTML report.</li>
<li> <code>Internal.printViolationsToLogFile</code> no longer takes a <code>Statistics</code> line of the same
     requirement for its own verdict line when it checks whether that line is already written.</li>
</ul>
<h4>Examples</h4>
<p>
<a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics\">Examples.Elementary.ViolationStatistics</a>:
</p>
<ul>
<li> <code>Sine</code>, <code>Episodes</code> and <code>Gating</code> assert every output against closed-form values.</li>
<li> <code>RequirementLog</code> shows the log and the summary.</li>
<li> The <code>Year*</code> models run a year and measure the cost of the two methods.</li>
</ul>
<p>
The first four are cases in the Impact regression list, with Impact's own references. <code>YearSmooth</code> is in
the list but disabled: its stored result has every event row and would be as large as the rest of the list. Full
Impact suite afterwards: 563/563 checks, every existing case unchanged.
</p>
<h4>Changes</h4>
<ul>
<li> New: <code>Verify.ViolationStatistics</code>, <code>Interfaces.MarginInput</code>,
     <code>Types.WorstMarginMethod</code>, <code>Internal.ContinuousWorst</code>, <code>Internal.RatchetWorst</code>,
     <code>Internal.StatisticsLogger</code>, <code>Internal.printStatisticsToLogFile</code>,
     <code>Examples.Elementary.ViolationStatistics</code>.</li>
<li> <code>Interfaces.PartialRequirement</code>: the Statistics tab (no change while <code>computeStatistics = false</code>).</li>
<li> <code>Internal.printViolationsToLogFile</code>, <code>Internal.printViolationsToOutput</code>: as above.</li>
<li> <code>conversion(noneFromVersion=\"0.11.1\")</code>: no model needs conversion.</li>
</ul>
</html>"));
  end Version_0_12_0;

  class Version_0_11_1 "Version 0.11.1 (Oct. 16, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>A steady-state check example, the verdict printed once, self-contained documentation.</b>
No requirement semantics changed.
</p>
<h4>New example</h4>
<p>
<a href=\"modelica://Requirements.Examples.SteadyState.CheckHeatExchanger\">Examples.SteadyState.CheckHeatExchanger</a> checks the
steady-state requirements of the MSL heat exchanger in a plain simulation and prints them with
<a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a>, in any Modelica tool. It extends
<code>HeatExchangerSimulation</code>, which stays a plant without requirement blocks.
</p>
<ul>
<li> A requirement block reports a violation if its property is <code>Violated</code> at any instant, but a
     steady-state requirement is about the settled operating point. Each requirement is therefore written as
     <code>during(steady, check)</code>: <code>Undefined</code> (not applicable) while the run is still moving.</li>
<li> <code>steady</code> holds in the last quarter of the run while both outlet temperatures change by less than
     <code>dTdtMax</code>; the rates come from <code>SignalAnalysis.ApproximateDerivativeWithFilter</code>.</li>
<li> <code>R0_settled</code> checks that the run has settled. If it has not, R0 is violated and the other
     requirements stay untested instead of being judged on a transient value.</li>
<li> The standard <code>PrintViolations</code> suffices: a steady-state verdict is taken at the end of the run
     like any other.</li>
</ul>
<h4>Bug fix: the verdict printed twice</h4>
<p>
Modelon Impact evaluates the when-equations that take the verdict twice at the event instant (with
<code>useEvaluationTime = true</code>, at <code>evaluationTime</code>; measured 2026-10-16, also with
<code>evaluationTime</code> before the stop time). Every requirement then wrote its line to the log file twice and
<code>PrintViolations</code> printed the summary twice, the second time with every requirement counted double
(\"2 of 6\" for three requirements). The satisfaction percentage was not affected. Both writes are now idempotent:
</p>
<ul>
<li> <code>Internal.printViolationsToLogFile</code> skips a requirement whose line is already in the log file.</li>
<li> <code>Internal.initializeLogFile</code> also removes the HTML report of an earlier run (new input
     <code>htmlFile</code>, default <code>\"\"</code> = none), and <code>Internal.printViolationsToOutput</code>
     returns at once when the report already exists: the summary is printed once per run.</li>
</ul>
<p>
A tool that evaluates the when-equations once (Dymola, OpenModelica, and every tool at <code>terminal()</code>)
behaves as before. No stored regression signal moved: the full Impact suite passed 488/488 checks afterwards.
</p>
<h4>Documentation</h4>
<ul>
<li> The documentation is self-contained. The relation to the verification framework the library is used in is
     explained once, in the <a href=\"modelica://Requirements.UsersGuide\">User's Guide</a>; the rest of the documentation does not refer to it.</li>
<li> <a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a> explains the two steps of a linear-analysis requirement
     (linearize in a tool, check in Modelica), the routes for producing the state-matrix file in different Modelica
     tools, from an FMU and from Python, and gives a template check model.</li>
<li> The repository <a href=\"https://github.com/MBILLC/Requirements\">MBILLC/Requirements</a> is public; the
     User's Guide and the Contact page link to it.</li>
</ul>
<h4>Changes</h4>
<ul>
<li> <code>Examples.SteadyState.CheckHeatExchanger</code>: new example.</li>
<li> <code>Internal.initializeLogFile</code>: new input <code>htmlFile</code> (default <code>\"\"</code>);
     <code>Verify.PrintViolations</code> passes its <code>htmlFile</code>.</li>
<li> <code>Internal.printViolationsToLogFile</code>, <code>Internal.printViolationsToOutput</code>: idempotent.</li>
<li> <code>conversion(noneFromVersion=\"0.11.0\")</code>: no model needs conversion.</li>
</ul>
</html>"));
  end Version_0_11_1;

  class Version_0_11_0 "Version 0.11.0 (Sept. 16, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>Eigenvalue predicates over a linearization.</b> A linearization is a tool operation, not a simulation,
so no check model computes a plant's eigenvalues inside the run that produces them. The new package
<a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a> therefore reads the state matrix from a MATLAB v4
file written after the linearization (<code>readStateMatrix</code>, through
<code>Modelica.Utilities.Streams.readRealMatrix</code>), folds its eigenvalues into modes with an integrator rule and
a parasitic cut (<code>modes</code>, the plant's expected slowest and fastest time constants), and evaluates the
predicates as constants over a nominal run:
<a href=\"modelica://Requirements.LinearAnalysis.EigenvalueCheck\">EigenvalueCheck</a> (a real-part, damping,
frequency or time-constant bound over every mode, optionally in a frequency band;
<code>Types.EigenMetric</code>) and
<a href=\"modelica://Requirements.LinearAnalysis.EigenvaluesWithinRegion\">EigenvaluesWithinRegion</a> (a polygon of
the (Re, Im) plane), each with <code>Property</code> and <code>margin</code>. The package documentation describes how
to produce the file in different Modelica tools, from an FMU, or from Python. The frequency-response family has no
Modelica side, by decision (see the package's documentation).
<a href=\"modelica://Requirements.Examples.Elementary.LinearAnalysis\">Examples.Elementary.LinearAnalysis</a> asserts
the blocks on a shipped second-order matrix against its closed forms.
</p>
<h4>Changes</h4>
<ul>
<li> <code>Types.EigenMetric</code>: new enumeration.</li>
<li> <code>LinearAnalysis</code>: new package (<code>readStateMatrix</code>, <code>modes</code>, <code>EigenvalueCheck</code>,
     <code>EigenvaluesWithinRegion</code> and their functions).</li>
<li> <code>Examples.Elementary.LinearAnalysis</code>: <code>SecondOrder</code>; <code>Resources/Data/SecondOrderLinearization.mat</code>.</li>
<li> <code>conversion(noneFromVersion=\"0.10.0\")</code>: no model needs conversion; no existing block changed.</li>
</ul>
</html>"));
  end Version_0_11_0;

  class Version_0_10_0 "Version 0.10.0 (Sept. 16, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>Step-response metrics.</b> The classic control requirements -- overshoot, undershoot, rise time, delay
time, settling time, steady-state error, damping ratio, decay ratio -- as blocks:
<a href=\"modelica://Requirements.SignalAnalysis.StepResponse\">SignalAnalysis.StepResponse</a> computes the
running metrics of a response <code>u</code> after a step of a signal <code>r</code>, sampled at
<code>samplePeriod</code> (at the half-periods, off a result grid of the same period): the step as a change of
<code>r</code> between two samples (of at least <code>threshold</code>), its window to the next step or
<code>T_window</code> after it, the target the stepping signal after the step or a reference input
(<code>Types.StepTarget</code>), the peak and its instant, the level crossings interpolated between samples,
the last exit from the settling band, the current deviation, the extrema beyond the target and the damping
and decay ratios from them;
<a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">ChecksInFixedWindow.StepResponseCheck</a>
bounds one metric (<code>Types.StepMetric</code>) and emits <code>Property</code> and <code>margin</code>:
Undefined before the first step, Undecided from the step to the earliest sample the bound is provably met or
broken, decided at the window's close otherwise, the margin following the running metric. Where the same metrics are
also evaluated on the stored trajectory after the run, the blocks agree with that evaluation to one sampling
period.
<a href=\"modelica://Requirements.Examples.Elementary.StepResponse\">Examples.Elementary.StepResponse</a>
asserts the blocks against the closed forms of a second-order step response and a disturbance.
</p>
<p>
Measured on the way: a sampled block whose period equals the result grid makes OpenModelica's CVODE runtime
stall on an event and an output point 1e-14 s apart (an endless <em>desired step too small</em>); the blocks
therefore sample at the half-periods. The 6000 sample events of a 6 s run restart the solver every
millisecond and its accumulated error is what the sampled block sees: the second-order example's peak reads
0.2 % low against the closed form under OpenModelica's cvode and 0.3 % low under Modelon Impact's CVode (0.9 % at
rtol 1e-4), where dassl, ida and Impact's Radau5ODE reproduce it at every tolerance (measured; the
tolerances of the example's asserts say so, and the regression lists run it under dassl on OpenModelica and under
Radau5ODE on Impact). Choose a solver that is not degraded by frequent sample events when the peak matters. The example's two states carry
<code>nominal</code> values (0.1 and 0.5) so the absolute tolerance is scaled to the 0.1 m step; it helps CVode a
little at 1e-6 and not at 1e-4. When the block reads a plant's stored trajectory in a second run (through
<code>Sources.PartialSignalsFromFile</code>, with no solver error between plant and check), it agrees with an
evaluation on that trajectory on both tools.
</p>
<h4>Changes</h4>
<ul>
<li> <code>Types.StepTarget</code>, <code>Types.StepMetric</code>: new enumerations.</li>
<li> <code>SignalAnalysis.StepResponse</code>, <code>ChecksInFixedWindow.StepResponseCheck</code>: new blocks.</li>
<li> <code>Examples.Elementary.StepResponse</code>: <code>SecondOrder</code>, <code>Disturbance</code>.</li>
<li> <code>conversion(noneFromVersion=\"0.9.1\")</code>: no model needs conversion; no existing block changed.</li>
</ul>
</html>"));
  end Version_0_10_0;

  class Version_0_9_1 "Version 0.9.1 (Sept. 15, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>The MA-HS-CSV reader's derivative at the file's last row.</b>
<a href=\"modelica://Requirements.Internal.CSV.getRealDer\">Internal.CSV.getRealDer</a> (the <code>derivative</code>
annotation of <code>getReal</code>, in <code>Resources/Include/RequirementsCsv.h</code>) returned 0 at the file's last
row, as it does beyond the file's range where the last row is held. A check model that reads a file to its end is
evaluated at exactly that instant, so every derived signal (<code>SignalAnalysis.ExactDerivative</code> on a reader
output) dropped to 0 in the run's final stored row and a check on a derivative could read a spurious edge there
(a zero-length excursion out of an altitude-rate envelope at the stop time, for instance). At the last row the function now returns the slope of the segment ending at it (at the
first row of a final event group), as the left side of an event does; beyond the file's range it is still 0. The
ctypes test (<code>Resources/C-Sources/test</code>) probes every row instant, the last included, against the Python
reader, which changed the same way. No other behaviour changes; no stored reference of this library moves.
</p>
</html>"));
  end Version_0_9_1;

  class Version_0_9_0 "Version 0.9.0 (Sept. 15, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>Margins.</b> Every check block exposes how far the check is from its limit: output <b>margin</b> =
<em>robustness</em>/<b>scale</b>, with <em>robustness</em> the signed distance of the check to its limit in the
quantity's unit (&ge; 0 exactly when the check holds) and <b>scale</b> a new parameter, the requirement's
tolerance (default 1: the raw robustness). A margin of 1 is one tolerance of headroom, &lt; 0 a violation by that
many tolerances; margins of different requirements compare only when their scales are set. The block emits the
instantaneous value; the worst value over a run and its instant are taken from the stored trajectory -- there are no accumulators in the library, by design.
</p>

<h4>Changes</h4>
<ul>
<li> <a href=\"modelica://Requirements.Interfaces.MarginOutput\">Interfaces.MarginOutput</a>, an
     <code>output Real(unit=\"1\")</code> connector of its own type, so a margin cannot be connected to a
     physical-unit signal by mistake and every margin of a model is found by type.</li>

<li> <a href=\"modelica://Requirements.Interfaces.PartialCheck\">PartialCheck</a> and the two sliding-window
     partials gain <code>parameter Real scale(min = eps) = 1</code>, <code>parameter Boolean computeMargin = true</code>
     and the conditional output <code>MarginOutput margin = robustness/scale if computeMargin</code> over a
     protected <code>robustness</code> that each block defines:
     <ul>
     <li><code>During</code> and <code>WhenRising</code> / <code>WhenFalling</code> / <code>WhenChanging</code> take
         the robustness as a new input <code>rho</code> (default <code>if check then 1 else -1</code>, the
         uninformative sign; a caller writes <code>u - limit</code> for <code>check = u &gt; limit</code>);
         the <code>When*</code> blocks sample it at the edge that decides the property and hold it with the
         verdict.</li>
     <li><code>MinDuration</code> / <code>MaxDuration</code> / <code>BandDuration</code> gain the output
         <code>duration</code>, the running accumulated duration of the current (or last) phase, and the
         robustness <code>duration - durationMin</code>, <code>durationMax - duration</code>, the band's minimum.</li>
     <li><code>FixedRising</code> / <code>MinRising</code> / <code>MaxRising</code> / <code>BandRising</code> /
         <code>NoRising</code>: <code>countRising</code> is an output (NoRising gains the counter); the robustness
         is the count difference (<code>-abs(count - nRising)</code> for the exact count, 0 when satisfied).</li>
     <li><code>MaxRisingFrequency</code>: <code>freqHzMax - freqHz</code>; <code>WithinDomain</code>:
         <code>distance</code>; the sliding-window blocks: the limit minus their window quantity
         (<code>maxDuration</code>, <code>accumulatedDuration</code>, <code>nRising</code>, <code>freqHzMean</code>,
         <code>increase</code>, <code>percentageIncrease</code>), the band blocks the minimum of both sides; the
         FFT blocks <code>scaledDistance/scale</code>.</li>
     </ul>
     A block that is still Undecided (a duration not yet reached, a sliding window not yet full) has a
     provisional margin; a consumer takes the worst value over the decided points.</li>

<li> <a href=\"modelica://Requirements.LogicalFunctions.marginAnd\">LogicalFunctions.marginAnd</a> /
     <a href=\"modelica://Requirements.LogicalFunctions.marginOr\">marginOr</a>: the minimum / maximum of the
     margins over the elements whose property is not Undefined -- the margin of <code>and4All</code> /
     <code>or4All</code>, an inapplicable element dropping out as it does there; 0 (no NaN) when nothing is
     applicable.</li>

<li> <a href=\"modelica://Requirements.Examples.Elementary.Margin\">Examples.Elementary.Margin</a>: eight examples,
     one per block family, asserting the margins against closed-form values at every instant and the sign
     invariant (satisfied &hArr; margin &ge; 0) continuously -- a ramp against a threshold, a sine against a band,
     the three duration blocks on one phase, the five count blocks on one edge train, a 2 Hz train against
     <code>MaxRisingFrequency</code>, a point crossing a square, a ramp against <code>MaxIncrease</code>, and the
     FFT example with a scale. Each is a case in the regression lists beside the library, with the margins stored.</li>

<li> <code>conversion(noneFromVersion=\"0.8.0\")</code>: no model needs conversion; every existing output is
     unchanged (the regression references of version 0.8.0 stand), the new outputs and parameters have defaults.</li>
</ul>
</html>"));
  end Version_0_9_0;

  class Version_0_8_0 "Version 0.8.0 (Sept. 15, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
<b>Four-valued logic.</b> <a href=\"modelica://Requirements.Types.Property\">Types.Property</a> gains a
fourth value, <code>Undefined</code>: the property is <em>not applicable</em> (its condition, time locator
or scope is false, or the component it is stated for is absent), as distinct from <code>Undecided</code>,
which now means <em>applicable but not yet decided</em> (a duration not yet reached, a count still below
its minimum, a sliding window not yet full, an FFT with too few periods). The operators follow the
extended temporal logic (ETL) of EDF's ReqSysPro and the CRML language: Undefined is the neutral element
of <em>and</em> and <em>or</em>, so a check that is outside its period, or a component to which a
requirement does not apply, drops out of a combination instead of holding it Undecided. This is a change
of requirement semantics; the library's version is raised accordingly.
</p>

<h4>Changes</h4>
<ul>
<li> <code>Types.Property = enumeration(Violated, Undecided, Satisfied, Undefined)</code>. Undefined is
     <b>appended</b> (Integer value 4): the values 1, 2, 3 of every stored result stay valid, and a consumer
     that knows three values fails on a 4 instead of misreading it. <code>Types.Boolean4</code> is CRML's
     name for the same type. The value order carries no meaning (the algebra has two different orders);
     a combination is never a <code>min</code> or <code>max</code> over the values.</li>

<li> <a href=\"modelica://Requirements.LogicalFunctions\">LogicalFunctions</a>: <code>and4</code>,
     <code>or4</code>, <code>not4</code> (the 16-entry tables, transcribed from the CRML specification),
     <code>and4All</code>, <code>or4All</code> (the folds over a vector, seeded with Undefined; the empty
     vector gives Undefined) and <code>cardUndefined</code>. <code>forall3</code> is superseded by
     <code>and4All</code> and delegates to it for a non-empty vector. <code>IntegerToProperty</code>
     accepts 4; <code>during</code> and <code>during3</code> return Undefined, not Undecided, while their
     condition is false.</li>

<li> <a href=\"modelica://Requirements.LogicalBlocks\">LogicalBlocks</a>: <code>PropertyAnd</code>,
     <code>PropertyOr</code> and <code>PropertyNot</code> delegate to the functions; an unconnected
     PropertyAnd / PropertyOr (<code>nu = 0</code>) is Undefined, the neutral element (was Satisfied /
     Violated). <code>PropertyToBoolean</code> gains <code>parameter Boolean undefined = false</code>
     beside <code>undecided</code>. <code>IntegerToProperty</code> accepts 4; <code>Sources.PropertyConstant</code>
     offers the fourth literal and <code>Sources.PropertyTable</code> accepts 4 in its table.</li>

<li> <b>Every check block of <a href=\"modelica://Requirements.ChecksInFixedWindow\">ChecksInFixedWindow</a>
     emits Undefined while its condition is false</b>, and before the first true condition phase (the
     value was Undecided): <code>During</code>, <code>WithinDomain</code>, <code>WhenRising</code>,
     <code>WhenFalling</code>, <code>WhenChanging</code>, <code>MaxRising</code>,
     <code>MaxRisingFrequency</code> outside the phase; the initial value of <code>MinDuration</code>,
     <code>MaxDuration</code>, <code>BandDuration</code>, <code>NoRising</code>, <code>FixedRising</code>,
     <code>MinRising</code>, <code>BandRising</code> when the condition is false at initialization. Inside a
     true condition phase Undecided keeps its meaning (not yet decidable), and a block that decides at the
     end of a phase keeps that verdict on its output after the phase, as before. The FFT checks
     (<a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a>) are
     Undefined before the first rising edge of their condition and Undecided from that edge until the first
     FFT is computed (the output is now an equation over the internal <code>yFFT</code> and the FFT counter,
     no longer assigned in the when-clause; the blocks' results at and after the FFT instants are unchanged).
     The sliding-window checks have no condition input and never emit Undefined.</li>

<li> <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> (through
     <a href=\"modelica://Requirements.Interfaces.PartialRequirement\">PartialRequirement</a>) and
     <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> collapse the four values to
     the three verdicts: a property that was Undefined or Undecided throughout is <em>untested</em>; the
     <code>status</code> stays 0 / 1 / 2 and the satisfaction percentage is unchanged. New beside every
     verdict: <b>attempts</b>, the number of phases in which the property was applicable (not Undefined);
     an untested requirement with 0 attempts was never applicable, one with attempts &gt; 0 was applicable
     but never decided. The log file gains the attempts as a column before the text
     (<code>Violated,&lt;observation&gt;,&lt;requirement&gt;,&lt;first failure time&gt;,&lt;attempts&gt;,&lt;text&gt;</code>;
     <code>Untested,...,&lt;attempts&gt;,&lt;text&gt;</code>), the printed summary and the HTML log show them.</li>

<li> <a href=\"modelica://Requirements.Examples.Elementary.LogicalBlocks.PropertyTable4\">Examples.Elementary.LogicalBlocks.PropertyTable4</a>
     asserts every entry of the three tables through the blocks (all 16 pairs over 16 s) and the functions,
     the laws that hold (commutativity, associativity, involution, De Morgan), and the laws that <b>fail</b>
     with counterexamples: absorption (12 of 64 triples) and distributivity (6 of 64) fail wherever
     Undefined is involved, in addition to the complements law the CRML paper acknowledges. The algebra is
     not a lattice; <b>an expression over Property values must never be simplified</b> by Boolean rewriting.</li>

<li> <code>conversion(noneFromVersion=\"0.7.1\")</code>: no model needs conversion. A model that reads a
     stored Property result as three values must be updated to accept 4.</li>
</ul>

<h4>Effect on the examples' results</h4>
<p>
Wherever a check block's condition is false, its output moves from Undecided (2) to Undefined (4); the
Satisfied and Violated phases, and the Undecided phases inside a true condition, are unchanged, and so
is every verdict printed by PrintViolations. The regression baselines beside this library
were re-established on OpenModelica, Dymola and Modelon Impact for this
version, with the changed references explained as Undecided &rarr; Undefined.
</p>
</html>"));
  end Version_0_8_0;

  class Version_0_7_1 "Version 0.7.1 (Sept. 14, 2026)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
Maintenance release. The library now runs in a third Modelica tool, Modelon Impact, and
its examples have been simulated with Dymola, OpenModelica and Modelon Impact and compared
tool against tool. No requirement semantics changed: every change below was checked to
leave the Dymola and OpenModelica results of every example unchanged.
</p>

<h4>Changes</h4>
<ul>
<li> <code>uses(Modelica(version=\"4.1.0\"))</code>. No change in the library was needed for
     the Modelica Standard Library 4.1.0.</li>

<li> <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> has two new parameters on its Advanced tab,
     <code>useEvaluationTime</code> (default <code>false</code>) and <code>evaluationTime</code>.
     The verdict of a requirement model is taken and printed at <code>terminal()</code>; a tool that
     does not support <code>terminal()</code> (Modelon Impact evaluates it to <code>false</code>) never
     printed it. With <code>useEvaluationTime = true</code> the verdict is taken at
     <code>evaluationTime</code> instead. <a href=\"modelica://Requirements.Interfaces.PartialVerify\">PartialVerify</a> passes both
     parameters through and <a href=\"modelica://Requirements.Interfaces.PartialRequirement\">PartialRequirement</a> reads them from the
     inner <code>printViolations</code>. Every example sets <code>evaluationTime</code> to its StopTime,
     so switching the option on is all such a tool needs; with the default the behaviour is as before.</li>

<li> <a href=\"modelica://Requirements.LogicalBlocks.FallingEdgeTerminate\">FallingEdgeTerminate</a> has a new parameter
     <code>delay</code> (default 0, Advanced tab): the simulation terminates that long after the falling
     edge instead of at it. A tool that stores only the pre-event state at a <code>terminate()</code>
     instant (Modelon Impact) otherwise drops the verdict a requirement block takes at that very
     edge from its result. Dymola and OpenModelica record the edge's values and need no delay.</li>

<li> <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a> did not run in
     Modelon Impact at all (the branch of an earlier port notes this). Four independent causes, each
     fixed in a form that leaves Dymola and OpenModelica bit-identical:
     <ol>
     <li> <code>Internal.checkDomain</code> declared local arrays <code>diff[:]</code>, <code>f[:]</code>.
          A function's local array needs a size that follows from its inputs; Impact refuses an
          undefined size. Both are now sized <code>size(A,1)</code>, the checked band is the slice
          <code>1:n</code>, and the division by the limit curve's maximum is guarded against an
          all-zero curve.</li>
     <li> <code>Internal.PartialFFT</code> starts its sampling chain through the edge
          <code>condition and not pre(condition)</code>, relying on the initial equation
          <code>pre(condition) = false</code> for a condition that is already true at
          initialization. A tool that initializes <code>pre(condition)</code> to the condition's own
          value never sees that edge, and the block was dead for the whole run. The start is now
          explicit: <code>(condition and not pre(condition)) or (initial() and condition)</code>.</li>
     <li> The FFT examples stop through <code>FallingEdgeTerminate</code> at the instant their
          FFT is evaluated; without the new <code>delay</code>, Impact's result did not contain the
          verdict.</li>
     <li> <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.WithinRelativeDomain\">WithinRelativeDomain</a> and
          <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.MaxTotalHarmonicDistortion\">MaxTotalHarmonicDistortion</a> evaluated
          their chain (base frequency, scaled limit curve or THD, check, icon curves) as eight
          equations in one when-clause. A tool that evaluates a when-body with the pre-event values
          of the variables assigned in that same when-clause (Impact, measured with an eleven-line
          model) checked the FFT against a limit curve scaled by the previous base amplitude, zero
          before the first FFT, and reported Violated for a satisfied requirement. Split over
          several when-clauses with the same condition, the same tool built a nonlinear block around
          them and failed its initialization in a fraction of the runs. The chain is now one
          function call, <code>Internal.checkRelativeDomain</code> and <code>Internal.checkTHD</code>.</li>
     </ol></li>

<li> <a href=\"modelica://Requirements.LogicalFunctions.card\">card</a>, <code>cardSatisfied</code>,
     <code>cardUndecided</code>, <code>cardViolated</code>: the reduction is written over the indices,
     <code>sum(if p[i] == ... then 1 else 0 for i in 1:size(p, 1))</code>, instead of over the elements.
     The same count; Modelon Impact fails to scalarize the element form (\"Exception caught while
     scalarizing function cardSatisfied\"), which took
     <code>Examples.AircraftRequirements.MinimumOperationalServiceLife</code> down with it.</li>

<li> <a href=\"modelica://Requirements.Examples.MotorsWithLosses\">Examples.MotorsWithLosses</a> and
     <a href=\"modelica://Requirements.Examples.SimplePumpingSystem.CheckPumpingSystem\">Examples.SimplePumpingSystem.CheckPumpingSystem</a>
     passed model instances to their binding functions (<code>watchDCMotor(obj=dcpm1)</code>,
     <code>TankObservation_from_OpenTank(reservoir)</code> and the like) where the function input is a record.
     That is a Dymola extension; the form the Modelica Language Specification allows (3.6, section 12.6.1,
     the record cast <code>R(m)</code>) turned out to be implemented by Dymola alone: OpenModelica 1.27.1 reads
     it as a positional constructor call and Modelon Impact refuses any access to a model instance in an
     expression, in the implicit and the explicit form alike. The call sites now build the observation
     records with explicit record constructors, nested and vectorized where the instance was
     (<code>MotorData(VaNominal=dcpm1.VaNominal, ..., inertiaRotor=InertiaData(w=dcpm1.inertiaRotor.w))</code>),
     which all three tools run; <code>MotorData</code> and <code>InertiaData</code> moved out of the
     function's protected section so the call site can name them. Two consequences of the same measurement:
     <code>DCMotorWatching</code>'s nominal values lost their <code>parameter</code> prefix and the current
     limit in <code>DCMotorRequirements</code> became a <code>BooleanExpression</code> like the speed limit
     (a record with parameter components returned by a function is continuous-time to Impact and
     over-determined to OpenModelica); and the source and sink observations are built with the
     <code>Source</code> record constructor directly, <code>SourceObservation_from_PartialSource</code> and
     <code>Records.PartialSource</code> being removed, because OpenModelica 1.27.1 silently returns zeros
     from a function whose result is a record with an array component when the call has parameter
     variability, as a fixed boundary's pressures have. Both examples now simulate in OpenModelica and
     Modelon Impact with agreeing results.</li>
</ul>

<h4>Three tools compared</h4>
<p>
All 68 example models under <a href=\"modelica://Requirements.Examples\">Examples</a> that carry an
<code>experiment</code> annotation were simulated with each tool with that annotation's StopTime and
Interval, CVode, a relative tolerance of 1e-6 (the annotation's Tolerance where it has one), and every
block output <code>*.y</code> was compared between tools on the output grid (an absolute
tolerance of 1e-3 of each signal's range, or its switching instants for a Boolean or Property
signal). The case lists, the stored results of the three tools and the reports belong to the
regression baselines, not to the library's packages.
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Tool</th><th>Examples simulated</th><th>Not simulated, and why</th></tr>
<tr><td valign=\"top\">Dymola 2026x</td>
    <td valign=\"top\">60</td>
    <td valign=\"top\">8 refused by the license used for the comparison (\"the model is too
        complex for the current license\", about 1000 unknowns): <code>MainPowerSupplyRequirements</code>,
        <code>LimitedCabinAltitudeRateOfChange</code>, four of the six FFT examples,
        <code>CheckMotorWithLosses</code>, <code>CheckPumpingSystem</code>. Not a library problem.</td></tr>
<tr><td valign=\"top\">OpenModelica 1.27.1</td>
    <td valign=\"top\">48</td>
    <td valign=\"top\">20 do not build: the 14 examples using a sliding-window block
        (\"No runtime support for this record assignment\" for the buffer record returned by
        <code>Internal.SlidingWindow.push</code>) and the 6 FFT examples
        (\"Internal error BackendDAECreate.lowerWhenEqn: equation not handled\").</td></tr>
<tr><td valign=\"top\">Modelon Impact (Sept. 2026)</td>
    <td valign=\"top\">68 (63 of them with a reference to compare against)</td>
    <td valign=\"top\">&mdash;</td></tr>
</table>

<p>
<b>OpenModelica against Dymola</b>, on the 45 examples both simulate: every continuous signal
agrees to better than 1e-4 of its range (most to 1e-13 or exactly), and every Boolean and Property
signal switches at identical instants in both tools; the only grid points that differ are those
instants themselves, sampled on opposite sides of the event. One example,
<code>SimplePumpingSystem.Components.PumpingSystem</code>, is an on-off pressure controller over
2000 s whose switching instants move with the tolerance, within one tool as between two.
</p>

<p>
<b>Modelon Impact against Dymola</b> (and against OpenModelica for the three examples Dymola's license
refuses and OpenModelica builds): on the 63 examples with a reference, all 296 signal checks pass. The 85 continuous signals lie inside their tolerance tube everywhere (a funnel error of exactly 0); of the 208 signals compared at their final value, 205 are identical and the other three agree to 5e-9; the relay signals of <code>PumpingSystem</code> agree by accumulated difference within the tolerance measured for Dymola against itself. The other 5 examples Impact simulates (<code>MainPowerSupplyRequirements</code> and four FFT examples) have no reference from either other tool.
</p>

<h4>Tool support for the record cast</h4>
<p>
The Modelica Language Specification (3.6, section 12.6.1) lets a record constructor take a model, block or
connector instance as its single argument, <code>R(m)</code>, copying the public components whose names
match, recursively and vectorized. Of the three tools compared here, only Dymola implements it (measured
2026-09-14 on a probe library); Dymola also accepts the instance itself where a record is expected, which
this library relied on until this release. The explicit record constructor,
<code>R(a=m.a, sub=S(w=m.sub.w))</code>, is what all three run, and it is what the examples now use.
</p>

<h4>New: reading signals from a MA-HS-CSV file</h4>
<p>
<a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">Sources.PartialSignalsFromFile</a> reads a file in the
Modelica Association's MA-HS-CSV format &mdash; Real, Boolean and Integer columns by name, same-time rows as events,
a time event scheduled at every instant a discrete column changes &mdash; through the external object and functions of
<a href=\"modelica://Requirements.Internal.CSV\">Internal.CSV</a> and a header-only C reader
(<code>Resources/Include/RequirementsCsv.h</code>, C89, tested against a Python reader in
<code>Resources/C-Sources/test/</code>). The block is the seam of a two-run verification: the plant is simulated alone,
its outputs are stored, and the requirement checks run on the stored signals in a second run.
Example: <a href=\"modelica://Requirements.Examples.Elementary.Sources.SignalsFromFile\">Examples.Elementary.Sources.SignalsFromFile</a>,
simulated in OpenModelica 1.27.1 and Modelon Impact with identical results. Dymola 2026x's current license refuses any user-defined
<code>ExternalObject</code> (\"too complex for the current license\", measured 2026-09-14), so the example is skipped there until the license changes.
</p>
</html>"));
  end Version_0_7_1;

  class Version_0_7_0 "Version 0.7.0 (Feb. 13, 2025)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
Updated implementation to Modelica 4.0.0.
</p>
</html>"));
  end Version_0_7_0;

  class Version_0_6_1 "Version 0.6.1 (Feb. 3, 2025)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
License changed to BSD 3-Clause license.
</p>
</html>"));
  end Version_0_6_1;

  class Version_0_6 "Version 0.6 (April 19, 2016)"
  extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p>
First version of the library provided to the public.
</p>
</html>"));
  end Version_0_6;

 annotation (Documentation(info="<html>

<p>
This section summarizes the changes that have been performed
on package Requirements. An overview of all changes and additions made in 2026
(versions 0.7.1 to 0.12.0) is given in
<a href=\"modelica://Requirements.UsersGuide.ReleaseNotes.Summary2026\">Summary of 2026</a>.
</p>
</html>"));
end ReleaseNotes;

class Contact "Contact"
  extends Modelica.Icons.Contact;

 annotation (Documentation(info="<html>
<dl>
<dt><strong>Main Author</strong></dt>
<dd>Martin Otter<br>
    German Aerospace Center (DLR)<br>
    Robotics and Mechatronics Center<br>
    <a href=\"http://www.dlr.de/rmc/sr/en/desktopdefault.aspx/tabid-8018/\">Institute of System Dynamics and Control</a><br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a><br></dd><p><strong>Current Maintainer and Author of Redesign</strong>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <br>&nbsp; &nbsp; Hubertus Tummescheit<br>&nbsp; &nbsp; Model Based Innovation LLC<br>&nbsp; &nbsp;&nbsp;<a href=\"https:www.modelbased.cloud\">www.modelbased.cloud</a><br>&nbsp; &nbsp; email:<a href=\"mailto:hubertus.tummescheit@modelbased.cloud\">hubertus.tummescheit@modelbased.cloud</a>&nbsp;<br>&nbsp; &nbsp; Source and issues: <a href=\"https://github.com/MBILLC/Requirements\">github.com/MBILLC/Requirements</a><br></p><p><br></p>
</dl>
<p><strong>Acknowledgements:</strong></p>

<ul>
<li> The structuring and most operators/models of this library are based on
     the informally defined <strong>FORM-L</strong> language by Nguyen Thuy from EDF.
     The backup-power-supply example is based on a description by
     Nguyen Thuy from EDF.</li>

<li> The example models in sublibrary <a href=\"modelica://Requirements.Examples.AircraftRequirements\">AircraftRequirements</a>
     have been provided by the aircraft manufacturer Dassault Aviation and implemented by Dassault Aviation and DLR.</li>

<li> Some operators/models are based on work
     by Dassault Aviation (such as <a href=\"modelica://Requirements.SignalAnalysis\">SignalAnalysis</a>)
     and by DLR (such as <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a>).
     </li>

<li> The functions \"card\", \"forall\" and \"exists\" are based on a design
     by Hilding Elmqvist from Dassault Systèmes Lund.</li>

<li> The functions \"first\", \"last\", \"oneTrue\"
     and the blocks \"WhenFalling\", \"WhenChanging\" are from Andrea Tunis (UNICAL).</li>

<li> Wladimir Schamai suggested to use a mix of 2- and 3-valued logic.</li>

<li> Earlier versions of this library have been tested with Dymola, OpenModelica and SimulationX.</li>

<li> Most of this library was developed within the ITEA2 project
     <a href=\"https://www.modelica.org/external-projects/modrio\">MODRIO</a>. Partial financial support of
     the German BMBF, the French DGE, and the Swedish VINNOVA are highly appreciated.</li>

<li> The FFT-based property blocks of this library
     (<a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a>)
     have been developed and implemented with help of partial funding in the European Union’s Seventh Framework Programme
     (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under grant agreement no. CSJU-GAM-SGO-2008-001.
     This support is highly appreciated.</li>
</ul>
</html>"));

end Contact;

annotation (DocumentationClass=true, Documentation(info="<html>
<p>
Library <b>Requirements</b> is a Modelica package
using temporal logic to formally define requirements
and automatically test these requirements when a model
is simulated.
</p>
<p>
<b>Origin.</b> Requirements is Model Based Innovation LLC's derivative of
<a href=\"https://github.com/modelica-3rdparty/Modelica_Requirements\">Modelica_Requirements</a>
version 0.7.1 (BSD 3-Clause), renamed on 2026-09-14. Its source, releases and issue tracker are
in the public repository <a href=\"https://github.com/MBILLC/Requirements\">https://github.com/MBILLC/Requirements</a>.
The license and the copyright notices of the original authors are unchanged;
see the <a href=\"modelica://Requirements.UsersGuide.Contact\">Contact</a> page and the
LICENSE file. Additions made here (a MA-HS-CSV signal reader and what builds on it)
are not part of the upstream library.
</p>
<p>
<b>Two runs, one file.</b> The additions serve a signal-based, two-run verification: the plant is simulated <em>alone</em>, with no
requirement block in it, its glossary signals are stored in one MA-HS-CSV file, and the
check blocks of this library run on that file in a second run through
<a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">Sources.PartialSignalsFromFile</a>.
Because the only thing that crosses from the simulation to the checks is a file of named
signals, the design transfers to <b>any FMI- or SSP-based tool</b>: whatever simulates the
plant -- a Modelica tool, an FMU in any master, an SSP system in a co-simulation platform --
produces the signals, and the checking engine (these blocks, or a monitor FMU built from them,
or a Python evaluation of the stored trajectories) is a separate tool that never alters the
simulation it judges. Separating the simulation from the checking engine is what opens the
library to tools it was never written for.
</p>
<p>
<b>Self-contained.</b> Everything in the library works in a plain Modelica tool: a check model holds
the requirement blocks and one <a href=\"modelica://Requirements.Verify.PrintViolations\">Verify.PrintViolations</a>,
and a simulation prints which requirements are violated, untested or satisfied. That holds for transient
requirements, for steady-state requirements
(<a href=\"modelica://Requirements.Examples.SteadyState.CheckHeatExchanger\">Examples.SteadyState.CheckHeatExchanger</a>)
and for eigenvalue requirements over a linearization
(<a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a>; the linearization itself is done with
whichever tool the user has).
</p>
<p>
<b>Relation to ModCheck.</b> The library is also the Modelica checking engine of
<a href=\"https://github.com/MBILLC/ModCheck\">ModCheck</a>, a regression-testing and
requirements-verification framework. ModCheck generates check models from requirement statements, runs the
two-run workflow above, parameter sweeps and linearizations across Modelica tools, and evaluates some
requirement families (step-response metrics, eigenvalue predicates) on the stored trajectories in Python as
well, with this library's blocks as an independent cross-check. The regression baselines of the library's
examples on Dymola, OpenModelica and Modelon Impact were produced with it and are kept in
<code>Resources/ModCheck/</code>. Nothing in the library depends on ModCheck, and the rest of this
documentation does not refer to it.
</p>
</html>"));
end UsersGuide;

  annotation (preferredView="info",
  uses(Modelica(version="4.1.0")),
version="0.12.0",
versionDate="2026-10-19",
dateModified = "2026-10-16",
conversion(noneFromVersion="0.7.1", noneFromVersion="0.8.0", noneFromVersion="0.9.0", noneFromVersion="0.9.1", noneFromVersion="0.10.0", noneFromVersion="0.11.0", noneFromVersion="0.11.1"),
revisionId="$Id:: package.mo 9390 2016-06-21 06:35:11Z #$",
Documentation(info="<html>
<p>
Library <b>Requirements</b> is a Modelica package
to formally define requirements and checking them automatically
when a model is simulated. An overview of this library is given in the publication
<a href=\"modelica://Requirements/Resources/Documentation/ecp15118625.pdf\">Formal Requirements Modeling for Simulation-Based Verification</a>
</p>

<p>
In order to define properties and requirements mostly a 2-valued logic is used.
There are some functions and blocks based on 4-valued logic using type
<a href=\"modelica://Requirements.Types.Property\">Property</a>
(Violated, Undecided, Satisfied, Undefined; since version 0.8.0, with the extended temporal
logic of EDF's ReqSysPro / CRML), especially
block <a href=\"modelica://Requirements.Verify.Requirement\">Requirement</a>.
Furthermore, there are cast-operators to map 2-valued to 4-valued logic and vice versa.
4-valued logic is used to define (a) if a property is not applicable (Undefined: only relevant
in a certain situation, and outside it), (b) if a property is applicable but not yet decided
(Undecided) and (c) if a requirement was not tested in a simulation run. The four values
combine with <code>and4</code> / <code>or4</code> / <code>not4</code>, where Undefined is the
neutral element; the algebra is not a lattice and Property expressions are never simplified.
</p>

<p>
In this package the standard convention is used that names of
memory-less operators (implemented as Modelica functions)
start with lower-case letters and names of operators
with memory (implemented as Modelica blocks) start with
upper-case letters.
</p>

<p>
This package uses basically Modelica 3.6 language elements and requires at least version 4.0.0 of
the Modelica Standard Library.
Additionally, the Modelica extension is used in some examples (but not outside of examples) to
pass a model instance as argument to a function (and the function argument is a record).
This feature is used to associate requirements in a reasonably convenient way with
behavioral models. This approach is currently under discussion at the Modelica Association.
Most likely a slightly different concept will be introduced in the next release of the
Modelica language by providing the cast of a model to a record. Once this is clear and
prototypes are available in Modelica tools, this new concept will be used in this library.
Earlier versions of this library contained also examples utilizing
the proposed new Modelica language element to \"call a block as a function\". These examples had been
removed from this version.
</p>

<p>
The current version of the library uses a buffer for the implementation of
sliding windows (<a href=\"modelica://Requirements.Internal.SlidingWindow\">Internal.SlidingWindow</a>).
The size of this buffer is fixed to 20 (constant nBuffer in package SlidingWindow).
If the buffer is too small for a requirement from package
<a href=\"modelica://Requirements.ChecksInSlidingWindow\">ChecksInSlidingWindow</a>,
then a warning is printed.
The result of the requirement verification might then not be correct.
</p>

<p>
<b>This package is not yet finalized. A redesign is planned. The redesigned library (with improved implementations
of models and new functionality) should be backwards compatible to this version, but
it is not guaranteed. If non-backwards compatible changes are introduced, most likely
automatic conversions will not be provided.</b>.
</p>

<p>
<i>This Modelica package is <u>free</u> software and
the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the
3-Clause BSD license, see the license conditions (including the
disclaimer of warranty) at
<a href=\"https://github.com/modelica-3rdparty/Modelica_Requirements/blob/master/LICENSE\">
https://github.com/modelica-3rdparty/Modelica_Requirements/blob/master/LICENSE</a>.</i>
</p>


<p>
<b>Copyright &copy; 2014-2016, DLR, Dassault Aviation and UNICAL</b>
</p>
</html>"));
end Requirements;
