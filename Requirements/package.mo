within ;
package Requirements "Requirements (Version 0.9.1) - Defining requirements formally and checking them when simulating"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

package ReleaseNotes "Release notes"
  extends Modelica.Icons.ReleaseNotes;

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
(seen on ModCheck's <code>TC-AC-CabinAltitudeRate-ShortExcursion</code>: a zero-length excursion out of the altitude-rate
envelope at the stop time). At the last row the function now returns the slope of the segment ending at it (at the
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
instantaneous value; the worst value over a run and its instant are taken from the stored trajectory (ModCheck's
plan, section 18.5, rule R2) -- there are no accumulators in the library, by design. Phase 12 of ModCheck's
requirements plan.
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
(<code>Resources/ModCheck</code>) were re-established on OpenModelica, Dymola and Modelon Impact for this
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
signal). The regression harness used is
<a href=\"https://github.com/MBILLC/ModCheck\">ModCheck</a>; the case lists, the stored results of
the three tools and the reports are kept beside it, not in this library.
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
on package Requirements.
</p>
</html>"));
end ReleaseNotes;

class Contact "Contact"
  extends Modelica.Icons.Contact;

 annotation (Documentation(info="<html>
<dl>
<dt><b>Main Author</b></dt>
<dd>Martin Otter<br>
    German Aerospace Center (DLR)<br>
    Robotics and Mechatronics Center<br>
    <a href=\"http://www.dlr.de/rmc/sr/en/desktopdefault.aspx/tabid-8018/\">Institute of System Dynamics and Control</a><br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a><br></dd>
</dl>
<p><b>Acknowledgements:</b></p>

<ul>
<li> The structuring and most operators/models of this library are based on
     the informally defined <b>FORM-L</b> language by Nguyen Thuy from EDF.
     The backup-power-supply example is based on a description by
     Nguyen Thuy from EDF.</li>

<li> The example models in sublibrary <a href=\"modelica://Requirements.Examples.AircraftRequirements\">AircraftRequirements</a>
     have been provided by the aircraft manufacturer Dassault Aviation and implemented by Dassault Aviation and DLR.</li>

<li> Some operators/models are based on work
     by Dassault Aviation (such as <a href=\"modelica://Requirements.SignalAnalysis\">SignalAnalysis</a>)
     and by DLR (such as <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT\">ChecksInFixedWindow_withFFT</a>).
     </li>

<li> The functions \"card\", \"forall\" and \"exists\" are based on a design
     by Hilding Elmqvist from Dassault Syst&egrave;mes Lund.</li>

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
version 0.7.1 (BSD 3-Clause), renamed on 2026-09-14 as the base for the
requirements-verification tooling of <a href=\"https://github.com/MBILLC/ModCheck\">ModCheck</a>.
The license and the copyright notices of the original authors are unchanged;
see the <a href=\"modelica://Requirements.UsersGuide.Contact\">Contact</a> page and the
LICENSE file. Additions made here (a MA-HS-CSV signal reader and what builds on it)
are not part of the upstream library.
</p>
<p>
<b>Two runs, one file.</b> The additions serve a signal-based, two-run verification
(ModCheck's requirements plan, rule R1): the plant is simulated <em>alone</em>, with no
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
</html>"));
end UsersGuide;

  annotation (preferredView="info",
  uses(Modelica(version="4.1.0")),
version="0.9.1",
versionDate="2026-09-15",
dateModified = "2026-09-15",
conversion(noneFromVersion="0.7.1", noneFromVersion="0.8.0", noneFromVersion="0.9.0"),
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
