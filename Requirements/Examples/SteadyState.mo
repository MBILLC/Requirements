within Requirements.Examples;
package SteadyState "Examples solved for a steady state: models whose requirements are checked over a point cloud rather than over time"
  extends Modelica.Icons.ExamplesPackage;

  model HeatExchangerSimulation "Modelica.Fluid.Examples.HeatExchanger.HeatExchangerSimulation with both inlet temperatures and both mass flows as parameters, run to its steady state"
    extends Modelica.Fluid.Examples.HeatExchanger.HeatExchangerSimulation(
      massFlowRate1(m_flow=m_flow1, T=T_in1),
      massFlowRate2(T=T_in2),
      ambient1(T=T_in1),
      ambient2(T=T_in2),
      Ramp1(offset=m_flow2, height=0, startTime=0),
      system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
    // The HX keeps the example's start values (304 K, 300 K, wall 300 K): its T_start_* carry Evaluate=true, and binding
    // them to the swept parameters would make those compile-time constants (a tool then refuses the runtime override).
    parameter Modelica.Units.SI.Temperature T_in1(displayUnit="degC", min=273.25, max=373.05) = 363.15 "Inlet temperature of side 1 (massFlowRate1; water: 0.1 to 99.9 degC)";
    parameter Modelica.Units.SI.Temperature T_in2(displayUnit="degC", min=273.25, max=373.05) = 283.15 "Inlet temperature of side 2 (ambient2, where the fluid enters in counterflow)";
    parameter Modelica.Units.SI.MassFlowRate m_flow1 = 0.2 "Mass flow of side 1, into port_a1";
    parameter Modelica.Units.SI.MassFlowRate m_flow2 = -0.2 "Mass flow of massFlowRate2 at port_b2: negative draws the fluid in from ambient2 at port_a2 and out at port_b2 -- the example's counterflow case";
    output Modelica.Units.SI.Temperature T_out1 = HEX.pipe_1.mediums[HEX.nNodes].T "Outlet temperature of side 1 (the last node, at port_b1)";
    output Modelica.Units.SI.Temperature T_out2 = HEX.pipe_2.mediums[HEX.nNodes].T "Outlet temperature of side 2 (the last node, at port_b2, where the negative massFlowRate2 draws the fluid out)";
    output Modelica.Units.SI.HeatFlowRate Q_flow = HEX.Q_flow_1 "Heat flow into side 1 (negative: side 1 is cooled)";
    output Modelica.Units.SI.HeatFlowRate Q_transferred = -HEX.Q_flow_1 "Heat side 1 gives to side 2 (positive when side 1 is the hotter one)";
    output Modelica.Units.SI.Temperature T_wall_max = max(HEX.wall.T) "Hottest wall node";
    annotation(experiment(StopTime=600, Interval=150),
      Documentation(info="<html>
<p>A steady-state example: the MSL heat exchanger simulation with both inlet
temperatures and both mass flows as parameters, so that a sweep over them is a map of the exchanger's operating points and
a requirement (<em>the outlet temperature of side 1 shall be at most 80 degC</em>, <em>the operating point shall stay
within the exchanger map</em>) is checked at every point of it. The example's ramp (counterflow to co-current at 50 s) is
replaced by the constant <code>m_flow2</code>, negative for counterflow: <code>massFlowRate2</code> at <code>port_b2</code>
then draws the fluid from <code>ambient2</code>, whose temperature is therefore side 2's inlet temperature
<code>T_in2</code>; side 1 enters at <code>massFlowRate1</code> with <code>T_in1</code>. The medium is water
(<code>StandardWaterOnePhase</code>): keep the temperatures between 0.1 and 99.9 degC. The energy dynamics are
<code>FixedInitial</code> -- the example's <code>SteadyStateInitial</code> would solve the steady state at
initialisation; a run from the example's own start values (304 / 300 K) is the genuine time simulation to it, and the
point is where the run ends up, settled over its last quarter (600 s suffice everywhere in the sweep below). The HX's
start parameters carry <code>Evaluate=true</code> and cannot follow a sweep.</p>
<p>This model is the plant alone: it carries no requirement block, so that it can be simulated, swept and stored by any
tool without the checks influencing the run. <a href=\"modelica://Requirements.Examples.SteadyState.CheckHeatExchanger\">CheckHeatExchanger</a>
adds the requirements and checks one operating point in a plain simulation.</p>
<p>A sweep of this model over a 400-row table of inlet temperatures (a 20 &times; 20 grid from 5 to 95 degC
on each side) with matched mass flows (side 1 from 0.1 to 0.3 kg/s, side 2 the counterflow of it within 10 %) settles
on every row, and the hottest wall node sits at the hotter inlet, half a tolerance under a 96 degC limit.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end HeatExchangerSimulation;

  model CheckHeatExchanger "HeatExchangerSimulation with its steady-state requirements, checked at the settled end of the run and printed by PrintViolations"
    extends HeatExchangerSimulation;
    import Requirements.LogicalFunctions.during;
    parameter Modelica.Units.SI.Time tSettled = 450 "Start of the window in which the run counts as settled (the last quarter of StopTime)";
    parameter Real dTdtMax(unit="K/s") = 1e-3 "Largest rate of change of an outlet temperature that counts as steady";
    parameter Modelica.Units.SI.Temperature T_out1_max(displayUnit="degC") = 353.15 "Requirement R1: the steady outlet temperature of side 1 shall be at most this";
    parameter Modelica.Units.SI.Temperature T_wall_limit(displayUnit="degC") = 369.15 "Requirement R2: the steady hottest wall node shall stay below this";

    inner Verify.PrintViolations printViolations(printSatisfied=true, evaluationTime=600)
      annotation (Placement(transformation(extent={{94.0,84.0},{114.0,104.0}},rotation = 0.0,origin = {0.0,0.0})));
    SignalAnalysis.ApproximateDerivativeWithFilter derT_out1(f_cut=0.1) "Rate of change of T_out1"
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    SignalAnalysis.ApproximateDerivativeWithFilter derT_out2(f_cut=0.1) "Rate of change of T_out2"
      annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
    Boolean steady = time >= tSettled and abs(derT_out1.y) <= dTdtMax and abs(derT_out2.y) <= dTdtMax
      "= true when the run is in its last quarter and both outlet temperatures have stopped moving";

    Verify.Requirement R0_settled(
      text="The run shall have settled over its last quarter: both outlet temperatures change by at most dTdtMax",
      property=during(time >= tSettled, abs(derT_out1.y) <= dTdtMax and abs(derT_out2.y) <= dTdtMax))
      annotation (Placement(transformation(extent={{-30,80},{30,100}})));
    Verify.Requirement R1_outletTemperature(
      text="In steady state, the outlet temperature of side 1 shall be at most T_out1_max (80 degC)",
      property=during(steady, T_out1 <= T_out1_max))
      annotation (Placement(transformation(extent={{-30,-80},{30,-60}})));
    Verify.Requirement R2_wallTemperature(
      text="In steady state, the hottest wall node shall stay below T_wall_limit (96 degC)",
      property=during(steady, T_wall_max < T_wall_limit))
      annotation (Placement(transformation(extent={{-30,-100},{30,-80}})));
  equation
    derT_out1.u = T_out1;
    derT_out2.u = T_out2;
    annotation(experiment(StopTime=600, Interval=1, Tolerance=1e-6),
      Documentation(info="<html>
<p>The one operating point of <a href=\"modelica://Requirements.Examples.SteadyState.HeatExchangerSimulation\">HeatExchangerSimulation</a>
(side 1 at 90 degC, side 2 at 10 degC, 0.2 kg/s each in counterflow) with its steady-state requirements checked in a
plain simulation in any Modelica tool. At the end of the run <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a>
prints the verdict of every requirement and writes <code>CheckHeatExchanger_log.txt</code> and
<code>CheckHeatExchanger_log.html</code>.</p>
<p><b>What is different about a steady-state requirement.</b> A requirement block reports a violation if its
property is <code>Violated</code> at <em>any</em> instant. A steady-state requirement is a statement about the
settled operating point, not about the way there: the transient from the start values must not count. Each
steady-state requirement is therefore written as <code>during(steady, check)</code>, which is <code>Undefined</code>
(not applicable) while the run is still moving and decides the check only once it has settled:</p>
<ul>
<li><code>steady</code> is true in the last quarter of the run (<code>time &ge; tSettled</code>) while the rates of
    change of both outlet temperatures are below <code>dTdtMax</code>. The rates come from
    <a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithFilter\">ApproximateDerivativeWithFilter</a>
    (the outlet temperatures are functions of the medium states, which a tool need not be able to differentiate).</li>
<li><b>R0_settled</b> makes the assumption explicit: if the run has not settled in its last quarter, R0 is
    violated, and R1 and R2 stay <em>untested</em> rather than being judged on a transient value.</li>
<li><b>R1_outletTemperature</b>: the outlet temperature of side 1 at most 80 degC.</li>
<li><b>R2_wallTemperature</b>: the hottest wall node below 96 degC.</li>
</ul>
<p>At the nominal point the run has settled well before 450 s; the outlet of side 1 ends at 37.6 degC, side 2 at
62.5 degC, the hottest wall node at 78.7 degC, and all three requirements are satisfied (decided at t = 450 s,
Undefined before).</p>
<p>The standard <code>PrintViolations</code> is used: the verdict of a steady-state requirement is decided at the
end of the run like any other. As in every example of this library, <code>evaluationTime</code> is the StopTime,
so that a tool that does not support <code>terminal()</code> prints the verdict once
<code>printViolations.useEvaluationTime = true</code> is set.</p>
<p>To check another operating point, modify <code>T_in1</code>, <code>T_in2</code>, <code>m_flow1</code> and
<code>m_flow2</code>; to check a map of them, sweep this model with your tool's parameter-variation facility and
collect the requirement verdicts per run (or sweep the plant alone and evaluate the requirements on its stored
outputs).</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end CheckHeatExchanger;

  annotation (Documentation(info="<html>
<p>Examples whose requirements are stated over a <strong>steady state</strong> -- a settled operating point -- rather
than over a transient trajectory. The models here are MSL examples run to their steady state with their inputs as
parameters, so that a sweep of parameters is a point cloud of operating points, each checked on its own.</p>
<ul>
<li><a href=\"modelica://Requirements.Examples.SteadyState.HeatExchangerSimulation\">HeatExchangerSimulation</a>
    is the plant alone, ready to be swept.</li>
<li><a href=\"modelica://Requirements.Examples.SteadyState.CheckHeatExchanger\">CheckHeatExchanger</a> adds the
    requirements and <code>PrintViolations</code>: one operating point, checked in a plain simulation. Its
    documentation explains how a steady-state requirement keeps the transient out of the verdict.</li>
</ul>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
end SteadyState;
