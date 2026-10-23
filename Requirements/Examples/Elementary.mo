within Requirements.Examples;
package Elementary
  "Library of examples to demonstrate the features of single property functions/blocks using a graphical description"
    extends Modelica.Icons.ExamplesPackage;

  package Verify "Library of examples using Verify blocks"
    extends Modelica.Icons.ExamplesPackage;

    model Requirement
      "Example for Requirement (Property shall not be Violated)"
      import Requirements;
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={1.5,3.3,4.2})
        annotation (Placement(transformation(extent={{-88,20},{-68,40}})));
      Requirements.Sources.PropertyConstant propertyConstant(c=Requirements.Types.Property.Undecided)
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
      inner Requirements.Verify.PrintViolations printViolations(evaluationTime=5)
        annotation (Placement(transformation(extent={{40,62},{60,82}})));
      Requirements.Verify.Requirement R_violated(text=
            "Input gives a violated requirement")
        annotation (Placement(transformation(extent={{0,20},{60,40}})));
      Requirements.Verify.Requirement R_Satisfied(text=
            "Input gives a satisfied requirement")
        annotation (Placement(transformation(extent={{0,-10},{60,10}})));
      Requirements.Verify.Requirement R_Undecided(text=
            "Input gives an undecided requirement")
        annotation (Placement(transformation(extent={{0,-40},{60,-20}})));

      Requirements.LogicalBlocks.BooleanToProperty BtoP1
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Requirements.ChecksInFixedWindow.During during1(check=check.y)
        annotation (Placement(transformation(extent={{-52,-10},{-12,10}})));
    equation

      connect(propertyConstant.y, R_Undecided.property) annotation (Line(
          points={{-59,-30},{-2,-30}},
          color={255,0,128},
          smooth=Smooth.None));
      connect(check.y, BtoP1.u) annotation (Line(
          points={{-67,30},{-37,30}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(BtoP1.y, R_violated.property) annotation (Line(
          points={{-24,30},{-2,30}},
          color={255,0,128},
          smooth=Smooth.None));
      connect(R_Satisfied.property, during1.y)
        annotation (Line(points={{-2,0},{-6,0},{-11,0}}, color={255,0,128}));
      connect(check.y, during1.condition) annotation (Line(points={{-67,30},{
              -67,30},{-60,30},{-60,0.1},{-54,0.1}}, color={255,0,255}));
      annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Using the <a href=\"modelica://Requirements.Verify.Requirement\">Requirement</a> block as
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
and gives the following output to the output window:
</p>

<blockquote>
<pre>
Requirements violated (1 of 3):
    (R_violated at 1.5 s): Input gives a violated requirement

Requirements untested (1 of 3):
    (R_Undecided): Input gives an undecided requirement

Requirements satisfied (1 of 3):
    (R_Satisfied): Input gives a satisfied requirement
</pre>
</blockquote>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}})));
    end Requirement;
  end Verify;

  package TimeLocators "Library of examples using TimeLocators blocks"
      extends Modelica.Icons.ExamplesPackage;

    model Every
      "Example for Every (output is true, during every interval for a defined duration)"
       extends Modelica.Icons.Example;

      Requirements.TimeLocators.Every every(interval=2, duration=0.5)
        annotation (Placement(transformation(extent={{-80,40},{-40,60}})));
      annotation (experiment(StopTime=11),Documentation(info="<html>
<p>
Using time locator block <a href=\"modelica://Requirements.TimeLocators.Every\">Every</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/Every1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/Every2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end Every;

    model Until
      "Example for Until (output is true, until first rising edge of input)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanPulse pulse1(period=2)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanPulse pulse2(period=2, startTime=3)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

      Requirements.TimeLocators.Until until1(u=pulse1.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.TimeLocators.Until until2(u=pulse2.y)
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      annotation (experiment(StopTime=8), Documentation(info="<html>
<p>
Using time locator block <a href=\"modelica://Requirements.TimeLocators.Until\">Until</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/Until1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/Until2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end Until;

    model After
      "Example for After (output is true, after first rising edge of input)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanPulse pulse1(period=2)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanPulse pulse2(period=2, startTime=3)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

      Requirements.TimeLocators.After after1(u=pulse1.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.TimeLocators.After after2(u=pulse2.y)
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      annotation (experiment(StopTime=8), Documentation(info="<html>
<p>
Using time locator block <a href=\"modelica://Requirements.TimeLocators.After\">After</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/After1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/After2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end After;

    model AfterFor
      "Example for AfterFor (output is true, after rising edge of input for defined duration)"
       extends Modelica.Icons.Example;

      Requirements.TimeLocators.AfterFor afterFor(duration=1, u=timeTable.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Modelica.Blocks.Sources.BooleanTable timeTable(table={1,3,5,5.2,9,9.2,9.5,9.7},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      annotation (experiment(StopTime=12),Documentation(info="<html>
<p>
Using time locator block <a href=\"modelica://Requirements.TimeLocators.AfterFor\">AfterFor</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/AfterFor1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/AfterFor2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end AfterFor;

    model AfterUntil
      "Example for AfterUntil (output is true, after rising edge of input u1 until rising edge of input u2)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanPulse pulse1(period=2)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanPulse pulse2(          startTime=3, period=1.5)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

      Requirements.TimeLocators.AfterUntil afterUntil1(u1=pulse1.y,u2=pulse2.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (experiment(StopTime=8), Documentation(info="<html>
<p>
Using time locator block <a href=\"modelica://Requirements.TimeLocators.AfterUntil\">AfterUntil</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/AfterUntil1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/TimeLocators/AfterUntil2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));

    end AfterUntil;
  end TimeLocators;

  package ChecksInFixedWindow
    "Library of examples using ChecksInFixedWindow blocks"
    model During
      "Example for During (in every true condition phase, check must be true)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,3,5,7,9,9.5,11,13},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={0.5,2.5,5.5,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.During during(check=check.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, during.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.During\">During</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/During1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/During2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end During;

    model MinDuration
      "Example for MinDuration (in every true condition phase, check must be true for at least the defined duration)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,3,5,7,9,9.5,11,13},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={0.5,2.5,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.MinDuration minDuration(durationMin=1,
                check=check.y)
              annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, minDuration.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.MinDuration\">MinDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MinDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MinDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinDuration;
    extends Modelica.Icons.ExamplesPackage;

    model MaxDuration
      "Example for MaxDuration (in every true condition phase, check must be true for at most the defined duration)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,3,5,7,9,9.5,11,13},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={0.5,2.5,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.MaxDuration maxDuration(durationMax=1,
                check=check.y)
              annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, maxDuration.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.MaxDuration\">MaxDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxDuration;

    model BandDuration
      "Example for BandDuration (in every true condition phase, check must be true for at least a minimum duration and at most a maximum duration)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,3,5,7,9,9.5,11,13},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={0.5,2.5,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.BandDuration bandDuration1(
        check=check.y,
        durationMin=0.9,
        durationMax=1.3)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, bandDuration1.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.BandDuration\">BandDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/BandDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/BandDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end BandDuration;

    model NoRising
      "Example for NoRising (in every true condition phase, no rising edge of check is allowed)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={0.2,0.3,0.4,
            1.1,1.2,1.3,1.4,2.2,2.5,2.8,3.4,3.6,3.8})
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.NoRising noRising1(check=check.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, noRising1.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=5),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.NoRising\">NoRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/NoRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/NoRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end NoRising;

    model FixedRising
      "Example for FixedRising (in every true condition phase, a defined number of check rising edges must occur)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={0.2,0.3,0.4,
            1.1,1.2,1.3,1.4,2.2,2.5,3.1,3.15,3.2,3.25,3.3, 3.35,3.4,3.45,
            4.1,4.15,4.3,4.35,4.5,4.55,4.7,4.75,4.9,4.95})
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.FixedRising fixedRising1(check=check.y, nRising=4)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.FixedRising fixedRising2(check=check.y, nRising=
            0)
        annotation (Placement(transformation(extent={{-40,10},{0,30}})));
    equation
      connect(condition.y, fixedRising1.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition.y, fixedRising2.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,20.1},{-42,20.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=5),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.FixedRising\">FixedRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/FixedRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/FixedRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end FixedRising;

    model MinRising
      "Example for MinRising (in every true condition phase, a minimum number of check rising edges must occur)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={0.2,0.3,0.4,
            1.1,1.2,1.3,1.4,2.2,2.5,3.1,3.15,3.2,3.25,3.3, 3.35,3.4,3.45})
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.MinRising minRising1(check=check.y,
          nRisingMin=3)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, minRising1.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=5),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.MinRising\">MinRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MinRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MinRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinRising;

    model MaxRising
      "Example for MaxRising (in every true condition phase, the number of check rising edges is bounded)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={0.2,0.3,0.4,
            1.1,1.2,1.3,1.4,2.2,2.5,3.1,3.15,3.2,3.25,3.3, 3.35,3.4,3.45})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.MaxRising maxRising(nRisingMax=3, check=
            check.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, maxRising.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=5),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.MaxRising\">MaxRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxRising;

    model BandRising
      "Example for BandRising (in every true condition phase, a minimum number of check rising edges must occur and the number of check rising edges is bounded)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable condition(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=true, table={0.2,0.3,0.4,
            1.1,1.2,1.3,1.4,2.2,2.5,3.1,3.15,3.2,3.25,3.3, 3.35,3.4,3.45})
        annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
      Requirements.ChecksInFixedWindow.BandRising bandRising(nRisingMax=3, check=check.y,
        nRisingMin=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(condition.y, bandRising.condition) annotation (Line(
          points={{-59,50},{-50,50},{-50,50.1},{-42,50.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=5),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.BandRising\">BandRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/BandRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/BandRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end BandRising;

    model MaxRisingFrequency
      "Example for MaxRisingFrequency (in every true condition phase, the frequency of the check rising edges is limited)"
       extends Modelica.Icons.Example;
      constant Real pi = Modelica.Constants.pi;

      Modelica.Blocks.Sources.BooleanTable condition(
          startValue=false, table={1,3,5,7,9,9.5,11,13,17})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.SignalAnalysis.CrossingMonitoring crossing
        annotation (Placement(transformation(extent={{36,10},{56,30}})));
      Requirements.ChecksInFixedWindow.MaxRisingFrequency maxFrequency1(
          freqHzMax=3, check=crossing.y)
                       annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.Sources.RealExpression expr1(y=sin(2*pi*(if time < 5
             then 2 elseif time < 10 then 4 elseif time < 15 then 2 else 0)*time))
        annotation (Placement(transformation(extent={{-92,10},{16,30}})));
    equation
      connect(condition.y, maxFrequency1.condition)
        annotation (Line(points={{-59,50},{-42,50},{-42,50}},   color={255,0,255}));
      connect(expr1.y, crossing.u)
        annotation (Line(points={{18.7,20},{26,20},{34,20}},
                                                           color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}),            graphics), experiment(StopTime=18, Interval=1e-4),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.MaxRisingFrequency\">MaxRisingFrequency</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxRisingFrequency1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/MaxRisingFrequency2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxRisingFrequency;

    model WhenRising
      "Example for WhenRising (return Satisfied when check is true and condition has a rising edge)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check1(startValue=true, table={1.5,
            3.3,4.2})
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.BooleanTable condition1(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Requirements.ChecksInFixedWindow.WhenRising whenRising1(check=check1.y)
        annotation (Placement(transformation(extent={{20,20},{60,40}})));
      Requirements.ChecksInFixedWindow.WhenRising whenRising2(check=check1.y)
        annotation (Placement(transformation(extent={{20,-10},{60,10}})));
      Modelica.Blocks.MathBoolean.Not condition2
        annotation (Placement(transformation(extent={{0,-4},{8,4}})));
      Requirements.ChecksInFixedWindow.WhenRising whenRising3(check=check2.y)
        annotation (Placement(transformation(extent={{20,-40},{60,-20}})));
      Modelica.Blocks.MathBoolean.Not check2
        annotation (Placement(transformation(extent={{-28,-14},{-20,-6}})));
    equation

      connect(condition1.y, whenRising1.condition) annotation (Line(
          points={{-39,30},{-30,30},{-30,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.u, whenRising1.condition) annotation (Line(
          points={{-1.6,0},{-10,0},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(whenRising3.condition, whenRising1.condition) annotation (Line(
          points={{18,-29.9},{-10,-29.9},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(check1.y, check2.u) annotation (Line(
          points={{-39,-10},{-29.6,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.y, whenRising2.condition) annotation (Line(
          points={{8.8,0},{14,0},{14,0.1},{18,0.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.WhenRising\">WhenRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end WhenRising;

    model WhenFalling
      "Example for WhenFalling (return Satisfied when check is true and condition has a falling edge)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check1(startValue=true, table={1.5,
            3.3,4.2})
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.BooleanTable condition1(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Requirements.ChecksInFixedWindow.WhenFalling whenFalling1(check=check1.y)
        annotation (Placement(transformation(extent={{20,20},{60,40}})));
      Requirements.ChecksInFixedWindow.WhenFalling whenFalling2(check=check1.y)
        annotation (Placement(transformation(extent={{20,-10},{60,10}})));
      Modelica.Blocks.MathBoolean.Not condition2
        annotation (Placement(transformation(extent={{0,-4},{8,4}})));
      Requirements.ChecksInFixedWindow.WhenFalling whenFalling3(check=check2.y)
        annotation (Placement(transformation(extent={{20,-40},{60,-20}})));
      Modelica.Blocks.MathBoolean.Not check2
        annotation (Placement(transformation(extent={{-28,-14},{-20,-6}})));
    equation

      connect(condition1.y, whenFalling1.condition) annotation (Line(
          points={{-39,30},{-30,30},{-30,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.u, whenFalling1.condition) annotation (Line(
          points={{-1.6,0},{-10,0},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(whenFalling3.condition, whenFalling1.condition) annotation (Line(
          points={{18,-29.9},{-10,-29.9},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(check1.y, check2.u) annotation (Line(
          points={{-39,-10},{-29.6,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.y, whenFalling2.condition) annotation (Line(
          points={{8.8,0},{14,0},{14,0.1},{18,0.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.WhenFalling\">WhenFalling</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenFalling1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenFalling2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td></tr>
</table>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end WhenFalling;

    model WhenChanging
      "Example for WhenChanging (return Satisfied when check is true and condition has a changing edge)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check1(startValue=true, table={1.5,
            3.3,4.2})
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.BooleanTable condition1(table={1,2,3,3.5,4},
          startValue=false)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Requirements.ChecksInFixedWindow.WhenChanging whenChanging1(check=check1.y)
        annotation (Placement(transformation(extent={{20,20},{60,40}})));
      Requirements.ChecksInFixedWindow.WhenChanging whenChanging2(check=check1.y)
        annotation (Placement(transformation(extent={{20,-10},{60,10}})));
      Modelica.Blocks.MathBoolean.Not condition2
        annotation (Placement(transformation(extent={{0,-4},{8,4}})));
      Requirements.ChecksInFixedWindow.WhenChanging whenChanging3(check=check2.y)
        annotation (Placement(transformation(extent={{20,-40},{60,-20}})));
      Modelica.Blocks.MathBoolean.Not check2
        annotation (Placement(transformation(extent={{-28,-14},{-20,-6}})));
    equation

      connect(condition1.y, whenChanging1.condition) annotation (Line(
          points={{-39,30},{-30,30},{-30,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.u, whenChanging1.condition) annotation (Line(
          points={{-1.6,0},{-10,0},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(whenChanging3.condition, whenChanging1.condition) annotation (Line(
          points={{18,-29.9},{-10,-29.9},{-10,30.1},{18,30.1}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(check1.y, check2.u) annotation (Line(
          points={{-39,-10},{-29.6,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(condition2.y, whenChanging2.condition) annotation (Line(
          points={{8.8,0},{14,0},{14,0.1},{18,0.1}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.WhenChanging\">WhenChanging</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenChanging1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WhenChanging2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end WhenChanging;

    model WithinDomain
      "Example for WithinDomain (in every true condition phase, point input must be within domain defined by polygon)"
       import Requirements;
       extends Modelica.Icons.Example;

      Requirements.ChecksInFixedWindow.WithinDomain withinDomain(polygon=[
            0.200003,1; 0.262864,1.06863; 0.31059,1.13545; 0.328082,1.18709;
            0.339319,1.2227; 0.366828,1.2975; 0.394388,1.35717; 0.413196,
            1.39279; 0.434519,1.4311; 0.45963,1.46851; 0.473459,1.48366;
            0.497347,1.50951; 0.518703,1.53802; 0.542597,1.56209; 0.556408,
            1.58258; 0.574017,1.59952; 0.596673,1.61646; 0.621856,1.63252;
            0.647041,1.64769; 0.673492,1.66197; 0.698669,1.67981; 0.723857,
            1.69409; 0.749043,1.70926; 0.772973,1.72265; 0.796897,1.73782;
            0.827112,1.75834; 0.859848,1.77975; 0.883775,1.79403; 0.901416,
            1.80118; 1.79731,1.80267; 1.79787,1.25984; 1.74873,1.2384; 1.70086,
            1.21608; 1.65676,1.19554; 1.6114,1.17499; 1.56474,1.16691; 1.53575,
            1.15796; 1.48661,1.1383; 1.44375,1.12488; 1.38575,1.11143; 1.31012,
            1.08728; 1.24708,1.07294; 1.19289,1.05238; 1.15004,1.0354; 1.11854,
            1.022; 1.09965,1.01129; 1.08581,1.00059; 0.200006,0.99911; 0.200003,
            1]) annotation (Placement(transformation(extent={{-20,0},{20,40}})));

      Modelica.Blocks.Sources.CombiTimeTable table(table=[0,0.26,1; 0.023,
            0.262864,1.02; 0.046,0.31059,1.02; 0.069,0.328082,1.03; 0.092,
            0.339319,1.05; 0.115,0.366828,1.07; 0.138,0.394388,1.1; 0.161,
            0.413196,1.11; 0.184,0.434519,1.12; 0.207,0.45963,1.13; 0.23,
            0.473459,1.14; 0.253,0.497347,1.15; 0.276,0.518703,1.16; 0.299,
            0.542597,1.17; 0.322,0.556408,1.18; 0.345,0.574017,1.19; 0.368,
            0.596673,1.2; 0.391,0.621856,1.21; 0.414,0.647041,1.22; 0.437,
            0.673492,1.23; 0.46,0.698669,1.24; 0.483,0.723857,1.25; 0.506,
            0.749043,1.26; 0.529,0.772973,1.27; 0.552,0.796897,1.25; 0.575,
            0.827112,1.22; 0.598,0.859848,1.19; 0.621,0.883775,1.18; 0.644,
            0.901416,1.19; 0.667,1.08581,1.18; 0.69,1.09965,1.17; 0.713,1.11854,
            1.16; 0.736,1.15004,1.15; 0.759,1.19289,1.14; 0.782,1.24708,1.13;
            0.805,1.31012,1.12; 0.828,1.38575,1.11; 0.851,1.44375,1.1; 0.874,
            1.48661,1.09; 0.897,1.53575,1.08; 0.92,1.56474,1.07; 0.943,1.6114,
            1.06; 0.966,1.65676,1.05; 0.989,1.70086,1.04; 1.012,1.74873,1.03;
            1.035,1.79787,1.02; 1.058,1.79731,1.01])
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

      Requirements.Sources.BooleanConstant const1
        annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
    equation
      connect(table.y, withinDomain.point) annotation (Line(points={{-59,10},{-42,
              10},{-22,10}}, color={0,0,127}));
      connect(withinDomain.condition, const1.y) annotation (Line(points={{-22,
              20.1},{-26,20.1},{-26,20},{-29,20}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Text(
              extent={{-190,120},{210,160}},
              lineColor={175,175,175},
              textString="%name")}),          experiment(StopTime=1.2),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow.WithinDomain\">WithinDomain</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WithinDomain1a.png\">
</blockquote></p>

<p>
displays the polygon and the point in the icon of the block. If the point is within the polygon,
the point is displayed in green and the polygon area in grey (the grey point on the polygon
marks the polygon point that is closest to the point).
If the point is outside of the polygon, it is displayed in red and the polygon area
in light red:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WithinDomain1b.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow/WithinDomain2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
<p>
Note, that the point is outside of the domain defined by the polygon if distance &lt; 0.
</p>
</html>"));
    end WithinDomain;

    model WithinBand
      "Example for WithinBand (a sine and three constants against a band, always, never and sometimes active)"
      extends Modelica.Icons.Example;
      Modelica.Blocks.Sources.Sine sin(f=1) "u = sin(2 pi t / 1 s)"
        annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
      Modelica.Blocks.Sources.Constant zer(k=0) "u = 0, inside the band"
        annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
      Modelica.Blocks.Sources.Constant zer1(k=0.5) "u = 0.5, on the upper limit"
        annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
      Modelica.Blocks.Sources.Constant zer2(k=-0.5) "u = -0.5, on the lower limit"
        annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
      Requirements.Sources.BooleanConstant on(c=true) "Always active"
        annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
      Requirements.Sources.BooleanConstant off(c=false) "Never active"
        annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
      Modelica.Blocks.Sources.BooleanPulse booPul(width=50, period=0.25) "Active in the first half of every 0.25 s"
        annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
      Requirements.ChecksInFixedWindow.WithinBand witBan(u_max=0.5, u_min=-0.5) "Always active: violated"
        annotation (Placement(transformation(extent={{-40,80},{0,100}})));
      Requirements.ChecksInFixedWindow.WithinBand witBan1(u_max=0.5, u_min=-0.5) "Never active: Undefined, untested"
        annotation (Placement(transformation(extent={{-40,50},{0,70}})));
      Requirements.ChecksInFixedWindow.WithinBand witBan2(u_max=0.5, u_min=-0.5) "Sometimes active: violated"
        annotation (Placement(transformation(extent={{-40,20},{0,40}})));
      Requirements.ChecksInFixedWindow.WithinBand con1(u_max=0.5, u_min=-0.5) "Constant inside the band: satisfied"
        annotation (Placement(transformation(extent={{-40,-30},{0,-10}})));
      Requirements.ChecksInFixedWindow.WithinBand con2(u_max=0.5, u_min=-0.5) "Constant on the upper limit: satisfied, margin 0"
        annotation (Placement(transformation(extent={{-40,-60},{0,-40}})));
      Requirements.ChecksInFixedWindow.WithinBand con3(u_max=0.5, u_min=-0.5) "Constant on the lower limit: satisfied, margin 0"
        annotation (Placement(transformation(extent={{-40,-90},{0,-70}})));
      Requirements.Verify.Requirement reqWitBan(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,80},{90,100}})));
      Requirements.Verify.Requirement reqWitBan1(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,50},{90,70}})));
      Requirements.Verify.Requirement reqWitBan2(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,20},{90,40}})));
      Requirements.Verify.Requirement reqCon1(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-30},{90,-10}})));
      Requirements.Verify.Requirement reqCon2(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-60},{90,-40}})));
      Requirements.Verify.Requirement reqCon3(text="Test whether signal is within band", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-90},{90,-70}})));
      inner Requirements.Verify.PrintViolations printViolations(useEvaluationTime=true, evaluationTime=1)
        annotation (Placement(transformation(extent={{30,-130},{90,-110}})));
    equation
      connect(sin.y, witBan.u) annotation (Line(points={{-79,80},{-60,80},{-60,96},{-42,96}}, color={0,0,127}));
      connect(sin.y, witBan1.u) annotation (Line(points={{-79,80},{-60,80},{-60,66},{-42,66}}, color={0,0,127}));
      connect(sin.y, witBan2.u) annotation (Line(points={{-79,80},{-60,80},{-60,36},{-42,36}}, color={0,0,127}));
      connect(zer.y, con1.u) annotation (Line(points={{-79,-20},{-60,-20},{-60,-14},{-42,-14}}, color={0,0,127}));
      connect(zer1.y, con2.u) annotation (Line(points={{-79,-50},{-60,-50},{-60,-44},{-42,-44}}, color={0,0,127}));
      connect(zer2.y, con3.u) annotation (Line(points={{-79,-80},{-60,-80},{-60,-74},{-42,-74}}, color={0,0,127}));
      connect(on.y, witBan.condition) annotation (Line(points={{-79,50},{-66,50},{-66,90},{-42,90}}, color={255,0,255}));
      connect(off.y, witBan1.condition) annotation (Line(points={{-79,20},{-70,20},{-70,60},{-42,60}}, color={255,0,255}));
      connect(booPul.y, witBan2.condition) annotation (Line(points={{-79,-100},{-50,-100},{-50,30},{-42,30}}, color={255,0,255}));
      connect(on.y, con1.condition) annotation (Line(points={{-79,50},{-66,50},{-66,-20},{-42,-20}}, color={255,0,255}));
      connect(on.y, con2.condition) annotation (Line(points={{-79,50},{-66,50},{-66,-50},{-42,-50}}, color={255,0,255}));
      connect(on.y, con3.condition) annotation (Line(points={{-79,50},{-66,50},{-66,-80},{-42,-80}}, color={255,0,255}));
      connect(witBan.y, reqWitBan.property) annotation (Line(points={{1,90},{26,90}}, color={0,0,255}));
      connect(witBan.margin, reqWitBan.margin) annotation (Line(points={{1,81},{26,81},{26,83}}, color={0,127,0}));
      connect(witBan1.y, reqWitBan1.property) annotation (Line(points={{1,60},{26,60}}, color={0,0,255}));
      connect(witBan1.margin, reqWitBan1.margin) annotation (Line(points={{1,51},{26,51},{26,53}}, color={0,127,0}));
      connect(witBan2.y, reqWitBan2.property) annotation (Line(points={{1,30},{26,30}}, color={0,0,255}));
      connect(witBan2.margin, reqWitBan2.margin) annotation (Line(points={{1,21},{26,21},{26,23}}, color={0,127,0}));
      connect(con1.y, reqCon1.property) annotation (Line(points={{1,-20},{26,-20}}, color={0,0,255}));
      connect(con1.margin, reqCon1.margin) annotation (Line(points={{1,-29},{26,-29},{26,-27}}, color={0,127,0}));
      connect(con2.y, reqCon2.property) annotation (Line(points={{1,-50},{26,-50}}, color={0,0,255}));
      connect(con2.margin, reqCon2.margin) annotation (Line(points={{1,-59},{26,-59},{26,-57}}, color={0,127,0}));
      connect(con3.y, reqCon3.property) annotation (Line(points={{1,-80},{26,-80}}, color={0,0,255}));
      connect(con3.margin, reqCon3.margin) annotation (Line(points={{1,-89},{26,-89},{26,-87}}, color={0,127,0}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,120}})),
        experiment(StopTime=1, Tolerance=1e-06),
        Documentation(info="<html>
<p>
Check block <a href=\"modelica://Requirements.ChecksInFixedWindow.WithinBand\">WithinBand</a> with the band
[&minus;0.5, 0.5], each check feeding a <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a>
with violation statistics and margin:
</p>
<ul>
<li> <code>witBan</code>, <code>witBan1</code> and <code>witBan2</code> check sin(2&pi;t) with the condition always true,
     always false and true in the first half of every 0.25 s. The first is violated; the second is Undefined
     throughout, so its requirement is <em>untested</em>; the third is violated in the active windows that the sine
     spends outside the band.</li>
<li> <code>con1</code>, <code>con2</code> and <code>con3</code> check the constants 0, 0.5 and &minus;0.5, always active:
     all three are satisfied (both limits are part of the band), the last two with margin 0.</li>
</ul>
<p>
This is the validation model <code>Buildings_Requirements.Validation.WithinBand</code> of
<a href=\"https://github.com/lbl-srg/modelica-buildings-requirements\">modelica-buildings-requirements</a>
(M. Wetter, LBNL), ported with the block in version 0.13.0. The verdicts are the original's, except that an
inactive check is Undefined (4) where the original reported Undecided (2).
Copyright (c) 1998-2024 The Regents of the University of California, through Lawrence Berkeley National Laboratory,
and contributors; see <a href=\"modelica://Requirements.UsersGuide.BuildingsLicense\">UsersGuide.BuildingsLicense</a>.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC (the port). All rights reserved.</p>
</html>"));
    end WithinBand;

    model GreaterEqual
      "Example for GreaterEqual (a sine and a constant compared, always, never and sometimes active)"
      extends Modelica.Icons.Example;
      Modelica.Blocks.Sources.Sine sin(f=1) "sin(2 pi t / 1 s)"
        annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
      Modelica.Blocks.Sources.Constant con(k=0) "Outputs zero"
        annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
      Requirements.Sources.BooleanConstant on(c=true) "Always active"
        annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
      Requirements.Sources.BooleanConstant off(c=false) "Never active"
        annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
      Modelica.Blocks.Sources.BooleanPulse booPul(width=50, period=0.25) "Active in the first half of every 0.25 s"
        annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
      Requirements.ChecksInFixedWindow.GreaterEqual greAct "sin >= 0, always active: violated"
        annotation (Placement(transformation(extent={{-40,80},{0,100}})));
      Requirements.ChecksInFixedWindow.GreaterEqual greAct1 "sin >= 0, never active: Undefined, untested"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.GreaterEqual greAct2 "sin >= 0, sometimes active: violated"
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      Requirements.ChecksInFixedWindow.GreaterEqual greAct3 "0 >= 0, sometimes active: satisfied, margin 0"
        annotation (Placement(transformation(extent={{-40,-40},{0,-20}})));
      Requirements.Verify.Requirement reqGreAct(text="sin >= 0", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,80},{90,100}})));
      Requirements.Verify.Requirement reqGreAct1(text="sin >= 0 (never active)", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,40},{90,60}})));
      Requirements.Verify.Requirement reqGreAct2(text="sin >= 0 (sometimes active)", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,0},{90,20}})));
      Requirements.Verify.Requirement reqGreAct3(text="0 >= 0 (sometimes active)", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-40},{90,-20}})));
      inner Requirements.Verify.PrintViolations printViolations(useEvaluationTime=true, evaluationTime=1)
        annotation (Placement(transformation(extent={{30,-90},{90,-70}})));
    equation
      connect(sin.y, greAct.u_max) annotation (Line(points={{-79,80},{-60,80},{-60,96},{-42,96}}, color={0,0,127}));
      connect(sin.y, greAct1.u_max) annotation (Line(points={{-79,80},{-60,80},{-60,56},{-42,56}}, color={0,0,127}));
      connect(sin.y, greAct2.u_max) annotation (Line(points={{-79,80},{-60,80},{-60,16},{-42,16}}, color={0,0,127}));
      connect(con.y, greAct.u_min) annotation (Line(points={{-79,-30},{-56,-30},{-56,84},{-42,84}}, color={0,0,127}));
      connect(con.y, greAct1.u_min) annotation (Line(points={{-79,-30},{-56,-30},{-56,44},{-42,44}}, color={0,0,127}));
      connect(con.y, greAct2.u_min) annotation (Line(points={{-79,-30},{-56,-30},{-56,4},{-42,4}}, color={0,0,127}));
      connect(con.y, greAct3.u_max) annotation (Line(points={{-79,-30},{-56,-30},{-56,-24},{-42,-24}}, color={0,0,127}));
      connect(con.y, greAct3.u_min) annotation (Line(points={{-79,-30},{-56,-30},{-56,-36},{-42,-36}}, color={0,0,127}));
      connect(on.y, greAct.condition) annotation (Line(points={{-79,50},{-66,50},{-66,90},{-42,90}}, color={255,0,255}));
      connect(off.y, greAct1.condition) annotation (Line(points={{-79,20},{-70,20},{-70,50},{-42,50}}, color={255,0,255}));
      connect(booPul.y, greAct2.condition) annotation (Line(points={{-79,-70},{-50,-70},{-50,10},{-42,10}}, color={255,0,255}));
      connect(booPul.y, greAct3.condition) annotation (Line(points={{-79,-70},{-50,-70},{-50,-30},{-42,-30}}, color={255,0,255}));
      connect(greAct.y, reqGreAct.property) annotation (Line(points={{1,90},{26,90}}, color={0,0,255}));
      connect(greAct.margin, reqGreAct.margin) annotation (Line(points={{1,81},{26,81},{26,83}}, color={0,127,0}));
      connect(greAct1.y, reqGreAct1.property) annotation (Line(points={{1,50},{26,50}}, color={0,0,255}));
      connect(greAct1.margin, reqGreAct1.margin) annotation (Line(points={{1,41},{26,41},{26,43}}, color={0,127,0}));
      connect(greAct2.y, reqGreAct2.property) annotation (Line(points={{1,10},{26,10}}, color={0,0,255}));
      connect(greAct2.margin, reqGreAct2.margin) annotation (Line(points={{1,1},{26,1},{26,3}}, color={0,127,0}));
      connect(greAct3.y, reqGreAct3.property) annotation (Line(points={{1,-30},{26,-30}}, color={0,0,255}));
      connect(greAct3.margin, reqGreAct3.margin) annotation (Line(points={{1,-39},{26,-39},{26,-37}}, color={0,127,0}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
        experiment(StopTime=1, Tolerance=1e-06),
        Documentation(info="<html>
<p>
Check block <a href=\"modelica://Requirements.ChecksInFixedWindow.GreaterEqual\">GreaterEqual</a>, each check feeding a
<a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> with violation statistics and margin:
</p>
<ul>
<li> <code>greAct</code>, <code>greAct1</code> and <code>greAct2</code> require sin(2&pi;t) &ge; 0 with the condition always
     true, always false and true in the first half of every 0.25 s: violated, Undefined throughout (untested), and
     violated in the active window [0.5, 0.625) s where the sine is negative.</li>
<li> <code>greAct3</code> requires 0 &ge; 0 in the same windows: satisfied, with margin 0.</li>
</ul>
<p>
This is the validation model <code>Buildings_Requirements.Validation.GreaterEqual</code> of
<a href=\"https://github.com/lbl-srg/modelica-buildings-requirements\">modelica-buildings-requirements</a>
(M. Wetter, LBNL), ported with the block in version 0.13.0. The verdicts are the original's, except that an
inactive check is Undefined (4) where the original reported Undecided (2).
Copyright (c) 1998-2024 The Regents of the University of California, through Lawrence Berkeley National Laboratory,
and contributors; see <a href=\"modelica://Requirements.UsersGuide.BuildingsLicense\">UsersGuide.BuildingsLicense</a>.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC (the port). All rights reserved.</p>
</html>"));
    end GreaterEqual;

    model StableSignal
      "Example for StableSignal (a slow and a fast sine, always and sometimes active)"
      extends Modelica.Icons.Example;
      Modelica.Blocks.Sources.Sine sin(amplitude=0.5, f=0.1/120, offset=0.5) "Slow: a period of 1200 s"
        annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
      Modelica.Blocks.Sources.Sine sin1(amplitude=0.5, f=1/120, offset=0.5) "Fast: a period of 120 s"
        annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
      Requirements.Sources.BooleanConstant on(c=true) "Always active"
        annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
      Modelica.Blocks.Sources.BooleanPulse booPul(width=50, period=600) "Active in the first half of every 600 s"
        annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
      Modelica.Blocks.Sources.BooleanPulse booPul1(width=50, period=1200) "Active in the first half of every 1200 s"
        annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
      Requirements.ChecksInFixedWindow.StableSignal staSigOn(window=120) "Slow sine, always active: satisfied"
        annotation (Placement(transformation(extent={{-40,80},{0,100}})));
      Requirements.ChecksInFixedWindow.StableSignal staSigPul(window=120) "Slow sine, sometimes active: satisfied"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.StableSignal staSigOn1 "Fast sine, always active: violated"
        annotation (Placement(transformation(extent={{-40,-10},{0,10}})));
      Requirements.ChecksInFixedWindow.StableSignal staSigPul1 "Fast sine, sometimes active: violated"
        annotation (Placement(transformation(extent={{-40,-50},{0,-30}})));
      Requirements.Verify.Requirement reqStaSigOn(method=Requirements.Types.WorstMarginMethod.Ratchet, text="Slow sine is stable", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,80},{90,100}})));
      Requirements.Verify.Requirement reqStaSigPul(method=Requirements.Types.WorstMarginMethod.Ratchet, text="Slow sine is stable while active", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,40},{90,60}})));
      Requirements.Verify.Requirement reqStaSigOn1(method=Requirements.Types.WorstMarginMethod.Ratchet, text="Fast sine is stable", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-10},{90,10}})));
      Requirements.Verify.Requirement reqStaSigPul1(method=Requirements.Types.WorstMarginMethod.Ratchet, text="Fast sine is stable while active", computeStatistics=true, useMargin=true)
        annotation (Placement(transformation(extent={{30,-50},{90,-30}})));
      inner Requirements.Verify.PrintViolations printViolations(useEvaluationTime=true, evaluationTime=3600)
        annotation (Placement(transformation(extent={{30,-90},{90,-70}})));
    equation
      connect(sin.y, staSigOn.u) annotation (Line(points={{-79,80},{-60,80},{-60,96},{-42,96}}, color={0,0,127}));
      connect(sin.y, staSigPul.u) annotation (Line(points={{-79,80},{-60,80},{-60,56},{-42,56}}, color={0,0,127}));
      connect(sin1.y, staSigOn1.u) annotation (Line(points={{-79,-20},{-60,-20},{-60,6},{-42,6}}, color={0,0,127}));
      connect(sin1.y, staSigPul1.u) annotation (Line(points={{-79,-20},{-60,-20},{-60,-34},{-42,-34}}, color={0,0,127}));
      connect(on.y, staSigOn.condition) annotation (Line(points={{-79,50},{-66,50},{-66,90},{-42,90}}, color={255,0,255}));
      connect(booPul.y, staSigPul.condition) annotation (Line(points={{-79,20},{-56,20},{-56,50},{-42,50}}, color={255,0,255}));
      connect(on.y, staSigOn1.condition) annotation (Line(points={{-79,50},{-66,50},{-66,0},{-42,0}}, color={255,0,255}));
      connect(booPul1.y, staSigPul1.condition) annotation (Line(points={{-79,-60},{-50,-60},{-50,-40},{-42,-40}}, color={255,0,255}));
      connect(staSigOn.y, reqStaSigOn.property) annotation (Line(points={{1,90},{26,90}}, color={0,0,255}));
      connect(staSigOn.margin, reqStaSigOn.margin) annotation (Line(points={{1,81},{26,81},{26,83}}, color={0,127,0}));
      connect(staSigPul.y, reqStaSigPul.property) annotation (Line(points={{1,50},{26,50}}, color={0,0,255}));
      connect(staSigPul.margin, reqStaSigPul.margin) annotation (Line(points={{1,41},{26,41},{26,43}}, color={0,127,0}));
      connect(staSigOn1.y, reqStaSigOn1.property) annotation (Line(points={{1,0},{26,0}}, color={0,0,255}));
      connect(staSigOn1.margin, reqStaSigOn1.margin) annotation (Line(points={{1,-9},{26,-9},{26,-7}}, color={0,127,0}));
      connect(staSigPul1.y, reqStaSigPul1.property) annotation (Line(points={{1,-40},{26,-40}}, color={0,0,255}));
      connect(staSigPul1.margin, reqStaSigPul1.margin) annotation (Line(points={{1,-49},{26,-49},{26,-47}}, color={0,127,0}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
        experiment(StopTime=3600, Tolerance=1e-06),
        Documentation(info="<html>
<p>
Check block <a href=\"modelica://Requirements.ChecksInFixedWindow.StableSignal\">StableSignal</a> with the default limit of
0.01 s<sup>-1</sup> on the moving average of |du/dt|, each check feeding a
<a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> with violation statistics and margin:
</p>
<ul>
<li> <code>staSigOn</code> and <code>staSigPul</code> check a slow sine, 0.5 + 0.5 sin(2&pi;t/1200 s), over a 120 s window,
     always active and active in the first half of every 600 s. Its average speed is at most
     0.5&middot;2&pi;/1200 s = 0.0026 s<sup>-1</sup>: satisfied, after an Undecided first window of each phase.</li>
<li> <code>staSigOn1</code> and <code>staSigPul1</code> check a fast sine, 0.5 + 0.5 sin(2&pi;t/120 s), over the default
     360 s window, always active and active in the first half of every 1200 s. Its average speed is
     (2/&pi;)&middot;0.5&middot;2&pi;/120 s = 0.0167 s<sup>-1</sup>: violated once the first window is complete.</li>
</ul>
<p>
This is the validation model <code>Buildings_Requirements.Validation.StableContinuousSignal</code> of
<a href=\"https://github.com/lbl-srg/modelica-buildings-requirements\">modelica-buildings-requirements</a>
(M. Wetter, LBNL), ported with the block in version 0.13.0. The verdicts are the original's, except that an
inactive check is Undefined (4) where the original reported Undecided (2), and the original's hysteresis of
upperLimit/20 is not set (default h = 0); neither signal comes near the limit, so the verdicts do not depend on it.
The requirements' statistics use <code>method = WorstMarginMethod.Ratchet</code>: the fast sine's window holds a whole
number of periods, so its average and margin are constant up to numerical noise, and the default continuous search
for the margin's extrema would fire an event at every sign change of that noise (35,000 events in this hour).
Copyright (c) 1998-2024 The Regents of the University of California, through Lawrence Berkeley National Laboratory,
and contributors; see <a href=\"modelica://Requirements.UsersGuide.BuildingsLicense\">UsersGuide.BuildingsLicense</a>.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC (the port). All rights reserved.</p>
</html>"));
    end StableSignal;
  end ChecksInFixedWindow;

    package ChecksInFixedWindow_withFFT
      "Library of check blocks that inspect properties in a fixed time window using FFT (Fast Fourier Transform)"
      extends Modelica.Icons.ExamplesPackage;

      model WithinAbsoluteDomain1
        "Example for WithinAbsoluteDomain block with one FFT computation (a rising condition input triggers an FFT calculation. The amplitudes of the FFTs must be below a frequency dependent limit)"
        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain
          fft_absoluteDomain1(
          f_max=4,
          f_resolution=0.2,
          maxAmplitude=[0,6; 1,6; 2,4; 3,1.5; 4,1.5])
          annotation (Placement(transformation(extent={{8,0},{68,60}})));
      Modelica.Blocks.Sources.Sine sine2(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Modelica.Blocks.Sources.Sine sine3(amplitude=1.5, f=3)
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
        Modelica.Blocks.Sources.Constant const(k=5)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=3)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
        Requirements.Sources.BooleanConstant const1
          annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
        Requirements.LogicalBlocks.FallingEdgeTerminate terminate1(text=
              "Terminated since FFT computation finished")
          annotation (Placement(transformation(extent={{78,40},{98,60}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,50},{-48,50},{-48,
                32.8},{-36,32.8}},            color={0,0,127}));
        connect(sine2.y, multiSum.u[2]) annotation (Line(points={{-59,10},{-48,10},{-48,
                30},{-36,30}},                color={0,0,127}));
        connect(sine3.y, multiSum.u[3]) annotation (Line(points={{-59,-30},{-46,-30},{
                -46,27.2},{-36,27.2}},         color={0,0,127}));
        connect(multiSum.y, fft_absoluteDomain1.u)
          annotation (Line(points={{-22.98,30},{-4,30},{6,30}},
                                                         color={0,0,127}));
        connect(const1.y, fft_absoluteDomain1.condition) annotation (Line(
              points={{-19,70},{-10,70},{-10,50},{6,50}},  color={255,0,255}));
        connect(fft_absoluteDomain1.FFT_computation, terminate1.u)
          annotation (Line(points={{69,50},{76,50}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=6),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain\">WithinAbsoluteDomain</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain1_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black), as well
as the maximume amplitudes maxAmplitude (in red).
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain1_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain1_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
As can be seen, the simulation is terminate (via instance <b>terminate1</b> of block 
<a href=\"modelica://Requirements.LogicalBlocks.FallingEdgeTerminate\">FallingEdgeTerminate</a>) once
the FFT has been computed (signaled via the falling edge of FFT_computation).
Since all FFT amplitudes between 0 &le; f &le; min(f_max, maxAmplitude[end,1]) are below the maximally allowed limit,
the block returns Property.Satisfied.
</p>

<p>
A plot of the FFT result file is shown in the next figure:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain1_FFT.png\">
</blockquote></p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end WithinAbsoluteDomain1;

      model WithinAbsoluteDomain2
        "Example for WithinAbsoluteDomain block with two FFT computations (a rising condition input triggers an FFT calculation. The amplitudes of the FFTs must be below a frequency dependent limit)"
        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain
          fft_absoluteDomain1(
          f_resolution=0.2,
          f_max=6,
          maxAmplitude=[0,6; 1,6; 2,4; 3,1.5; 10,1.5])
          annotation (Placement(transformation(extent={{20,0},{80,60}})));
      Modelica.Blocks.Sources.Sine sine2(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
      Modelica.Blocks.Sources.Sine sine3(amplitude=1.5, f=3)
        annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
        Modelica.Blocks.Sources.Constant const(k=5)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Sine sine5(
        f=5,
        startTime=7,
        amplitude=2)
        annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=4)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
        Modelica.Blocks.Sources.BooleanTable booleanTable(table={1,1.5,9,9.5})
          annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,50},{-48,
                50},{-48,33.15},{-36,33.15}}, color={0,0,127}));
        connect(sine2.y, multiSum.u[2]) annotation (Line(points={{-59,18},{-48,18},{-48,
                31.05},{-36,31.05}},          color={0,0,127}));
        connect(sine3.y, multiSum.u[3]) annotation (Line(points={{-59,-14},{-46,-14},{
                -46,28.95},{-36,28.95}},       color={0,0,127}));
        connect(sine5.y, multiSum.u[4]) annotation (Line(points={{-59,-46},{-44,-46},{
                -44,26.85},{-36,26.85}},       color={0,0,127}));
        connect(multiSum.y, fft_absoluteDomain1.u)
          annotation (Line(points={{-22.98,30},{18,30}}, color={0,0,127}));
        connect(booleanTable.y, fft_absoluteDomain1.condition) annotation (Line(
              points={{-19,70},{-8,70},{-8,50},{18,50}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=16),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain\">WithinAbsoluteDomain</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain2_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black), as well
as the maximume amplitudes maxAmplitude (in red). At the end of the simulation, one of the amplitudes
is larger as allowed:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain2_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinAbsoluteDomain2_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
As can be seen, the first FFT fulfills the check (scaledDistance = 0), whereas the second FFT has amplitudes that are larger as allowed (scaledDistance = -0.1).
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end WithinAbsoluteDomain2;

      model WithinRelativeDomain1
        "Example for RelativeDomain block with one FFT computation (a rising condition input triggers an FFT calculation. The amplitudes of the FFTs must be below a frequency dependent limit that is defined relative to the amplitude of the base frequency)"
        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.WithinRelativeDomain
          fft_relativeDomain1(
          f_max=4,
          f_resolution=0.2,
          f_base=2,
          maxAmplitude=[0,120; 1,120; 2,100; 3,50; 4,50])
          annotation (Placement(transformation(extent={{4,0},{64,60}})));
      Modelica.Blocks.Sources.Sine sine2(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Modelica.Blocks.Sources.Sine sine3(amplitude=1.5, f=3)
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
        Modelica.Blocks.Sources.Constant const(k=3)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=3)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
        Requirements.Sources.BooleanConstant const1
          annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
        Requirements.LogicalBlocks.FallingEdgeTerminate
                                           terminate1(text=
              "Terminated since FFT computation finished")
          annotation (Placement(transformation(extent={{74,40},{94,60}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,50},{-48,50},{-48,
                32.8},{-36,32.8}},            color={0,0,127}));
        connect(sine2.y, multiSum.u[2]) annotation (Line(points={{-59,10},{-48,10},{-48,
                30},{-36,30}},                color={0,0,127}));
        connect(sine3.y, multiSum.u[3]) annotation (Line(points={{-59,-30},{-46,-30},{
                -46,27.2},{-36,27.2}},         color={0,0,127}));
        connect(multiSum.y,fft_relativeDomain1. u)
          annotation (Line(points={{-22.98,30},{2,30}},  color={0,0,127}));
        connect(const1.y,fft_relativeDomain1. condition) annotation (Line(
              points={{-19,70},{-10,70},{-10,50},{2,50}},  color={255,0,255}));
        connect(fft_relativeDomain1.FFT_computation, terminate1.u) annotation (
            Line(points={{65,50},{68,50},{72,50}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=6),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.WithinRelativeDomain\">WithinRelativeDomain</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain1_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black), as well
as the maximume amplitudes maxAmplitude (in red).
The computed amplitude of the base frequency is shown in green (so this amplitude is 100 %)
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain1_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain1_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
As can be seen, the simulation is terminate (via instance <b>terminate1</b> of block 
<a href=\"modelica://Requirements.LogicalBlocks.FallingEdgeTerminate\">FallingEdgeTerminate</a>) once
the FFT has been computed (signaled via the falling edge of FFT_computation).
Since all FFT amplitudes between 0 &le; f &le; min(f_max, maxAmplitude[end,1]) are below the maximally allowed limit,
the block returns Property.Satisfied.
</p>

<p>
A plot of the FFT result file is shown in the next figure:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain1_FFT.png\">
</blockquote></p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end WithinRelativeDomain1;

      model WithinRelativeDomain2
        "Example for RelativeDomain block with two FFT computations (a rising condition input triggers an FFT calculation. The amplitudes of the FFTs must be below a frequency dependent limit that is defined relative to the amplitude of the base frequency)"
        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.WithinRelativeDomain
          fft_relativeDomain1(
          f_resolution=0.2,
          f_max=6,
          f_base=2,
          maxAmplitude=[0,120; 1,120; 2,100; 3,50; 10,50])
          annotation (Placement(transformation(extent={{20,0},{80,60}})));
      Modelica.Blocks.Sources.Sine sine2(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
      Modelica.Blocks.Sources.Sine sine3(amplitude=1.5, f=3)
        annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
        Modelica.Blocks.Sources.Constant const(k=3)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Sine sine5(
        f=5,
        startTime=7,
        amplitude=2)
        annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=4)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
        Modelica.Blocks.Sources.BooleanTable booleanTable(table={1,1.5,9,9.5})
          annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,50},{-48,
                50},{-48,33.15},{-36,33.15}}, color={0,0,127}));
        connect(sine2.y, multiSum.u[2]) annotation (Line(points={{-59,18},{-48,18},{-48,
                31.05},{-36,31.05}},          color={0,0,127}));
        connect(sine3.y, multiSum.u[3]) annotation (Line(points={{-59,-14},{-46,-14},{
                -46,28.95},{-36,28.95}},       color={0,0,127}));
        connect(sine5.y, multiSum.u[4]) annotation (Line(points={{-59,-46},{-44,-46},{
                -44,26.85},{-36,26.85}},       color={0,0,127}));
        connect(multiSum.y,fft_relativeDomain1. u)
          annotation (Line(points={{-22.98,30},{18,30}}, color={0,0,127}));
        connect(booleanTable.y,fft_relativeDomain1. condition) annotation (Line(
              points={{-19,70},{-8,70},{-8,50},{18,50}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=16),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.WithinRelativeDomain\">WithinRelativeDomain</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain2_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black), as well
as the maximume amplitudes maxAmplitude (in red). 
The computed amplitude of the base frequency is shown in green (so this amplitude is 100 %).
At the end of the simulation, one of the amplitudes
is larger as allowed:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain2_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/WithinRelativeDomain2_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
As can be seen, the first FFT fulfills the check (scaledDistance = 0), whereas the second FFT has amplitudes that are larger as allowed (scaledDistance = -0.1).
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end WithinRelativeDomain2;

      model MaxTotalHamonicDistortion1
        "Example for MaxTotalHamonicDistortion block with one FFT computation (a rising condition input triggers an FFT calculation. The Total Harmonic Distortion (THD) of the FFTs must be below the given limit)"

        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.MaxTotalHarmonicDistortion
          maxTHD1(f_resolution=0.2, f_base=2)
          annotation (Placement(transformation(extent={{-2,0},{58,60}})));
      Modelica.Blocks.Sources.Sine sine1(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Sine sine2(f=4, amplitude=0.2)
        annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
        Modelica.Blocks.Sources.Constant const(k=2.5)
          annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=6)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
        Requirements.Sources.BooleanConstant const1
          annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
      Modelica.Blocks.Sources.Sine sine3(f=6, amplitude=0.15)
        annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
      Modelica.Blocks.Sources.Sine sine4(f=8, amplitude=0.1)
        annotation (Placement(transformation(extent={{-14,-40},{-34,-20}})));
      Modelica.Blocks.Sources.Sine sine5(f=10, amplitude=0.08)
        annotation (Placement(transformation(extent={{-14,-6},{-34,14}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,80},{-46,80},{-46,
                33.5},{-36,33.5}},            color={0,0,127}));
        connect(sine1.y, multiSum.u[2]) annotation (Line(points={{-59,50},{-48,50},{-48,
                32.1},{-36,32.1}},            color={0,0,127}));
        connect(sine2.y, multiSum.u[3]) annotation (Line(points={{-59,18},{-48,18},{-48,
                30.7},{-36,30.7}},             color={0,0,127}));
        connect(multiSum.y, maxTHD1.u)
          annotation (Line(points={{-22.98,30},{-4,30}}, color={0,0,127}));
        connect(const1.y, maxTHD1.condition) annotation (Line(points={{-19,70},{-10,70},
                {-10,50},{-4,50}},          color={255,0,255}));
        connect(sine3.y, multiSum.u[4]) annotation (Line(points={{-59,-16},{-46,-16},{
                -46,29.3},{-36,29.3}}, color={0,0,127}));
        connect(sine4.y, multiSum.u[5]) annotation (Line(points={{-35,-30},{-44,-30},{
                -44,28},{-36,28},{-36,27.9}}, color={0,0,127}));
        connect(sine5.y, multiSum.u[6]) annotation (Line(points={{-35,4},{-42,4},{-42,
                26.5},{-36,26.5}},     color={0,0,127}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=6),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.MaxTotalHarmonicDistortion\">MaxTotalHarmonicDistortion</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion1_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black).
The computed amplitude of the base frequency is shown in green:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion1_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion1_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
A plot of the FFT result file is shown in the next figure:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion1_FFT.png\">
</blockquote></p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end MaxTotalHamonicDistortion1;

      model MaxTotalHamonicDistortion2
        "Example for MaxTotalHamonicDistortion block with two FFT computations (a rising condition input triggers an FFT calculation. The Total Harmonic Distortion (THD) of the FFTs must be below the given limit)"

        extends Modelica.Icons.Example;

        Requirements.ChecksInFixedWindow_withFFT.MaxTotalHarmonicDistortion
          maxTHD1(f_resolution=0.2, f_base=2,
          THDmax=0.1)
          annotation (Placement(transformation(extent={{20,0},{80,60}})));
      Modelica.Blocks.Sources.Sine sine1(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Sine sine2(f=4, amplitude=0.2)
        annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
        Modelica.Blocks.Sources.Constant const(k=2.5)
          annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
        Modelica.Blocks.Math.MultiSum multiSum(nu=6)
          annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
      Modelica.Blocks.Sources.Sine sine3(
        f=6,
        amplitude=0.3,
        startTime=7)
        annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
      Modelica.Blocks.Sources.Sine sine4(amplitude=0.15, f=8)
        annotation (Placement(transformation(extent={{0,-34},{-20,-14}})));
      Modelica.Blocks.Sources.Sine sine5(f=10, amplitude=0.1)
        annotation (Placement(transformation(extent={{0,0},{-20,20}})));
        Modelica.Blocks.Sources.BooleanTable booleanTable(table={1,1.5,9,9.5})
          annotation (Placement(transformation(extent={{-32,60},{-12,80}})));
      equation
        connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,80},{-46,80},{-46,
                33.5},{-36,33.5}},            color={0,0,127}));
        connect(sine1.y, multiSum.u[2]) annotation (Line(points={{-59,50},{-48,50},{-48,
                32.1},{-36,32.1}},            color={0,0,127}));
        connect(sine2.y, multiSum.u[3]) annotation (Line(points={{-59,18},{-48,18},{-48,
                30.7},{-36,30.7}},             color={0,0,127}));
        connect(multiSum.y, maxTHD1.u)
          annotation (Line(points={{-22.98,30},{18,30}}, color={0,0,127}));
        connect(sine3.y, multiSum.u[4]) annotation (Line(points={{-59,-16},{-46,-16},{
                -46,29.3},{-36,29.3}}, color={0,0,127}));
        connect(sine4.y, multiSum.u[5]) annotation (Line(points={{-21,-24},{-44,-24},{
                -44,28},{-36,28},{-36,27.9}}, color={0,0,127}));
        connect(sine5.y, multiSum.u[6]) annotation (Line(points={{-21,10},{-42,10},{-42,
                26.5},{-36,26.5}},     color={0,0,127}));
        connect(booleanTable.y, maxTHD1.condition) annotation (Line(points={{-11,70},{
                6,70},{6,50},{18,50}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=16),
          Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInFixedWindow_withFFT.MaxTotalHarmonicDistortion\">MaxTotalHarmonicDistortion</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion2_example.png\">
</blockquote></p>

<p>
The amplitutes of the FFT are dynamically displayed in the icon of the block (in black).
The computed amplitude of the base frequency is shown in green:
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion2_icon.png\">
</blockquote></p>

<p>
Simulating this examples results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInFixedWindow_withFFT/MaxTotalHarmonicDistortion2_result.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
As can be seen, the first FFT fulfills the check (THD &lt; THDmax), whereas the second FFT has a too large THD value.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
      end MaxTotalHamonicDistortion2;
      annotation (Documentation(revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Nov. 29, 2015 </td>
    <td valign=\"top\">
     Initial version implemented by
     Martin R. Kuhn and Martin Otter 
     (<a href=\"http://www.dlr.de/rmc/sr/en\">DLR Institute of System Dynamics and Control</a>)<br>  
     The research leading to these results has received funding from the European Union’s Seventh
     Framework Programme (FP7/2007-2016) for the Clean Sky Joint Technology Initiative under
     grant agreement no. CSJU-GAM-SGO-2008-001.</td></tr>
</table>
</html>"));
    end ChecksInFixedWindow_withFFT;

  package ChecksInSlidingWindow
    "Library of examples using ChecksInSlidingWindow blocks"
    extends Modelica.Icons.ExamplesPackage;

    model MinDuration
      "Example for MinDuration (in every sliding time window, the longest time duration where check was permanently true must be above a lower limit)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MinDuration minDuration(
        lowerLimit=1,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MinDuration\">MinDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinDuration;

    model MinAccumulatedDuration
      "Example for AccumulatedMinDuration (in every sliding time window, the accumulated time duration where check was true must be above a lower limit)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MinAccumulatedDuration minAccDuration(
        lowerLimit=1,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MinAccumulatedDuration\">AccumulatedMinDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinAccumulatedDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinAccumulatedDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinAccumulatedDuration;

    model MinAccumulatedDuration2
      "Example for AccumulatedMinDuration (in every sliding time window, the accumulated time duration where check was true must be above a lower limit)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MinAccumulatedDuration2 minAccDuration(
        lowerLimit=1,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MinAccumulatedDuration\">AccumulatedMinDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinAccumulatedDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinAccumulatedDuration2_2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinAccumulatedDuration2;

    model MaxDuration
      "Example for MaxDuration (in every sliding time window, the longest time duration where check was permanently true must be below an upper limit)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,8.2,8.4,8.6,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MaxDuration maxDuration1(check=
            check.y, upperLimit=1,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxDuration\">MaxDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxDuration;

    model MaxAccumulatedDuration
      "Example for MaxDuration (in every sliding time window, the accumulated time duration where check was true must be below an upper limit)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,8.2,8.4,8.6,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MaxAccumulatedDuration maxAccDuration(
        check=check.y,
        upperLimit=1,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxAccumulatedDuration\">AccumulatedMaxDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxAccumulatedDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxAccumulatedDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxAccumulatedDuration;

    model BandDuration
      "Example for BandDuration (in every sliding time window, the longest time duration where check was permanently true must be within a given band)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.5,5.2,5.4,5.6,5.8,6.0,8.5,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.BandDuration bandDuration(
        lowerLimit=1,
        upperLimit=2,
        check=check.y,
        window=3)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.BandDuration\">BandDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end BandDuration;

    model BandAccumulatedDuration
      "Example for BandAccumulatedDuration (in every sliding time window, the accumulated time duration where check was true must be within a given band)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.5,5.2,5.4,5.6,5.8,6.0,8.5,9.1,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.BandAccumulatedDuration bandAccDuration(
        lowerLimit=1,
        upperLimit=2,
        check=check.y,
        window=3)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.BandAccumulatedDuration\">BandAccumulatedDuration</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandAccumulatedDuration1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandAccumulatedDuration2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end BandAccumulatedDuration;

    model MinRising
      "Example for MinRising (in every sliding time window, a minimum number of check rising edges must occur)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,8,9.1,9.3,9.5,9.7,10,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MinRising minRising(
        nRisingMin=1,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MinRising\">MinRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MinRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MinRising;

    model MaxRising
      "Example for MaxRising (in every sliding time window, the number of check rising edges is bounded)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,6.2,6.4,8,9.1,9.3,9.5,9.7,10,10.5,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.MaxRising maxRising(
        nRisingMax=2,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxRising\">MaxRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxRising;

    model BandRising
      "Example for BandRising (in every sliding time window, a minimum number of check rising edges must occur and the number of check rising edges is bounded)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable check(startValue=false,
            table={1,3.3,5.2,5.4,5.6,5.8,6.0,6.2,6.4,8,9.1,9.3,9.5,9.7,10,10.2,10.4,10.6,11.5,12})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInSlidingWindow.BandRising bandRising(
        nRisingMin=1,
        nRisingMax=3,
        check=check.y,
        window=2)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=14),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.BandRising\">BandRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/BandRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end BandRising;

    model MaxFrequency
      "Example for MaxFrequency (in every sliding time window, the mean frequency of check is limited)"
      import Requirements;
       extends Modelica.Icons.Example;
      constant Real pi = Modelica.Constants.pi;

      Requirements.SignalAnalysis.CrossingMonitoring crossing
        annotation (Placement(transformation(extent={{34,10},{54,30}})));
      Requirements.ChecksInSlidingWindow.MaxFrequency maxFrequency(
        check=crossing.y,
        freqHzMeanMax=3,
        window=2)
        annotation (Placement(transformation(extent={{-60,40},{-20,60}})));
      Requirements.Sources.RealExpression expr1(
        y=sin(2*pi*(if time < 5 then 2 elseif time < 10 then 4 elseif time < 15 then 2 else 0)*time))
        annotation (Placement(transformation(extent={{-88,10},{20,30}})));
    equation
      connect(expr1.y, crossing.u)
        annotation (Line(points={{22.7,20},{28,20},{28,20},{32,20}},
                                                     color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=18,Interval=4e-3),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxFrequency\">MaxFrequency</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxFrequency1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxFrequency2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
<p>
Note, the check signal has first a frequency of 2 Hz, then of 4 Hz, then of 2 Hz and finally of 0 Hz.
The MaxFrequency block can reproduce these frequencies approximately. It is not exact, because
the frequency is only determined based on the rising and falling edges of check. However, it is slightly
more precise as using the <a href=\"modelica://Requirements.Examples.Elementary.ChecksInSlidingWindow.MaxRisingFrequency\">MaxRisingFrequency</a> block that takes only the rising edges of check into account.
</p>
</html>"));
    end MaxFrequency;

    model MaxRisingFrequency
      "Example for MaxRisingFrequency (in every sliding time window, the frequency of the check rising edges is limited)"
      import Requirements;
       extends Modelica.Icons.Example;
      constant Real pi = Modelica.Constants.pi;

      Requirements.SignalAnalysis.CrossingMonitoring crossing
        annotation (Placement(transformation(extent={{34,10},{54,30}})));
      Requirements.ChecksInSlidingWindow.MaxRisingFrequency maxRisingFrequency(
        check=crossing.y,
        freqHzMeanMax=3,
        window=2)
        annotation (Placement(transformation(extent={{-60,40},{-20,60}})));
      Requirements.Sources.RealExpression expr1(
        y=sin(2*pi*(if time < 5 then 2 elseif time < 10 then 4 elseif time < 15 then 2 else 0)*time))
        annotation (Placement(transformation(extent={{-88,10},{20,30}})));
    equation
      connect(expr1.y, crossing.u)
        annotation (Line(points={{22.7,20},{32,20}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=18,Interval=4e-3),
        Documentation(info="<html>
<p>
Using check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxRisingFrequency\">MaxRisingFrequency</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxRisingFrequency1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxRisingFrequency2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxRisingFrequency;

    model MaxIncrease
      "Example for MaxIncrease (in every sliding time window, the increase of the input is limited)"
      import Requirements;
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.CombiTimeTable signal(table=[0,20; 4,22.5; 6,27;
            8,28; 12,28])
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Requirements.ChecksInSlidingWindow.MaxIncrease maxIncrease(
          upperLimit=3, window(displayUnit="s") = 2)
        annotation (Placement(transformation(extent={{-44,60},{-24,80}})));
    equation
      connect(signal.y[1], maxIncrease.u) annotation (Line(points={{-59,70},{-52.5,
              70},{-46,70}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})),           experiment(StopTime=12),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxIncrease\">MaxIncrease</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxIncrease1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxIncrease2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxIncrease;

    model MaxPercentageIncrease
      "Example for MaxPercentageIncrease (in every sliding time window, the increase of the input is limited)"
      import Requirements;
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.CombiTimeTable signal(table=[0,20; 2,20; 4,24; 6,
            27; 8,28; 12,28])
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Requirements.ChecksInSlidingWindow.MaxPercentageIncrease
                                        maxIncrease1(
                                  window(displayUnit="s") = 2,
          upperPercentageLimit=10)
        annotation (Placement(transformation(extent={{-44,60},{-24,80}})));
    equation
      connect(signal.y[1], maxIncrease1.u)
        annotation (Line(points={{-59,70},{-52.5,70},{-46,70}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})),           experiment(StopTime=12),
        Documentation(info="<html>
<p>
Using sliding time window check block <a href=\"modelica://Requirements.ChecksInSlidingWindow.MaxPercentageIncrease\">MaxPercentageIncrease</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxPercentageIncrease1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/ChecksInSlidingWindow/MaxPercentageIncrease2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end MaxPercentageIncrease;
  end ChecksInSlidingWindow;

  package SignalAnalysis "Library of examples using SignalAnalysis blocks"
      extends Modelica.Icons.ExamplesPackage;

    model Derivatives
      "Examples for DerXXX (various ways to compute derivatives of signals)"
       extends Modelica.Icons.Example;

      Requirements.SignalAnalysis.ExactDerivative der1
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Requirements.SignalAnalysis.ApproximateDerivativeWithFilter
        approxDerFilter(f_cut=10)
        annotation (Placement(transformation(extent={{-40,-4},{-20,16}})));
      Modelica.Blocks.Sources.Sine sine(
        amplitude=2,
        f=1,
        phase=0.78539816339745)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Requirements.SignalAnalysis.ApproximateDerivativeWithWindow
        approxDerWindow(dt=0.1)
        annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
    equation
      connect(sine.y, der1.u) annotation (Line(
          points={{-59,30},{-37,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sine.y, approxDerFilter.u) annotation (Line(
          points={{-59,30},{-52,30},{-52,6},{-42,6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(approxDerWindow.u, der1.u) annotation (Line(
          points={{-42,-16},{-52,-16},{-52,30},{-37,30}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics), experiment(StopTime=2),
        Documentation(info="<html>
<p>
Using the signal analysis blocks
<a href=\"modelica://Requirements.SignalAnalysis.ExactDerivative\">ExactDerivative</a>,
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithFilter\">ApproximateDerivativeWithFilter</a>, and 
<a href=\"modelica://Requirements.SignalAnalysis.ApproximateDerivativeWithWindow\">ApproximateDerivativeWithWindow</a>
to compute the derivative of the input signal analytically or approximately with
the following example
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/SignalAnalysis/Derivatives1.png\">
</blockquote></p>

<p>
results in
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
    end Derivatives;

    model Integrator
      "Example for Integrator (output is the integral over the input, as long as input active is true)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.Sine sine(f=0.3, offset=2)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Modelica.Blocks.Sources.BooleanPulse pulse(period=2, startTime=1)
        annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
      Requirements.SignalAnalysis.TriggeredIntegrator integrator1
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(sine.y, integrator1.u)
        annotation (Line(points={{-39,10},{-30.5,10},{-22,10}}, color={0,0,127}));
      connect(pulse.y, integrator1.active) annotation (Line(points={{-19,-30},{
              -10,-30},{-10,3}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using signal analysis block <a href=\"modelica://Requirements.SignalAnalysis.Integrator\">Integrator</a> as
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
</html>
"),     experiment(StopTime=8));
    end Integrator;

    model MovingAverage
      "Example for MovingAverage (output is the continuous moving average of the input, as long as input active is true)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.Sine sine(f=0.3, offset=2)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Modelica.Blocks.Sources.BooleanPulse pulse(          startTime=1, period=3)
        annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
      Requirements.SignalAnalysis.MovingAverage movAv1(T=0.2)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(sine.y, movAv1.u)
        annotation (Line(points={{-39,10},{-30.5,10},{-22,10}}, color={0,0,127}));
      connect(pulse.y, movAv1.active) annotation (Line(points={{-19,-30},{-10,-30},{
              -10,-2}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using signal analysis block <a href=\"modelica://Requirements.SignalAnalysis.MovingAverage\">MovingAverage</a> as
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
</html>
"),     experiment(StopTime=8));
    end MovingAverage;

    model TimeMonitoring
      "Example for TimeMonitoring (output is the time duration where the Boolean input was true)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable booleanTable(startValue=false, table={1,2,
            3.5,5,6,6.5})
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Requirements.SignalAnalysis.TimeMonitoring timeMon1
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(booleanTable.y, timeMon1.u)
        annotation (Line(points={{-39,10},{-22,10},{-22,10}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using signal analysis block <a href=\"modelica://Requirements.SignalAnalysis.TimeMonitoring\">TimeMonitoring</a> as
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
</html>
"),     experiment(StopTime=8));
    end TimeMonitoring;

    model CrossingMonitoring
      "Example for CrossingMonitoring (output is true for a positive threshold crossing of the input and false for a negative threshold crossing)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.Sine sine(f=2)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Requirements.SignalAnalysis.CrossingMonitoring crossingMon1(
          threshold=0.5)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(sine.y, crossingMon1.u)
        annotation (Line(points={{-39,10},{-22,10}},          color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using signal analysis block <a href=\"modelica://Requirements.SignalAnalysis.CrossingMonitoring\">CrossingMonitoring</a> as
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
</html>
"),     experiment(StopTime=2));
    end CrossingMonitoring;

  end SignalAnalysis;

  package LogicalBlocks "Library of examples using LogicalBlocks blocks"
    model Conversions
      "Examples for BooleanToProperty, IntegerToProperty, PropertyToBoolean, PropertyToInteger"
       import Requirements.Types.Property;
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable booleanTable(startValue=true, table={1.5,
            3.3,4.2})
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.LogicalBlocks.BooleanToProperty BtoP1
        annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
      Modelica.Blocks.Sources.IntegerTable integerTable(table=[0,3; 1,2; 2,1; 3,3; 4,
            2]) annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Requirements.LogicalBlocks.IntegerToProperty ItoP1
        annotation (Placement(transformation(extent={{-52,0},{-32,20}})));
      Requirements.LogicalBlocks.PropertyToBoolean PtoB1
        annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
      Requirements.LogicalBlocks.PropertyToBoolean PtoB2(undecided=true)
        annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
      Requirements.LogicalBlocks.PropertyToInteger PtoI1
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation

      connect(booleanTable.y, BtoP1.u) annotation (Line(
          points={{-59,50},{-47,50}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(integerTable.y, ItoP1.u) annotation (Line(
          points={{-59,10},{-49,10}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(ItoP1.y, PtoB1.u) annotation (Line(
          points={{-36,10},{-30,10},{-30,-10},{-22,-10}},
          color={255,0,128},
          smooth=Smooth.None));
      connect(ItoP1.y, PtoB2.u) annotation (Line(
          points={{-36,10},{-30,10},{-30,-30},{-22,-30}},
          color={255,0,128},
          smooth=Smooth.None));
      connect(ItoP1.y, PtoI1.u) annotation (Line(
          points={{-36,10},{-17,10}},
          color={255,0,128},
          smooth=Smooth.None));
      annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Using conversion blocks from package
 <a href=\"modelica://Requirements.LogicalBlocks\">LogicalBlocks</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/Conversions5.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/Conversions1.png\"></td>
<br>
    </tr>

<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/Conversions2.png\"></td>
<br>
    </tr>

<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/Conversions3.png\"></td>
<br>
    </tr>

<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/Conversions4.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation results</td>
   </tr>
</table>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}),            graphics));
    end Conversions;
    extends Modelica.Icons.ExamplesPackage;

    model ThresholdComparisons
      "Examples for the threshold comparison blocks in package LogicalBlocks"
       import Requirements.Types.Property;
       extends Modelica.Icons.Example;

      Requirements.LogicalBlocks.GreaterThreshold gt1(threshold=0.5)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Modelica.Blocks.Sources.Sine sine(amplitude=2, f=1)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.LogicalBlocks.GreaterEqualThreshold ge1(threshold=
            0.5)
        annotation (Placement(transformation(extent={{-40,20},{0,40}})));
      Requirements.LogicalBlocks.LessThreshold lt1(threshold=0.5)
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      Requirements.LogicalBlocks.LessEqualThreshold le1(threshold=0.5)
        annotation (Placement(transformation(extent={{-40,-20},{0,0}})));
      Requirements.LogicalBlocks.WithinBand band1(u_min=-0.5, u_max=
            0.5)
        annotation (Placement(transformation(extent={{-40,-44},{0,-24}})));
    equation
      connect(sine.y, gt1.u) annotation (Line(
          points={{-59,50},{-42,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sine.y, ge1.u) annotation (Line(
          points={{-59,50},{-52,50},{-52,30},{-42,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(lt1.u, ge1.u) annotation (Line(
          points={{-42,10},{-52,10},{-52,30},{-42,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(le1.u, ge1.u) annotation (Line(
          points={{-42,-10},{-52,-10},{-52,30},{-42,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(band1.u, gt1.u) annotation (Line(
          points={{-42,-34},{-52,-34},{-52,50},{-42,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics), experiment(StopTime=2),
        Documentation(info="<html>
<p>
Using comparison blocks from package
 <a href=\"modelica://Requirements.LogicalBlocks\">LogicalBlocks</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/ThresholdComparisons1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/ThresholdComparisons2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
    end ThresholdComparisons;

    model DelayedRising
      "Example for DelayedRising (output is true, after a duration of a rising input edge and false after a falling input edge)"
       extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanTable timeTable(table={1,3,5,5.2,9,9.2,9.5,10.7},
          startValue=false)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.LogicalBlocks.DelayedRising delayedRising1(u=
            timeTable.y, duration=1)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      annotation (experiment(StopTime=12),Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.DelayedRising\">DelayedRising</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/DelayedRising1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/DelayedRising2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                   graphics));
    end DelayedRising;

    model AnyTrue
      "Example for AnyTrue (output is true if at least one input is true)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=2)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Modelica.Blocks.Sources.BooleanPulse booleanPulse(
        width=50,
        period=1.5,
        startTime=1.5)
        annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
      Requirements.Sources.BooleanConstant const1(c=false)
        annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
      Requirements.LogicalBlocks.AnyTrue anyTrue1(nu=3)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(const1.y, anyTrue1.u[1]) annotation (Line(points={{-39,34},{-26,
              34},{-26,12.6667},{-15,12.6667}}, color={255,0,255}));
      connect(booleanStep.y, anyTrue1.u[2]) annotation (Line(points={{-39,10},{
              -15,10},{-15,10}}, color={255,0,255}));
      connect(booleanPulse.y, anyTrue1.u[3]) annotation (Line(points={{-39,-22},
              {-28,-22},{-28,7.33333},{-15,7.33333}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.AnyTrue\">AnyTrue</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/AnyTrue1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/AnyTrue2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     experiment(StopTime=5));
    end AnyTrue;

    model AllTrue "Example for AllTrue (output is true if all inputs are true)"
      extends Modelica.Icons.Example;

      Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=2)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Modelica.Blocks.Sources.BooleanPulse booleanPulse(
        width=50,
        period=1.5,
        startTime=1.5)
        annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
      Requirements.Sources.BooleanConstant const1
        annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
      Requirements.LogicalBlocks.AllTrue allTrue1(nu=3)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(const1.y, allTrue1.u[1]) annotation (Line(points={{-39,34},{-28,
              34},{-28,12.6667},{-15,12.6667}}, color={255,0,255}));
      connect(booleanStep.y, allTrue1.u[2]) annotation (Line(points={{-39,10},{
              -15,10},{-15,10}}, color={255,0,255}));
      connect(booleanPulse.y, allTrue1.u[3]) annotation (Line(points={{-39,-22},
              {-28,-22},{-28,7.33333},{-15,7.33333}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.AllTrue\">AllTrue</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/AllTrue1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/AllTrue2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     experiment(StopTime=5));
    end AllTrue;

    model PropertyNot
      "Example for AllTrue (output is true if all inputs are true)"
      import Requirements;
      extends Modelica.Icons.Example;

      Requirements.Sources.PropertyTable p(table=[0,1; 3,2; 6,3; 9,2;
            12,1; 13,3])
        annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
      Requirements.LogicalBlocks.PropertyNot not1
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(p.y, not1.u)
        annotation (Line(points={{-29,10},{-17,10}}, color={255,0,128}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.PropertyNot\">PropertyNot</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyNot1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyNot2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     experiment(StopTime=14));
    end PropertyNot;

    model PropertyOr
      "Example for PropertyOr (3-valued logic 'or' of Property input u)"
      import Requirements;
      extends Modelica.Icons.Example;

      Requirements.Sources.PropertyTable p1(table=[0,1; 3,2; 6,3; 9,2; 12,1; 13,3])
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
      Requirements.Sources.PropertyTable p2(table=[0,1; 1,2; 4,3; 7,1; 10,2; 12,3])
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Requirements.Sources.PropertyTable p3(table=[0,1; 2,3; 5,1; 8,2; 11,3; 13,3])
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
      Requirements.LogicalBlocks.PropertyOr or1(nu=3)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(p1.y, or1.u[1]) annotation (Line(points={{-39,40},{-34,40},{-28,
              40},{-28,12.6667},{-15,12.6667}}, color={255,0,128}));
      connect(p2.y, or1.u[2])
        annotation (Line(points={{-39,10},{-15,10}}, color={255,0,128}));
      connect(p3.y, or1.u[3]) annotation (Line(points={{-39,-20},{-28,-20},{-28,
              7.33333},{-15,7.33333}}, color={255,0,128}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.PropertyOr\">PropertyOr</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyOr1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyOr2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     experiment(StopTime=14));
    end PropertyOr;

    model PropertyAnd
      "Example for PropertyAnd (3-valued logic 'and' of Property input u)"
      import Requirements;
      extends Modelica.Icons.Example;

      Requirements.Sources.PropertyTable p1(table=[0,1; 3,2; 6,3; 9,2; 12,1; 13,3])
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
      Requirements.Sources.PropertyTable p2(table=[0,1; 1,2; 4,3; 7,1; 10,2; 12,3])
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Requirements.Sources.PropertyTable p3(table=[0,1; 2,3; 5,1; 8,2; 11,3; 13,3])
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
      Requirements.LogicalBlocks.PropertyAnd and1(nu=3)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    equation
      connect(p1.y, and1.u[1]) annotation (Line(points={{-39,40},{-34,40},{-28,
              40},{-28,12.6667},{-15,12.6667}},
                                           color={255,0,128}));
      connect(p2.y, and1.u[2])
        annotation (Line(points={{-39,10},{-15,10}},          color={255,0,128}));
      connect(p3.y, and1.u[3]) annotation (Line(points={{-39,-20},{-28,-20},{
              -28,7.33333},{-15,7.33333}},
                              color={255,0,128}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
                Documentation(info="<html>
<p>
Using logical block <a href=\"modelica://Requirements.LogicalBlocks.PropertyAnd\">PropertyAnd</a> as
</p>

<p><blockquote>
<img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyAnd1.png\">
</blockquote></p>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Elementary/LogicalBlocks/PropertyAnd2.png\"></td>
    </tr>

<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>
"),     experiment(StopTime=14));
    end PropertyAnd;

    model PropertyTable4
      "The four-valued (ETL) tables of and4, or4 and not4 asserted entry by entry, and the laws that fail"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.LogicalFunctions.and4;
      import Requirements.LogicalFunctions.or4;
      import Requirements.LogicalFunctions.not4;
      import Requirements.LogicalFunctions.and4All;
      import Requirements.LogicalFunctions.or4All;

      // The four values in their Integer order (1, 2, 3, 4)
      constant Property V = Property.Violated;
      constant Property U = Property.Undecided;
      constant Property S = Property.Satisfied;
      constant Property N = Property.Undefined "Undefined: not applicable, the neutral element";
      constant Property values[4] = {V, U, S, N};
      // The tables, transcribed from the CRML specification (rows a, columns b):
      // Undefined is neutral, an Undecided operand decides only against Violated (and)
      // or Satisfied (or), negation fixes Undecided and Undefined
      constant Property andTable[4, 4] = {{V, V, V, V}, {V, U, U, U}, {V, U, S, S}, {V, U, S, N}};
      constant Property orTable[4, 4] = {{V, U, S, V}, {U, U, S, U}, {S, S, S, S}, {V, U, S, N}};
      constant Property notTable[4] = {S, U, V, N};

      // The two sources run through all 16 pairs (a changes every 4 s, b every second)
      Requirements.Sources.PropertyTable a(table=[0,1; 4,2; 8,3; 12,4])
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Requirements.Sources.PropertyTable b(table=[0,1; 1,2; 2,3; 3,4; 4,1; 5,2; 6,3; 7,4;
            8,1; 9,2; 10,3; 11,4; 12,1; 13,2; 14,3; 15,4])
        annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      Requirements.LogicalBlocks.PropertyAnd and1(nu=2)
        annotation (Placement(transformation(extent={{-20,30},{0,50}})));
      Requirements.LogicalBlocks.PropertyOr or1(nu=2)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      Requirements.LogicalBlocks.PropertyNot not1
        annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
      Requirements.LogicalBlocks.PropertyAnd andEmpty "nu = 0: the neutral element, Undefined"
        annotation (Placement(transformation(extent={{40,30},{60,50}})));
      Requirements.LogicalBlocks.PropertyOr orEmpty "nu = 0: the neutral element, Undefined"
        annotation (Placement(transformation(extent={{40,0},{60,20}})));
      Integer nAbsorption = countAbsorptionFailures(values)
        "Triples (a,b,c) at which a and (a or b) = a fails: 12 of 64";
      Integer nDistributivity = countDistributivityFailures(values)
        "Triples (a,b,c) at which a and (b or c) = (a and b) or (a and c) fails: 6 of 64";
    protected
      function tablesHold
        "true if and4, or4 and not4 reproduce the tables at every entry and are commutative, associative, involutive and De Morgan dual"
        input Property values[4];
        input Property andTable[4, 4];
        input Property orTable[4, 4];
        input Property notTable[4];
        output Boolean ok = true;
      algorithm
        for i in 1:4 loop
          ok := ok and not4(values[i]) == notTable[i] and not4(not4(values[i])) == values[i];
          for j in 1:4 loop
            ok := ok and and4(values[i], values[j]) == andTable[i, j];
            ok := ok and or4(values[i], values[j]) == orTable[i, j];
            ok := ok and and4(values[i], values[j]) == and4(values[j], values[i]);
            ok := ok and or4(values[i], values[j]) == or4(values[j], values[i]);
            ok := ok and or4(values[i], values[j]) == not4(and4(not4(values[i]), not4(values[j])));
            for k in 1:4 loop
              ok := ok and and4(and4(values[i], values[j]), values[k]) == and4(values[i], and4(values[j], values[k]));
              ok := ok and or4(or4(values[i], values[j]), values[k]) == or4(values[i], or4(values[j], values[k]));
            end for;
          end for;
        end for;
      end tablesHold;

      function countAbsorptionFailures "Number of triples (a,b,c) at which a and4 (a or4 b) <> a"
        input Property values[4];
        output Integer n = 0;
      algorithm
        for i in 1:4 loop
          for j in 1:4 loop
            for k in 1:4 loop
              n := n + (if and4(values[i], or4(values[i], values[j])) <> values[i] then 1 else 0);
            end for;
          end for;
        end for;
      end countAbsorptionFailures;

      function countDistributivityFailures "Number of triples (a,b,c) at which a and4 (b or4 c) <> (a and4 b) or4 (a and4 c)"
        input Property values[4];
        output Integer n = 0;
      algorithm
        for i in 1:4 loop
          for j in 1:4 loop
            for k in 1:4 loop
              n := n + (if and4(values[i], or4(values[j], values[k])) <>
                           or4(and4(values[i], values[j]), and4(values[i], values[k])) then 1 else 0);
            end for;
          end for;
        end for;
      end countDistributivityFailures;
    equation
      connect(a.y, and1.u[1]) annotation (Line(points={{-59,30},{-40,30},{-40,43.5},{-15,43.5}}, color={255,0,128}));
      connect(b.y, and1.u[2]) annotation (Line(points={{-59,-10},{-40,-10},{-40,36.5},{-15,36.5}}, color={255,0,128}));
      connect(a.y, or1.u[1]) annotation (Line(points={{-59,30},{-40,30},{-40,13.5},{-15,13.5}}, color={255,0,128}));
      connect(b.y, or1.u[2]) annotation (Line(points={{-59,-10},{-40,-10},{-40,6.5},{-15,6.5}}, color={255,0,128}));
      connect(a.y, not1.u) annotation (Line(points={{-59,30},{-40,30},{-40,-20},{-17,-20}}, color={255,0,128}));

      // The blocks follow the tables at every instant of the 16 pairs
      assert(and1.y == andTable[Integer(a.y), Integer(b.y)], "PropertyAnd differs from the and4 table");
      assert(or1.y == orTable[Integer(a.y), Integer(b.y)], "PropertyOr differs from the or4 table");
      assert(not1.y == notTable[Integer(a.y)], "PropertyNot differs from the not4 table");
      assert(andEmpty.y == N and orEmpty.y == N, "an unconnected PropertyAnd / PropertyOr is Undefined, the neutral element");

      // Every entry of the three tables through the functions, with the laws that hold
      assert(tablesHold(values, andTable, orTable, notTable),
        "and4 / or4 / not4 differ from the ETL tables, or commutativity, associativity, involution or De Morgan fails");

      // The laws that FAIL, with the counterexamples of the research (every one involves Undefined):
      // absorption: Undefined and (Undefined or Satisfied) = Satisfied, not Undefined
      assert(and4(N, or4(N, S)) == S and or4(N, and4(N, S)) == S, "absorption counterexample");
      // distributivity: Satisfied and (Violated or Undefined) = Violated, but (S and V) or (S and N) = Satisfied
      assert(and4(S, or4(V, N)) == V and or4(and4(S, V), and4(S, N)) == S, "distributivity counterexample");
      // complements: Undecided and not Undecided = Undecided, Undefined and not Undefined = Undefined
      assert(and4(U, not4(U)) == U and and4(N, not4(N)) == N, "complements counterexample");
      assert(nAbsorption == 12 and nDistributivity == 6, "12 of 64 absorption and 6 of 64 distributivity failures expected");

      // The folds: Undefined elements drop out, the vector is otherwise a Kleene and / or
      assert(and4All({N, S, N}) == S and and4All({N, U, S}) == U and and4All({S, V, U}) == V and and4All({N, N}) == N, "and4All");
      assert(or4All({N, V, N}) == V and or4All({V, U, N}) == U and or4All({V, S, U}) == S and or4All({N, N}) == N, "or4All");
      annotation (experiment(StopTime=16), Documentation(info="<html>
<p>
The four-valued logic of <a href=\"modelica://Requirements.Types.Property\">Types.Property</a>,
asserted: the two sources run through all 16 pairs of values in 16 s and the blocks
<a href=\"modelica://Requirements.LogicalBlocks.PropertyAnd\">PropertyAnd</a>,
<a href=\"modelica://Requirements.LogicalBlocks.PropertyOr\">PropertyOr</a> and
<a href=\"modelica://Requirements.LogicalBlocks.PropertyNot\">PropertyNot</a> are compared with the
tables of the extended temporal logic (ETL) of EDF's ReqSysPro / CRML at every instant; the functions
<a href=\"modelica://Requirements.LogicalFunctions.and4\">and4</a>,
<a href=\"modelica://Requirements.LogicalFunctions.or4\">or4</a> and
<a href=\"modelica://Requirements.LogicalFunctions.not4\">not4</a> are checked against every table entry,
and the laws that hold (commutativity, associativity, involution, De Morgan) and the ones that fail are
asserted with counterexamples. An unconnected PropertyAnd or PropertyOr (<code>nu = 0</code>) gives
Undefined, the neutral element.
</p>

<h4>The laws that fail</h4>
<p>
The Modelica 2023 paper on CRML states that the four-valued algebra satisfies all Boolean laws except the
complements law. Enumerating all 64 triples over the four values from the paper's own three generating
rules (Undefined is neutral; an Undecided operand decides only against Violated for <em>and</em> and
Satisfied for <em>or</em>; negation fixes Undecided and Undefined) shows more:
</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Law</th><th>Result</th><th>Counterexample</th></tr>
<tr><td>De Morgan, involution, commutativity, associativity, idempotence</td><td>hold</td><td>&mdash;</td></tr>
<tr><td>Absorption <code>a and (a or b) = a</code></td><td><b>fails, 12 of 64 triples</b></td>
    <td><code>a = Undefined, b = Satisfied</code>: <code>Undefined or Satisfied = Satisfied</code>,
        <code>Undefined and Satisfied = Satisfied &ne; Undefined</code></td></tr>
<tr><td>Distributivity <code>a and (b or c) = (a and b) or (a and c)</code></td><td><b>fails, 6 of 64 triples</b></td>
    <td><code>a = Satisfied, b = Violated, c = Undefined</code>: left side <code>Satisfied and Violated = Violated</code>,
        right side <code>Violated or Satisfied = Satisfied</code></td></tr>
<tr><td>Complements <code>a and not a = Violated</code></td><td>fails (acknowledged by the paper)</td>
    <td><code>Undecided</code>, <code>Undefined</code></td></tr>
</table>
<p>
Every absorption and distributivity failure involves Undefined: they are caused by the neutral-element
design itself. The structure is therefore not a Boolean algebra and not a lattice (Undefined is the top of
the <em>and</em>-order and the bottom of the <em>or</em>-order). Absorption and distributivity are exactly
the rewrites an expression simplifier applies, so <b>no Boolean simplification may be applied to an
expression over Property values</b>: a diagram of Property blocks is evaluated as drawn.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end PropertyTable4;
  end LogicalBlocks;

  package Sources "Library of examples using Sources blocks"
    extends Modelica.Icons.ExamplesPackage;
    model ConstantsAndExpressions "Examples for XXXConstant and XXXExpressions"
       extends Modelica.Icons.Example;
      Requirements.Sources.RealExpression expr1(y=time/2)
        annotation (Placement(transformation(extent={{-60,-20},{-20,0}})));
      Requirements.Sources.IntegerExpression expr2(y=integer(time))
        annotation (Placement(transformation(extent={{-60,-40},{-20,-20}})));
      Requirements.Sources.BooleanExpression expr3(y=time >= 1 and time < 3)
        annotation (Placement(transformation(extent={{-60,-60},{-20,-40}})));
      Requirements.Sources.RealConstant const1(c=1.234)
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      Requirements.Sources.BooleanConstant const2(c=false)
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
      Requirements.Sources.IntegerConstant const3(c=123)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Requirements.Sources.PropertyConstant const4(c=Requirements.Types.Property.Undecided)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
       annotation (experiment(StopTime=4));
    end ConstantsAndExpressions;

    model PropertyTable "Example for PropertyTable"
      import Requirements;
       extends Modelica.Icons.Example;

      Requirements.Sources.PropertyTable propertyTable(table=[0,2; 1,1; 2,3;
            3,2; 4,3; 5,1; 6,2])
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      annotation (experiment(StopTime=8));
    end PropertyTable;

    model SignalsFromFile "Example for PartialSignalsFromFile (a hand-written MA-HS-CSV reader with named outputs)"
      extends Modelica.Icons.Example;

      block CabinReader "Reads T_cabin, p_cabin, packOn and flightPhase from a MA-HS-CSV file"
        extends Requirements.Sources.PartialSignalsFromFile(
          final realNames = {"T_cabin", "p_cabin"},
          final booleanNames = {"packOn"},
          final integerNames = {"flightPhase"});
        Modelica.Blocks.Interfaces.RealOutput T_cabin = Requirements.Internal.CSV.getReal(file, 1, time, nextTimeEvent, pre(nextTimeEvent))
          annotation (Placement(transformation(extent={{100,50},{120,70}})));
        Modelica.Blocks.Interfaces.RealOutput p_cabin = Requirements.Internal.CSV.getReal(file, 2, time, nextTimeEvent, pre(nextTimeEvent))
          annotation (Placement(transformation(extent={{100,10},{120,30}})));
        Modelica.Blocks.Interfaces.BooleanOutput packOn
          annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
        Modelica.Blocks.Interfaces.IntegerOutput flightPhase
          annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
      equation
        // Boolean and Integer columns change only at the file's events, so they
        // are read in the when-clause that fires there (as BooleanTable does)
        when {time >= pre(nextTimeEvent), initial()} then
          packOn = Requirements.Internal.CSV.getBoolean(file, 1, time, nextTimeEvent, pre(nextTimeEvent));
          flightPhase = Requirements.Internal.CSV.getInteger(file, 1, time, nextTimeEvent, pre(nextTimeEvent));
        end when;
        annotation(Documentation(info="<html>
<p>The documented pattern for reading a MA-HS-CSV file without the generator: the three name lists fix the column types, one output per column, the column index passed to the C reader fixed at authoring time; Real outputs as declaration equations, Boolean and Integer outputs assigned in the when-clause that fires at the file's events.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
      end CabinReader;

      CabinReader reader(fileName="modelica://Requirements/Resources/Data/SignalsFromFile.csv")
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Requirements.LogicalBlocks.WithinBand band1(u_min=18, u_max=27)
        annotation (Placement(transformation(extent={{-40,20},{0,40}})));
      Requirements.ChecksInFixedWindow.During during1(check=band1.y)
        "While the pack is on, the cabin temperature shall remain within 18 and 27 degC"
        annotation (Placement(transformation(extent={{20,20},{60,40}})));
      Requirements.ChecksInFixedWindow.WhenRising whenRising1(check=reader.p_cabin > 0.9e5)
        "When the pack is switched on, the cabin pressure shall be above 0.9 bar"
        annotation (Placement(transformation(extent={{20,-20},{60,0}})));
      Requirements.ChecksInFixedWindow.During during2(check=reader.packOn)
        "While in cruise (flight phase 2), the pack shall be on"
        annotation (Placement(transformation(extent={{20,-60},{60,-40}})));
      Requirements.Sources.BooleanExpression inCruise(y=reader.flightPhase == 2)
        annotation (Placement(transformation(extent={{-40,-60},{0,-40}})));
    equation
      connect(reader.T_cabin, band1.u) annotation (Line(points={{-59,16},{-50,16},{-50,30},{-42,30}}, color={0,0,127}));
      connect(reader.packOn, during1.condition) annotation (Line(points={{-59,8},{-10,8},{-10,30.1},{18,30.1}}, color={255,0,255}));
      connect(reader.packOn, whenRising1.condition) annotation (Line(points={{-59,8},{-10,8},{-10,-9.9},{18,-9.9}}, color={255,0,255}));
      connect(inCruise.y, during2.condition) annotation (Line(points={{1,-50},{10,-50},{10,-49.9},{18,-49.9}}, color={255,0,255}));
      annotation (experiment(StopTime=300), Documentation(info="<html>
<p>
<a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">PartialSignalsFromFile</a> extended by a block with four named outputs
reading <code>Resources/Data/SignalsFromFile.csv</code> &mdash; a 300 s cabin run with the pack switched on at 20 s and off at 200 s
(stored as same-time event rows), a temperature excursion above 27 degC between 120 s and 150 s, and a flight phase that steps
0 &rarr; 1 &rarr; 2. Three checks read the outputs: <code>during1</code> is Violated during the excursion; <code>whenRising1</code> is
Satisfied because the cabin pressure is 1.013 bar when the pack rises at 20 s; <code>during2</code> is Violated from 200 s,
when the pack is switched off while the flight phase is still 2 (until 250 s).
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end SignalsFromFile;
  end Sources;

  package Units "Library of examples using the Units package"
    extends Modelica.Icons.ExamplesPackage;
    model Conversions "Every conversion of Requirements.Units.Conversions asserted against its factor, and its round trip"
      extends Modelica.Icons.Example;
      import C = Requirements.Units.Conversions;
      constant Real eps = 1e-12 "Relative tolerance of the assertions";
      Real m_kft = C.from_kft(4.65) "4.65 kft in metres";
      Real kgps = C.from_kgpmin(8.1) "8.1 kg/min in kg/s";
    equation
      assert(abs(C.from_ms(1500) - 1.5) < eps, "from_ms");
      assert(abs(C.from_mm(2540) - 2.54) < eps, "from_mm");
      assert(abs(C.from_cm(254) - 2.54) < eps, "from_cm");
      assert(abs(C.from_km(1.852) - 1852) < eps*1852, "from_km");
      assert(abs(C.from_ft(1000) - 304.8) < eps*304.8, "from_ft");
      assert(abs(C.from_kft(1) - 304.8) < eps*304.8, "from_kft");
      assert(abs(C.from_g(250) - 0.25) < eps, "from_g");
      assert(abs(C.from_kgpmin(60) - 1) < eps, "from_kgpmin");
      assert(abs(C.from_ftps(100) - 30.48) < eps*30.48, "from_ftps");
      assert(abs(C.from_ftpmin(6000) - 30.48) < eps*30.48, "from_ftpmin");
      assert(abs(C.from_kPa(101.325) - 101325) < eps*101325, "from_kPa");
      assert(abs(C.from_mbar(1013.25) - 101325) < eps*101325, "from_mbar");
      assert(abs(C.from_kW(2.5) - 2500) < eps*2500, "from_kW");
      assert(abs(C.from_kJ(3.6) - 3600) < eps*3600, "from_kJ");
      // round trips
      assert(abs(C.to_ms(C.from_ms(7)) - 7) < eps*7, "ms round trip");
      assert(abs(C.to_mm(C.from_mm(7)) - 7) < eps*7, "mm round trip");
      assert(abs(C.to_cm(C.from_cm(7)) - 7) < eps*7, "cm round trip");
      assert(abs(C.to_km(C.from_km(7)) - 7) < eps*7, "km round trip");
      assert(abs(C.to_ft(C.from_ft(7)) - 7) < eps*7, "ft round trip");
      assert(abs(C.to_kft(C.from_kft(7)) - 7) < eps*7, "kft round trip");
      assert(abs(C.to_g(C.from_g(7)) - 7) < eps*7, "g round trip");
      assert(abs(C.to_kgpmin(C.from_kgpmin(7)) - 7) < eps*7, "kg/min round trip");
      assert(abs(C.to_ftps(C.from_ftps(7)) - 7) < eps*7, "ft/s round trip");
      assert(abs(C.to_ftpmin(C.from_ftpmin(7)) - 7) < eps*7, "ft/min round trip");
      assert(abs(C.to_kPa(C.from_kPa(7)) - 7) < eps*7, "kPa round trip");
      assert(abs(C.to_mbar(C.from_mbar(7)) - 7) < eps*7, "mbar round trip");
      assert(abs(C.to_kW(C.from_kW(7)) - 7) < eps*7, "kW round trip");
      assert(abs(C.to_kJ(C.from_kJ(7)) - 7) < eps*7, "kJ round trip");
      annotation (experiment(StopTime=1), Documentation(info="<html>
<p>Asserts every factor of <a href=\"modelica://Requirements.Units.Conversions\">Requirements.Units.Conversions</a> (the international foot is 0.3048 m exactly, 1 kft = 304.8 m, 1 kg/min = 1/60 kg/s, ...) and every round trip; a model that translates and runs is the test. The two variables show how a check model writes a quantity stated in a non-SI unit: <code>from_kft(4.65)</code>, not 1417.32.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Conversions;
  end Units;

  package Margin "Library of examples asserting the margin outputs of the check blocks against closed-form values"
    extends Modelica.Icons.ExamplesPackage;

    model During "A ramp against a threshold: During's margin is (8 - u)/scale in closed form"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.Ramp level(height=10, duration=10) "u = time on [0, 10]"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.During during1(
        check=level.y < 8,
        rho=8 - level.y,
        scale=0.5) "the level shall be below 8, tolerance 0.5"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(always.y, during1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      when time >= 10 then
        assert(noEvent(during1.y == Property.Violated and abs(during1.margin + 4) < 1e-6),
          "During: at the end the level is 10, two above the limit of 8: violated by 4 tolerances");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(abs(during1.margin - (8 - time)/0.5) < 1e-6), "During: the margin is not (8 - u)/scale");
        assert(noEvent(during1.y <> Property.Satisfied or during1.margin >= -1e-6), "During: satisfied with a negative margin");
        assert(noEvent(during1.y <> Property.Violated or during1.margin <= 1e-6), "During: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=10, Interval=0.01), Documentation(info="<html>
<p>The level rises from 0 to 10 in 10 s against <em>the level shall be below 8</em> with a tolerance of 0.5:
<code>During(check = u &lt; 8, rho = 8 &minus; u, scale = 0.5)</code>. The margin is <code>(8 &minus; t)/0.5</code>
at every instant, asserted in closed form; it crosses zero at t = 8 s together with the property, and the
worst value is &minus;4 at the end: violated by four tolerances. The sign invariant (satisfied &hArr; margin &ge; 0)
is asserted continuously.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end During;

    model Band "A sine against a band: During's margin is min(u - lo, hi - u)/scale in closed form, the worst 0.5 at t = 7.5 s"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.Sine T(amplitude=7, f=0.1, offset=293.15) "a temperature in K"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.During during1(
        check=T.y >= 285.15 and T.y <= 303.15,
        rho=min(T.y - 285.15, 303.15 - T.y),
        scale=2) "the temperature shall remain within 12 degC and 30 degC, tolerance 2 K"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    protected
      Real s = sin(2*Modelica.Constants.pi*0.1*time);
    equation
      connect(always.y, during1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      when time >= 7.5 then
        assert(noEvent(abs(during1.margin - 0.5) < 1e-4), "Band: the worst margin, at t = 7.5 s, is not 0.5");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(abs(during1.margin - min(8 + 7*s, 10 - 7*s)/2) < 1e-6), "Band: the margin is not min(u - lo, hi - u)/scale");
        assert(noEvent(during1.y == Property.Satisfied), "Band: the sine stays inside the band");
        assert(noEvent(during1.margin >= 0), "Band: satisfied with a negative margin");
      end when;
      annotation (experiment(StopTime=10, Interval=0.01), Documentation(info="<html>
<p>A temperature 293.15 + 7 sin(2&pi; t / 10 s) K against <em>within 12 degC and 30 degC</em> (285.15 .. 303.15 K)
with a tolerance of 2 K: <code>During(check = lo &le; u &le; hi, rho = min(u &minus; lo, hi &minus; u), scale = 2)</code>.
The margin is <code>min(8 + 7 sin, 10 &minus; 7 sin)/2</code> in closed form; the requirement is satisfied
throughout and the closest call is at t = 7.5 s (the minimum of the sine, 1 K above the lower bound): margin 0.5,
half a tolerance -- what a report shows amber.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Band;

    model Duration "Min/Max/BandDuration on one condition phase: the margin is the running duration against its limit, piecewise linear"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.BooleanTable condition(startValue=false, table={1,4}) "true on [1, 4)"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false, table={1.5,3}) "true on [1.5, 3)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.MinDuration minDuration(durationMin=1, check=check.y, scale=0.5)
        annotation (Placement(transformation(extent={{-40,60},{0,80}})));
      Requirements.ChecksInFixedWindow.MaxDuration maxDuration(durationMax=1, check=check.y, scale=0.5)
        annotation (Placement(transformation(extent={{-40,20},{0,40}})));
      Requirements.ChecksInFixedWindow.BandDuration bandDuration(durationMin=0.5, durationMax=2, check=check.y, scale=0.5)
        annotation (Placement(transformation(extent={{-40,-20},{0,0}})));
    protected
      Real d = if time < 1.5 then 0 elseif time < 3 then time - 1.5 else 1.5 "the accumulated duration in closed form";
      Boolean inside = (time > 1.6 and time < 2.9) or (time > 3.1 and time < 3.9) or time > 4.1 "away from the event instants";
    equation
      connect(condition.y, minDuration.condition) annotation (Line(points={{-59,50},{-50,50},{-50,70},{-42,70}}, color={255,0,255}));
      connect(condition.y, maxDuration.condition) annotation (Line(points={{-59,50},{-50,50},{-50,30},{-42,30}}, color={255,0,255}));
      connect(condition.y, bandDuration.condition) annotation (Line(points={{-59,50},{-50,50},{-50,-10},{-42,-10}}, color={255,0,255}));
      when time >= 4.5 then
        assert(noEvent(minDuration.y == Property.Satisfied and abs(minDuration.margin - 1) < 1e-6), "MinDuration: 1.5 s of 1 s, margin 1");
        assert(noEvent(maxDuration.y == Property.Violated and abs(maxDuration.margin + 1) < 1e-6), "MaxDuration: 1.5 s over 1 s, margin -1");
        assert(noEvent(bandDuration.y == Property.Satisfied and abs(bandDuration.margin - 1) < 1e-6), "BandDuration: 1.5 s in [0.5, 2], margin 1");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(not inside or abs(minDuration.margin - (d - 1)/0.5) < 1e-6), "MinDuration: the margin is not (duration - durationMin)/scale");
        assert(noEvent(not inside or abs(maxDuration.margin - (1 - d)/0.5) < 1e-6), "MaxDuration: the margin is not (durationMax - duration)/scale");
        assert(noEvent(not inside or abs(bandDuration.margin - min(d - 0.5, 2 - d)/0.5) < 1e-6), "BandDuration: the margin is not min(...)/scale");
        assert(noEvent(minDuration.y <> Property.Satisfied or minDuration.margin >= -1e-6), "MinDuration: satisfied with a negative margin");
        assert(noEvent(minDuration.y <> Property.Violated or minDuration.margin <= 1e-6), "MinDuration: violated with a positive margin");
        assert(noEvent(maxDuration.y <> Property.Satisfied or maxDuration.margin >= -1e-6), "MaxDuration: satisfied with a negative margin");
        assert(noEvent(maxDuration.y <> Property.Violated or maxDuration.margin <= 1e-6), "MaxDuration: violated with a positive margin");
        assert(noEvent(bandDuration.y <> Property.Satisfied or bandDuration.margin >= -1e-6), "BandDuration: satisfied with a negative margin");
        assert(noEvent(bandDuration.y <> Property.Violated or bandDuration.margin <= 1e-6), "BandDuration: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=5, Interval=0.01), Documentation(info="<html>
<p>One condition phase [1, 4) s in which the check is true on [1.5, 3) s, 1.5 s in total, against
<code>MinDuration(durationMin = 1)</code>, <code>MaxDuration(durationMax = 1)</code> and
<code>BandDuration(0.5, 2)</code>, all with <code>scale = 0.5</code>. The blocks' new output <code>duration</code>
is the running accumulated duration of the phase (0, then t &minus; 1.5, then 1.5, frozen after the phase),
and the margins are <code>(duration &minus; 1)/0.5</code>, <code>(1 &minus; duration)/0.5</code> and the band's
minimum, asserted in closed form away from the event instants. MinDuration turns Satisfied at t = 2.5 s where its
margin crosses zero, MaxDuration Violated there; at the end the verdicts are Satisfied / Violated / Satisfied with
margins 1 / &minus;1 / 1. While a duration block is still Undecided its margin is provisional (negative for
MinDuration until the minimum is reached), which is why a consumer takes the worst value over the decided
points only.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Duration;

    model Rising "The five count checks on one edge train: the margins are count differences, scale 1"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.BooleanTable condition(startValue=false, table={1,5}) "true on [1, 5)"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false, table={2,2.1,3,3.1,4,4.1}) "rising edges at 2, 3, 4 s"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.FixedRising fixedRising(nRising=3, check=check.y)
        annotation (Placement(transformation(extent={{-40,80},{0,100}})));
      Requirements.ChecksInFixedWindow.MinRising minRising(nRisingMin=2, check=check.y)
        annotation (Placement(transformation(extent={{-40,50},{0,70}})));
      Requirements.ChecksInFixedWindow.MaxRising maxRising(nRisingMax=2, check=check.y)
        annotation (Placement(transformation(extent={{-40,20},{0,40}})));
      Requirements.ChecksInFixedWindow.BandRising bandRising(nRisingMin=1, nRisingMax=2, check=check.y)
        annotation (Placement(transformation(extent={{-40,-10},{0,10}})));
      Requirements.ChecksInFixedWindow.NoRising noRising(check=check.y)
        annotation (Placement(transformation(extent={{-40,-40},{0,-20}})));
    protected
      Integer n = if time < 2 then 0 elseif time < 3 then 1 elseif time < 4 then 2 else 3 "edges so far";
      Boolean inside = time > 1.1 and time < 4.9 and abs(time - 2) > 0.15 and abs(time - 3) > 0.15 and abs(time - 4) > 0.15
        "inside the phase, away from the edges";
    equation
      connect(condition.y, fixedRising.condition) annotation (Line(points={{-59,50},{-50,50},{-50,90},{-42,90}}, color={255,0,255}));
      connect(condition.y, minRising.condition) annotation (Line(points={{-59,50},{-50,50},{-50,60},{-42,60}}, color={255,0,255}));
      connect(condition.y, maxRising.condition) annotation (Line(points={{-59,50},{-50,50},{-50,30},{-42,30}}, color={255,0,255}));
      connect(condition.y, bandRising.condition) annotation (Line(points={{-59,50},{-50,50},{-50,0},{-42,0}}, color={255,0,255}));
      connect(condition.y, noRising.condition) annotation (Line(points={{-59,50},{-50,50},{-50,-30},{-42,-30}}, color={255,0,255}));
      when time >= 5.5 then
        assert(noEvent(fixedRising.y == Property.Satisfied and abs(fixedRising.margin) < 1e-9), "FixedRising: exactly 3 edges, margin 0");
        assert(noEvent(minRising.y == Property.Satisfied and abs(minRising.margin - 1) < 1e-9), "MinRising: 3 of at least 2, margin 1");
        assert(noEvent(maxRising.y == Property.Undefined), "MaxRising: Undefined after the phase");
        assert(noEvent(bandRising.y == Property.Violated and abs(bandRising.margin + 1) < 1e-9), "BandRising: 3 above the band's 2, margin -1");
        assert(noEvent(noRising.y == Property.Violated and abs(noRising.margin + 3) < 1e-9), "NoRising: 3 edges, margin -3");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(not inside or abs(fixedRising.margin + abs(n - 3)) < 1e-9), "FixedRising: the margin is not -|count - nRising|");
        assert(noEvent(not inside or abs(minRising.margin - (n - 2)) < 1e-9), "MinRising: the margin is not count - nRisingMin");
        assert(noEvent(not inside or abs(maxRising.margin - (2 - n)) < 1e-9), "MaxRising: the margin is not nRisingMax - count");
        assert(noEvent(not inside or abs(bandRising.margin - min(n - 1, 2 - n)) < 1e-9), "BandRising: the margin is not min(count - nMin, nMax - count)");
        assert(noEvent(not inside or abs(noRising.margin + n) < 1e-9), "NoRising: the margin is not -count");
        assert(noEvent(fixedRising.y <> Property.Satisfied or fixedRising.margin >= 0), "FixedRising: satisfied with a negative margin");
        assert(noEvent(fixedRising.y <> Property.Violated or fixedRising.margin <= 0), "FixedRising: violated with a positive margin");
        assert(noEvent(minRising.y <> Property.Satisfied or minRising.margin >= 0), "MinRising: satisfied with a negative margin");
        assert(noEvent(minRising.y <> Property.Violated or minRising.margin <= 0), "MinRising: violated with a positive margin");
        assert(noEvent(maxRising.y <> Property.Satisfied or maxRising.margin >= 0), "MaxRising: satisfied with a negative margin");
        assert(noEvent(maxRising.y <> Property.Violated or maxRising.margin <= 0), "MaxRising: violated with a positive margin");
        assert(noEvent(bandRising.y <> Property.Satisfied or bandRising.margin >= 0), "BandRising: satisfied with a negative margin");
        assert(noEvent(bandRising.y <> Property.Violated or bandRising.margin <= 0), "BandRising: violated with a positive margin");
        assert(noEvent(noRising.y <> Property.Satisfied or noRising.margin >= 0), "NoRising: satisfied with a negative margin");
        assert(noEvent(noRising.y <> Property.Violated or noRising.margin <= 0), "NoRising: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=6, Interval=0.01), Documentation(info="<html>
<p>One condition phase [1, 5) s with rising edges of the check at 2, 3 and 4 s against
<code>FixedRising(3)</code>, <code>MinRising(2)</code>, <code>MaxRising(2)</code>, <code>BandRising(1, 2)</code> and
<code>NoRising</code>, every <code>scale = 1</code> (a count has no other unit). The blocks' <code>countRising</code>
is an output now and the margins are count differences -- <code>&minus;|count &minus; 3|</code>,
<code>count &minus; 2</code>, <code>2 &minus; count</code>, <code>min(count &minus; 1, 2 &minus; count)</code>,
<code>&minus;count</code> -- asserted exactly between the edges. MaxRising turns Violated at the third edge with
margin &minus;1, BandRising too; FixedRising's margin is 0 when satisfied (an exact count has no headroom);
MaxRising is Undefined after the phase and its margin is masked then.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Rising;

    model RisingFrequency "A 2 Hz edge train against MaxRisingFrequency(3 Hz): the margin is 1 Hz once the frequency is known"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      constant Real pi = Modelica.Constants.pi;
      Requirements.Sources.RealExpression expr1(y=sin(2*pi*2*time))
        annotation (Placement(transformation(extent={{-90,10},{-50,30}})));
      Requirements.SignalAnalysis.CrossingMonitoring crossing
        annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.MaxRisingFrequency maxFrequency1(freqHzMax=3, check=crossing.y)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(expr1.y, crossing.u) annotation (Line(points={{-48,20},{-42,20}}, color={0,0,127}));
      connect(always.y, maxFrequency1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      when sample(0, 1e-3) then
        assert(noEvent(time > 0.9 or abs(maxFrequency1.margin - 3) < 1e-9), "MaxRisingFrequency: before the second edge the frequency is 0, the margin freqHzMax");
        assert(noEvent(time < 1.2 or abs(maxFrequency1.margin - 1) < 1e-4), "MaxRisingFrequency: the margin is not freqHzMax - 2 Hz");
        assert(noEvent(maxFrequency1.y <> Property.Satisfied or maxFrequency1.margin >= -1e-6), "MaxRisingFrequency: satisfied with a negative margin");
        assert(noEvent(maxFrequency1.y <> Property.Violated or maxFrequency1.margin <= 1e-6), "MaxRisingFrequency: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=3, Interval=1e-3), Documentation(info="<html>
<p>The upward zero crossings of a 2 Hz sine (every 0.5 s from t = 0.5 s) against
<code>MaxRisingFrequency(freqHzMax = 3)</code>: the block's <code>freqHz</code> is 0 until the second rising edge
at t = 1 s (margin 3, the whole limit) and 2 Hz from then on (margin 1, asserted to 1e-4: the edges are located
by the solver). Satisfied throughout with one Hz of headroom.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end RisingFrequency;

    model WithinDomain "A point crossing a square: the margin is the signed distance to the nearest edge over scale, in closed form"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Requirements.ChecksInFixedWindow.WithinDomain withinDomain(polygon=[0,0; 2,0; 2,2; 0,2], scale=0.25)
        annotation (Placement(transformation(extent={{-20,0},{20,40}})));
      Requirements.Sources.RealExpression px(y=1)
        annotation (Placement(transformation(extent={{-90,0},{-50,20}})));
      Requirements.Sources.RealExpression py(y=0.5 + 0.1*time)
        annotation (Placement(transformation(extent={{-90,-30},{-50,-10}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    equation
      connect(px.y, withinDomain.point[1]) annotation (Line(points={{-48,10},{-22,10}}, color={0,0,127}));
      connect(py.y, withinDomain.point[2]) annotation (Line(points={{-48,-20},{-30,-20},{-30,10},{-22,10}}, color={0,0,127}));
      connect(always.y, withinDomain.condition) annotation (Line(points={{-39,40},{-30,40},{-30,20.1},{-22,20.1}}, color={255,0,255}));
      when time >= 5 then
        assert(noEvent(abs(withinDomain.margin - 4) < 1e-6), "WithinDomain: at t = 5 s the point is 1 from every edge, four tolerances");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(abs(withinDomain.margin - min(0.5 + 0.1*time, 1.5 - 0.1*time)/0.25) < 1e-6), "WithinDomain: the margin is not distance/scale");
        assert(noEvent(withinDomain.y == Property.Satisfied and withinDomain.margin >= 0), "WithinDomain: the point stays inside");
      end when;
      annotation (experiment(StopTime=10, Interval=0.01), Documentation(info="<html>
<p>The point (1, 0.5 + 0.1 t) moves up through the square [0, 2] &times; [0, 2] against
<code>WithinDomain(scale = 0.25)</code>: the block's <code>distance</code> to the nearest edge is
<code>min(0.5 + 0.1 t, 1.5 &minus; 0.1 t)</code> (the bottom edge, then the top one) and the margin is that over
0.25, asserted in closed form; the farthest point from any edge is the centre at t = 5 s, four tolerances away.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end WithinDomain;

    model SlidingIncrease "A ramp against MaxIncrease: the margin is upperLimit - increase, with increase = min(t, window) in closed form"
      extends Modelica.Icons.Example;
      Modelica.Blocks.Sources.Ramp u(height=10, duration=10, offset=20) "u = 20 + t"
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Requirements.ChecksInSlidingWindow.MaxIncrease maxIncrease(window=2, upperLimit=3)
        annotation (Placement(transformation(extent={{-44,60},{-24,80}})));
    equation
      connect(u.y, maxIncrease.u) annotation (Line(points={{-59,70},{-46,70}}, color={0,0,127}));
      when sample(0, 0.01) then
        assert(noEvent(abs(maxIncrease.margin - (3 - min(time, 2))) < 1e-3), "MaxIncrease: the margin is not upperLimit - increase");
        assert(noEvent(not maxIncrease.y or maxIncrease.margin >= -1e-6), "MaxIncrease: satisfied with a negative margin");
        assert(noEvent(maxIncrease.y or maxIncrease.margin <= 1e-6), "MaxIncrease: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=5, Interval=0.01), Documentation(info="<html>
<p>A ramp of 1 per second against <code>MaxIncrease(window = 2, upperLimit = 3)</code>: the increase over the
window is <code>t</code> while the window still reaches back to the start (u(t &minus; window) = u(0) there) and
2 from t = 2 s on, so the margin is <code>3 &minus; min(t, 2)</code>, asserted to 1e-3 (the delayed signal is
interpolated). Satisfied throughout with one unit of headroom. The sliding-window checks with a buffer
(<code>SlidingWindow.push</code>) carry the same <code>margin</code> output; this example uses the one block of
the family that has no buffer (which was, until October 2026, the one OpenModelica built).</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end SlidingIncrease;

    model FFT "WithinAbsoluteDomain with a scale: the margin is scaledDistance/scale and agrees in sign with the verdict"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Requirements.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain fft(
        f_max=4,
        f_resolution=0.2,
        maxAmplitude=[0,6; 1,6; 2,4; 3,1.5; 4,1.5],
        scale=0.5)
        annotation (Placement(transformation(extent={{8,0},{68,60}})));
      Modelica.Blocks.Sources.Sine sine2(amplitude=3, f=2)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Modelica.Blocks.Sources.Sine sine3(amplitude=1.5, f=3)
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
      Modelica.Blocks.Sources.Constant const(k=5)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Math.MultiSum multiSum(nu=3)
        annotation (Placement(transformation(extent={{-36,24},{-24,36}})));
      Requirements.Sources.BooleanConstant const1
        annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    equation
      connect(const.y, multiSum.u[1]) annotation (Line(points={{-59,50},{-48,50},{-48,32.8},{-36,32.8}}, color={0,0,127}));
      connect(sine2.y, multiSum.u[2]) annotation (Line(points={{-59,10},{-48,10},{-48,30},{-36,30}}, color={0,0,127}));
      connect(sine3.y, multiSum.u[3]) annotation (Line(points={{-59,-30},{-46,-30},{-46,27.2},{-36,27.2}}, color={0,0,127}));
      connect(multiSum.y, fft.u) annotation (Line(points={{-22.98,30},{6,30}}, color={0,0,127}));
      connect(const1.y, fft.condition) annotation (Line(points={{-19,70},{-10,70},{-10,50},{6,50}}, color={255,0,255}));
      when time >= 5.5 then
        assert(noEvent(fft.y == Property.Satisfied and fft.margin > 0), "FFT: the spectrum is within the limit, the margin positive");
      end when;
      when sample(0, 0.01) then
        assert(noEvent(abs(fft.margin - fft.scaledDistance/0.5) < 1e-12), "FFT: the margin is not scaledDistance/scale");
        assert(noEvent(fft.y <> Property.Satisfied or fft.margin >= 0), "FFT: satisfied with a negative margin");
        assert(noEvent(fft.y <> Property.Violated or fft.margin <= 0), "FFT: violated with a positive margin");
      end when;
      annotation (experiment(StopTime=6), Documentation(info="<html>
<p>The stimulus of <a href=\"modelica://Requirements.Examples.Elementary.ChecksInFixedWindow_withFFT.WithinAbsoluteDomain1\">WithinAbsoluteDomain1</a>
(5 + 3 sin 2 Hz + 1.5 sin 3 Hz against the limit polygon) with <code>scale = 0.5</code> and without the terminate
block: the FFT completes at t = 4.975 s, the property is Satisfied and the margin is <code>scaledDistance/scale</code>,
positive -- the FFT blocks' <code>scaledDistance</code> is their robustness. The
value itself is not closed-form (leakage); it is the stored reference of this example in the regression lists.
The example runs on Dymola, OpenModelica and Modelon Impact.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end FFT;

    model Gated "WithinBand and GreaterEqual behind a pulsed condition and a delay: the margins in closed form while active, Undefined otherwise"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.Sine u(amplitude=1, f=0.1) "u = sin(2 pi t / 10 s)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Modelica.Blocks.Sources.Constant lower(k=-0.5) "-0.5"
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
      Modelica.Blocks.Sources.BooleanPulse condition(width=50, period=10) "true on [0, 5) s of every 10 s"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.WithinBand withinBand1(
        u_max=0.8,
        u_min=-0.8,
        delayTime=1,
        scale=0.2) "|u| <= 0.8 from 1 s after the condition rises, tolerance 0.2"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.GreaterEqual greaterEqual1(delayTime=1, scale=0.5)
        "u >= -0.5 from 1 s after the condition rises, tolerance 0.5"
        annotation (Placement(transformation(extent={{-40,-20},{0,0}})));
      Requirements.Verify.ViolationStatistics statistics "Statistics of withinBand1"
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
    protected
      Real s = sin(2*Modelica.Constants.pi*0.1*time);
      Real tm = mod(time, 10) "Time within the period of the condition";
      constant Real t1 = asin(0.8)/(2*Modelica.Constants.pi*0.1) "u rises above 0.8 at t1 within each period";
    equation
      connect(condition.y, withinBand1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(condition.y, greaterEqual1.condition) annotation (Line(points={{-59,50},{-50,50},{-50,-10},{-42,-10}}, color={255,0,255}));
      connect(u.y, withinBand1.u) annotation (Line(points={{-59,20},{-50,20},{-50,56},{-42,56}}, color={0,0,127}));
      connect(u.y, greaterEqual1.u_max) annotation (Line(points={{-59,20},{-50,20},{-50,-4},{-42,-4}}, color={0,0,127}));
      connect(lower.y, greaterEqual1.u_min) annotation (Line(points={{-59,-30},{-50,-30},{-50,-16},{-42,-16}}, color={0,0,127}));
      connect(withinBand1.y, statistics.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(withinBand1.margin, statistics.margin) annotation (Line(points={{1,41},{16,41},{16,46},{28,46}}, color={0,127,0}));
      when sample(0, 0.01) then
        if noEvent(tm > 1.001 and tm < 4.999) then
          assert(noEvent(abs(withinBand1.margin - min(s + 0.8, 0.8 - s)/0.2) < 1e-6), "Gated: WithinBand's margin is not min(u - u_min, u_max - u)/scale");
          assert(noEvent(withinBand1.y <> Property.Satisfied or withinBand1.margin >= -1e-6), "Gated: WithinBand satisfied with a negative margin");
          assert(noEvent(withinBand1.y <> Property.Violated or withinBand1.margin <= 1e-6), "Gated: WithinBand violated with a positive margin");
          assert(noEvent(withinBand1.y <> Property.Undefined and withinBand1.y <> Property.Undecided), "Gated: WithinBand undecided while active");
          assert(noEvent(abs(greaterEqual1.margin - (s + 0.5)/0.5) < 1e-6), "Gated: GreaterEqual's margin is not (u_max - u_min)/scale");
          assert(noEvent(greaterEqual1.y == Property.Satisfied), "Gated: u stays above -0.5 while active");
        elseif noEvent(tm < 0.999 or tm > 5.001) then
          assert(noEvent(withinBand1.y == Property.Undefined and greaterEqual1.y == Property.Undefined),
            "Gated: not Undefined while the condition is false or during the delay");
          assert(noEvent(abs(withinBand1.margin - 4) < 1e-12 and abs(greaterEqual1.margin) < 1e-12),
            "Gated: an inactive check does not have the margin of the middle of the band (WithinBand) or 0 (GreaterEqual)");
        end if;
      end when;
      when time >= 19.9 then
        assert(noEvent(statistics.nViolations == 2), "Gated: one violation in each of the two active phases");
        assert(noEvent(abs(statistics.totalDuration - 2*(5 - 2*t1)) < 1e-3), "Gated: total violated time is not 2 (5 s - 2 t1)");
        assert(noEvent(abs(statistics.violatedFraction - 2*(5 - 2*t1)/8) < 1e-3),
          "Gated: the violated fraction is not of the 8 s in which the check applies");
        assert(noEvent(abs(statistics.worstMargin + 1) < 1e-3), "Gated: the worst margin, at the peak u = 1, is not -1");
      end when;
      annotation (experiment(StopTime=20, Interval=0.01), Documentation(info="<html>
<p>u = sin(2&pi;t / 10 s) against <a href=\"modelica://Requirements.ChecksInFixedWindow.WithinBand\">WithinBand</a>
(|u| &le; 0.8, tolerance 0.2) and <a href=\"modelica://Requirements.ChecksInFixedWindow.GreaterEqual\">GreaterEqual</a>
(u &ge; &minus;0.5, tolerance 0.5), both behind a condition that is true for the first 5 s of every 10 s and a delay of
1 s: the checks apply on [1, 5) s and [11, 15) s. Asserted at every output point:</p>
<ul>
<li>while the checks apply, the margins are min(u + 0.8, 0.8 &minus; u)/0.2 and (u + 0.5)/0.5 in closed form, and the
    sign of WithinBand's margin is its verdict; GreaterEqual is satisfied (u is positive on (0, 5) s);</li>
<li>while the condition is false and during the delay, both are Undefined, with the margin of the inactive check:
    the middle of the band for WithinBand (4 tolerances), 0 for GreaterEqual;</li>
<li>a <a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a> counts one violation of
    WithinBand per active phase, u &gt; 0.8 from t1 = asin(0.8)/(0.2&pi;) = 1.476 s to 5 &minus; t1 within the period,
    a violated fraction of the 8 s in which the check applies (the inactive time does not count), and the worst
    margin &minus;1 at the peak u = 1.</li>
</ul>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Gated;

    model StableSignal "StableSignal on a sine that stops: the moving average of |du/dt| and the margin in closed form, and the hysteresis"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.RealExpression u(y=if time < 100 then sin(2*Modelica.Constants.pi*0.05*time) else 0)
        "sin(2 pi t / 20 s) until 100 s, 0 after"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.StableSignal stable1(
        window=40,
        upperLimit=0.25,
        Td=0.1,
        scale=0.05) "Limit above the sine's average speed: satisfied"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.StableSignal stable2(
        window=40,
        upperLimit=0.15,
        Td=0.1,
        scale=0.05) "Limit below it: violated while the sine runs"
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      Requirements.ChecksInFixedWindow.StableSignal stable3(
        window=40,
        upperLimit=0.15,
        h=0.06,
        Td=0.1,
        scale=0.05) "As stable2, with hysteresis: stable again only at or below 0.09"
        annotation (Placement(transformation(extent={{-40,-40},{0,-20}})));
    protected
      constant Real w = 2*Modelica.Constants.pi*0.05 "Angular frequency of the sine";
      constant Real average = 2/Modelica.Constants.pi*w/sqrt(1 + (w*0.1)^2)
        "Moving average of |du/dt| over whole periods: 2/pi times the amplitude of the filtered derivative";
    equation
      connect(always.y, stable1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(always.y, stable2.condition) annotation (Line(points={{-59,50},{-50,50},{-50,10},{-42,10}}, color={255,0,255}));
      connect(always.y, stable3.condition) annotation (Line(points={{-59,50},{-50,50},{-50,-30},{-42,-30}}, color={255,0,255}));
      connect(u.y, stable1.u) annotation (Line(points={{-59,20},{-54,20},{-54,56},{-42,56}}, color={0,0,127}));
      connect(u.y, stable2.u) annotation (Line(points={{-59,20},{-54,20},{-54,16},{-42,16}}, color={0,0,127}));
      connect(u.y, stable3.u) annotation (Line(points={{-59,20},{-54,20},{-54,-24},{-42,-24}}, color={0,0,127}));
      when sample(0, 0.1) then
        if noEvent(time < 39.99) then
          assert(noEvent(stable1.y == Property.Undecided and stable2.y == Property.Undecided and stable3.y == Property.Undecided),
            "StableSignal: not Undecided during the first window");
          assert(noEvent(abs(stable1.rateAverage) < 1e-15), "StableSignal: rateAverage is not 0 during the first window");
        elseif noEvent(time > 42 and time < 99) then
          assert(noEvent(abs(stable1.rateAverage - average) < 2e-4), "StableSignal: rateAverage is not 2/pi times the amplitude of du/dt");
          assert(noEvent(abs(stable1.margin - (0.25 - average)/0.05) < 5e-3), "StableSignal: stable1's margin is not (upperLimit - rateAverage)/scale");
          assert(noEvent(abs(stable2.margin - (0.15 - average)/0.05) < 5e-3), "StableSignal: stable2's margin is not (upperLimit - rateAverage)/scale");
          assert(noEvent(stable1.y == Property.Satisfied and stable2.y == Property.Violated and stable3.y == Property.Violated),
            "StableSignal: wrong verdict while the sine runs");
        end if;
        if noEvent(time > 40.01) then
          assert(noEvent(stable2.y <> Property.Satisfied or stable2.margin >= -1e-6), "StableSignal: satisfied with a negative margin (h = 0)");
          assert(noEvent(stable2.y <> Property.Violated or stable2.margin <= 1e-6), "StableSignal: violated with a positive margin (h = 0)");
        end if;
      end when;
      when time >= 115 then
        assert(noEvent(stable2.y == Property.Satisfied), "StableSignal: stable2 not satisfied once the average fell below 0.15");
        assert(noEvent(stable3.y == Property.Violated and stable3.margin > 0),
          "StableSignal: stable3 not still violated (with a positive margin) above upperLimit - h = 0.09");
      end when;
      when time >= 145 then
        assert(noEvent(stable3.y == Property.Satisfied), "StableSignal: stable3 not satisfied once the average fell below 0.09");
      end when;
      annotation (experiment(StopTime=150, Interval=0.1), Documentation(info="<html>
<p>u = sin(2&pi;t / 20 s) until 100 s, 0 after, against <a href=\"modelica://Requirements.ChecksInFixedWindow.StableSignal\">StableSignal</a>
with a 40 s window (two periods) and the derivative filter's time constant Td = 0.1 s. Over whole periods the moving
average of |du/dt| is (2/&pi;) &omega;/&radic;(1 + (&omega; Td)<sup>2</sup>) = 0.1999 s<sup>-1</sup> with &omega; = 2&pi;/20 s,
asserted from 42 s (after the filter's start-up has left the window) until the sine stops:</p>
<ul>
<li>during the first 40 s all three checks are Undecided and rateAverage is 0;</li>
<li><code>stable1</code> (limit 0.25) is satisfied with margin (0.25 &minus; 0.1999)/0.05 = 1.0, <code>stable2</code> (limit 0.15)
    violated with margin &minus;1.0, and the sign of stable2's margin is its verdict throughout;</li>
<li>after 100 s the oscillation slides out of the window and the average falls. At 115 s it is about 0.12: stable2 is
    satisfied again, while <code>stable3</code>, the same check with hysteresis h = 0.06, is still violated although its
    margin is already positive -- the documented price of a hysteresis. At 145 s, with the average below 0.09, it is
    satisfied too.</li>
</ul>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end StableSignal;
    annotation (Documentation(info="<html>
<p>Every check block of the library carries a <code>margin</code> output since version 0.9.0: the signed distance of the check to its limit divided by the block's <code>scale</code> (the
requirement's tolerance), &ge; 0 exactly when the check holds. These examples assert the margins against
closed-form values at every instant and the sign invariant (satisfied &hArr; margin &ge; 0) continuously, one
example per block family; each is a case in the regression lists beside this library, with the margins stored.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end Margin;

  package ViolationStatistics "Examples of Verify.ViolationStatistics: how often, how long and how badly a requirement was violated, asserted against closed-form values"
    extends Modelica.Icons.ExamplesPackage;

    model Sine "A sine against a limit: four episodes of 10/3 s each, the worst margin -2 between two output points"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.Types.WorstMarginMethod;
      Modelica.Blocks.Sources.Sine u(amplitude=1, f=0.1) "u = sin(2 pi t / 10 s)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.During during1(
        check=u.y < 0.5,
        rho=0.5 - u.y,
        scale=0.25) "u shall stay below 0.5, tolerance 0.25"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.Verify.ViolationStatistics continuous
        "Worst margin at the local extrema of the margin (default)"
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
      Requirements.Verify.ViolationStatistics ratchet(method=WorstMarginMethod.Ratchet, resolution=0.01)
        "Worst margin at every new low by more than 0.01"
        annotation (Placement(transformation(extent={{30,0},{50,20}})));
    protected
      constant Real P = 10 "Period of the sine";
    equation
      connect(always.y, during1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(during1.y, continuous.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(during1.margin, continuous.margin) annotation (Line(points={{1,42},{16,42},{16,46},{28,46}}, color={0,127,0}));
      connect(during1.y, ratchet.property) annotation (Line(points={{1,50},{16,50},{16,14},{28,14}}, color={0,0,255}));
      connect(during1.margin, ratchet.margin) annotation (Line(points={{1,42},{12,42},{12,6},{28,6}}, color={0,127,0}));
      when time >= 34.99 then
        assert(noEvent(continuous.nViolations == 4), "Sine: four episodes, one per period in which sin > 0.5");
        assert(noEvent(abs(continuous.totalDuration - 4*P/3) < 1e-4), "Sine: violated 4 x 10/3 s in total");
        assert(noEvent(abs(continuous.violatedFraction - 4*P/3/34.99) < 1e-5), "Sine: the fraction is the total over the run so far");
        assert(noEvent(abs(continuous.longestDuration - P/3) < 1e-4
          and abs(continuous.tLongestStart - P*floor(continuous.tLongestStart/P) - P/12) < 1e-4),
          "Sine: the longest episode is 10/3 s long and starts at 10/12 s in its period");
        assert(noEvent(abs(continuous.worstMargin + 2) < 1e-4), "Sine: the worst margin is (0.5 - 1)/0.25 = -2");
        assert(noEvent(abs(continuous.tWorst - P*floor(continuous.tWorst/P) - P/4) < 2*continuous.T),
          "Sine: the worst margin is at a maximum of the sine, found about T after it");
        assert(noEvent(abs(continuous.episodeWorstMargin + 2) < 1e-4 and abs(continuous.tEpisodeWorst - 32.5) < 2*continuous.T),
          "Sine: the last episode is as bad, at 32.5 s");
        assert(noEvent(abs(continuous.currentDuration) < 1e-12), "Sine: not violated at the end");
        assert(noEvent(ratchet.nViolations == 4 and abs(ratchet.totalDuration - continuous.totalDuration) < 1e-6),
          "Sine: the method changes the worst margin only");
        assert(noEvent(ratchet.worstMargin >= -2 - 1e-6 and ratchet.worstMargin <= -2 + 0.01),
          "Sine: the ratchet is within its resolution of -2");
        assert(noEvent(abs(ratchet.tWorst - P*floor(ratchet.tWorst/P) - P/4) < 0.12),
          "Sine: the ratchet's instant is within a resolution of the maximum");
      end when;
      annotation (experiment(StopTime=35, Interval=1), Documentation(info="<html>
<p>u = sin(2&pi; t / 10 s) against <em>u shall stay below 0.5</em> with a tolerance of 0.25:
<code>During(check = u &lt; 0.5, rho = 0.5 &minus; u, scale = 0.25)</code>, into two
<a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a>, one per worst-margin method.
The sine exceeds 0.5 from 10/12 s to 50/12 s in every period: four episodes of 10/3 s each in 35 s, 40/3 s in total;
which of the four equally long ones is reported as the longest is decided by the last digits of the event times. The worst margin is (0.5 &minus; 1)/0.25 = &minus;2 at
every maximum, t = 2.5 s + k&middot;10 s; the continuous method reports it T = 0.01 s late (2.51 s), off by
8&middot;10<sup>&minus;5</sup>.</p>
<p>The output interval is 1 s on purpose. The stored result has no point at a maximum of the sine, so the least margin
over the stored points is (0.5 &minus; sin(0.4&pi;))/0.25 = &minus;1.80 (at 2 s and 3 s); the block finds &minus;2.
The ratchet method is within its resolution of 0.01.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Sine;

    model Episodes "Five violations against mergeGap and minDuration, and against a property that is applicable half of the time"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      Modelica.Blocks.Sources.BooleanTable violatedTable(startValue=false, table={1,1.2,1.3,2,5,5.05,8,8.9,9.7})
        "true on [1, 1.2), [1.3, 2), [5, 5.05), [8, 8.9) and from 9.7 s"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Property p = if violatedTable.y then Property.Violated else Property.Satisfied "Violated while the table is true";
      Property q = if time < 5 then Property.Undefined elseif violatedTable.y then Property.Violated else Property.Satisfied
        "The same, not applicable before 5 s";
      Requirements.Verify.ViolationStatistics plain(useMargin=false, property=p) "Every violation an episode"
        annotation (Placement(transformation(extent={{-20,60},{0,80}})));
      Requirements.Verify.ViolationStatistics merged(useMargin=false, mergeGap=0.2, property=p)
        "A violation within 0.2 s of the previous one continues its episode"
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Requirements.Verify.ViolationStatistics mergedMin(useMargin=false, mergeGap=0.2, minDuration=0.1, property=p)
        "Merged, and episodes under 0.1 s not counted"
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      Requirements.Verify.ViolationStatistics minOnly(useMargin=false, minDuration=0.25, property=p)
        "Episodes under 0.25 s not counted"
        annotation (Placement(transformation(extent={{20,20},{40,40}})));
      Requirements.Verify.ViolationStatistics partly(useMargin=false, property=q)
        "Applicable from 5 s only"
        annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    equation
      when time >= 9.9 then
        assert(noEvent(minOnly.nViolations == 2), "Episodes: at 9.9 s the running violation (0.2 s) is still under 0.25 s");
      end when;
      when time >= 9.99 then
        assert(noEvent(plain.nViolations == 5), "Episodes: five violations");
        assert(noEvent(abs(plain.totalDuration - 2.14) < 1e-6), "Episodes: 0.2 + 0.7 + 0.05 + 0.9 + 0.29 s violated");
        assert(noEvent(abs(plain.violatedFraction - 2.14/9.99) < 1e-6), "Episodes: always applicable");
        assert(noEvent(abs(plain.longestDuration - 0.9) < 1e-6 and abs(plain.tLongestStart - 8) < 1e-6), "Episodes: the longest is [8, 8.9)");
        assert(noEvent(abs(plain.currentDuration - 0.29) < 1e-6), "Episodes: violated for 0.29 s at 9.99 s");
        assert(noEvent(merged.nViolations == 4), "Episodes: [1, 1.2) and [1.3, 2) merge, the gap at 8.9 s is too long");
        assert(noEvent(abs(merged.longestDuration - 1) < 1e-6 and abs(merged.tLongestStart - 1) < 1e-6),
          "Episodes: the merged [1, 2) is the longest, its gap included");
        assert(noEvent(abs(merged.totalDuration - 2.14) < 1e-6), "Episodes: merging leaves the total unchanged");
        assert(noEvent(mergedMin.nViolations == 3), "Episodes: merged, and [5, 5.05) too short");
        assert(noEvent(abs(mergedMin.totalDuration - 2.14) < 1e-6), "Episodes: minDuration leaves the total unchanged");
        assert(noEvent(minOnly.nViolations == 3 and abs(minOnly.longestDuration - 0.9) < 1e-6), "Episodes: 0.7, 0.9 and the running 0.29 s count");
        assert(noEvent(partly.nViolations == 3), "Episodes: three violations after 5 s");
        assert(noEvent(abs(partly.totalDuration - 1.24) < 1e-6), "Episodes: 0.05 + 0.9 + 0.29 s violated after 5 s");
        assert(noEvent(abs(partly.violatedFraction - 1.24/4.99) < 1e-6), "Episodes: applicable for 4.99 s");
        assert(noEvent(abs(plain.worstMargin) < 1e-12 and abs(plain.tWorst) < 1e-12), "Episodes: without margin the worst margin is 0");
      end when;
      annotation (experiment(StopTime=10, Interval=0.01), Documentation(info="<html>
<p>A property that is <code>Violated</code> on [1, 1.2), [1.3, 2), [5, 5.05), [8, 8.9) and from 9.7 s, and
<code>Satisfied</code> otherwise, into five <a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a>
without margin. At 9.99 s:</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Instance</th><th>Settings</th><th>nViolations</th><th>longest</th><th>total</th></tr>
<tr><td>plain</td><td>&mdash;</td><td>5</td><td>0.9 s from 8 s</td><td>2.14 s</td></tr>
<tr><td>merged</td><td>mergeGap = 0.2 s</td><td>4: the first two merge across their 0.1 s gap</td><td>1 s from 1 s (gap included)</td><td>2.14 s</td></tr>
<tr><td>mergedMin</td><td>mergeGap = 0.2 s, minDuration = 0.1 s</td><td>3: [5, 5.05) is too short</td><td>1 s from 1 s</td><td>2.14 s</td></tr>
<tr><td>minOnly</td><td>minDuration = 0.25 s</td><td>3 (2 at 9.9 s: the running violation counts once it is 0.25 s long)</td><td>0.9 s from 8 s</td><td>2.14 s</td></tr>
<tr><td>partly</td><td>property <code>Undefined</code> before 5 s</td><td>3</td><td>0.9 s from 8 s</td><td>1.24 s, 1.24/4.99 of the applicable time</td></tr>
</table>
<p>The filters change the count and the longest episode, never the total.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Episodes;

    model Gating "A MinDuration check: its provisional margin while Undecided does not count, the worst decided margin is 0"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.Types.WorstMarginMethod;
      Modelica.Blocks.Sources.BooleanTable condition(startValue=false, table={1,4}) "true on [1, 4)"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.BooleanTable check(startValue=false, table={1.5,3}) "true on [1.5, 3)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.ChecksInFixedWindow.MinDuration minDuration(durationMin=1, check=check.y, scale=0.5)
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.Verify.ViolationStatistics continuous
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
      Requirements.Verify.ViolationStatistics ratchet(method=WorstMarginMethod.Ratchet)
        annotation (Placement(transformation(extent={{30,0},{50,20}})));
    equation
      connect(condition.y, minDuration.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(minDuration.y, continuous.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(minDuration.margin, continuous.margin) annotation (Line(points={{1,42},{16,42},{16,46},{28,46}}, color={0,127,0}));
      connect(minDuration.y, ratchet.property) annotation (Line(points={{1,50},{16,50},{16,14},{28,14}}, color={0,0,255}));
      connect(minDuration.margin, ratchet.margin) annotation (Line(points={{1,42},{12,42},{12,6},{28,6}}, color={0,127,0}));
      when time >= 2 then
        assert(noEvent(minDuration.y == Property.Undecided and minDuration.margin < -0.9),
          "Gating: at 2 s the check is still Undecided, its margin provisional and negative");
        assert(noEvent(abs(continuous.worstMargin) < 1e-12 and abs(ratchet.worstMargin) < 1e-12),
          "Gating: nothing is decided yet, the worst margin is 0");
      end when;
      when time >= 4.5 then
        assert(noEvent(minDuration.y == Property.Satisfied), "Gating: satisfied once the duration reached 1 s");
        assert(noEvent(abs(continuous.worstMargin) < 1e-6 and abs(continuous.tWorst - 2.5) < 1e-6),
          "Gating: the worst decided margin is 0, at 2.5 s, not the provisional -2 before");
        assert(noEvent(abs(ratchet.worstMargin) < 1e-6 and abs(ratchet.tWorst - 2.5) < 1e-6),
          "Gating: the same with the ratchet");
        assert(noEvent(continuous.nViolations == 0 and abs(continuous.totalDuration) < 1e-12), "Gating: never violated");
      end when;
      annotation (experiment(StopTime=5, Interval=0.01), Documentation(info="<html>
<p>The condition phase [1, 4) s with the check true on [1.5, 3) s against <code>MinDuration(durationMin = 1, scale = 0.5)</code>.
The check is <code>Undecided</code> until the accumulated duration reaches 1 s at 2.5 s; until then its margin
(duration &minus; 1)/0.5 is provisional, &minus;2 at 1.5 s. A
<a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a> takes the worst margin over the
decided phases only: 0 at 2.5 s, the instant the requirement became satisfied. The verdict of the requirement follows
the same rule.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Gating;

    model RequirementLog "Verify.Requirement with computeStatistics: the statistics are logged beside the verdict and printed in the summary"
      extends Modelica.Icons.Example;
      Modelica.Blocks.Sources.Sine u(amplitude=1, f=0.1) "u = sin(2 pi t / 10 s)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.During during1(
        check=u.y < 0.5,
        rho=0.5 - u.y,
        scale=0.25) "u shall stay below 0.5, tolerance 0.25"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.ChecksInFixedWindow.During during2(check=u.y > -1.5) "u shall stay above -1.5"
        annotation (Placement(transformation(extent={{-40,0},{0,20}})));
      Requirements.Verify.Requirement below(
        text="u shall stay below 0.5",
        computeStatistics=true,
        useMargin=true) "Violated four times; its statistics with the worst margin"
        annotation (Placement(transformation(extent={{20,40},{80,60}})));
      Requirements.Verify.Requirement above(text="u shall stay above -1.5", computeStatistics=true)
        "Satisfied; its statistics without margin"
        annotation (Placement(transformation(extent={{20,0},{80,20}})));
      Requirements.Verify.Requirement plain(text="u shall stay above -1.5")
        "Without statistics: logged as before"
        annotation (Placement(transformation(extent={{20,-40},{80,-20}})));
      inner Requirements.Verify.PrintViolations printViolations(evaluationTime=35)
        annotation (Placement(transformation(extent={{-80,-60},{-20,-40}})));
    equation
      connect(always.y, during1.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(always.y, during2.condition) annotation (Line(points={{-59,50},{-50,50},{-50,10},{-42,10}}, color={255,0,255}));
      connect(during1.y, below.property) annotation (Line(points={{1,50},{16,50}}, color={0,0,255}));
      connect(during1.margin, below.margin) annotation (Line(points={{1,42},{8,42},{8,43},{16,43}}, color={0,127,0}));
      connect(during2.y, above.property) annotation (Line(points={{1,10},{16,10}}, color={0,0,255}));
      connect(during2.y, plain.property) annotation (Line(points={{1,10},{10,10},{10,-30},{16,-30}}, color={0,0,255}));
      annotation (experiment(StopTime=35, Interval=1), Documentation(info="<html>
<p>The sine of <a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.Sine\">Sine</a> against two
requirements in <a href=\"modelica://Requirements.Verify.Requirement\">Verify.Requirement</a> blocks with
<code>computeStatistics = true</code> (tab Statistics). <code>below</code> also has <code>useMargin = true</code> and its
<code>margin</code> input connected to the check's margin; <code>above</code> has no margin; <code>plain</code> has no
statistics. Each requirement with statistics writes a <code>Statistics</code> line to the log file beside its verdict line,
and <a href=\"modelica://Requirements.Verify.PrintViolations\">PrintViolations</a> prints them in a section of its summary:</p>
<pre>
Violation statistics (2 of 3 requirements):
   RequirementLog (below): 4 violations, 13.3333 s violated in total (38.1 % of the applicable time), longest 3.33333 s from 0.833333 s, worst margin -2 at 2.5 s
   RequirementLog (above): 0 violations, 0 s violated in total (0.0 % of the applicable time), longest 0 s from 0 s
</pre>
<p>Set <code>useEvaluationTime = true</code> in <code>printViolations</code> to print in a tool without <code>terminal()</code>.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end RequirementLog;

    partial model PartialYear "A year of a room temperature against a comfort band, hourly output"
      extends Modelica.Icons.Example;
      parameter Real ripple(unit="K") = 0 "Amplitude of a 10-minute oscillation, as of a controller";
      Modelica.Blocks.Sources.RealExpression load(y=22.5 + 3*sin(2*Modelica.Constants.pi*(time - 9*3600)/86400)
          + 2.5*sin(2*Modelica.Constants.pi*(time - 105*86400)/(365*86400))
          + ripple*sin(2*Modelica.Constants.pi*time/600))
        "Temperature the room is driven to, in degC: daily swing of 3 K peaking at 15:00, seasonal swing of 2.5 K peaking in mid-July"
        annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
      Modelica.Blocks.Continuous.FirstOrder T(T=60, initType=Modelica.Blocks.Types.Init.SteadyState)
        "Room temperature in degC: the room air follows with a time constant of 60 s"
        annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
      Requirements.Sources.BooleanConstant always
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Requirements.ChecksInFixedWindow.During comfort(
        check=T.y >= 20 and T.y <= 26,
        rho=min(T.y - 20, 26 - T.y),
        scale=1) "The room temperature shall stay within 20 degC and 26 degC, tolerance 1 K"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
    equation
      connect(always.y, comfort.condition) annotation (Line(points={{-59,50},{-42,50}}, color={255,0,255}));
      connect(load.y, T.u) annotation (Line(points={{-79,20},{-72,20}}, color={0,0,127}));
      annotation (experiment(StopTime=31536000, Interval=3600), Documentation(info="<html>
<p>The plant of the year-long examples: a synthetic room temperature over a year (t = 0 is 1 January, 0:00),
22.5 &deg;C + 3 K daily (peak at 15:00) + 2.5 K seasonal (peak in mid-July), optionally with a 10-minute <code>ripple</code>,
through a first-order lag of 60 s for the room air, against <em>within 20 &deg;C and 26 &deg;C, tolerance 1 K</em>. It is
too warm on summer afternoons and too cold on winter nights. The output interval is one hour, as is usual for an annual
building simulation.</p>
<p>The lag is what a real room has, and it matters here: it gives the solver a state to control its error on. Without it
the temperature is a plain expression, the solver takes steps of up to an hour, and a 10-minute ripple's dip across a band
edge, or below the least margin so far, falls between two steps and is missed &mdash; by every event-based check, the check
block's own included. ViolationStatistics sees what the solver resolves, no more.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end PartialYear;

    model YearSmooth "A smooth year: 366 violations, 2937 h, the worst three tolerances below the band; both worst-margin methods agree"
      extends PartialYear(ripple=0);
      Requirements.Verify.ViolationStatistics continuous(T=60) "T: a thousandth of a day"
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
      Requirements.Verify.ViolationStatistics ratchet(method=Requirements.Types.WorstMarginMethod.Ratchet)
        annotation (Placement(transformation(extent={{30,0},{50,20}})));
    equation
      connect(comfort.y, continuous.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(comfort.margin, continuous.margin) annotation (Line(points={{1,42},{16,42},{16,46},{28,46}}, color={0,127,0}));
      connect(comfort.y, ratchet.property) annotation (Line(points={{1,50},{16,50},{16,14},{28,14}}, color={0,0,255}));
      connect(comfort.margin, ratchet.margin) annotation (Line(points={{1,42},{12,42},{12,6},{28,6}}, color={0,127,0}));
      when time >= 31535000 then
        assert(noEvent(abs(continuous.worstMargin + 2.99992) < 1e-4 and abs(continuous.tWorst - 1220460) < 2*continuous.T),
          "YearSmooth: the coldest instant, 17.00008 degC on 15 January at 3:01, is three tolerances below 20 degC");
        assert(noEvent(continuous.nViolations == 366 and abs(continuous.totalDuration - 10573667.39) < 1),
          "YearSmooth: 366 episodes (one at the start of the run), 10573667.39 s violated by the instant of this check");
        assert(noEvent(ratchet.worstMargin >= continuous.worstMargin - 1e-6 and ratchet.worstMargin <= continuous.worstMargin + 0.01),
          "YearSmooth: the ratchet is within its resolution of the continuous method");
        assert(noEvent(ratchet.nViolations == continuous.nViolations and abs(ratchet.totalDuration - continuous.totalDuration) < 1),
          "YearSmooth: the method changes the worst margin only");
      end when;
      annotation (experiment(StopTime=31536000, Interval=3600), Documentation(info="<html>
<p><a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.PartialYear\">PartialYear</a> without ripple into
both worst-margin methods. The band is left on both sides: on summer afternoons (up to 28 &deg;C, margin &minus;2) and on
winter nights. The worst instant is the coldest, 17.00008 &deg;C at 3:01 on 15 January (t = 1,220,460 s): margin
&minus;2.99992. The requirement is violated in 366 episodes (one at the start of the run, a winter night), 2937.1 h in all
by the check at t = 31,535,000 s; the values are those of the closed-form response of the lag, evaluated on a 1 s grid
with the crossings interpolated. The two methods agree to the ratchet's resolution, and in count and
duration exactly.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end YearSmooth;

    model YearRippleNoStatistics "A year with a 10-minute ripple, no statistics: the reference for the cost of the statistics"
      extends PartialYear(ripple=0.1);
      annotation (experiment(StopTime=31536000, Interval=3600), Documentation(info="<html>
<p><a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.PartialYear\">PartialYear</a> with a 0.1 K ripple
of 10-minute period and no statistics: the reference that the two models with statistics are timed against.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end YearRippleNoStatistics;

    model YearRippleContinuous "A year with a 10-minute ripple, continuous method: one event per local extremum of the margin"
      extends PartialYear(ripple=0.1);
      Requirements.Verify.ViolationStatistics statistics(mergeGap=1800, T=0.6)
        "Violations within 30 min of each other are one episode; T a thousandth of the ripple's period"
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
    equation
      connect(comfort.y, statistics.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(comfort.margin, statistics.margin) annotation (Line(points={{1,42},{16,42},{16,46},{28,46}}, color={0,127,0}));
      annotation (experiment(StopTime=31536000, Interval=3600), Documentation(info="<html>
<p><a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.PartialYear\">PartialYear</a> with a 0.1 K ripple
of 10-minute period into a <a href=\"modelica://Requirements.Verify.ViolationStatistics\">ViolationStatistics</a> with the
continuous method: the margin has two local extrema every 10 minutes, about 105,000 in the year, and the method fires an
event at each. <code>mergeGap</code> = 30 min keeps the ripple's repeated crossings of the band edge from counting as
separate violations.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end YearRippleContinuous;

    model YearRippleRatchet "A year with a 10-minute ripple, ratchet method: an event only at a new low"
      extends PartialYear(ripple=0.1);
      Requirements.Verify.ViolationStatistics statistics(mergeGap=1800, method=Requirements.Types.WorstMarginMethod.Ratchet)
        "Violations within 30 min of each other are one episode"
        annotation (Placement(transformation(extent={{30,40},{50,60}})));
    equation
      connect(comfort.y, statistics.property) annotation (Line(points={{1,50},{16,50},{16,54},{28,54}}, color={0,0,255}));
      connect(comfort.margin, statistics.margin) annotation (Line(points={{1,42},{16,42},{16,46},{28,46}}, color={0,127,0}));
      annotation (experiment(StopTime=31536000, Interval=3600), Documentation(info="<html>
<p>The same as <a href=\"modelica://Requirements.Examples.Elementary.ViolationStatistics.YearRippleContinuous\">YearRippleContinuous</a>
with the ratchet method: an event only when the margin falls 0.01 below its least value so far, however often it
oscillates.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end YearRippleRatchet;

    annotation (Documentation(info="<html>
<p>
Examples of <a href=\"modelica://Requirements.Verify.ViolationStatistics\">Verify.ViolationStatistics</a> and of the
statistics option of the requirement blocks. <code>Sine</code>, <code>Episodes</code> and <code>Gating</code> assert every
output against closed-form values; <code>RequirementLog</code> shows the log and the summary; the <code>Year*</code> models
run a year with hourly output, as an annual building simulation does, and measure what the two worst-margin methods cost.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end ViolationStatistics;

  package StepResponse "Library of examples asserting the step-response blocks against the closed forms of a second-order system"
    extends Modelica.Icons.ExamplesPackage;

    model SecondOrder "A 0.1 m step into a second-order system (D = 0.5, w = 5 rad/s): every metric against its closed form, every check against its verdict"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.Types.StepMetric;
      Modelica.Blocks.Sources.Step step(height=0.1, startTime=1) "the reference"
        annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
      Modelica.Blocks.Continuous.SecondOrder sys(k=1, w=5, D=0.5, initType=Modelica.Blocks.Types.Init.InitialState,
        y(nominal=0.1), yd(nominal=0.5))
        "the response; the states' nominal values scale the solver's absolute tolerance to the 0.1 m step (the owner's call)"
        annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
      Requirements.SignalAnalysis.StepResponse metrics(T_window=4) "the running metrics, the window closing 4 s after the step"
        annotation (Placement(transformation(extent={{0,40},{40,80}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck overshoot20(metric=StepMetric.Overshoot, bound=20, T_window=4, scale=1)
        "the overshoot shall be at most 20 %, tolerance 1 %: satisfied at the close by 3.70 tolerances"
        annotation (Placement(transformation(extent={{0,-10},{40,10}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck overshoot10(metric=StepMetric.Overshoot, bound=10, T_window=4, scale=1)
        "at most 10 %: violated at the first sample the excursion exceeds 10 % (1.52 s)"
        annotation (Placement(transformation(extent={{0,-40},{40,-20}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck rise(metric=StepMetric.RiseTime, bound=0.5, T_window=4, scale=0.05)
        "the 10-90 % rise time shall be at most 0.5 s: satisfied at the 90 % crossing (1.43 s)"
        annotation (Placement(transformation(extent={{0,-70},{40,-50}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck delay(metric=StepMetric.DelayTime, bound=0.3, T_window=4, scale=0.05)
        "the delay time shall be at most 0.3 s: satisfied at the 50 % crossing (1.26 s)"
        annotation (Placement(transformation(extent={{60,40},{100,60}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck settle(metric=StepMetric.SettlingTime, bound=2, band=0.02, T_window=4, scale=0.1)
        "settled to within 2 % within 2 s: satisfied at the close (the last exit at 1.615 s)"
        annotation (Placement(transformation(extent={{60,10},{100,30}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck settle1(metric=StepMetric.SettlingTime, bound=1, band=0.02, T_window=4, scale=0.1)
        "within 1 s: violated at the first sample after the deadline outside the band"
        annotation (Placement(transformation(extent={{60,-20},{100,0}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck damping(metric=StepMetric.DampingRatio, bound=0.4, T_window=4, scale=0.05)
        "the damping ratio shall be at least 0.4: 0.5 from the log decrement, satisfied at the close"
        annotation (Placement(transformation(extent={{60,-50},{100,-30}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck decay(metric=StepMetric.DecayRatio, bound=0.25, T_window=4, scale=0.05)
        "the decay ratio shall be at most 0.25: 0.0266"
        annotation (Placement(transformation(extent={{60,-80},{100,-60}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck error(metric=StepMetric.SteadyStateError, bound=1, T_window=4, scale=0.5)
        "the steady-state error 4 s after the step shall be at most 1 %"
        annotation (Placement(transformation(extent={{-50,-80},{-10,-60}})));
    equation
      connect(step.y, sys.u) annotation (Line(points={{-69,20},{-52,20}}, color={0,0,127}));
      connect(sys.y, metrics.u) annotation (Line(points={{-29,20},{-20,20},{-20,72},{-4,72}}, color={0,0,127}));
      connect(step.y, metrics.r) annotation (Line(points={{-69,20},{-60,20},{-60,60},{-4,60}}, color={0,0,127}));
      connect(sys.y, overshoot20.u); connect(step.y, overshoot20.r);
      connect(sys.y, overshoot10.u); connect(step.y, overshoot10.r);
      connect(sys.y, rise.u); connect(step.y, rise.r);
      connect(sys.y, delay.u); connect(step.y, delay.r);
      connect(sys.y, settle.u); connect(step.y, settle.r);
      connect(sys.y, settle1.u); connect(step.y, settle1.r);
      connect(sys.y, damping.u); connect(step.y, damping.r);
      connect(sys.y, decay.u); connect(step.y, decay.r);
      connect(sys.y, error.u); connect(step.y, error.r);
      when time >= 5.5 then
        // the closed forms of the second-order step response at D = 0.5, w = 5
        // The tolerances below are the solver's, not the block's: the 6000 sample events restart the
        // solver every millisecond and its accumulated error is what the sampled block sees (measured
        // 2026-09-16) -- dassl and ida reproduce the closed form to 1e-6, OpenModelica's
        // cvode reads the peak 0.2 % low at rtol 1e-6, Modelon Impact's cvode 0.3 % low at 1e-6 and
        // 0.9 % low at 1e-4 (the regression suites' comparison runs), the time metrics up to 3 ms off.
        assert(noEvent(abs(metrics.overshoot - 0.0163033) < 2.5e-4), "StepResponse: the overshoot is not 16.303 % of 0.1 m");
        assert(noEvent(abs(metrics.tPeak - 1.7255) < 0.005), "StepResponse: the peak is not at 1 + pi / (w sqrt(1 - D^2)) = 1.7255 s");
        assert(noEvent(abs(metrics.riseTime - 0.32752) < 0.005), "StepResponse: the 10-90 % rise time is not 0.3275 s");
        assert(noEvent(abs(metrics.delayTime - 0.25881) < 0.005), "StepResponse: the delay time is not 0.2588 s");
        assert(noEvent(abs(metrics.settlingTime - 1.61527) < 0.005), "StepResponse: the 2 % settling time is not 1.615 s");
        assert(noEvent(abs(metrics.zeta - 0.5) < 0.01), "StepResponse: the damping ratio from the log decrement is not 0.5");
        assert(noEvent(abs(metrics.decayRatio - 0.026580) < 0.002), "StepResponse: the decay ratio is not exp(-2 pi D / sqrt(1 - D^2))");
        assert(noEvent(overshoot20.y == Property.Satisfied and abs(overshoot20.margin - 3.6967) < 0.25), "overshoot20: satisfied by 3.70 tolerances at the close");
        assert(noEvent(overshoot10.y == Property.Violated and abs(overshoot10.margin + 6.3033) < 0.25), "overshoot10: violated by 6.30 tolerances (the margin follows the peak after the early decision)");
        assert(noEvent(rise.y == Property.Satisfied and abs(rise.margin - 3.4497) < 0.1), "rise: satisfied by 3.45 tolerances");
        assert(noEvent(delay.y == Property.Satisfied and abs(delay.margin - 0.8238) < 0.1), "delay: satisfied by 0.82 tolerances");
        assert(noEvent(settle.y == Property.Satisfied and abs(settle.margin - 3.8473) < 0.05), "settle: satisfied by 3.85 tolerances");
        assert(noEvent(settle1.y == Property.Violated and abs(settle1.margin + 6.1527) < 0.05), "settle1: violated by 6.15 tolerances");
        assert(noEvent(damping.y == Property.Satisfied and abs(damping.margin - 2.0) < 0.1), "damping: satisfied by 2 tolerances");
        assert(noEvent(decay.y == Property.Satisfied and abs(decay.margin - 4.4684) < 0.03), "decay: satisfied by 4.47 tolerances");
        assert(noEvent(error.y == Property.Satisfied and error.margin > 1.9), "error: satisfied by two tolerances");
      end when;
      when time >= 2.0 then
        assert(noEvent(overshoot10.y == Property.Violated), "overshoot10: not yet violated at 2 s (the excursion passed 10 % at 1.52 s)");
        assert(noEvent(rise.y == Property.Satisfied and delay.y == Property.Satisfied), "rise / delay: not decided at their crossings");
        assert(noEvent(overshoot20.y == Property.Undecided and settle.y == Property.Undecided), "overshoot20 / settle: decided before the window closed");
      end when;
      when time >= 3.5 then
        assert(noEvent(settle1.y == Property.Violated), "settle1: not violated after the 1 s deadline while outside the band");
      end when;
      annotation (experiment(StopTime=6, Interval=0.001), Documentation(info="<html>
<p>The textbook step response, <code>y'' + 2 D w y' + w&sup2; y = w&sup2; r</code> with r stepping 0.1 m at 1 s,
D = 0.5, w = 5 rad/s, under <a href=\"modelica://Requirements.SignalAnalysis.StepResponse\">StepResponse</a>
and one <a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">StepResponseCheck</a> per
metric, the window closing 4 s after the step. Every metric is asserted against its closed form
(the overshoot <code>exp(-D pi / sqrt(1 - D&sup2;))</code> = 16.30 %, the peak time
<code>pi / (w sqrt(1 - D&sup2;))</code>, the rise, delay and settling times by root finding on the analytic
solution, the damping ratio recovered from the log decrement, the decay ratio
<code>exp(-2 pi D / sqrt(1 - D&sup2;))</code>), and every check against its verdict and margin: the early
decisions (an overshoot bound broken at 1.52 s, a settling deadline missed, a level reached) and the
decisions at the close. The same closed-form numbers hold for an evaluation of the metrics on the stored
trajectory after the run.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end SecondOrder;

    model Disturbance "A load step with the response returning to its setpoint: the peak deviation is the overshoot, a percent bound has no base"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.Types.StepMetric;
      import Requirements.Types.StepTarget;
      Modelica.Blocks.Sources.Step load(height=-5, offset=-10, startTime=2.5) "the load torque, stepping at 2.5 s"
        annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
      Modelica.Blocks.Sources.ExpSine response(amplitude=-0.1, f=4/(2*Modelica.Constants.pi), damping=3, startTime=2.5, offset=1)
        "the speed: 1 - 0.1 exp(-3 (t - 2.5)) sin(4 (t - 2.5)) after the load step -- a dip and a damped return"
        annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
      Modelica.Blocks.Sources.Constant setpoint(k=1) "the speed setpoint"
        annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck dip(metric=StepMetric.Overshoot, boundIsPercent=false, bound=0.03, target=StepTarget.Reference, scale=0.01)
        "the deviation from the setpoint shall be at most 0.03: the dip of 0.040 violates it (the overshoot of a disturbance is the peak deviation)"
        annotation (Placement(transformation(extent={{0,40},{40,60}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck dipPercent(metric=StepMetric.Overshoot, boundIsPercent=true, bound=5, target=StepTarget.Reference, T_window=3)
        "the same in percent: no base (the speed starts and ends at the setpoint), Undefined at the close"
        annotation (Placement(transformation(extent={{0,0},{40,20}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck recovery(metric=StepMetric.SettlingTime, bound=1.5, band=0.01, bandIsFraction=false, target=StepTarget.Reference, T_window=3, scale=0.1)
        "back within 0.01 of the setpoint within 1.5 s: satisfied at the close"
        annotation (Placement(transformation(extent={{0,-40},{40,-20}})));
      Requirements.ChecksInFixedWindow.StepResponseCheck damping(metric=StepMetric.DampingRatio, bound=0.3, target=StepTarget.Reference, T_window=3, scale=0.1)
        "the damping ratio from the dip and its return"
        annotation (Placement(transformation(extent={{0,-80},{40,-60}})));
    equation
      connect(response.y, dip.u); connect(load.y, dip.r); connect(setpoint.y, dip.yRef);
      connect(response.y, dipPercent.u); connect(load.y, dipPercent.r); connect(setpoint.y, dipPercent.yRef);
      connect(response.y, recovery.u); connect(load.y, recovery.r); connect(setpoint.y, recovery.yRef);
      connect(response.y, damping.u); connect(load.y, damping.r); connect(setpoint.y, damping.yRef);
      when time >= 3.0 then
        assert(noEvent(dip.y == Property.Violated and dip.value > 0.039 and dip.value < 0.041), "dip: the peak deviation of 0.040 must violate the 0.03 bound early");
      end when;
      when time >= 5.6 then
        assert(noEvent(dipPercent.y == Property.Undefined), "dipPercent: a percent bound on a disturbance has no base and must be Undefined");
        assert(noEvent(recovery.y == Property.Satisfied and recovery.value < 1.5), "recovery: settled within 1.5 s");
        assert(noEvent(damping.y == Property.Satisfied and damping.value > 0.3 and damping.value < 1), "damping: the log decrement of the dip and its return");
      end when;
      annotation (experiment(StopTime=6, Interval=0.001), Documentation(info="<html>
<p>A disturbance step: the load steps at 2.5 s and the speed dips by 0.040 and returns to its setpoint of 1 as a
damped oscillation. With <code>target = Reference</code> the metrics are measured against the setpoint input:
the response's change over the step is zero, so the excursion is oriented by its largest deviation and the
<em>overshoot</em> is the peak deviation (0.040, violating an absolute bound of 0.03 as soon as it is passed);
a percent bound has no base and its property is Undefined; the settling time is the return to within 0.01 of the
setpoint; the damping ratio comes from the dip and the return overshoot.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end Disturbance;
    annotation (Documentation(info="<html>
<p>The step-response blocks: the running metrics of
<a href=\"modelica://Requirements.SignalAnalysis.StepResponse\">SignalAnalysis.StepResponse</a> and the
Property of <a href=\"modelica://Requirements.ChecksInFixedWindow.StepResponseCheck\">ChecksInFixedWindow.StepResponseCheck</a>,
asserted against the closed forms of a second-order step response and a disturbance.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end StepResponse;

  package LinearAnalysis "Library of examples asserting the eigenvalue blocks on a shipped second-order state matrix"
    extends Modelica.Icons.ExamplesPackage;

    model SecondOrder "The state matrix of a second-order system (w0 = 2 rad/s, D = 0.2) read from a MATLAB v4 file: every predicate against its closed form"
      extends Modelica.Icons.Example;
      import Requirements.Types.Property;
      import Requirements.Types.EigenMetric;
      parameter String fileName = "modelica://Requirements/Resources/Data/SecondOrderLinearization.mat"
        "A = [0, 1; -4, -0.8] (w0 = 2, D = 0.2): eigenvalues -0.4 +- 1.9596j, damping 0.2, 0.3183 Hz, time constant 2.5 s";
      parameter String filePath = Modelica.Utilities.Files.loadResource(fileName) "the URI resolved (folded at translation)";
      parameter Real A[2, 2](each fixed=false) "the state matrix from the file, read at initialization (an impure read cannot be evaluated when the model is translated: some tools refuse it at flattening)";
      Requirements.LinearAnalysis.EigenvalueCheck realPart(nx=2, A=A, metric=EigenMetric.RealPart, bound=-0.1, scale=0.1)
        "every real part below -0.1 1/s: satisfied, margin (0.4 - 0.1) / 0.1 = 3"
        annotation (Placement(transformation(extent={{-40,40},{0,60}})));
      Requirements.LinearAnalysis.EigenvalueCheck damping(nx=2, A=A, metric=EigenMetric.Damping, bound=0.5, scale=0.1)
        "every mode damped to at least 0.5: violated, margin (0.2 - 0.5) / 0.1 = -3"
        annotation (Placement(transformation(extent={{-40,10},{0,30}})));
      Requirements.LinearAnalysis.EigenvalueCheck frequency(nx=2, A=A, metric=EigenMetric.FrequencyMax, bound=1, fBandLo=0.1, scale=0.1)
        "every mode above 0.1 Hz at most 1 Hz: satisfied, margin (1 - 0.3183) / 0.1 = 6.817"
        annotation (Placement(transformation(extent={{-40,-20},{0,0}})));
      Requirements.LinearAnalysis.EigenvalueCheck outsideBand(nx=2, A=A, metric=EigenMetric.Damping, bound=0.5, fBandLo=10, scale=0.1)
        "no mode above 10 Hz: Undefined (untested), margin 0"
        annotation (Placement(transformation(extent={{-40,-50},{0,-30}})));
      Requirements.LinearAnalysis.EigenvalueCheck timeConstant(nx=2, A=A, metric=EigenMetric.TimeConstant, bound=3, scale=0.5)
        "the slowest mode within 3 s: satisfied (2.5 s), margin 0.5 / 0.5 = 1"
        annotation (Placement(transformation(extent={{-40,-80},{0,-60}})));
      Requirements.LinearAnalysis.EigenvaluesWithinRegion region(nx=2, A=A, polygon=[-100, -100; -0.1, -100; -0.1, 100; -100, 100], scale=0.1)
        "the half-plane Re < -0.1 as a polygon: satisfied, margin 0.3 / 0.1 = 3"
        annotation (Placement(transformation(extent={{40,40},{80,60}})));
    initial equation
      A = Requirements.LinearAnalysis.readStateMatrix(filePath, 2);
    equation
      assert(abs(A[2, 1] + 4) < 1e-12 and abs(A[2, 2] + 0.8) < 1e-12, "the file did not give A = [0, 1; -4, -0.8]");
      assert(realPart.n == 1 and abs(realPart.re[1] + 0.4) < 1e-9 and abs(realPart.im[1] - 2*sqrt(1 - 0.04)) < 1e-9, "the mode is not -0.4 + 1.9596j");
      assert(realPart.y == Property.Satisfied and abs(realPart.margin - 3) < 1e-9, "realPart: expected Satisfied with margin 3");
      assert(damping.y == Property.Violated and abs(damping.margin + 3) < 1e-9, "damping: expected Violated with margin -3");
      assert(frequency.y == Property.Satisfied and abs(frequency.margin - (1 - 1/Modelica.Constants.pi)/0.1) < 1e-9, "frequency: expected Satisfied with margin 6.817");
      assert(outsideBand.y == Property.Undefined and abs(outsideBand.margin) < 1e-12, "outsideBand: expected Undefined");
      assert(timeConstant.y == Property.Satisfied and abs(timeConstant.margin - 1) < 1e-9, "timeConstant: expected Satisfied with margin 1");
      assert(region.y == Property.Satisfied and abs(region.margin - 3) < 1e-9, "region: expected Satisfied with margin 3");
      annotation (experiment(StopTime=1), Documentation(info="<html>
<p>The eigenvalue blocks of <a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a> on a state
matrix read from a shipped MATLAB v4 file (<code>Resources/Data/SecondOrderLinearization.mat</code>, a matrix named <code>A</code> in MATLAB v4 format,
the layout <a href=\"modelica://Requirements.LinearAnalysis\">LinearAnalysis</a> describes): the second-order system with
<code>w0 = 2 rad/s</code> and <code>D = 0.2</code>, whose mode is <code>-0.4 &plusmn; 1.9596j</code> --
damping 0.2, 0.3183 Hz, a 2.5 s time constant. Every block's <code>Property</code> and <code>margin</code> is
asserted against the closed form, including the Undefined of an empty band. To check a plant of your own, linearize it in your
Modelica tool, write its A matrix to such a file, and point <code>readStateMatrix</code> at it.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end SecondOrder;

    annotation (Documentation(info="<html>
<p>The eigenvalue blocks asserted on a shipped state matrix.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end LinearAnalysis;
  annotation (Documentation(info="<html>
<p>
This package contains example models to demonstrate all components of library
Requirements. Every example demonstrates usually <b>one</b> component, in order
to understand the fine details of this component. <b>Every</b> component of library
Requirements is used at least once in one of the examples of package Elementary.
Using the Requirements components in applications is performed
in the other packages of the Examples package.
</p>
</html>"));
end Elementary;
