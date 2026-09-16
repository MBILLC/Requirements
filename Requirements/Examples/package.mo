within Requirements;
package Examples "Library of examples to demonstrate requirement definitions with package Requirements"
   extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p>
This package contains example models to demonstrate the usage of the Requirements
package.
</p>

<ul>
<li> 
In sub-library <a href=\"modelica://Requirements.Examples.Elementary\">Elementary</a>
every component of the library is demonstrated with simple examples. Typically, an example in this
sub-library contains one component and demonstrates the fine details of this component.
</li>

<li>
In sub-library <a href=\"modelica://Requirements.Examples.SteadyState\">SteadyState</a>
models are run to their steady state with their inputs as parameters; their requirements are checked over
a point cloud (a parameter sweep) by ModCheck, not over a trajectory (ModCheck's requirements plan, section 19).
</li>

<li>
In sub-library <a href=\"modelica://Requirements.Examples.AircraftRequirements\">AircraftRequirements</a>
it is shown how typical requirements appearing in aircraft design can be formulated with the
Requirements library. These examples have been provided by the aircraft
manufacturer Dassault Aviation.
</li>

<li>
The other sub-libraries of package Examples contain more complete scenarios how to
utilize the Requirements library in actual (small) applications.
</li>
</ul>
</html>"));
end Examples;
