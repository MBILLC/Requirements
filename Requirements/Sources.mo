within Requirements;
package Sources
  "Library of signal source blocks generating Real, Integer, Boolean and Property signals"
  block RealConstant "Output y is a Real parameter"
    extends Requirements.Interfaces.PartialConstant;

    parameter Real c=0.0 "Fixed Real output value";
    Modelica.Blocks.Interfaces.RealOutput y "Value of Real output"
                                annotation (Placement(transformation(
            extent={{100,-10},{120,10}}, rotation=0), iconTransformation(extent={{100,-10},
              {120,10}})));
  equation
    y = c;
    annotation(defaultComponentName="const1",
        Icon(graphics={
          Text(
            extent={{-90,-15},{90,15}},
            lineColor={0,0,0},
            textString="%c")}),
  Documentation(info="<html>
<p>
Output y is the Real constant <b>c</b> defined in the parameter menu.
</p>

<p>
Alternatively component <a href=\"modelica://Requirements.Sources.RealExpression\">RealExpression</a>
could be used to define a constant. The advantage of RealConstant is that a literal value
given as parameter can still be changed after model translation which is not the case for a
literal value defined with RealExpression.
</p>
</html>"));
  end RealConstant;
  extends Modelica.Icons.Package;

  block IntegerConstant "Output y is an Integer parameter"
    extends Requirements.Interfaces.PartialConstant;

    parameter Integer c=0 "Fixed Integer output value";
    Modelica.Blocks.Interfaces.IntegerOutput y "Value of Integer output"
                                annotation (Placement(transformation(
            extent={{100,-10},{120,10}}, rotation=0), iconTransformation(extent={{100,-10},
              {120,10}})));
  equation
    y = c;
    annotation(defaultComponentName="const1",
        Icon(graphics={
          Text(
            extent={{-90,-15},{90,15}},
            lineColor={0,0,0},
            textString="%c")}),
  Documentation(info="<html>
<p>
Output y is the Integer constant <b>c</b> defined in the parameter menu.
</p>

<p>
Alternatively component <a href=\"modelica://Requirements.Sources.IntegerExpression\">IntegerExpression</a>
could be used to define a constant. The advantage of IntegerConstant is that a literal value
given as parameter can still be changed after model translation which is not the case for a
literal value defined with IntegerExpression.
</p>
</html>"));
  end IntegerConstant;

  block BooleanConstant "Output y is a Boolean parameter"
    extends Requirements.Interfaces.PartialConstant;

    parameter Boolean c=true "Fixed Boolean output value" annotation(choices(checkBox=true));
    Modelica.Blocks.Interfaces.BooleanOutput y
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = c;
    annotation (defaultComponentName="const1",
        Icon(graphics={
          Text(
            extent={{-90,-15},{90,15}},
            lineColor={0,0,0},
            textString="%c")}),
        Documentation(info="<html>
<p>
Output y is the Boolean constant <b>c</b> defined in the parameter menu.
</p>

<p>
Alternatively component <a href=\"modelica://Requirements.Sources.BooleanExpression\">BooleanExpression</a>
could be used to define a constant. The advantage of BooleanConstant is that a literal value
given as parameter can still be changed after model translation which is not the case for a
literal value defined with BooleanExpression.
</p>
</html>"));
  end BooleanConstant;

  block PropertyConstant "Output y is a Property parameter"
    extends Requirements.Interfaces.PartialConstant;

    parameter Requirements.Types.Property c=Requirements.Types.Property.Satisfied
      "Fixed Property output value"
      annotation(Dialog(__Dymola_compact=true, __Dymola_descriptionLabel = true),
                          choices(choice=Requirements.Types.Property.Violated
          "Violated",     choice=Requirements.Types.Property.Undecided
          "Undecided",    choice=Requirements.Types.Property.Satisfied
          "Satisfied",    choice=Requirements.Types.Property.Undefined
          "Undefined",    __Dymola_radioButtons=true));
    Requirements.Interfaces.PropertyOutput y
      "Constant Property output value"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = c;
    annotation (
    defaultComponentName="const1",
        Icon(graphics={
          Text(
            extent={{-90,-15},{90,15}},
            lineColor={0,0,0},
            textString="%c")}),
        Documentation(info="<html>
<p>
Output y is the <a href=\"modelica://Requirements.Types.Property\">Property</a>
constant <b>c</b> defined in the parameter menu.
</p>
</html>"));
  end PropertyConstant;

  block RealExpression "Output y is a (time-varying) Real expression"
    extends Requirements.Interfaces.PartialExpression;

    Modelica.Blocks.Interfaces.RealOutput y = 0.0 "Value of Real output"
                                annotation (Dialog,  Placement(transformation(
            extent={{200,-10},{220,10}}, rotation=0), iconTransformation(extent={{200,-10},
              {220,10}})));

    annotation(defaultComponentName="expr1",
        Icon(graphics={
          Text(
            extent={{-190,-15},{190,15}},
            lineColor={0,0,0},
            textString="%y")}),
  Documentation(info="<html>
<p>
Output y is defined as an arbitrary (time-varying) Real expression
in the parameter menu.
</p>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
              100}}), graphics));
  end RealExpression;

  block IntegerExpression "Output y is a (time-varying) Integer expression"
    extends Requirements.Interfaces.PartialExpression;

    Modelica.Blocks.Interfaces.IntegerOutput y = 0 "Value of Integer output"
                                annotation (Dialog,  Placement(transformation(
            extent={{200,-10},{220,10}}, rotation=0)));

    annotation(defaultComponentName="expr1",
        Icon(graphics={
          Text(
            extent={{-190,-15},{190,15}},
            lineColor={0,0,0},
            textString="%y")}),
                           Documentation(info="<html>
<p>
Output y is defined as an arbitrary (time-varying) Integer expression
in the parameter menu.
</p>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
              100}}), graphics));
  end IntegerExpression;

  block BooleanExpression "Output y is a (time-varying) Boolean expression"
    extends Requirements.Interfaces.PartialExpression;

    Modelica.Blocks.Interfaces.BooleanOutput y = false
      "Value of Boolean output" annotation (Dialog,  Placement(transformation(
            extent={{200,-10},{220,10}}, rotation=0)));

    annotation(defaultComponentName="expr1",
        Icon(graphics={
          Text(
            extent={{-190,-15},{190,15}},
            lineColor={0,0,0},
            textString="%y")}),
  Documentation(info="<html>
<p>
Output y is defined as an arbitrary (time-varying) Boolean expression
in the parameter menu.
</p>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
              200,100}}), graphics));
  end BooleanExpression;

  block PropertyTable
    "Output y is a Property signal computed by constant interpolation in a table matrix with [time, property] values"
    parameter Real table[:, 2]=fill(
          0,
          0,
          2)
      "Table matrix (first column time; second column y as Integer: =1 (Violated), =2 (Undecided), =3 (Satisfied), =4 (Undefined))";

    Requirements.Interfaces.PropertyOutput y
      "Constantly interpolated table value"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Sources.IntegerTable integerTable(table=table)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    LogicalBlocks.IntegerToProperty ItoP "Transform Integer to Property"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  equation
    connect(integerTable.y, ItoP.u) annotation (Line(
        points={{11,0},{23,0}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(ItoP.y, y) annotation (Line(
        points={{36,0},{110,0}},
        color={255,0,128},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
                                             Rectangle(
              extent={{-100,-100},{100,100}},
              lineColor={255,0,128},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-150,150},{150,110}},
              textString="%name",
              lineColor={0,0,255}),
          Line(points={{-80,64},{-80,-84}}, color={192,192,192}),
          Polygon(
            points={{-80,86},{-88,64},{-72,64},{-80,86}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,-74},{82,-74}}, color={192,192,192}),
          Polygon(
            points={{90,-74},{68,-66},{68,-82},{90,-74}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-46,68},{4,-52}},
            lineColor={255,255,255},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-46,-52},{-46,68},{54,68},{54,-52},{-46,-52},{-46,-22},{54,
                -22},{54,8},{-46,8},{-46,38},{54,38},{54,68},{4,68},{4,-53}},
              color={0,0,0})}));
  end PropertyTable;

  partial block PartialSignalsFromFile
    "Base of a reader of a MA-HS-CSV file: the extending block names the columns and declares one output per column"
    parameter String fileName "MA-HS-CSV file: an absolute path, or a modelica:// URI"
      annotation(Dialog(loadSelector(filter="MA-HS-CSV files (*.csv)", caption="Open MA-HS-CSV file")));
    parameter Boolean extrapolateHold = true
      "= true: hold the first/last row outside the file's time range; = false: error";
  protected
    parameter String realNames[:] = fill("", 0) "Header names of the columns read as Real, set by the extending block";
    parameter String booleanNames[:] = fill("", 0) "Header names of the columns read as Boolean, set by the extending block";
    parameter String integerNames[:] = fill("", 0) "Header names of the columns read as Integer, set by the extending block";
    parameter String fileNameResolved = Modelica.Utilities.Files.loadResource(fileName) "fileName with a modelica:// URI resolved";
    parameter Requirements.Internal.CSV.File file = Requirements.Internal.CSV.File(
      fileNameResolved, realNames, booleanNames, integerNames, extrapolateHold) "The file, read once";
    discrete Real nextTimeEvent(start=0, fixed=true) "Next instant at which a column of the file changes";
    Real clock(fixed=false) "time as a state, so that fileEvent is a state event";
    Boolean fileEvent = clock >= pre(nextTimeEvent)
      "The file's next event is due: the condition of every when-clause that reads the file";
  initial equation
    clock = time;
  equation
    der(clock) = 1;
    when {fileEvent, initial()} then
      nextTimeEvent = Requirements.Internal.CSV.nextTimeEvent(file, time);
    end when;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid),
          Text(extent={{-150,150},{150,110}}, textString="%name", lineColor={0,0,255}),
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}}, lineColor={192,192,192}, fillColor={192,192,192}, fillPattern=FillPattern.Solid),
          Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
          Polygon(points={{90,-70},{68,-62},{68,-78},{90,-70}}, lineColor={192,192,192}, fillColor={192,192,192}, fillPattern=FillPattern.Solid),
          Line(points={{-80,-20},{-40,-20},{-40,40},{0,40},{0,-10},{40,-10},{40,20},{70,20}}, color={0,0,127}),
          Line(points={{-80,-50},{-50,-50},{-50,-50},{-10,10},{30,-40},{70,-40}}, color={0,127,0}),
          Text(extent={{-96,-72},{96,-96}}, lineColor={0,0,0}, textString="%fileName")}),
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
<b>block</b> MyReader
  <b>extends</b> Requirements.Sources.PartialSignalsFromFile(
    <b>final</b> realNames    = {\"T_cabin\", \"p_cabin\"},
    <b>final</b> booleanNames = {\"packOn\"},
    <b>final</b> integerNames = {\"flightPhase\"});
  Modelica.Blocks.Interfaces.RealOutput    T_cabin = Requirements.Internal.CSV.getReal(file, 1, time, nextTimeEvent, <b>pre</b>(nextTimeEvent));
  Modelica.Blocks.Interfaces.RealOutput    p_cabin = Requirements.Internal.CSV.getReal(file, 2, time, nextTimeEvent, <b>pre</b>(nextTimeEvent));
  Modelica.Blocks.Interfaces.BooleanOutput packOn;
  Modelica.Blocks.Interfaces.IntegerOutput flightPhase;
<b>equation</b>
  <b>when</b> {fileEvent, <b>initial</b>()} <b>then</b>
    packOn      = Requirements.Internal.CSV.getBoolean(file, 1, time, nextTimeEvent, <b>pre</b>(nextTimeEvent));
    flightPhase = Requirements.Internal.CSV.getInteger(file, 1, time, nextTimeEvent, <b>pre</b>(nextTimeEvent));
  <b>end when</b>;
<b>end</b> MyReader;

MyReader reader(fileName=\"modelica://MyLibrary/Resources/Data/run1.csv\");
</pre></blockquote>

<h4>Description</h4>
<p>
Reads a file in the Modelica Association's
<a href=\"https://github.com/modelica/ma-hs-csv\">MA-HS-CSV</a> format (beta, 2026): RFC 4180 records,
a header row of unique column names, the first column the independent variable (time) with non-decreasing values,
<b>consecutive rows with the same time representing an event</b> (the rows carry the values before and after it),
fields containing a space, a comma, a double quote or a line break enclosed in double quotes (<code>\"\"</code> for a quote),
values in XML-Schema lexical form: <code>Float64</code> as decimal or scientific notation, <code>NaN</code>, <code>INF</code>, <code>-INF</code>;
<code>Boolean</code> as <code>true</code>/<code>false</code>/<code>1</code>/<code>0</code>; integers as decimals. LF or CR&nbsp;LF line breaks, UTF-8 (a byte-order mark is skipped).
The file carries no type row: <b>the extending block decides the type of every column it reads</b> through the three name lists,
and declares one output per column, so the reader reads in a diagram like any block with named outputs:
Real outputs as declaration equations (they are continuous-time), Boolean and Integer outputs assigned in a when-clause with the
same trigger as the block's own, <code>when {fileEvent, initial()}</code>, because a discrete signal may only change
at an event and this is the event at which the file's Boolean and Integer columns change (the pattern of
<a href=\"modelica://Modelica.Blocks.Sources.BooleanTable\">BooleanTable</a>).
<code>fileEvent</code> is <code>clock &gt;= pre(nextTimeEvent)</code> with <code>clock</code> a state equal to <code>time</code>:
a state event, located by the integrator. The obvious <code>time &gt;= pre(nextTimeEvent)</code> is a time event, and a time
event due a few ulps after another event of the model (a timer started at an event of the file, due at the instant a later
row of the file was written, from a time that differs in the last digits) is dropped by OCT as already past and never
retried: the reader would hold every Boolean and Integer column for the rest of the run (version 0.13.1).
Columns not named are skipped. A name that is not in the header, or a header name that appears twice, is an error when the file is opened
(at initialization), not a silent zero. Arrays (space-separated fields) are not supported; a numeric field containing a space is an error.
</p>

<h4>Value semantics</h4>
<ul>
<li><b>Real</b> columns are linear between rows; at a group of rows with the same time the value jumps at that instant
    from the group's first row to its last row.</li>
<li><b>Boolean</b> and <b>Integer</b> columns are piecewise constant: the value of the last row whose time is &le; <code>time</code>,
    stepping at the row's time.</li>
<li><b>Events</b>: the block schedules a time event at every instant at which a Boolean or Integer column changes, or at which
    any read column changes inside a same-time group, so <code>edge()</code> and <code>change()</code> downstream fire at the file's
    event instants. The value functions take the event bracket <code>(nextTimeEvent, pre(nextTimeEvent))</code>, as
    <a href=\"modelica://Modelica.Blocks.Sources.CombiTimeTable\">CombiTimeTable</a> does, so the value on either side of an event is
    unambiguous during event iteration: before the when-clause has fired at the event instant the left value applies
    (a Real: the group's first row; a Boolean/Integer: the last row before the group), afterwards the right value.</li>
<li><b>Groups</b>: rows whose times are within a relative 1e-10 of the first row of their group (equal, or a few ulps apart, as a
    simulator's result can hold) are one instant at that row's time. Two time events that close would be one the tool cannot
    schedule: the second would be dropped as already past, and the Boolean and Integer outputs would never change again.</li>
<li>Outside the file's time range the first/last row is held (<code>extrapolateHold=true</code>, the default), or an error is raised.</li>
</ul>

<p>
<code>fileName</code> may be a <code>modelica://</code> URI (resolved with
<a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>) or an absolute path. The C reader
(<code>Resources/Include/RequirementsCsv.h</code>, header-only) is compiled with the model; see
<a href=\"modelica://Requirements.Internal.CSV\">Internal.CSV</a>. For an example see
<a href=\"modelica://Requirements.Examples.Elementary.Sources.SignalsFromFile\">Examples.Elementary.Sources.SignalsFromFile</a>.
</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> First version (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end PartialSignalsFromFile;

  annotation (Icon(graphics={Line(
          points={{-76,0},{82,0}},
          color={135,135,135},
          smooth=Smooth.None,
          thickness=0.5),      Polygon(
          points={{82,0},{8,40},{8,-36},{82,0}},
          lineColor={135,135,135},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}));
end Sources;
