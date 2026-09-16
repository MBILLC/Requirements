within Requirements;
package LinearAnalysis "Eigenvalue predicates over a state matrix read from a file: the Modelica side of ModCheck's linear-analysis requirements (plan section 22.7)"
  extends Modelica.Icons.Package;

  impure function readStateMatrix "The A matrix of a linearisation from a MATLAB v4 file (as ModCheck's run_requirements.py writes it beside the .npz)"
    extends Modelica.Icons.Function;
    input String filePath "The file's path -- a modelica:// URI resolved by the caller (parameter String filePath = Modelica.Utilities.Files.loadResource(fileName)), so that the compiler folds the URI and leaves this impure read to initialization";
    input Integer nx "The number of states (the matrix is nx x nx; the caller knows it, the file's own size is not a structural parameter)";
    input String matrixName = "A" "The matrix's name in the file";
    output Real A[nx, nx] "The state matrix";
  algorithm
    A := Modelica.Utilities.Streams.readRealMatrix(filePath, matrixName, nx, nx);
    annotation(Documentation(info="<html>
<p><code>Modelica.Utilities.Streams.readRealMatrix</code> on the MATLAB v4 file ModCheck's orchestrator writes
for every linearisation (<code>lin/&lt;TC&gt;.mat</code>: <code>A</code>, <code>B</code>, <code>C</code>,
<code>D</code>, the operating point). v4 is the format every tool's ModelicaIO reads without a compression
library. The number of states is an input, not read from the file: an array dimension must be a
structural parameter, and the generated check model takes it as a modifier from the orchestrator. The
path is the caller's <code>loadResource</code> of the URI, in a parameter of its own: Optimica (OCT)
folds <code>loadResource</code> at translation and refuses to evaluate an impure function that calls it
there, while the read itself must happen at initialization (the matrix is a parameter with
<code>fixed = false</code> and an initial equation).</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end readStateMatrix;

  function modes "The modes of a state matrix: its eigenvalues with conjugate pairs folded into their Im >= 0 member, the integrator rule and the parasitic cut applied, sorted by magnitude"
    extends Modelica.Icons.Function;
    input Real A[:, size(A, 1)] "The state matrix";
    input Real tauSlow = 0 "The slowest expected time constant [s]: a mode with |Re| < 1/tauSlow is an integrator (Re := 0); 0 = the roundoff rule alone";
    input Real tauFast = 0 "The fastest expected time constant [s]: a mode with |lambda| > 1/tauFast is parasitic and left out; 0 = none";
    output Real re[size(A, 1)] "Real parts of the modes kept (entries beyond n unused)";
    output Real im[size(A, 1)] "Imaginary parts (>= 0) of the modes kept";
    output Integer n "The number of modes kept";
  protected
    Real evRe[size(A, 1)];
    Real evIm[size(A, 1)];
    Real evec[size(A, 1), size(A, 1)];
    Integer info;
    Real eps;
    Real slowEps;
    Real fastLim;
    Real mag[size(A, 1)];
    Real r;
    Real i;
    Integer k;
    Integer j;
    Real tr;
    Real ti;
    Real tm;
  algorithm
    n := 0;
    if size(A, 1) == 0 then
      return;
    end if;
    // LAPACK dgeev directly (Modelica.Math.Matrices.eigenValues wraps it with a slice
    // assignment OpenModelica 1.27 cannot generate code for in a parameter context)
    (evRe, evIm, evec, info) := Modelica.Math.Matrices.LAPACK.dgeev(A);
    assert(info == 0, "LinearAnalysis.modes: LAPACK dgeev failed (info = " + String(info) + ")");
    eps := 0;
    for k in 1:size(A, 1) loop
      eps := max(eps, sqrt(evRe[k]^2 + evIm[k]^2));
    end for;
    eps := 1e-12*max(1, eps);
    // if-statements, not if-expressions: a tool may evaluate both branches of an expression and divide by zero
    slowEps := eps;
    if tauSlow > 0 then
      slowEps := max(eps, 1/tauSlow);
    end if;
    fastLim := Modelica.Constants.inf;
    if tauFast > 0 then
      fastLim := 1/tauFast;
    end if;
    for k in 1:size(A, 1) loop
      r := evRe[k];
      i := evIm[k];
      if abs(i) <= eps then
        i := 0;
      end if;
      if i < 0 then
        // the conjugate carries the pair
      elseif sqrt(r^2 + i^2) > fastLim then
        // parasitic: outside the expected range
      else
        if abs(r) <= slowEps then
          r := 0;
        end if;
        n := n + 1;
        re[n] := r;
        im[n] := i;
        mag[n] := sqrt(r^2 + i^2);
      end if;
    end for;
    // sort by magnitude, the slowest first (insertion sort: n is small)
    for k in 2:n loop
      j := k;
      while j > 1 and mag[j - 1] > mag[j] loop
        tr := re[j]; re[j] := re[j - 1]; re[j - 1] := tr;
        ti := im[j]; im[j] := im[j - 1]; im[j - 1] := ti;
        tm := mag[j]; mag[j] := mag[j - 1]; mag[j - 1] := tm;
        j := j - 1;
      end while;
    end for;
    for k in n + 1:size(A, 1) loop
      re[k] := 0;
      im[k] := 0;
    end for;
    annotation(Documentation(info="<html>
<p>The modes of <code>A</code> as ModCheck's <code>linear_checks.modes_of</code> defines them (plan section 22.2):
LAPACK's <code>dgeev</code> (what <code>Modelica.Math.Matrices.eigenValues</code> wraps), a complex pair folded into one mode represented by
its <code>Im &ge; 0</code> member, an imaginary or real part below <code>1e-12</code> of the largest eigenvalue's
magnitude taken as zero, the integrator rule of <code>tauSlow</code> (a mode slower than the plant's slowest
expected time constant is an integrator, its real part zero) and the parasitic cut of <code>tauFast</code> (a
mode faster than the fastest expected one is left out), sorted by magnitude with the slowest first. The
damping ratio of a mode is <code>-Re/|&lambda;|</code> (1 for a real non-positive eigenvalue), its frequency
<code>|&lambda;|/2&pi;</code>, its time constant <code>-1/Re</code> where it decays.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end modes;

  block EigenvalueCheck "One eigenvalue predicate over every mode of a state matrix (optionally in a frequency band): Property and margin, constant over the run"
    import Requirements.Types.Property;
    import Requirements.Types.EigenMetric;
    parameter Integer nx(min=0) "The number of states: the size of A (a plain parameter, so that A itself need not be evaluated when the model is translated -- OCT refuses to evaluate the impure file read at flattening)";
    parameter Real A[nx, nx] "The state matrix (readStateMatrix on the linearisation file)";
    parameter EigenMetric metric "The predicate";
    parameter Real bound "The bound: a real part [1/s] the modes stay below, a damping ratio [1] they reach, a frequency [Hz] they reach or stay below, a time constant [s] the slowest stays below";
    parameter Real fBandLo = 0 "The band's lower frequency [Hz] (0 = none): only the modes with a frequency above it are checked";
    parameter Real fBandHi = 0 "The band's upper frequency [Hz] (0 = none): only the modes with a frequency below it are checked";
    parameter Real tauSlow = 0 "The slowest expected time constant [s] (the integrator rule); 0 = roundoff";
    parameter Real tauFast = 0 "The fastest expected time constant [s] (the parasitic cut); 0 = none";
    parameter Real scale(min=Modelica.Constants.eps) = 1 "Scale of the margin: margin = robustness/scale, the requirement's tolerance in the metric's unit";
    final parameter Real re[nx] = modesRe "Real parts of the modes kept";
    final parameter Real im[nx] = modesIm "Imaginary parts of the modes kept";
    final parameter Integer n = modesN "The number of modes kept";
    final parameter Property p[nx] = propertyPerMode(metric, bound, fBandLo, fBandHi, re, im, n) "The property per mode (Undefined outside the band and beyond n)";
    final parameter Real m[nx] = marginPerMode(metric, bound, fBandLo, fBandHi, re, im, n) "The raw margin per mode (-inf for a non-decaying mode against a time constant)";
    final parameter Property yFixed = Requirements.LogicalFunctions.and4All(p) "The fold over the modes";
    final parameter Real marginFixed = worstMargin(p, m)/scale "The least margin over the decided modes (-inf when a violated mode has none)";
    Requirements.Interfaces.PropertyOutput y "Property output signal: the fold over the modes, constant"
      annotation (Placement(transformation(extent={{200,-10},{220,10}})));
    Requirements.Interfaces.MarginOutput margin "Normalized margin: the least over the modes, constant"
      annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  protected
    parameter Real modesRe[nx](each fixed=false);
    parameter Real modesIm[nx](each fixed=false);
    parameter Integer modesN(fixed=false);
  initial equation
    (modesRe, modesIm, modesN) = modes(A, tauSlow, tauFast);
  equation
    y = yFixed;
    margin = marginFixed;
    annotation (defaultComponentName="eigen",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}), graphics={
          Rectangle(extent={{-200,100},{200,-100}}, lineColor={0,0,0}, lineThickness=5.0, fillColor={210,210,210}, fillPattern=FillPattern.Solid, borderPattern=BorderPattern.Raised),
          Text(extent={{-180,60},{180,-60}}, textString="eig(A)", textColor={0,0,0})}),
      Documentation(info="<html>
<p>One predicate of ModCheck's eigenvalue family (plan section 22.2) over the modes of a state matrix
read from a linearisation file, evaluated once on parameters and emitted as a constant
<code>Property</code> and <code>margin</code> -- the R3 cross-check of a requirement whose reported
verdict is <code>linear_checks.py</code> on the same matrix:</p>
<ul>
<li><code>RealPart</code>: every mode's real part below <code>bound</code> [1/s]; margin <code>bound - Re</code>.</li>
<li><code>Damping</code>: every mode's damping ratio <code>-Re/|&lambda;|</code> at least <code>bound</code>; margin the difference.</li>
<li><code>FrequencyMin</code> / <code>FrequencyMax</code>: every mode's frequency <code>|&lambda;|/2&pi;</code> [Hz] at least / at most <code>bound</code>.</li>
<li><code>TimeConstant</code>: every decaying mode's <code>-1/Re</code> [s] at most <code>bound</code>; a non-decaying mode
violates it with no finite margin (<code>-inf</code>).</li>
</ul>
<p>A band (<code>fBandLo</code>, <code>fBandHi</code>) selects the modes by frequency, the others being
Undefined; no mode in the band leaves the fold Undefined (untested). The fold over the modes is
<code>and4All</code>, the margin the least over the decided modes. <code>tauSlow</code> and <code>tauFast</code>
are the test case's TIME_CONSTANTS.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end EigenvalueCheck;

  block EigenvaluesWithinRegion "Every mode of a state matrix inside a polygon of the (Re, Im) plane: Property and margin, constant over the run"
    import Requirements.Types.Property;
    parameter Integer nx(min=0) "The number of states: the size of A (a plain parameter, as in EigenvalueCheck)";
    parameter Real A[nx, nx] "The state matrix (readStateMatrix on the linearisation file)";
    parameter Real polygon[:, 2] "The region's vertices (Re [1/s], Im [rad/s])";
    parameter Real tauSlow = 0 "The slowest expected time constant [s] (the integrator rule); 0 = roundoff";
    parameter Real tauFast = 0 "The fastest expected time constant [s] (the parasitic cut); 0 = none";
    parameter Real scale(min=Modelica.Constants.eps) = 1 "Scale of the margin: margin = robustness/scale, the requirement's tolerance in 1/s";
    final parameter Real re[nx] = modesRe;
    final parameter Real im[nx] = modesIm;
    final parameter Integer n = modesN;
    final parameter Real m[nx] = regionMargins(polygon, re, im, n) "The signed distance to the polygon per mode (the least of the mode and its conjugate)";
    final parameter Property p[nx] = {if k <= n then (if m[k] >= 0 then Property.Satisfied else Property.Violated) else Property.Undefined for k in 1:nx};
    final parameter Property yFixed = Requirements.LogicalFunctions.and4All(p);
    final parameter Real marginFixed = worstMargin(p, m)/scale;
    Requirements.Interfaces.PropertyOutput y "Property output signal: the fold over the modes, constant"
      annotation (Placement(transformation(extent={{200,-10},{220,10}})));
    Requirements.Interfaces.MarginOutput margin "Normalized margin: the least signed distance over the modes, constant"
      annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  protected
    parameter Real modesRe[nx](each fixed=false);
    parameter Real modesIm[nx](each fixed=false);
    parameter Integer modesN(fixed=false);
  initial equation
    (modesRe, modesIm, modesN) = modes(A, tauSlow, tauFast);
  equation
    y = yFixed;
    margin = marginFixed;
    annotation (defaultComponentName="region",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}), graphics={
          Rectangle(extent={{-200,100},{200,-100}}, lineColor={0,0,0}, lineThickness=5.0, fillColor={210,210,210}, fillPattern=FillPattern.Solid, borderPattern=BorderPattern.Raised),
          Text(extent={{-180,60},{180,-60}}, textString="eig(A) in D", textColor={0,0,0})}),
      Documentation(info="<html>
<p>The pole-region predicate of ModCheck's eigenvalue family (plan section 22.2): every mode of the state
matrix inside the polygon, the margin the least signed distance of any mode (or its conjugate) to it --
<a href=\"modelica://Requirements.Utilities.distancePointToPolygon\">Utilities.distancePointToPolygon</a>,
positive inside -- over the requirement's scale. Evaluated once on parameters, constant over the run; the
R3 cross-check of <code>linear_checks.py</code>'s region distance.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end EigenvaluesWithinRegion;

  function propertyPerMode "The property of one eigenvalue predicate per mode (Undefined outside the band)"
    extends Modelica.Icons.Function;
    import Requirements.Types.Property;
    import Requirements.Types.EigenMetric;
    input EigenMetric metric;
    input Real bound;
    input Real fBandLo;
    input Real fBandHi;
    input Real re[:];
    input Real im[size(re, 1)];
    input Integer n;
    output Property p[size(re, 1)];
  protected
    Real f;
    Real mag;
    Real zeta;
    Boolean holds;
  algorithm
    for k in 1:size(re, 1) loop
      p[k] := Property.Undefined;
      if k <= n then
        mag := sqrt(re[k]^2 + im[k]^2);
        f := mag/(2*Modelica.Constants.pi);
        if (fBandLo <= 0 or f > fBandLo) and (fBandHi <= 0 or f < fBandHi) then
          zeta := if mag > 0 then -re[k]/mag else 1;
          if metric == EigenMetric.RealPart then
            holds := re[k] < bound;
          elseif metric == EigenMetric.Damping then
            holds := zeta >= bound;
          elseif metric == EigenMetric.FrequencyMin then
            holds := f >= bound;
          elseif metric == EigenMetric.FrequencyMax then
            holds := f <= bound;
          elseif re[k] < 0 then
            holds := -1/re[k] <= bound;
          else
            holds := false;   // a non-decaying mode has no time constant
          end if;
          p[k] := if holds then Property.Satisfied else Property.Violated;
        end if;
      end if;
    end for;
    annotation(Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
  end propertyPerMode;

  function marginPerMode "The raw margin of one eigenvalue predicate per mode (0 outside the band, -inf for a non-decaying mode against a time constant)"
    extends Modelica.Icons.Function;
    import Requirements.Types.EigenMetric;
    input EigenMetric metric;
    input Real bound;
    input Real fBandLo;
    input Real fBandHi;
    input Real re[:];
    input Real im[size(re, 1)];
    input Integer n;
    output Real m[size(re, 1)];
  protected
    Real f;
    Real mag;
    Real zeta;
  algorithm
    for k in 1:size(re, 1) loop
      m[k] := 0;
      if k <= n then
        mag := sqrt(re[k]^2 + im[k]^2);
        f := mag/(2*Modelica.Constants.pi);
        if (fBandLo <= 0 or f > fBandLo) and (fBandHi <= 0 or f < fBandHi) then
          zeta := if mag > 0 then -re[k]/mag else 1;
          if metric == EigenMetric.RealPart then
            m[k] := bound - re[k];
          elseif metric == EigenMetric.Damping then
            m[k] := zeta - bound;
          elseif metric == EigenMetric.FrequencyMin then
            m[k] := f - bound;
          elseif metric == EigenMetric.FrequencyMax then
            m[k] := bound - f;
          elseif re[k] < 0 then
            m[k] := bound + 1/re[k];
          else
            m[k] := -Modelica.Constants.inf;   // no time constant, no finite margin (the division is guarded: a tool may evaluate both branches of an if-expression)
          end if;
        end if;
      end if;
    end for;
    annotation(Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
  end marginPerMode;

  function regionMargins "The signed distance of every mode (and its conjugate) to a polygon, positive inside"
    extends Modelica.Icons.Function;
    input Real polygon[:, 2];
    input Real re[:];
    input Real im[size(re, 1)];
    input Integer n;
    output Real m[size(re, 1)];
  algorithm
    for k in 1:size(re, 1) loop
      m[k] := if k <= n then min(Requirements.Utilities.distancePointToPolygon(polygon, {re[k], im[k]}),
                                 Requirements.Utilities.distancePointToPolygon(polygon, {re[k], -im[k]})) else 0;
    end for;
    annotation(Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
  end regionMargins;

  function worstMargin "The least margin over the decided modes (-inf where a violated mode has none, 0 when no mode is decided)"
    extends Modelica.Icons.Function;
    import Requirements.Types.Property;
    input Property p[:];
    input Real m[size(p, 1)];
    output Real worst;
  protected
    Boolean any;
  algorithm
    worst := 0;
    any := false;
    for k in 1:size(p, 1) loop
      if p[k] == Property.Satisfied or p[k] == Property.Violated then
        worst := if any then min(worst, m[k]) else m[k];
        any := true;
      end if;
    end for;
    annotation(Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
  end worstMargin;

  annotation (Documentation(info="<html>
<p>The Modelica side of ModCheck's linear-analysis requirements (its requirements plan, section 22.7):
a linearisation is a tool operation, not a simulation, so no check model can compute a plant's eigenvalues
inside the run that produces them. What Modelica can do is read the matrices from the file the orchestrator
wrote (<code>readStateMatrix</code>, MATLAB v4 through <code>Modelica.Utilities.Streams.readRealMatrix</code>),
take the eigenvalues (LAPACK's <code>dgeev</code>, as <code>Modelica.Math.Matrices.eigenValues</code> does) and evaluate the predicates of the
eigenvalue family as constants -- <code>EigenvalueCheck</code> (a real-part, damping, frequency or
time-constant bound over every mode, optionally in a frequency band) and <code>EigenvaluesWithinRegion</code>
(a polygon of the (Re, Im) plane) -- each with <code>Property</code> and <code>margin</code> outputs, constant
over a nominal run, which ModCheck's orchestrator compares with <code>linear_checks.py</code>'s per-mode
result: the R3 cross-check, never the reported verdict. The frequency-response family (gain and phase
margin, bandwidth, peak, dc and envelope gain, sensitivity peak, delay margin) has no Modelica side, by
decision: it needs the complex evaluation of the transfer function over a frequency grid and a crossover
search, which no MSL function provides.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
end LinearAnalysis;
