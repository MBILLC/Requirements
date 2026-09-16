within Requirements;
package SignalAnalysis
  "Library of signal analysis blocks to compute properties from Real signals"
  extends Modelica.Icons.Package;

  block ExactDerivative
    "Output is the analytic derivative of the input (= exact derivative)"

    Modelica.Blocks.Interfaces.RealInput u "Real input signal" annotation (Placement(transformation(extent={{-90,-20},
              {-50,20}}), iconTransformation(extent={{-90,-20},{-50,20}})));
    Modelica.Blocks.Interfaces.RealOutput y "Derivative of the input signal" annotation (Placement(transformation(extent={{50,-10},
              {70,10}}), iconTransformation(extent={{50,-10},{70,10}})));
  equation
    y = der(u);

     annotation (defaultComponentName="der1",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-50,50},{50,-50}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,100},{150,60}},
            lineColor={175,175,175},
            textString="%name"),
          Text(
            extent={{-50,15},{50,-15}},
            lineColor={0,0,0},
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            textString="der")}),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
der_u = <b>ExactDerivative</b>(u=...).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the exact (analytic) derivative of the input <b>u</b>.
This is achieved by using the Modelica operator <b>der</b>(..).
This block will only work, if the tool is able to \"somehow\" determine the
analytic derivative of the input u (for example, either der(u) is computed
already somewhere else, or a tool is able to differentiate u analytically).
If this fails, or if this is not practical, for example with measurement data,
then use the blocks that compute a derivative in an approximate way:
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithFilter\">ApproximateDerivativeWithFilter</a> or
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithWindow\">ApproximateDerivativeWithWindow</a>.
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.Derivatives\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives1.png\">
</blockquote></p>

<p>
that compares different ways to compute a derivative. Simulation results in:
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
Note, the approximate derivatives have a large error at the start of the simulation, because
no information about the derivative of the signal is known. For this reason, the
ApproximateDerivativeWithFilter block starts, for example, with steady-state (so zero derivative), and then
needs some time until the approximation of the derivative is fine.
</p>
</html>"));
  end ExactDerivative;

  block ApproximateDerivativeWithFilter
    "Output is the filtered derivative of the input (= approximate derivative)"
    parameter Modelica.Units.SI.Frequency f_cut "Cut-off frequency of filter";
    parameter Integer order=2 "Order of filter";

    Modelica.Blocks.Continuous.Filter filter(
      analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
      order=order,
      f_cut=f_cut)   annotation (Placement(transformation(extent={{-39,-10},{-19,10}})));
    Modelica.Blocks.Interfaces.RealInput u "Real input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    ExactDerivative derExact
      annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
    Modelica.Blocks.Interfaces.RealOutput y
      "Real output signal (= approximative derivative of input u)"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    connect(filter.u, u) annotation (Line(
        points={{-41,0},{-120,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(filter.y, derExact.u) annotation (Line(
        points={{-18,0},{-3,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(derExact.y, y) annotation (Line(
        points={{10,0},{110,0}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (defaultComponentName="approxDer1",Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
         Rectangle(
            extent={{-100,100},{101,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Rectangle(
            extent={{-90,45},{90,-5}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Text(
            extent={{-90,75},{90,50}},
            lineColor={95,95,95},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            textString="f_cut",
            horizontalAlignment=TextAlignment.Left),
          Text(
            extent={{-90,35},{90,5}},
            lineColor={0,0,0},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            textString="%f_cut Hz"),             Text(
            extent={{-150,110},{150,150}},
            lineColor={175,175,175},
            textString="%name"),
          Rectangle(
            extent={{-90,-39},{90,-89}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Text(
            extent={{-90,-49},{90,-79}},
            lineColor={0,0,0},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            textString="%order"),
          Text(
            extent={{-90,-10},{90,-35}},
            lineColor={95,95,95},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            horizontalAlignment=TextAlignment.Left,
            textString="order"),
          Text(
            extent={{-90,95},{90,65}},
            lineColor={0,0,0},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            textString="der")}),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
der_u = <b>ApproximateDerivativeWithFilter</b>(u=..., f_cut=..., order=2).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the approximate derivative of the input <b>u</b>.
This is achieved by first filtering the input with a low pass critical damping
filter and then differentiating the filter output analytically
(with the effect that some combinations of filter states are used as
approximate derivative). This block requires to define two parameters:
<b>f_cut</b> the cut-off frequency of the filter in Hz and
<b>order</b> the order of the filter (default of order=2).
The larger the cut-off frequency, the smaller the approximation error.
On the other hand, if the input signal is from measurements, then the
cut-off frequency should be not too large to remove unwanted signal noise
by the filter. The order of the filter defines the \"steepness\" of the
frequency response and therefore a larger order reduces the effect
of frequencies in the input that are above f_cut.
</p>

<p>
Alternatively, derivatives might be computed with the following blocks:
<a href=\"modelica://Requirements.SignalAnalysis.ExactDerivative\">ExactDerivative</a> or
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithWindow\">ApproximateDerivativeWithWindow</a>.
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.Derivatives\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives1.png\">
</blockquote></p>

<p>
that compares different ways to compute a derivative. Simulation results in:
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
Note, the approximate derivatives have a large error at the start of the simulation, because
no information about the derivative of the signal is known. For this reason, the
ApproximateDerivativeWithFilter block starts, for example, with steady-state (so zero derivative), and then
needs some time until the approximation of the derivative is fine.
</p>
</html>"));
  end ApproximateDerivativeWithFilter;

  block ApproximateDerivativeWithWindow
    "Output is the finite difference quotient of the input (= approximate derivative)"
    parameter Modelica.Units.SI.Time dt(min=10*Modelica.Constants.eps)
      "Time difference used for difference quotient";
    Modelica.Blocks.Interfaces.RealInput u
      "Real input signal (shall be differentiated)"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput y
      "Approximative derivative of u (computed via finite difference)"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = (u - delay(u, dt))/dt;
    annotation (defaultComponentName="approxDer1",Diagram(coordinateSystem(preserveAspectRatio=false,
                                                                  extent={{-100,-100},{100,100}}),
                           graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),           graphics={
          Rectangle(
            extent={{-100,50},{100,-50}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Rectangle(
            extent={{-90,10},{90,-40}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Text(
            extent={{-90,-30},{90,0}},
            lineColor={0,0,0},
            textString="%dt s"),
          Text(
            extent={{-150,100},{150,60}},
            lineColor={175,175,175},
            textString="%name"),
          Text(
            extent={{-90,35},{90,10}},
            lineColor={95,95,95},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            horizontalAlignment=TextAlignment.Left,
            textString="dt"),
          Text(
            extent={{-90,45},{90,15}},
            lineColor={0,0,0},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            textString="der")}),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
der_u = <b>ApproximateDerivativeWithWindow</b>(u=..., dt=...).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the approximate derivative of the input <b>u</b>.
This is achieved by computing a backwards finite difference quotient:
</p>
<blockquote>
<pre>
y = (u - delay(u,dt)) / dt;
</pre>
</blockquote>
<p>
where parameter <b>dt</b> is the time increment for the finite difference
quotient and delay(u,dt) is the input signal u delayed by dt.
The smaller dt, the smaller the appropximation error.
</p>

<p>
Alternatively, derivatives might be computed with the following blocks:
<a href=\"modelica://Requirements.SignalAnalysis.ExactDerivative\">ExactDerivative</a> or
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithFilter\">ApproximateDerivativeWithFilter</a>.
If the input signal is from measurements, it is better to utilize
the <a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithFilter\">ApproximateDerivativeWithFilter</a>
block to compute the derivative, since the signal noise in the measurement
is low pass filtered (and therefore this unwanted effect is considerably removed).
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.Derivatives\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives1.png\">
</blockquote></p>

<p>
that compares different ways to compute a derivative. Simulation results in:
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
Note, the approximate derivatives have a large error at the start of the simulation, because
no information about the derivative of the signal is known. For this reason, the
ApproximateDerivativeWithFilter block starts, for example, with steady-state (so zero derivative), and then
needs some time until the approximation of the derivative is fine.
</p>
</html>"));
  end ApproximateDerivativeWithWindow;

  block TriggeredIntegrator
    "Output is the integral over the input, as long as the Boolean input active is true (for a rising edge of active the integrator state is reset to 0)"

    Modelica.Blocks.Interfaces.RealInput u "Input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput y
      "Output signal = if active then integral over input"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.BooleanInput active
      "Boolean input defining when integral shall be computed)" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-70})));
  initial equation
    y = 0;
  equation
    der(y) = if active then u else 0;

    when active then
       reinit(y,0);
    end when;
    annotation (defaultComponentName="integrator1",Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
          Rectangle(
            extent={{-100,50},{100,-50}},
            lineColor={0,0,0},
            lineThickness=5,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,100},{150,60}},
            lineColor={175,175,175},
            textString="%name"), Polygon(
            points={{-70,36},{-78,14},{-62,14},{-70,36}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-70,36},{-70,-36}},
            color={135,135,135}),          Polygon(
            points={{84,-28},{62,-20},{62,-36},{84,-28}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-78,-28},{74,-28}},
            color={135,135,135}),
          Polygon(
            points={{-47,-28},{-47,17},{-44,22},{-39,28},{-35,31},{-35,-28},{-47,-28}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Polygon(
            points={{-5,-28},{-5,29},{0.5,26},{6,22},{10,19},{15,17},{18,16},{21,16},
                {24,17.5},{27,19.5},{28.5,21},{30,22.5},{32,23.5},{32,-28},{-5,-28}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
                                      Line(
            points={{-57,2},{-35,36},{-7,32},{19,12},{33,26},{59,32},{67,22},{67,20}},
            color={135,135,135},
            smooth=Smooth.Bezier)}),
                                   Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
integral_u = <b>TriggeredIntegrator</b>(u=..., active=...).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the integral over the input <b>u</b>, that is y = integral(u*dt) whenever
the Boolean input <b>active</b> = true. Output y is initialized to zero.
When active has a rising edge, output y is re-initialized to zero.
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.Integrator\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Integrator1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Integrator2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end TriggeredIntegrator;

  block MovingAverage "Output is the continuous moving average of the input"
   extends Requirements.Interfaces.PartialTriggeredMovingWindow;
  protected
    Real uFilt;
  initial equation
    uFilt = u;
  equation
    der(uFilt) = (u - delay(u,T))/T;

    y = if active then uFilt else 0;

    annotation (defaultComponentName="movAv1",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                           graphics={      Line(points={{-74,80},{-74,8}},
            color={135,135,135}),Polygon(
            points={{-74,80},{-82,58},{-66,58},{-74,80}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Polygon(
            points={{80,16},{58,24},{58,8},{80,16}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-82,16},{70,16}},
            color={135,135,135}),
          Polygon(
            points={{-9,16},{-9,73},{-3.5,70},{2,66},{6,63},{11,61},{14,60},{17,60},
                {20,61.5},{23,63.5},{24.5,65},{26,66.5},{28,67.5},{28,16},{-9,16}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
                                      Line(
            points={{-61,46},{-39,80},{-11,76},{15,56},{29,70},{55,76},{63,66},{63,
                64}},
            color={135,135,135},
            smooth=Smooth.Bezier),
          Text(
            extent={{28,60},{71,30}},
            lineColor={102,102,102},
            horizontalAlignment=TextAlignment.Right,
            textString="/ T"),
          Line(points={{28,92},{28,16}}, color={255,0,0})}),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
u_filt = <b>MovingAverage</b>(u=..., active=...).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the moving average over the input <b>u</b> as long as 
Boolean input <b>active</b> is true. If active = true, the output is computed as:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/SignalAnalysis/MovingAverageFormula.png\">
</blockquote></p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.MovingAverage\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/MovingAverage1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/MovingAverage2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end MovingAverage;

  block TimeMonitoring
    "Output is the time duration where the Boolean input was true"

    Modelica.Blocks.Interfaces.BooleanInput u "Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    Modelica.Blocks.Interfaces.RealOutput y(quantity="Time", unit="s")
      "Real output signal = duration of input signal u being true"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Logical.Timer timer annotation (Placement(transformation(extent={{-10,-10},
              {10,10}})));
  equation
    connect(timer.u, u)
      annotation (Line(points={{-12,0},{-120,0}},          color={255,0,255}));
    connect(timer.y, y)
      annotation (Line(points={{11,0},{58,0},{110,0}},        color={0,0,127}));
    annotation (defaultComponentName="timeMon1",Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
          Rectangle(
            extent={{-100,50},{100,-50}},
            lineColor={0,0,0},
            lineThickness=5,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,100},{150,60}},
            lineColor={175,175,175},
            textString="%name"), Polygon(
            points={{-70,42},{-78,20},{-62,20},{-70,42}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-70,36},{-70,-41}},
            color={135,135,135}),          Polygon(
            points={{84,-34},{62,-26},{62,-42},{84,-34}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-78,-34},{74,-34}},
            color={135,135,135}),        Line(points={{-70,-24},{-34,-24},{-34,
                0},{34,0},{34,-24},{62,-24}},
                                  color={255,0,255}),Line(points={{-70,14},{-34,
                14},{34,40},{34,14},{62,14}},        color={0,0,255})}),
                                   Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
duration = <b>TimeMonitoring</b>(u=...).y;
</p></blockquote>

<h4>Description</h4>

<p>
Real output <b>y</b> is the duration in seconds, since the input <b>u</b> was true.
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.TimeMonitoring\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/TimeMonitoring1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/TimeMonitoring2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end TimeMonitoring;

  block CrossingMonitoring
    "Output is true for a positive threshold crossing of the input and false for a negative threshold crossing"
    parameter Real threshold = 0 "Threshold to define crossing";

    Modelica.Blocks.Interfaces.RealInput u "Real input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.BooleanOutput y
      "Boolean output signal (= monitoring zero crossing of u)"                                           annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Boolean b;
  initial equation
    y = u >= threshold and
        u <= threshold + max(10*Modelica.Constants.eps, abs(threshold)*10*Modelica.Constants.eps);
  equation
    b = u >= threshold;
    when b then
       y = true;
    elsewhen not b then
       y = false;
    end when;

    annotation (defaultComponentName="crossingMon1",Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1})), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,150},{150,110}},
            lineColor={175,175,175},
            textString="%name"), Polygon(
            points={{-73,92},{-81,70},{-65,70},{-73,92}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),Line(points={{-73,92},{-73,-2}},
            color={135,135,135}),          Line(points={{-82,6},{70,6}},
            color={135,135,135}),          Polygon(
            points={{91,6},{69,14},{69,-2},{91,6}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
                                      Line(
            points={{-71,21},{-49,76},{-21,55},{10,20},{23,73},{43,57},{52,32},{74,
                31}},
            color={135,135,135},
            smooth=Smooth.Bezier),
          Line(points={{-73,18},{-60,18},{-60,80},{-16,80},{-16,18},{17,18},{17,80},
                {45,80},{45,18},{75,18}},       color={255,0,255}),
          Rectangle(
            extent={{-90,-30},{90,-90}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Sunken),
          Text(
            extent={{-90,-47},{90,-77}},
            lineColor={0,0,0},
            textString="%threshold"),      Line(points={{-81,49},{75,49}},
            color={135,135,135},
            pattern=LinePattern.Dot),
          Text(
            extent={{-80,0},{90,-25}},
            lineColor={102,102,102},
            textString="threshold",
            horizontalAlignment=TextAlignment.Left)}),
      Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
b = <b>CrossingMonitoring</b>(u=..., threshold = 0).y;
</p></blockquote>

<h4>Description</h4>

<p>
Whenever the Real input <b>u</b> crosses parameter <b>threshold</b> from negative to positive values, 
output <b>y</b> is set to true, and whenever u crosses threshold from positive to negative values,
y is set to false. The default value for the threshold = 0.
</p>

<h4>Example</h4>

<p>
This block is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Elementary.SignalAnalysis.CrossingMonitoring\">example</a>: 
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/CrossingMonitoring1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/CrossingMonitoring2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end CrossingMonitoring;

  block StepResponse
    "Running step-response metrics of u after a step of r, sampled: the peak, the level crossings, the last exit from the settling band, the extrema (ModCheck's requirements plan, section 21)"
    import Modelica.Units.SI;
    import Requirements.Types.StepTarget;

    Modelica.Blocks.Interfaces.RealInput u "The response"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput r "The stepping signal (the setpoint or the disturbance)"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    parameter StepTarget target = StepTarget.Stepping
      "The target the metrics measure u against: the stepping signal after the step, or the yRef input"
      annotation(Evaluate=true);
    Modelica.Blocks.Interfaces.RealInput yRef if target == StepTarget.Reference
      "The reference the response is measured against (target = Reference)"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    parameter Real threshold(min=0) = 0
      "A step is a change of r between two samples of at least this (0: any change)";
    parameter SI.Time samplePeriod(min=Modelica.Constants.eps) = 1e-3
      "The metrics are evaluated at this period (at the half-periods, off a result grid of the same period); a level crossing is interpolated between two samples";
    parameter Real level1(min=0, max=1) = 0.1 "Lower level of the rise time, a fraction of the change";
    parameter Real level2(min=0, max=1) = 0.9 "Upper level of the rise time, a fraction of the change";
    parameter Real band(min=0) = 0.02 "Settling band around the target: a fraction of the change (bandIsFraction) or an absolute value";
    parameter Boolean bandIsFraction = true "= true: band is a fraction of |deltaY|; false: in u's unit";
    parameter SI.Time T_window(min=0) = 0
      "0: a step's window runs to the next step of r; > 0: it closes T_window after the step";
    parameter Real peakFraction(min=0) = 0.001
      "An extremum beyond the target counts when its amplitude exceeds this fraction of the base (|deltaY|, or the largest deviation)";

    Modelica.Blocks.Interfaces.BooleanOutput active "= true while a step's window is open"
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.BooleanOutput closed "= true at the sample that closes a window (the next step, or T_window after the step)"
      annotation (Placement(transformation(extent={{100,60},{120,80}})));
    Modelica.Blocks.Interfaces.IntegerOutput nSteps "Number of steps seen so far"
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput tStep(unit="s") "Instant of the last step (-1 before the first)"
      annotation (Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealOutput y0 "The response before the step"
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Modelica.Blocks.Interfaces.RealOutput yInf "The target"
      annotation (Placement(transformation(extent={{100,-20},{120,0}})));
    Modelica.Blocks.Interfaces.RealOutput deltaY "The change yInf - y0, the base of every percent"
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
    Modelica.Blocks.Interfaces.RealOutput overshoot "The largest excursion beyond the target in the direction of the change, in u's unit (never negative)"
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
    Modelica.Blocks.Interfaces.RealOutput undershoot "The largest excursion opposite to the change, beyond y0, in u's unit"
      annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
    Modelica.Blocks.Interfaces.RealOutput tPeak(unit="s") "Instant of the overshoot"
      annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
    Modelica.Blocks.Interfaces.RealOutput tLevel1(unit="s") "Instant the lower level is first reached (-1 until then)";
    Modelica.Blocks.Interfaces.RealOutput tLevel2(unit="s") "Instant the upper level is first reached (-1 until then)";
    Modelica.Blocks.Interfaces.RealOutput tHalf(unit="s") "Instant half the change is first reached (-1 until then)";
    Modelica.Blocks.Interfaces.RealOutput riseTime(unit="s") "The rise time: tLevel2 - tLevel1 once both are reached, else the time since tLevel1 (or the step) so far -- a lower bound";
    Modelica.Blocks.Interfaces.RealOutput delayTime(unit="s") "The delay time: tHalf - tStep once reached, else the time since the step so far";
    Modelica.Blocks.Interfaces.RealOutput settlingTime(unit="s") "The last exit from the settling band so far, relative to the step (the time since the step while outside)";
    Modelica.Blocks.Interfaces.BooleanOutput inBand "= true while |u - yInf| <= the band";
    Modelica.Blocks.Interfaces.RealOutput error "|u - yInf| now: the steady-state error when the window closes";
    Modelica.Blocks.Interfaces.IntegerOutput nExtrema "Extrema beyond the target closed so far (alternating in sign)";
    Modelica.Blocks.Interfaces.RealOutput a1 "Amplitude of the first extremum (0 until it closes)";
    Modelica.Blocks.Interfaces.RealOutput a2 "Amplitude of the second extremum";
    Modelica.Blocks.Interfaces.RealOutput a3 "Amplitude of the third extremum";
    Modelica.Blocks.Interfaces.RealOutput zeta "The damping ratio: from the log decrement of a1 and a2, from the overshoot alone, or 1 (monotone); provisional until the window closes";
    Modelica.Blocks.Interfaces.RealOutput decayRatio "a3 / a1 (0 until a third extremum closes)";
    Modelica.Blocks.Interfaces.RealOutput openAmplitude "Amplitude of the extremum segment still open (0: none) -- the last extremum when the window closes at a step";
    Modelica.Blocks.Interfaces.IntegerOutput openSign "Sign of the open segment (0: none)";
    Modelica.Blocks.Interfaces.BooleanOutput noBase "= true when the response's change over the step is below a quarter of its largest deviation (a disturbance): no base for a percent";
  protected
    Modelica.Blocks.Interfaces.RealInput yRefInternal "yRef, or 0 without a reference input";
    discrete Real rS "r at the last sample";
    discrete Real uS "u at the last sample";
    discrete Real s "Orientation of the excursion: sign(deltaY), or the side of the largest deviation for a disturbance";
    discrete Real e "The excursion s (u - yInf) at the last sample";
    discrete Real eS "The excursion at the sample before";
    discrete Boolean reached "The response has reached its target since the step";
    discrete Boolean stepNow "A step was seen at this sample";
    discrete Real rAfter "r after the step";
    discrete Real maxDev "The largest |u - yInf| since the step";
    discrete Integer segSign "Sign of the open extremum segment (0: none)";
    discrete Real segMax "Amplitude of the open segment";
    discrete Boolean wasOutside "Outside the band at the sample before";
    discrete Real base "The base of the extremum threshold: |deltaY| or the largest deviation";
    discrete Real yInfS "The target at the last sample";
  equation
    connect(yRef, yRefInternal);
    if target <> StepTarget.Reference then
      yRefInternal = 0;
    end if;
  algorithm
    when sample(samplePeriod/2, samplePeriod) then
      // -- the step: a change of r between two samples
      stepNow := abs(r - pre(rS)) > (if threshold > 0 then threshold*(1 - 1e-12) else 0);
      // -- closing the open window: at the next step or T_window after the step
      closed := pre(active) and (stepNow or (T_window > 0 and time >= pre(tStep) + T_window - 1e-9*samplePeriod));
      if pre(active) and closed and not stepNow and pre(segSign) <> 0 then
        // the window closes T_window after the step: the open extremum segment closes with it
        // (a window closed by the next step keeps its open segment in openAmplitude / openSign,
        // read with pre() by a check block at that sample, since the step resets the metrics)
        nExtrema := pre(nExtrema) + 1;
        if nExtrema == 1 then
          a1 := pre(segMax);
        elseif nExtrema == 2 then
          a2 := pre(segMax);
        elseif nExtrema == 3 then
          a3 := pre(segMax);
        end if;
        segSign := 0;
        segMax := 0;
      end if;
      if stepNow then
        nSteps := pre(nSteps) + 1;
        active := true;
        tStep := time;
        y0 := pre(uS);
        rAfter := r;
        reached := false;
        maxDev := 0;
        overshoot := 0;
        undershoot := 0;
        tPeak := time;
        tLevel1 := -1;
        tLevel2 := -1;
        tHalf := -1;
        settlingTime := 0;
        wasOutside := false;
        nExtrema := 0;
        a1 := 0;
        a2 := 0;
        a3 := 0;
        segSign := 0;
        segMax := 0;
        eS := 0;
      elseif pre(active) and closed then
        active := false;
      end if;
      // -- the target and the orientation
      if active then
        yInf := if target == StepTarget.Reference then yRefInternal else rAfter;
        deltaY := yInf - y0;
        maxDev := max(pre(maxDev), abs(u - yInf));
        if abs(deltaY) > max(1e-12, 0.25*maxDev) then
          s := if deltaY > 0 then 1 else -1;
        elseif not stepNow and pre(active) then
          // a disturbance: the side of the largest deviation so far
          s := if abs(u - yInf) >= pre(maxDev) then (if u - yInf >= 0 then 1 else -1) else pre(s);
        else
          s := 1;
        end if;
        base := max(abs(deltaY), maxDev);
        noBase := abs(deltaY) <= max(1e-12, 0.25*maxDev);
        e := s*(u - yInf);
        eS := if stepNow then s*(pre(uS) - yInf) else pre(e);
        // -- the peaks
        if e > pre(overshoot) then
          overshoot := e;
          tPeak := time;
        end if;
        undershoot := max(pre(undershoot), -s*(u - y0));
        // -- the level crossings, interpolated between the two samples
        if tLevel1 < 0 and s*(u - (y0 + level1*deltaY)) >= 0 then
          tLevel1 := if stepNow or s*(pre(uS) - (y0 + level1*deltaY)) >= 0 then time else
            time - samplePeriod*(s*(u - (y0 + level1*deltaY)))/(s*(u - pre(uS)));
        end if;
        if tLevel2 < 0 and s*(u - (y0 + level2*deltaY)) >= 0 then
          tLevel2 := if stepNow or s*(pre(uS) - (y0 + level2*deltaY)) >= 0 then time else
            time - samplePeriod*(s*(u - (y0 + level2*deltaY)))/(s*(u - pre(uS)));
        end if;
        if tHalf < 0 and s*(u - (y0 + 0.5*deltaY)) >= 0 then
          tHalf := if stepNow or s*(pre(uS) - (y0 + 0.5*deltaY)) >= 0 then time else
            time - samplePeriod*(s*(u - (y0 + 0.5*deltaY)))/(s*(u - pre(uS)));
        end if;
        riseTime := if tLevel2 >= 0 then tLevel2 - (if tLevel1 >= 0 then tLevel1 else tStep) else
          time - (if tLevel1 >= 0 then tLevel1 else tStep);
        delayTime := if tHalf >= 0 then tHalf - tStep else time - tStep;
        // -- the settling band: the last exit
        inBand := abs(u - yInf) <= (if bandIsFraction then band*abs(deltaY) else band);
        if not inBand then
          settlingTime := time - tStep;
        elseif pre(wasOutside) and not stepNow then
          // back inside: the crossing between the two samples
          settlingTime := time - tStep - samplePeriod*((if bandIsFraction then band*abs(deltaY) else band) - abs(u - yInf))
            /max(1e-300, abs(pre(uS) - yInfS) - abs(u - yInf));
        end if;
        wasOutside := not inBand;
        error := abs(u - yInf);
        // -- the extrema beyond the target, counted from the first reach
        reached := pre(reached) or e >= 0;
        if reached then
          if e > peakFraction*base and pre(segSign) <> 1 or e < -peakFraction*base and pre(segSign) <> -1 then
            // a new segment on the other side: the previous one closes
            if pre(segSign) <> 0 then
              nExtrema := pre(nExtrema) + 1;
              if nExtrema == 1 then
                a1 := pre(segMax);
              elseif nExtrema == 2 then
                a2 := pre(segMax);
              elseif nExtrema == 3 then
                a3 := pre(segMax);
              end if;
            end if;
            segSign := if e > 0 then 1 else -1;
            segMax := abs(e);
          elseif segSign <> 0 then
            segMax := max(pre(segMax), if (e > 0) == (segSign > 0) then abs(e) else 0);
          end if;
        end if;
      else
        yInf := pre(yInf);
        deltaY := pre(deltaY);
        s := pre(s);
        base := pre(base);
        e := pre(e);
        inBand := pre(inBand);
        error := pre(error);
      end if;
      // -- the damping and decay ratios from the closed extrema
      if nExtrema >= 2 and a2 > 0 then
        zeta := 2*log(a1/a2)/sqrt(4*Modelica.Constants.pi^2 + (2*log(a1/a2))^2);
      elseif nExtrema == 1 and not noBase and abs(deltaY) > 0 then
        zeta := if a1/abs(deltaY) >= 1 then 0 else -log(a1/abs(deltaY))/sqrt(Modelica.Constants.pi^2 + log(a1/abs(deltaY))^2);
      else
        zeta := 1;
      end if;
      decayRatio := if nExtrema >= 3 and a1 > 0 then a3/a1 else 0;
      openAmplitude := segMax;
      openSign := segSign;
      rS := r;
      uS := u;
      yInfS := yInf;
    end when;
  initial equation
    rS = r;
    uS = u;
    yInfS = 0;
    active = false;
    closed = false;
    stepNow = false;
    nSteps = 0;
    tStep = -1;
    y0 = 0;
    yInf = 0;
    deltaY = 0;
    s = 1;
    e = 0;
    eS = 0;
    reached = false;
    rAfter = 0;
    maxDev = 0;
    overshoot = 0;
    undershoot = 0;
    tPeak = -1;
    tLevel1 = -1;
    tLevel2 = -1;
    tHalf = -1;
    riseTime = 0;
    delayTime = 0;
    settlingTime = 0;
    inBand = true;
    wasOutside = false;
    error = 0;
    nExtrema = 0;
    a1 = 0;
    a2 = 0;
    a3 = 0;
    segSign = 0;
    segMax = 0;
    base = 0;
    zeta = 1;
    decayRatio = 0;
    openAmplitude = 0;
    openSign = 0;
    noBase = false;
    annotation (defaultComponentName="stepResponse1",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}, lineThickness=5.0, fillColor={210,210,210},
            fillPattern=FillPattern.Solid, borderPattern=BorderPattern.Raised),
          Line(points={{-80,-60},{-40,-60},{-40,20},{-20,50},{0,30},{20,42},{40,36},{80,38}}, color={0,0,255}, thickness=0.5),
          Line(points={{-40,38},{80,38}}, color={0,140,72}, pattern=LinePattern.Dash),
          Text(extent={{-100,-70},{100,-100}}, textColor={0,0,0}, textString="step response")}),
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><p>
metrics = <b>StepResponse</b>(u=..., r=..., target=..., samplePeriod=...);
</p></blockquote>

<h4>Description</h4>
<p>
The running metrics of the step response of <b>u</b> after a step of <b>r</b>, evaluated at every
<b>samplePeriod</b> (ModCheck's requirements plan, section 21.2, the R3 layer of section 21.7):
a step is a change of r between two samples of at least <b>threshold</b> (any change with the default 0);
its window runs to the next step of r, or closes <b>T_window</b> after it when that is set; the target
<b>yInf</b> is r after the step (<b>target</b> = Stepping) or the current value of the <b>yRef</b> input
(Reference); <code>y0</code> is u at the sample before the step, <code>deltaY = yInf - y0</code> the base
of every percent, and the excursion <code>e = s (u - yInf)</code> is oriented by the sign of the change
-- for a disturbance (the response starts and ends at the target, its change below a quarter of its
largest deviation) by the side of that deviation, so <b>overshoot</b> is the peak deviation.
</p>
<p>
Outputs: <b>overshoot</b> and <b>undershoot</b> with <b>tPeak</b>; the level crossings <b>tLevel1</b>,
<b>tLevel2</b>, <b>tHalf</b> interpolated between the two samples around them, and from them
<b>riseTime</b> (a lower bound -- the time since the lower level -- until the upper level is reached)
and <b>delayTime</b>; <b>settlingTime</b> the last exit from the <b>band</b> around the target so far
(the time since the step while outside, the interpolated re-entry once inside); <b>error</b> the current
deviation from the target (the steady-state error when the window closes); the extrema beyond the
target, counted from the first reach of the target, each a maximal segment of one sign beyond
<b>peakFraction</b> of the base, closed when the other side is entered or the window closes
(<b>nExtrema</b>, <b>a1</b>, <b>a2</b>, <b>a3</b>); <b>zeta</b> the damping ratio from the log decrement
<code>2 ln(a1/a2)</code>, from the overshoot alone when only one extremum has closed, or 1 (monotone);
<b>decayRatio</b> = a3/a1.
</p>
<p>
The metrics are sampled: an instant is known to one <b>samplePeriod</b>, a peak read low by the
curvature over one period. The reported verdict of a step-response requirement is computed by
ModCheck's <code>step_checks.py</code> on the stored trajectory (rule R7); this block is the
development aid in a Modelica tool and its cross-check, and
<a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">StepResponseCheck</a>
turns one of its metrics into a Property. The post-processing target <em>the response's final
value</em> has no running form and is not offered here.
</p>
<h4>Example</h4>
<p>
<a href=\"modelica://Requirements.Examples.Elementary.StepResponse\">Examples.Elementary.StepResponse</a>:
the second-order system's closed forms asserted against the block's outputs.
</p>
</html>"));
  end StepResponse;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Line(
          points={{-90,-56},{-40,-28},{-32,64},{-6,64},{4,-54},{30,34},{42,-68},
              {62,-30},{86,62}},
          color={135,135,135},
          smooth=Smooth.Bezier)}));
end SignalAnalysis;
