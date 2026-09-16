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
    "The target a step-response metric measures the response against (ModCheck's requirements plan, section 21.2); the post-processing target 'the response's final value' has no running form and is Python's alone"
    annotation (Documentation(info="<html>
<p>The target <code>yInf</code> of a step response's metrics: <b>Stepping</b> -- the stepping signal's
value after the step, the setpoint of a closed loop; <b>Reference</b> -- a separate reference signal's
current value, for a disturbance step measured against the setpoint. The third target of ModCheck's
step-response requirements, the response's own final value, is only known when the window closes and has
no running form: <code>step_checks.py</code> evaluates it, the blocks refuse it.</p>
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
    "The step-response metrics of ModCheck's requirements plan, section 21.2"
    annotation (Documentation(info="<html>
<p>The eight metrics of a step response (ModCheck's requirements plan, section 21.2), as
<a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">StepResponseCheck</a> bounds them.</p>
</html>"));

end Types;
