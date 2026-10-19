within Requirements;
package Types "Library of type definitions"
  extends Modelica.Icons.TypesPackage;

 type Property = enumeration(
      Violated,
      Undecided,
      Satisfied,
      Undefined) "Enumeration defining literals for four-valued logic (ETL): Undefined = not applicable, the neutral element of and/or"  annotation (
       Documentation(info="<html>
<p>
Enumeration defining literals for four-valued logic to model properties and requirements
(a requirement is a property that should be Satisfied). The second column (Integer value)
defines the (Modelica) value of the enumeration that is, for example, used when
storing a value in a result file.
</p>

<p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\"><b>Literal</b></td>
    <td valign=\"top\"><b>Integer value</b></td>
    <td valign=\"top\"><b>Description</b></td></tr>
<tr><td valign=\"top\">Violated</td>
    <td valign=\"top\" align=\"center\">= 1</td>
    <td valign=\"top\">The property is violated.</td></tr>
<tr><td valign=\"top\">Undecided</td>
    <td valign=\"top\" align=\"center\">= 2</td>
    <td valign=\"top\">The property is applicable, but neither satisfied nor violated yet
        (a window not yet full, a count still below its minimum, an FFT with too few periods).</td></tr>
<tr><td valign=\"top\">Satisfied</td>
    <td valign=\"top\" align=\"center\">= 3</td>
    <td valign=\"top\">The property is satisfied.</td></tr>
<tr><td valign=\"top\">Undefined</td>
    <td valign=\"top\" align=\"center\">= 4</td>
    <td valign=\"top\">The property is not applicable: its condition (time locator, scope) is false,
        or the component it is stated for is absent. Its value must not affect a logical
        combination, so it is the neutral element of <code>and4</code> and <code>or4</code>.</td></tr>
</table>
</p>

<h4>Four-valued logic</h4>
<p>
The four values and their operators follow the extended temporal logic (ETL) of EDF's
ReqSysPro and the CRML language (Bouskela et&nbsp;al., <i>Formal requirements modeling for
cyber-physical systems in CRML</i>, Modelica Conference 2023). In CRML's names,
<code>true4</code> is Satisfied, <code>false4</code> is Violated, <code>undecided</code> is Undecided
and <code>undefined</code> is Undefined; <code>CRML.Blocks.Logical4.and4/or4/not4</code> correspond to
<a href=\"modelica://Requirements.LogicalFunctions.and4\">LogicalFunctions.and4</a>,
<a href=\"modelica://Requirements.LogicalFunctions.or4\">or4</a> and
<a href=\"modelica://Requirements.LogicalFunctions.not4\">not4</a>, whose documentation holds the
tables. Three rules generate every table entry: Undefined is a neutral element of every logical
operation (<code>Undefined op x = x</code>); an Undecided operand gives Violated for <code>and</code>
when the other operand is Violated and Undecided otherwise, and Satisfied for <code>or</code> when the
other operand is Satisfied and Undecided otherwise; negation fixes both Undecided and Undefined;
on {Satisfied, Violated} the operators are classical.
</p>

<p>
Undefined is appended as the fourth literal (Integer value 4): the three earlier values keep
their Integer values in every stored result, and a consumer that only knows three values fails
on a 4 instead of misreading it. The value order carries no meaning: the algebra has two
different orders (Undefined is the top of the <code>and</code>-order and the bottom of the
<code>or</code>-order), so a logical combination is never a <code>min</code> or <code>max</code> over the
Integer values.
</p>

<p>
<b>The algebra is not a lattice.</b> De Morgan's laws, involution, commutativity, associativity
and idempotence hold; the complements law (<code>a and not a = Violated</code>), absorption
(<code>a and (a or b) = a</code>) and distributivity fail whenever Undefined is involved
(<code>Undefined and (Undefined or Satisfied) = Satisfied</code>). <b>Do not apply Boolean simplification
to expressions over Property values</b>: the block diagram or expression must be evaluated as written.
<a href=\"modelica://Requirements.Examples.Elementary.LogicalBlocks.PropertyTable4\">Examples.Elementary.LogicalBlocks.PropertyTable4</a>
asserts every table entry and documents the failed laws with counterexamples.
</p>

<p>
At the boundary of a simulation, the four values collapse to three: a
<a href=\"modelica://Requirements.Verify.Requirement\">Requirement</a> whose property was Undefined or
Undecided throughout is <em>untested</em> (the log records the number of <em>attempts</em>, the times
the property became applicable, beside it); one that was Violated at any instant is
<em>violated</em>; otherwise it is <em>satisfied</em>.
</p>

</html>"));

  type Boolean4 = Property "CRML's name for the four-valued logic type (Requirements.Types.Property)";

   type Event = Boolean
    "Boolean that is only used as edge-type to emulate event signals";

  type StepTarget = enumeration(
      Stepping "The stepping signal after the step (the setpoint of a closed loop)",
      Reference "A reference signal's current value (a disturbance step measured against the setpoint)")
    "The target a step-response metric measures the response against; the response's own final value has no running form and is not offered"
    annotation (Documentation(info="<html>
<p>The target <code>yInf</code> of a step response's metrics: <b>Stepping</b> -- the stepping signal's
value after the step, the setpoint of a closed loop; <b>Reference</b> -- a separate reference signal's
current value, for a disturbance step measured against the setpoint. A third target one might want, the
response's own final value, is only known when the window closes and has no running form; the blocks do
not offer it (evaluate it on the stored trajectory after the run).</p>
</html>"));

  type EigenMetric = enumeration(
      RealPart "Every mode's real part below the bound [1/s]",
      Damping "Every mode's damping ratio -Re/|lambda| at least the bound",
      FrequencyMin "Every mode's frequency |lambda|/2 pi [Hz] at least the bound",
      FrequencyMax "Every mode's frequency [Hz] at most the bound",
      TimeConstant "Every decaying mode's time constant -1/Re [s] at most the bound; a non-decaying mode violates it")
    "The eigenvalue predicates over the modes of a state matrix"
    annotation (Documentation(info="<html>
<p>The eigenvalue predicates of a linear-analysis requirement, as
<a href=\"modelica://Requirements.LinearAnalysis.EigenvalueCheck\">LinearAnalysis.EigenvalueCheck</a> evaluates them
over the modes of a state matrix; the pole region is
<a href=\"modelica://Requirements.LinearAnalysis.EigenvaluesWithinRegion\">EigenvaluesWithinRegion</a>.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));

  type StepMetric = enumeration(
      Overshoot "The excursion beyond the target, in the direction of the change",
      Undershoot "The excursion opposite to the change, beyond the starting value",
      RiseTime "From the lower to the upper level (level1 .. level2 of the change)",
      DelayTime "To half of the change",
      SettlingTime "The last exit from the band around the target",
      SteadyStateError "The deviation from the target at the window's end",
      DampingRatio "From the log decrement of the first two extrema beyond the target",
      DecayRatio "The third extremum over the first")
    "The classic step-response metrics"
    annotation (Documentation(info="<html>
<p>The eight classic metrics of a step response, as
<a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">StepResponseCheck</a> bounds them.</p>
</html>"));

  type WorstMarginMethod = enumeration(
      Continuous "Every local extremum of the margin (Modelica.Blocks.Math.ContinuousSignalExtrema): exact, one event per local extremum",
      Ratchet "Every new low by more than resolution: within resolution of the exact value, one event per resolution of descent")
    "How Verify.ViolationStatistics finds the worst margin"
    annotation (Documentation(info="<html>
<p>The two ways <a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a> tracks the least
margin of a run.</p>
<ul>
<li><b>Continuous</b> (the default) detects every local extremum of the margin with the derivative filter of
    <a href=\"modelica://Modelica.Blocks.Math.ContinuousSignalExtrema\">Modelica.Blocks.Math.ContinuousSignalExtrema</a>,
    which it extends. The worst margin is exact up to the filter's lag (about <code>T</code>, to be chosen from the margin's
time scale); the cost is one state event
    per local extremum of the margin, minima and maxima.</li>
<li><b>Ratchet</b> fires a state event only when the margin falls more than <code>resolution</code> below the least value
    found so far. The worst margin is within <code>resolution</code> of the exact value; the number of events is bounded by
    the depth of the descent divided by <code>resolution</code>, however much the margin oscillates. Use it for a margin
    with many small local extrema (a temperature under an oscillating controller).</li>
</ul>
</html>"));

end Types;
