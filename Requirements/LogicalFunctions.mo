within Requirements;
package LogicalFunctions
  "Library of logical functions (2-/3-valued logical operators without memory)"
  extends Modelica.Icons.Package;

  function card
    "Returns the number of elements of a Boolean vector that are true"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Integer result "Number of true entries";
  algorithm
    result :=sum(if b[i] then 1 else 0 for i in 1:size(b, 1));
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>card</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns the number of true-elements of Boolean vector b.
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.card\">example</a> calling the function as:
</p>

<blockquote>
nTrueElements = card( b )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/card.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> Reduction written over the indices <code>1:size(.,1)</code> instead of over the elements; the same count, and it compiles in Modelon Impact, which fails to scalarize the element form (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end card;

  function exists
    "Returns true if at least one element of a Boolean vector is true ('or' of all elements)"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Boolean result "= true, if at least one element of b is true";
  algorithm
    result :=card(b) > 0;
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>exists</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns true if at least one element of the Boolean vector b is true.
Otherwise, the function returns false.
</p>

<h4>Example</h4>

<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.exists\">example</a> calling the function as:
</p>

<blockquote>
Boolean atleastOnePumpActive = exists({p.isActive <b>for</b> p <b>in</b> pumps})
</blockquote>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/exists.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
Note, the same result can be achieved with the max(..) built-in operator:
</p>

<p>
<blockquote>
Boolean atleastOnePumpActive2 = max(p.isActive <b>for</b> p <b>in</b> pumps)
</blockquote>
</p>
</html>"));
  end exists;

  function forall
    "Returns true if all elements of a Boolean vector are true ('and' of all elements)"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Boolean result "= true, if all elements of b are true";
  algorithm
    result :=card(b) == size(b, 1);
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>forall</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns true if all elements of the Boolean vector b are true.
Otherwise, the function returns false.
</p>

<h4>Example</h4>

<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.forall\">example</a> calling the function as:
</p>

<blockquote>
<p>
Boolean noCavitation = forall({p.p_a > p_cavitate <b>for</b> p <b>in</b> pumps})
</p>
</blockquote>


<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/forall.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

<p>
Note, the same result can be achieved with the min(..) built-in operator:
</p>

<p>
<blockquote>
Boolean noCavitation2 = min(p.p_a > p_cavitate <b>for</b> p <b>in</b> pumps);
</blockquote>
</p>
</html>"));
  end forall;

  function implies
    "Returns check as long as the condition is true, otherwise returns true"
    extends Modelica.Icons.Function;
    input Boolean condition;
    input Boolean check;
    output Boolean result;
  algorithm
    result :=if condition then check else true;

    annotation (Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>implies</b>(condition, check);
</p></blockquote>

<h4>Description</h4>
<p>
If condition is true, the function returns check. Otherwise, it returns true.
</p>


<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.implies\">example</a> calling the function as:
</p>

<blockquote>
property = implies(condition,check)<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/implies.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end implies;

  function first "Returns the value of the first element of a Boolean vector"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Boolean result "Value of the first entry";
  algorithm
    result := b[1];
    annotation(Inline=true, Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
<b>first</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns the value of the first element of a Boolean vector b.
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.first\">example</a> calling the function as:
</p>

<blockquote>
firstBooleanElement = first( b ) <br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/first.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end first;

  function last "Returns the value of the last element of a Boolean vector"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Boolean result "Value of last entry";
  algorithm
    result := b[size(b, 1)];
    annotation(Inline=true, Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
<b>last</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns the value of the last element of a Boolean vector b.
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.last\">example</a> calling the function as:
</p>

<blockquote>
lastBooleanElement = last( b )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/last.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end last;

  function oneTrue
    "Returns true if exactly one element of a Boolean vector is true ('xor' of all elements)"
    extends Modelica.Icons.Function;
    input Boolean b[:] "Boolean vector";
    output Boolean result "= true, if exactly one element of b is true";
  algorithm
    result := card(b) == 1;
    annotation(Inline=true, Documentation(info="<html>
<h4>Syntax</h4>

<blockquote><p>
<b>oneTrue</b>(b);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns  true if exactly one element of a Boolean vector is true ('xor' of all elements).
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.oneTrue\">example</a> calling the function as:
</p>

<blockquote>
oneTrueElement = oneTrue( b )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/oneTrue.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

</html>"));
  end oneTrue;

  function PropertyToBoolean
    "Convert  Property (Violated, Undecided, Satisfied) to Boolean (false, true)"
     import Requirements.Types.Property;
     extends Modelica.Icons.Function;

     input Requirements.Types.Property u
      "Property to be mapped to Boolean";
     input Boolean undecided=false "Boolean value of Property.Undecided";
    output Boolean y "Boolean as Property";
  algorithm
    y :=if u == Property.Satisfied then true else (if u == Property.Undecided
       then undecided else false);

    annotation (Documentation(info="<html>
</html>"));
  end PropertyToBoolean;

  function PropertyToInteger
    "Convert  Property (Violated, Undecided, Satisfied) to Integer (1,2,3)"
     import Requirements.Types.Property;
     extends Modelica.Icons.Function;

     input Requirements.Types.Property u
      "Property to be mapped to Boolean";
    output Integer y "Integer as Property";
  algorithm
    y :=Integer(u);

    annotation (Documentation(info="<html>
</html>"));
  end PropertyToInteger;

  function BooleanToProperty
    "Convert Boolean (false,true) to Property (Violated, Satisfied)"
     import Requirements.Types.Property;

     extends Requirements.Interfaces.PropertyFunction;
     input Boolean u "Boolean to be mapped to Property";
    output Requirements.Types.Property y "Boolean as Property";
  algorithm
     y :=if u then Property.Satisfied else Property.Violated;

    annotation (Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>BooleanToProperty</b>(check);
</p></blockquote>

<h4>Description</h4>
<p>
The function returns Satisfied if check=true and returns Violated, if check=false.
Satisfied and Violated are elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.toProperty\">example</a> calling the function as:
</p>

<blockquote>
property = BooleanToProperty(check)<br>
</blockquote>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/toProperty.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

</html>"));

  end BooleanToProperty;

  function IntegerToProperty
    "Convert Integer (1,2,3,4) to Property (Violated, Undecided, Satisfied, Undefined)"
     import Requirements.Types.Property;

     extends Requirements.Interfaces.PropertyFunction;
     input Integer u "Integer to be mapped to Property";
    output Requirements.Types.Property y "Integer as Property";
  algorithm
    assert(u>=1 and u<=4, "Integer input u (=" + String(u) + ") cannot be converted to Property output (u = 1, 2, 3 or 4 required)");
    y :=if u == 4 then Property.Undefined else (if u == 3 then Property.Satisfied else (if u == 2 then Property.Undecided
       else Property.Violated));

    annotation (Documentation(info="<html>
</html>"));
  end IntegerToProperty;

  function during
    "Return Satisfied when check is true as long as condition is true"
    import Requirements.Types.Property;
    extends Requirements.Interfaces.PropertyFunction;
    input Boolean condition "Verify check as long as condition = true";
    input Boolean check "As long as condition is true, check should be true";
    output Requirements.Types.Property result;
  algorithm
    result :=if condition then
                (if check then Property.Satisfied else Property.Violated) else Property.Undefined;

    annotation (Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>during</b>(condition, check);
</p></blockquote>

<h4>Description</h4>
<p>
If condition is true, the function returns \"<a href=\"modelica://Requirements.Types.Property\">Property</a>(check)\"
(so either Satisfied or Violated). Otherwise, it returns Undefined: the property is not
applicable while its condition is false (before version 0.8.0 the function returned Undecided here).
Violated, Undecided, Satisfied and Undefined are the elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.during\">example</a> calling the function as:
</p>

<blockquote>
property = during(condition,check)<br>
</blockquote>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/during.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

</html>"),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics));
  end during;

  function during3
    "Return Satisfied when check is Satisfied as long as condition is true (check: 4-valued logic)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Boolean condition "Verify check as long as condition = true";
    input Requirements.Types.Property check
      "As long as condition is true, check should be Satisfied";
    output Requirements.Types.Property result;
  algorithm
    result :=if condition then check else Property.Undefined;

    annotation (Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>during3</b>(condition, check);
</p></blockquote>

<h4>Description</h4>
<p>
If condition is true, the function returns check (which must be of type
<a href=\"modelica://Requirements.Types.Property\">Property</a>). Otherwise, it returns Undefined:
the property is not applicable while its condition is false (before version 0.8.0 the function
returned Undecided here).
</p>

<h4>Example</h4>
<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.during3\">example</a> calling the function as:
</p>

<blockquote>
property = during3(condition,check)<br>
</blockquote>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/during3.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>

</html>"));
  end during3;

  function forall3
    "Returns Violated, if at least one element of the Property vector is Violated (superseded by and4All)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;

    input Types.Property p[:] "Property vector";
    output Types.Property result
      "= and4All(p) for a non-empty vector (Violated if one element is Violated, else Undecided if one is Undecided, else Satisfied if one is Satisfied, else Undefined); Undecided for the empty vector";
  algorithm
    if size(p,1) < 1 then
       result :=Property.Undecided;
       return;
    end if;
    result :=and4All(p);

    annotation(Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
<b>forall3</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
<b>Superseded by <a href=\"modelica://Requirements.LogicalFunctions.and4All\">and4All</a></b> since
version 0.8.0; kept for existing models. For a non-empty vector the function returns
<code>and4All(p)</code>: Property.Violated, if at least <b>one element</b> of Property vector p has value
Violated; else Undecided if one element is Undecided; else Satisfied if one element is Satisfied;
else Undefined (every element Undefined). Elements that are Undefined do not affect the result.
For the empty vector (dimension of p is 0) the function keeps its old result Undecided, where
and4All returns Undefined.
</p>

<h4>Example</h4>

<p>
The property is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.forall3\">example</a> calling the function as:
</p>

<blockquote>
properties = {during(p.isActive, check=p.p_a > p_cavitate) for p in pumps};<br>
result = forall3(properties);
</blockquote>

<p>
results in
</p>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/forall3_1.png\"></td>
    </tr>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/forall3_2.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>"));
  end forall3;

  function cardSatisfied
    "Returns the number of elements of a Property vector that are Satisfied"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Integer result "Number of Property.Satisfied entries";
  algorithm
    result :=sum(if p[i] == Property.Satisfied then 1 else 0 for i in 1:size(p, 1));
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
nSatisfied = <b>cardSatisfied</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
This function returns the number of Satisfied-elements of Property vector p.
</p>

<p>
Violated, Undecided, Satisfied and Undefined are elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>.
</p>

<h4>Example</h4>
<p>
This function is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.cardSatisfied\">example</a> calling the function as:
</p>

<blockquote>
nSatisfied = cardSatisfied( p )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/cardSatisfied.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> Reduction written over the indices <code>1:size(.,1)</code> instead of over the elements; the same count, and it compiles in Modelon Impact, which fails to scalarize the element form (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end cardSatisfied;

  function cardUndecided
    "Returns the number of elements of a Property vector that are Undecided"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Integer result "Number of Property.Undecided entries";
  algorithm
    result :=sum(if p[i] == Property.Undecided then 1 else 0 for i in 1:size(p, 1));
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
nUndecided = <b>cardUndecided</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
This function returns the number of Undecided-elements of Property vector p.
</p>

<p>
Violated, Undecided, Satisfied and Undefined are elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>.
</p>

<h4>Example</h4>
<p>
This function is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.cardUndecided\">example</a> calling the function as:
</p>

<blockquote>
nUndecided = cardUndecided( p )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/cardUndecided.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> Reduction written over the indices <code>1:size(.,1)</code> instead of over the elements; the same count, and it compiles in Modelon Impact, which fails to scalarize the element form (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end cardUndecided;

  function cardViolated
    "Returns the number of elements of a Property vector that are Violated"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Integer result "Number of Property.Violated entries";
  algorithm
    result :=sum(if p[i] == Property.Violated then 1 else 0 for i in 1:size(p, 1));
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
nViolated = <b>cardViolated</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
This function returns the number of Violated-elements of Property vector p.
</p>

<p>
Violated, Undecided, Satisfied and Undefined are elements of enumeration
<a href=\"modelica://Requirements.Types.Property\">Property</a>.
</p>

<h4>Example</h4>
<p>
This function is demonstrated with the following
<a href=\"modelica://Requirements.Examples.Textual.Elementary.LogicalFunctions.cardViolated\">example</a> calling the function as:
</p>

<blockquote>
nViolated = cardViolated( p )<br>
</blockquote>

<table border=0 cellspacing=0 cellpadding=2>
<tr><td width=\"50\"></td>
    <td valign=\"bottom\"><img src=\"modelica://Requirements/Resources/Images/Examples/Textual/Elementary/LogicalFunctions/cardViolated.png\"></td>
    </tr>
<tr><td></td>
    <td align=\"center\">simulation result</td>
   </tr>
</table>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>

<tr><td valign=\"top\"> Sept. 14, 2026 </td>
    <td valign=\"top\"> Reduction written over the indices <code>1:size(.,1)</code> instead of over the elements; the same count, and it compiles in Modelon Impact, which fails to scalarize the element form (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end cardViolated;

  function cardUndefined
    "Returns the number of elements of a Property vector that are Undefined"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Integer result "Number of Property.Undefined entries";
  algorithm
    result :=sum(if p[i] == Property.Undefined then 1 else 0 for i in 1:size(p, 1));
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
nUndefined = <b>cardUndefined</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
This function returns the number of Undefined-elements of Property vector p
(the elements that are not applicable). Violated, Undecided, Satisfied and Undefined are
elements of enumeration <a href=\"modelica://Requirements.Types.Property\">Property</a>.
The reduction is written over the indices <code>1:size(p,1)</code> like the other card functions,
the form Modelon Impact scalarizes.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end cardUndefined;

  function and4
    "4-valued logic 'and' of two Property values (ETL: Undefined is the neutral element)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property a "First operand";
    input Property b "Second operand";
    output Property result "= a and b";
  algorithm
    result :=if a == Property.Undefined then b
        elseif b == Property.Undefined then a
        elseif a == Property.Violated or b == Property.Violated then Property.Violated
        elseif a == Property.Undecided or b == Property.Undecided then Property.Undecided
        else Property.Satisfied;
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
result = <b>and4</b>(a, b);
</p></blockquote>

<h4>Description</h4>
<p>
The four-valued logic <b>and</b> of two <a href=\"modelica://Requirements.Types.Property\">Property</a>
values, with the extended temporal logic (ETL) table of EDF's ReqSysPro / CRML
(<code>CRML.Blocks.Logical4.and4</code>). Undefined (not applicable) is the neutral element:
<code>and4(Undefined, b) = b</code>. The table (rows a, columns b):
</p>

<blockquote>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">a <b>and4</b> b</td>
    <td valign=\"top\"><b>Violated</b></td>
    <td valign=\"top\"><b>Undecided</b></td>
    <td valign=\"top\"><b>Satisfied</b></td>
    <td valign=\"top\"><b>Undefined</b></td></tr>
<tr><td valign=\"top\"><b>Violated</b></td>
    <td> Violated </td><td> Violated </td><td> Violated </td><td> Violated </td></tr>
<tr><td valign=\"top\"><b>Undecided</b></td>
    <td> Violated </td><td> Undecided </td><td> Undecided </td><td> Undecided </td></tr>
<tr><td valign=\"top\"><b>Satisfied</b></td>
    <td> Violated </td><td> Undecided </td><td> Satisfied </td><td> Satisfied </td></tr>
<tr><td valign=\"top\"><b>Undefined</b></td>
    <td> Violated </td><td> Undecided </td><td> Satisfied </td><td> Undefined </td></tr>
</table>
</blockquote>

<p>
On {Violated, Undecided, Satisfied} this is the three-valued (Kleene) <b>and</b> the library had
before version 0.8.0. The operator is commutative, associative and idempotent, and De Morgan's
laws hold with <a href=\"modelica://Requirements.LogicalFunctions.or4\">or4</a> and
<a href=\"modelica://Requirements.LogicalFunctions.not4\">not4</a>; absorption and distributivity
do <b>not</b> hold (see <a href=\"modelica://Requirements.Types.Property\">Property</a>), so an
expression over Property values must be evaluated as written, never simplified.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end and4;

  function or4
    "4-valued logic 'or' of two Property values (ETL: Undefined is the neutral element)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property a "First operand";
    input Property b "Second operand";
    output Property result "= a or b";
  algorithm
    result :=if a == Property.Undefined then b
        elseif b == Property.Undefined then a
        elseif a == Property.Satisfied or b == Property.Satisfied then Property.Satisfied
        elseif a == Property.Undecided or b == Property.Undecided then Property.Undecided
        else Property.Violated;
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
result = <b>or4</b>(a, b);
</p></blockquote>

<h4>Description</h4>
<p>
The four-valued logic <b>or</b> of two <a href=\"modelica://Requirements.Types.Property\">Property</a>
values, with the extended temporal logic (ETL) table of EDF's ReqSysPro / CRML
(<code>CRML.Blocks.Logical4.or4</code>). Undefined (not applicable) is the neutral element:
<code>or4(Undefined, b) = b</code>. The table (rows a, columns b):
</p>

<blockquote>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">a <b>or4</b> b</td>
    <td valign=\"top\"><b>Violated</b></td>
    <td valign=\"top\"><b>Undecided</b></td>
    <td valign=\"top\"><b>Satisfied</b></td>
    <td valign=\"top\"><b>Undefined</b></td></tr>
<tr><td valign=\"top\"><b>Violated</b></td>
    <td> Violated </td><td> Undecided </td><td> Satisfied </td><td> Violated </td></tr>
<tr><td valign=\"top\"><b>Undecided</b></td>
    <td> Undecided </td><td> Undecided </td><td> Satisfied </td><td> Undecided </td></tr>
<tr><td valign=\"top\"><b>Satisfied</b></td>
    <td> Satisfied </td><td> Satisfied </td><td> Satisfied </td><td> Satisfied </td></tr>
<tr><td valign=\"top\"><b>Undefined</b></td>
    <td> Violated </td><td> Undecided </td><td> Satisfied </td><td> Undefined </td></tr>
</table>
</blockquote>

<p>
<code>or4(a, b) = not4(and4(not4(a), not4(b)))</code> (De Morgan). See
<a href=\"modelica://Requirements.LogicalFunctions.and4\">and4</a> for the laws that hold and the ones that
do not.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end or4;

  function not4
    "4-valued logic 'not' of a Property value (ETL: Undecided and Undefined are fixed)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property a "Operand";
    output Property result "= not a";
  algorithm
    result :=if a == Property.Satisfied then Property.Violated
        elseif a == Property.Violated then Property.Satisfied
        else a;
    annotation(Inline=true, Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
result = <b>not4</b>(a);
</p></blockquote>

<h4>Description</h4>
<p>
The four-valued logic <b>not</b> of a <a href=\"modelica://Requirements.Types.Property\">Property</a>
value (<code>CRML.Blocks.Logical4.not4</code>): Satisfied and Violated are exchanged, Undecided and
Undefined are fixed (a property that is not decided, or not applicable, stays so under negation).
</p>

<blockquote>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\"> a </td>
    <td valign=\"top\"><b>Violated</b></td>
    <td valign=\"top\"><b>Undecided</b></td>
    <td valign=\"top\"><b>Satisfied</b></td>
    <td valign=\"top\"><b>Undefined</b></td></tr>
<tr><td valign=\"top\"><b>not4</b> a</td>
    <td> Satisfied </td><td> Undecided </td><td> Violated </td><td> Undefined </td></tr>
</table>
</blockquote>

<p>
<code>not4(not4(a)) = a</code>. Negation is not difference: <code>a &lt;&gt; b</code> does not imply
<code>a == not4(b)</code> (CRML specification, section 3.2).
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end not4;

  function and4All
    "4-valued logic 'and' over a Property vector (the empty vector gives Undefined, the neutral element)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Property result "= p[1] and4 p[2] and4 ... and4 p[size(p,1)]; Undefined for the empty vector";
  algorithm
    result :=Property.Undefined;
    for i in 1:size(p,1) loop
       result :=and4(result, p[i]);
    end for;
    annotation(Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
result = <b>and4All</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
The four-valued <a href=\"modelica://Requirements.LogicalFunctions.and4\">and4</a> folded over
the elements of Property vector p, seeded with Undefined, the neutral element: the result is
Violated if at least one element is Violated; else Undecided if at least one element is
Undecided; else Satisfied if at least one element is Satisfied; else Undefined (every element
Undefined, or the empty vector). Elements that are Undefined (not applicable: the component's
requirement was outside its scope, or the component is absent) do not affect the result, which
is what a requirement quantified over a set of components needs. Supersedes
<a href=\"modelica://Requirements.LogicalFunctions.forall3\">forall3</a>.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end and4All;

  function or4All
    "4-valued logic 'or' over a Property vector (the empty vector gives Undefined, the neutral element)"
    extends Requirements.Interfaces.PropertyFunction;
    import Requirements.Types.Property;
    input Property p[:] "Property vector";
    output Property result "= p[1] or4 p[2] or4 ... or4 p[size(p,1)]; Undefined for the empty vector";
  algorithm
    result :=Property.Undefined;
    for i in 1:size(p,1) loop
       result :=or4(result, p[i]);
    end for;
    annotation(Documentation(info="<html>

<h4>Syntax</h4>

<blockquote><p>
result = <b>or4All</b>(p);
</p></blockquote>

<h4>Description</h4>
<p>
The four-valued <a href=\"modelica://Requirements.LogicalFunctions.or4\">or4</a> folded over the
elements of Property vector p, seeded with Undefined, the neutral element: the result is
Satisfied if at least one element is Satisfied; else Undecided if at least one element is
Undecided; else Violated if at least one element is Violated; else Undefined (every element
Undefined, or the empty vector). Elements that are Undefined do not affect the result.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the fourth value Undefined (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end or4All;

  function marginAnd
    "Margin of a conjunction: the minimum of the margins whose property is applicable (not Undefined)"
    extends Modelica.Icons.Function;
    import Requirements.Types.Property;
    input Real m[:] "Margins";
    input Property p[size(m,1)] "The properties the margins belong to";
    output Real result "min of m[i] over i with p[i] <> Undefined; 0 when no element is applicable";
  protected
    Boolean any = false;
  algorithm
    result := 0;
    for i in 1:size(m,1) loop
      if p[i] <> Property.Undefined then
        result := if any then min(result, m[i]) else m[i];
        any := true;
      end if;
    end for;
    annotation(Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><p>
result = <b>marginAnd</b>(m, p);
</p></blockquote>
<h4>Description</h4>
<p>
The margin of <code>and4All(p)</code>: the minimum of the margins m[i] over the elements whose property p[i] is applicable (not Undefined) -- conjunction is the minimum in the robustness semantics, and an inapplicable element drops out of the combination as it does in <a href=\"modelica://Requirements.LogicalFunctions.and4All\">and4All</a>.
When no element is applicable the result is 0 (the combined property is Undefined then, and a consumer
masks the margin with it); no NaN is produced.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the margin outputs (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end marginAnd;

  function marginOr
    "Margin of a disjunction: the maximum of the margins whose property is applicable (not Undefined)"
    extends Modelica.Icons.Function;
    import Requirements.Types.Property;
    input Real m[:] "Margins";
    input Property p[size(m,1)] "The properties the margins belong to";
    output Real result "max of m[i] over i with p[i] <> Undefined; 0 when no element is applicable";
  protected
    Boolean any = false;
  algorithm
    result := 0;
    for i in 1:size(m,1) loop
      if p[i] <> Property.Undefined then
        result := if any then max(result, m[i]) else m[i];
        any := true;
      end if;
    end for;
    annotation(Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><p>
result = <b>marginOr</b>(m, p);
</p></blockquote>
<h4>Description</h4>
<p>
The margin of <code>or4All(p)</code>: the maximum of the margins m[i] over the elements whose property p[i] is applicable (not Undefined) -- disjunction is the maximum in the robustness semantics; see <a href=\"modelica://Requirements.LogicalFunctions.marginAnd\">marginAnd</a>.
When no element is applicable the result is 0 (the combined property is Undefined then, and a consumer
masks the margin with it); no NaN is produced.
</p>
</html>", revisions="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Date</th> <th align=\"left\">Description</th></tr>
<tr><td valign=\"top\"> Sept. 15, 2026 </td>
    <td valign=\"top\"> Added with the margin outputs (H. Tummescheit, Model Based Innovation LLC)</td></tr>
</table>
</html>"));
  end marginOr;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
                          Line(
          points={{-86,-12},{-50,-12},{-50,32},{48,32},{48,-12},{88,-12}},
          color={135,135,135})}),           Documentation(info="<html>
<p>
Sublibrary LogicalFunctions contains operators without memory, implemented as Modelica functions. 
The input arguments of these functions have 2-valued logic type (Boolean) or, for the
four-valued operators <code>and4</code>, <code>or4</code>, <code>not4</code>, <code>and4All</code>,
<code>or4All</code> and the <code>card*</code> counts, 4-valued logic type.
The output arguments of these functions have 2-valued or 4-valued logic type
(Boolean or <a href=\"modelica://Requirements.Types.Property\">Property</a>).
The provided operators reason about their input arguments based on Boolean algebra, or,
for Property values, on the four-valued ETL algebra described at
<a href=\"modelica://Requirements.Types.Property\">Property</a> (which is not a Boolean algebra:
absorption and distributivity fail, so Property expressions are never simplified).
The icon of a function depends on the the type of its output argument
(whether it is Boolean or <a href=\"modelica://Requirements.Types.Property\">Property</a>).
</p>
</html>"));
end LogicalFunctions;
