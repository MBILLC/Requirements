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
<p>A steady-state example (ModCheck's requirements plan, section 19.3): the MSL heat exchanger simulation with both inlet
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
<p>ModCheck's corpus sweeps this model over a 400-row table of inlet temperatures (a 20 &times; 20 grid from 5 to 95 degC
on each side) with matched mass flows (side 1 from 0.1 to 0.3 kg/s, side 2 the counterflow of it within 10 %); every
row settles, and the hottest wall node sits at the hotter inlet, half a tolerance under a 96 degC limit.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end HeatExchangerSimulation;

  annotation (Documentation(info="<html>
<p>Examples whose requirements are stated over a <strong>steady state</strong> and checked over a point cloud -- a sweep of
parameters, each point a steady-state solution -- rather than over a transient trajectory (ModCheck's requirements plan,
section 19). The models here are MSL examples run to their steady state with their inputs as parameters; ModCheck's
corpus package <code>RequirementsCorpus.Plants.SteadyState</code> extends them, binds the glossary signals and holds the
sweeps and the requirements.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
end SteadyState;
