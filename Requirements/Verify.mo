within Requirements;
package Verify "Library of components to verify requirements"
  extends Modelica.Icons.Package;

  model PrintViolations
    "Print violated, untested and satisfied requirements at end of simulation (drag in top level of your model)"
     import Modelica.Utilities.Streams.print;
     import Requirements.Internal;
     parameter String logFile = Internal.getFirstName(getInstanceName()) + "_log.txt"
      "Name of log file (default = <root name>_log.txt)";
     parameter String htmlFile = Internal.getFirstName(getInstanceName()) + "_log.html"
      "Name of html log file (default = <root name>_log.html)";
      parameter Boolean useEvaluationTime = false
        "= true: take the verdict at evaluationTime instead of at terminal() (tools without terminal())"
        annotation(Dialog(tab="Advanced"));
      parameter Modelica.Units.SI.Time evaluationTime = 1
        "Instant the verdict is taken at when useEvaluationTime = true"
        annotation(Dialog(tab="Advanced", enable=useEvaluationTime));
      parameter Boolean printViolated = true
      "= true, if violated requirements shall be printed"
       annotation(choices(checkBox=true));
      parameter Boolean printUntested = true
      "= true, if untested requirements shall be printed"
       annotation(choices(checkBox=true));
      parameter Boolean printSatisfied = true
      "= true, if satisfied requirements shall be printed"
       annotation(choices(checkBox=true));
     Requirements.Internal.SortingPort sortingPort(final dummy1=ok, final dummy2=0.0)
      "Dummy connector to enforce that printing to and reading from log file is performed in the correct order; do not connect to it)";
     final output Real satisfaction = noEvent(if abs(sortingPort.one) < 0.5 then 100.0 else 100*abs(sortingPort.status/(2*sortingPort.one)))
      "Satisfaction of all requirements in % (0% ... 100%)";
  protected
    constant String rootName = Internal.getFirstName( getInstanceName());
    Real ok annotation(HideResult=true);
  equation
    when initial() then
       ok = Internal.initializeLogFile(logFile, time, htmlFile);
    end when;

    // Opt-in for tools without terminal(): evaluate at a fixed instant instead.
    when (if useEvaluationTime then time >= evaluationTime else terminal()) then
       Internal.printViolationsToOutput(logFile, htmlFile, rootName, sortingPort.one,
                 satisfaction, time, printViolated, printUntested, printSatisfied);
    end when;

    annotation (
      defaultComponentName="printViolations",
      defaultComponentPrefixes="inner",
      missingInnerMessage="
Your model is using an outer \"printViolations\" component but
an inner \"printViolations\" component is not defined and therefore
a default inner \"printViolations\" component is introduced by the tool.
To change the default setting, drag Requirements.Verify.PrintViolations
into your model.
",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                           graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Text(
            extent={{-150,140},{150,100}},
            textString="%name",
            lineColor={175,175,175}),
            Line(
              points={{-48,-10},{-8,-68},{54,58}},
              color={0,127,0},
              smooth=Smooth.None,
              thickness=1),
          Text(
            extent={{-120,-105},{120,-135}},
            lineColor={0,0,0},
            textString="satisfaction:"),
          Text(
            extent={{-150,-140},{150,-175}},
            lineColor={0,0,0},
            textStyle={TextStyle.Bold},
            textString=DynamicSelect("???", String(satisfaction,format="3.1f")) + " %% at " +
                       DynamicSelect("???", String(time)) + " s")}),
      Documentation(info="<html>
<p>
Block PrintViolations has to be dragged in the top-level of the model, where components of
library Requirements are used. This block provides the file name, to which the Requirement
blocks write their status at the end of the simulation (whether a Requirement is Violated,
Untested or Satisfied, and in how many attempts, i.e. phases in which its property was applicable). Furthermore, the PrintViolations block reads this log-file at the end of
the simulation and prints a summary to the output window.
</p>

<p>
The verdict is taken and printed when <code>terminal()</code> becomes true. A tool that does not
support <code>terminal()</code> (Modelon Impact evaluates it to <code>false</code>) never prints it.
For such a tool, set <code>useEvaluationTime = true</code> and <code>evaluationTime</code> to the instant
the verdict shall be taken at, normally the simulation stop time (both on the Advanced tab). Every
example of this library sets <code>evaluationTime</code> to its StopTime, so that it prints in either
kind of tool once <code>useEvaluationTime</code> is switched on; with the default
<code>useEvaluationTime = false</code> the parameter has no effect.
</p>

<p>
A tool may evaluate the when-equations that take the verdict more than once at the same event instant
(Modelon Impact does). Each requirement writes its line to the log file only once, and the summary is
printed only once per run: the HTML report is removed at initialization, and printing stops as soon as
the report of this run exists.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> Parameters <code>useEvaluationTime</code> and <code>evaluationTime</code> added: opt-in verdict at a fixed instant for tools without <code>terminal()</code> (H. Tummescheit, Model Based Innovation LLC)</td></tr>
<tr><td valign=\"top\"> Oct. 16, 2026 </td>
    <td valign=\"top\"> The verdict is printed once in a tool that evaluates its when-equations twice at the event (Modelon Impact printed every requirement twice): the HTML report of an earlier run is removed at initialization and the summary is not printed again once the report exists; the log file holds one line per requirement (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end PrintViolations;

  block Requirement
    "Check requirement defined by Property input property (property shall be Property.Satisfied)"
    extends Requirements.Interfaces.PartialRequirement(final localProperty=property);
    Requirements.Interfaces.PropertyInput property
      "Property that shall be Satisfied"
      annotation (Placement(transformation(extent={{-340,-20},{-300,20}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-300,-100},{300,100}},
          initialScale=0.1), graphics={
          Rectangle(
            extent={{-300,100},{300,-100}},
            lineColor={0,0,0},
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Rectangle(
            extent={{-300,100},{-240,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Line(
            points={{-288,12},{-274,-30},{-252,42}},
            color={0,127,0},
            smooth=Smooth.None,
            thickness=0.5),
          Text(
            extent={{-230,90},{290,-90}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            horizontalAlignment=TextAlignment.Left,
            textString="%text"),
          Text(
            extent={{-300,150},{300,110}},
            textString="%name",
            lineColor={175,175,175})}),           Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-300,-100},{300,100}}),
                                                      graphics),
      Documentation(info="<html>
<p>
This block is used to verify a requirement. The input signal \"property\" can have the
four values Violated, Undecided, Satisfied or Undefined
(= elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>).
A requirement is violated, if property = Violated at any instant; it is untested, if property was
Undecided (applicable, not decided) or Undefined (not applicable) all the time; and it is satisfied
otherwise. The number of <em>attempts</em> (phases in which the property was not Undefined) is
logged beside the verdict. If a required property is naturally 
defined as Boolean, use block 
<a href=\"modelica://Requirements.Verify.BooleanRequirement\">BooleanRequirement</a>
instead.
</p>

<p>
With parameter <b>text</b> a textual description of the required property should be defined in
natural language.
This description is, for example, shown when a requirement is violated at the end of a simulation.
</p>

<p>
In the top level of a model, block <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a>
has to be dragged. This block prints an information message at the end of a simulation, whether
a Requirement has been violated, untested, or satisfied in the current simulation run
(the amount of output can be configured).
Furthermore, all Requirement instances store information about the Requirement in a log file
(the default name is \"&lt;root-name&gt;_log.txt\"; this name can be changed via parameter logFile
in the instance of PrintViolations. Exactly one line is printed in the log file with the status for every 
instance of a Requirement block.
</p>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.Verify.Requirement\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/Verify/Requirement1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/Verify/Requirement2.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
<b>Violation statistics.</b> With <code>computeStatistics = true</code> (tab Statistics) the block also counts
how often the property was violated, for how long in total and at most, and, with <code>useMargin = true</code>
and its <code>margin</code> input connected to the check block's <code>margin</code>, the worst margin and when.
The statistics are those of
<a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a>, which the block then
contains as <code>statistics</code>. They are logged as a <code>Statistics</code> line beside the verdict and
printed in the summary of PrintViolations. Example:
<a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.RequirementLog\">Examples.Elementary.ViolationStatistics.RequirementLog</a>.
</p>
<p>
In a textual definition, the Requirements block can be used as shown in this
<a href=\"modelica://Requirements.Examples.Textual.Elementary.Verify.Requirement\">example</a>: 
</p>

<blockquote>
<pre>
import Requirements.LogicalFunctions.*;
import Requirements.Types.Property;
Requirement R_Violated (property = PropertyToBoolean(check));
Requirement R_Undecided(property = Property.Undecided);
Requirement R_Satisfied(property = during(check, check));
</pre>
</blockquote>v
</html>"));
  end Requirement;

  block BooleanRequirement
    "Check requirement defined by Boolean input u (u shall be true for a satisfied requirement)"
    extends Requirements.Interfaces.PartialRequirement(final localProperty=Requirements.LogicalFunctions.BooleanToProperty(
                                                                                                    u));

    Modelica.Blocks.Interfaces.BooleanInput u
      "Boolean input that shall be true"
      annotation (Placement(transformation(extent={{-340,-20},{-300,20}})));
    annotation (defaultComponentName="requirement",Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-300,-100},{300,100}},
          initialScale=0.1), graphics={
          Rectangle(
            extent={{-300,100},{300,-100}},
            lineColor={0,0,0},
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Rectangle(
            extent={{-300,100},{-240,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Line(
            points={{-288,12},{-274,-30},{-252,42}},
            color={0,127,0},
            smooth=Smooth.None,
            thickness=0.5),
          Text(
            extent={{-230,90},{290,-90}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            horizontalAlignment=TextAlignment.Left,
            textString="%text"),
          Text(
            extent={{-300,150},{300,110}},
            textString="%name",
            lineColor={175,175,175})}),           Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-300,-100},{300,100}}),
                                                      graphics),
      Documentation(info="<html><p>
This block is used to verify a requirement. The Boolean input signal \"property\" shall always be true.
This signal is mapped to a 3-valued logic <a href=\"modelica://Requirements.Types.Property\">Property</a>
(= Property.Satisfied if true and Property.Violated if false).
</p>

<p>
In the top level of a model, block <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a>
has to be dragged. This block prints an information message at the end of a simulation, whether
a Requirement has been violated in the current simulation run.
Furthermore, all Requirement instances store information about the Requirement in a log file
(the default name is \"&lt;root-name&gt;_log.txt\"; this name can be changed via parameter logFile
in the instance of PrintViolations. Exactly one line is printed in the log file for every used
Requirement block that is either violated or untested:
</p>

<p>
If the Requirement instance is violated at least once:
</p>
<pre>
   Requirement violated: &lt;full path name&gt; (at time = &lt;first failure time&gt; s)
</pre>

<p>
If the Requirement instance is not tested:
</p>

<pre>
   Requirement untested: &lt;full path name&gt;
</pre>

<p>
For an example to use the Requirement block in graphical form, see
<a href=\"modelica://Requirements.Examples.Elementary.Verify.Requirement\">Examples.Elementary.Verify.Requirement</a>.<br>
For an example to use the Requirement block in textual form, see
<a href=\"modelica://Requirements.Examples.Textual.Elementary.Verify.Requirement\">Examples.Textual.Elementary.Verify.Requirement</a>.<br>

</p>
</html>"));
  end BooleanRequirement;

  block ViolationStatistics
    "Violation statistics of a property over a run: how often it was violated, for how long in total, the longest violation, the worst margin and when"
    import Requirements.Types.Property;
    import Requirements.Types.WorstMarginMethod;

    parameter Boolean useMargin = true
      "= true, if the margin input is enabled: the worst margin over the run and per violation episode"
      annotation(Evaluate=true, choices(checkBox=true));
    parameter Modelica.Units.SI.Time minDuration(min=0) = 0
      "Violation episodes shorter than this are not counted (0: every one is)";
    parameter Modelica.Units.SI.Time mergeGap(min=0) = 0
      "A violation that starts within this time after the previous one ended continues that episode (0: only at the same instant)";
    parameter Requirements.Types.WorstMarginMethod method = WorstMarginMethod.Continuous
      "How the worst margin is found"
      annotation(Dialog(group="Worst margin", enable=useMargin), Evaluate=true);
    parameter Modelica.Units.SI.Time T(min=Modelica.Constants.small) = 0.01
      "Continuous: time constant of the derivative filter, about a thousandth of the margin's time scale (60 s for a year)"
      annotation(Dialog(group="Worst margin", enable=useMargin and method == WorstMarginMethod.Continuous));
    parameter Real resolution(min=Modelica.Constants.small) = 0.01
      "Ratchet: resolution of the worst margin, in margin units (tolerances)"
      annotation(Dialog(group="Worst margin", enable=useMargin and method == WorstMarginMethod.Ratchet));
    parameter Boolean logStatistics = false
      "= true, if the statistics are written to the log file of the inner printViolations and printed in its summary"
      annotation(Dialog(tab="Log"), Evaluate=true, choices(checkBox=true));
    parameter String requirementName = getInstanceName()
      "Name the statistics are logged under"
      annotation(Dialog(tab="Log", enable=logStatistics));

    Requirements.Interfaces.PropertyInput property "Property of the requirement"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
    Requirements.Interfaces.MarginInput margin if useMargin
      "Margin of the requirement (the check block's margin output)"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

    Modelica.Blocks.Interfaces.IntegerOutput nViolations
      "Number of violation episodes (merged within mergeGap, at least minDuration long)"
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.RealOutput totalDuration(final quantity="Time", final unit="s")
      "Time in which the property was Violated, in total (every violation, unfiltered)"
      annotation (Placement(transformation(extent={{100,50},{120,70}})));
    Modelica.Blocks.Interfaces.RealOutput violatedFraction(final unit="1")
      "totalDuration over the time in which the property was applicable (not Undefined)"
      annotation (Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealOutput longestDuration(final quantity="Time", final unit="s")
      "Duration of the longest counted violation episode"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput tLongestStart(final quantity="Time", final unit="s")
      "Start of the longest counted violation episode"
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
    Modelica.Blocks.Interfaces.RealOutput worstMargin(final unit="1")
      "Least margin over the phases in which the property was decided (0 before the first one, or without margin)"
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
    Modelica.Blocks.Interfaces.RealOutput tWorst(final quantity="Time", final unit="s")
      "Instant of worstMargin"
      annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
    Modelica.Blocks.Interfaces.RealOutput currentDuration(final quantity="Time", final unit="s")
      "Duration of the running violation (0 while not violated)"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=270, origin={-40,-110})));
    Modelica.Blocks.Interfaces.RealOutput episodeWorstMargin(final unit="1")
      "Least margin of the current (or last) violation episode (0 before the first one, or without margin)"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=270, origin={20,-110})));
    Modelica.Blocks.Interfaces.RealOutput tEpisodeWorst(final quantity="Time", final unit="s")
      "Instant of episodeWorstMargin"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=270, origin={60,-110})));

    Requirements.Internal.ContinuousWorst continuousWorst(
      final T=T,
      final decided=decided,
      final violated=violated,
      final episode=episode) if useMargin and method == WorstMarginMethod.Continuous
      annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
    Requirements.Internal.RatchetWorst ratchetWorst(
      final resolution=resolution,
      final decided=decided,
      final violated=violated,
      final episode=episode) if useMargin and method == WorstMarginMethod.Ratchet
      annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
    Requirements.Internal.StatisticsLogger logger(
      final requirementName=requirementName,
      final hasMargin=useMargin,
      final minDuration=minDuration,
      final mergeGap=mergeGap,
      final nViolations=nViolations,
      final totalDuration=totalDuration,
      final violatedFraction=violatedFraction,
      final longestDuration=longestDuration,
      final tLongestStart=tLongestStart,
      final worst=worstMargin,
      final tWorst=tWorst) if logStatistics
      annotation (Placement(transformation(extent={{40,60},{60,80}})));

  protected
    Boolean violated = property == Property.Violated "= true while the property is Violated";
    Boolean decided = property == Property.Violated or property == Property.Satisfied
      "= true while the property is decided (its margin final)";
    Boolean applicable = property <> Property.Undefined "= true while the property is not Undefined";
    discrete Modelica.Units.SI.Time tViolatedStart "Start of the running violation";
    discrete Modelica.Units.SI.Time closedViolated "Violated time of the violations that have ended";
    discrete Modelica.Units.SI.Time tApplicableStart "Start of the running applicable phase";
    discrete Modelica.Units.SI.Time closedApplicable "Applicable time of the phases that have ended";
    discrete Integer episode "Number of violation episodes started (a merged violation does not start one)";
    discrete Modelica.Units.SI.Time tEpisodeStart "Start of the current (or last) episode";
    discrete Modelica.Units.SI.Time tEpisodeEnd "End of the last violation of the current episode";
    discrete Integer nClosed "Counted episodes before the current one";
    discrete Modelica.Units.SI.Time longestClosed "Longest counted episode before the current one";
    discrete Modelica.Units.SI.Time tLongestClosed "Its start";
    Modelica.Units.SI.Time episodeDuration = if episode == 0 then 0 elseif violated then time - tEpisodeStart
      else tEpisodeEnd - tEpisodeStart "Duration of the current (or last) episode, gaps of a merge included";
    Boolean episodeCounts = episode > 0 and episodeDuration >= minDuration "= true, if the current episode is counted";
    Modelica.Units.SI.Time applicableDuration = closedApplicable + (if applicable then time - tApplicableStart else 0)
      "Time in which the property was applicable";
    Modelica.Blocks.Interfaces.RealOutput worst_internal(unit="1") "Needed for the conditional worst-margin blocks";
    Modelica.Blocks.Interfaces.RealOutput tWorst_internal(unit="s") "Needed for the conditional worst-margin blocks";
    Modelica.Blocks.Interfaces.RealOutput episodeWorst_internal(unit="1") "Needed for the conditional worst-margin blocks";
    Modelica.Blocks.Interfaces.RealOutput tEpisodeWorst_internal(unit="s") "Needed for the conditional worst-margin blocks";

  initial equation
    tViolatedStart = time;
    closedViolated = 0;
    tApplicableStart = time;
    closedApplicable = 0;
    episode = if violated then 1 else 0;
    tEpisodeStart = time;
    tEpisodeEnd = time;
    nClosed = 0;
    longestClosed = 0;
    tLongestClosed = time;

  algorithm
    when violated then
      // Within mergeGap of the previous violation the same episode goes on;
      // otherwise a new episode starts and the previous one is final now.
      if not (episode > 0 and time - tEpisodeEnd <= mergeGap) then
        if episode > 0 and tEpisodeEnd - tEpisodeStart >= minDuration then
          nClosed := nClosed + 1;
          if tEpisodeEnd - tEpisodeStart > longestClosed then
            longestClosed := tEpisodeEnd - tEpisodeStart;
            tLongestClosed := tEpisodeStart;
          end if;
        end if;
        episode := episode + 1;
        tEpisodeStart := time;
      end if;
      tViolatedStart := time;
    elsewhen not violated then
      tEpisodeEnd := time;
      closedViolated := closedViolated + time - tViolatedStart;
    end when;

    when applicable then
      tApplicableStart := time;
    elsewhen not applicable then
      closedApplicable := closedApplicable + time - tApplicableStart;
    end when;

  equation
    currentDuration = if violated then time - tViolatedStart else 0;
    totalDuration = closedViolated + currentDuration;
    violatedFraction = totalDuration/max(applicableDuration, Modelica.Constants.small);
    nViolations = nClosed + (if episodeCounts then 1 else 0);
    longestDuration = if episodeCounts and noEvent(episodeDuration > longestClosed) then episodeDuration else longestClosed;
    tLongestStart = if episodeCounts and noEvent(episodeDuration > longestClosed) then tEpisodeStart else tLongestClosed;

    connect(margin, continuousWorst.u);
    connect(margin, ratchetWorst.u);
    connect(continuousWorst.worst, worst_internal);
    connect(continuousWorst.tWorst, tWorst_internal);
    connect(continuousWorst.episodeWorst, episodeWorst_internal);
    connect(continuousWorst.tEpisodeWorst, tEpisodeWorst_internal);
    connect(ratchetWorst.worst, worst_internal);
    connect(ratchetWorst.tWorst, tWorst_internal);
    connect(ratchetWorst.episodeWorst, episodeWorst_internal);
    connect(ratchetWorst.tEpisodeWorst, tEpisodeWorst_internal);
    if not useMargin then
      worst_internal = 0;
      tWorst_internal = 0;
      episodeWorst_internal = 0;
      tEpisodeWorst_internal = 0;
    end if;
    worstMargin = worst_internal;
    tWorst = tWorst_internal;
    episodeWorstMargin = episodeWorst_internal;
    tEpisodeWorst = tEpisodeWorst_internal;

    annotation (defaultComponentName="statistics", Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Line(points={{-80,0},{80,0}}, color={0,127,0}, pattern=LinePattern.Dash),
          Line(points={{-80,40},{-60,30},{-40,-30},{-20,-50},{0,-20},{20,30},{40,50},{60,-10},{80,-40}},
            color={0,127,0}, thickness=0.5),
          Rectangle(extent={{-46,-2},{-6,-14}}, lineColor={255,0,0}, fillColor={255,0,0}, fillPattern=FillPattern.Solid),
          Rectangle(extent={{54,-2},{80,-14}}, lineColor={255,0,0}, fillColor={255,0,0}, fillPattern=FillPattern.Solid),
          Text(extent={{-90,90},{90,60}}, textColor={0,0,0}, textString="n, T, max"),
          Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
      Documentation(info="<html>
<p>
Statistics of the violations of one requirement over a run, from its <code>property</code> and (optionally) its normalized
<code>margin</code>: how often it was violated, for how long in total, the longest violation, and the worst violation and when.
For a long run (an annual building simulation, a duty cycle) these answer what a verdict alone cannot: a requirement
violated once for a second and one violated every afternoon for three hours are both <em>violated</em>.
</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Output</th><th>Meaning</th></tr>
<tr><td><code>nViolations</code></td><td>Number of violation <em>episodes</em>: maximal phases with <code>property = Violated</code>,
    merged when one starts within <code>mergeGap</code> after the previous one ended, and counted only when at least
    <code>minDuration</code> long (an episode still running is counted as soon as it is)</td></tr>
<tr><td><code>totalDuration</code></td><td>Time with <code>property = Violated</code> in total, every violation, unfiltered
    (for a comfort band this is the &quot;unmet hours&quot; of building simulation, in seconds)</td></tr>
<tr><td><code>violatedFraction</code></td><td><code>totalDuration</code> over the time in which the property was applicable
    (not <code>Undefined</code>)</td></tr>
<tr><td><code>longestDuration</code>, <code>tLongestStart</code></td><td>The longest counted episode and its start (the first
    of equally long ones); an episode's duration runs from its first violation to the end of its last, merged gaps included</td></tr>
<tr><td><code>worstMargin</code>, <code>tWorst</code></td><td>The least margin over the phases in which the property was
    decided (<code>Satisfied</code> or <code>Violated</code>) and its instant: the worst violation if the requirement was
    violated, the closest call if not. 0 before the property is first decided</td></tr>
<tr><td><code>episodeWorstMargin</code>, <code>tEpisodeWorst</code></td><td>The same over the current (or last) episode</td></tr>
<tr><td><code>currentDuration</code></td><td>Duration of the running violation, 0 while not violated</td></tr>
</table>
<p>
Every output holds its value at the end of the run without <code>terminal()</code> (which Modelon Impact evaluates to false):
the outputs include the episode still running.
</p>

<h4>What counts</h4>
<p>
An episode is a phase of <code>property = Violated</code>, not of a negative margin: while a check is still
<code>Undecided</code> (a duration not yet reached, a sliding window not yet full) its margin is provisional and may be
negative without a violation. For the same reason the worst margin is taken over the decided phases only. This is the
rule the verdict of the requirement follows, so the statistics agree with it: <code>nViolations &gt; 0</code> exactly when
the requirement is violated (with <code>minDuration = 0</code>), and a negative <code>worstMargin</code> then.
</p>
<p>
<code>mergeGap</code> and <code>minDuration</code> keep a signal that hovers at its limit from counting as hundreds of
violations: a room temperature that crosses its setpoint band back and forth for ten minutes is one episode with
<code>mergeGap</code> = 10 min. Both only change the episode count and the longest episode, never
<code>totalDuration</code>. With <code>mergeGap = 0</code> a violation that resumes at the very instant it ended (in the
same event iteration) still continues its episode.
</p>

<h4>Worst margin</h4>
<p>
The least value of a continuous signal is found at its local minima, which a block can only locate through events. The
two methods (parameter <code>method</code>, <a href=\"modelica://Requirements.Types.WorstMarginMethod\">WorstMarginMethod</a>):
</p>
<ul>
<li><b>Continuous</b> (default) reuses
    <a href=\"modelica://Modelica.Blocks.Math.ContinuousSignalExtrema\">Modelica.Blocks.Math.ContinuousSignalExtrema</a>:
    a first-order filter of the margin with time constant <code>T</code> approximates its derivative, and a state event
    fires at every local extremum. The event comes about <code>T</code> after the extremum, so <code>tWorst</code> is about
    <code>T</code> late, and the value is off by about <code>u''&middot;T&sup2;/2</code>, negligible. Cost: one event per local
    extremum of the margin, minima and maxima, plus the filter state.</li>
<li><b>Ratchet</b> fires an event only when the margin falls more than <code>resolution</code> below the least value so
    far. The value is within <code>resolution</code> (default 0.01: a hundredth of the tolerance) of the exact one; the
    number of events is the depth of the descent over <code>resolution</code>, however much the margin oscillates.</li>
</ul>
<p>
<b>Choosing <code>T</code>.</b> Near an extremum the filter's event indicator is about <code>T</code> times the margin's
slope. If that is smaller than the solver's absolute tolerance, integration noise flips its sign over and over and the
solver reports chattering at every extremum. This is why the default is 0.01 s, not the 1 &micro;s of the MSL block. Set
<code>T</code> to about a thousandth of the shortest time scale on which the margin varies: 0.01 s for a margin that
moves in seconds, 60 s for an annual building simulation driven by daily cycles.
</p>
<p>
Either method is more accurate than the minimum over a stored result, which sees only the output points: an annual run stored
hourly misses a peak between two of them. The counts and durations need no extra events at all: the property only changes
at events the check block produces anyway.
</p>

<h4>Use</h4>
<p>
Connect <code>property</code> to a check block's <code>y</code> and <code>margin</code> to its <code>margin</code>. The
requirement blocks <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> and
<a href=\"modelica://Requirements.Verify.BooleanRequirement\">BooleanRequirement</a> contain this block when their parameter
<code>computeStatistics</code> is set, and then write the statistics to the log file and the summary of
<a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> beside the verdict (<code>logStatistics</code>
does the same for a stand-alone instance). Examples:
<a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics\">Examples.Elementary.ViolationStatistics</a>.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Oct. 19, 2026 </td>
    <td valign=\"top\"> New block (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end ViolationStatistics;

  annotation (Icon(graphics={             Line(
          points={{-46,-6},{-6,-64},{56,62}},
          color={135,135,135},
          smooth=Smooth.None,
          thickness=0.5)}),      Documentation(info="<html>
<p>
Sublibrary Verify contains components to evaluate whether requirements are
satisfied, violated, or not tested and to print the result of this assessment after
the simulation run to the output window.
</p>
</html>"));
end Verify;
