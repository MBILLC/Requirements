within Requirements;
package Units "Type definitions of non-SI units and conversion functions, for the units Modelica.Units lacks"
  extends Modelica.Icons.Package;

  package NonSI "Type definitions of non-SI units (the ones Modelica.Units.NonSI does not define)"
    extends Modelica.Icons.Package;

    type Time_ms = Real (final quantity="Time", final unit="ms") "Time in milliseconds";
    type Length_mm = Real (final quantity="Length", final unit="mm") "Length in millimetres";
    type Length_cm = Real (final quantity="Length", final unit="cm") "Length in centimetres";
    type Length_km = Real (final quantity="Length", final unit="km") "Length in kilometres";
    type Length_ft = Real (final quantity="Length", final unit="ft") "Length in feet";
    type Length_kft = Real (final quantity="Length", final unit="kft") "Length in thousands of feet (flight levels, cabin and aircraft altitudes)";
    type Mass_g = Real (final quantity="Mass", final unit="g") "Mass in grams";
    type MassFlowRate_kgpmin = Real (final quantity="MassFlowRate", final unit="kg/min") "Mass flow rate in kilograms per minute";
    type Velocity_ftps = Real (final quantity="Velocity", final unit="ft/s") "Velocity in feet per second";
    type Velocity_ftpmin = Real (final quantity="Velocity", final unit="ft/min") "Velocity in feet per minute (rates of climb)";
    type Pressure_kPa = Real (final quantity="Pressure", final unit="kPa") "Pressure in kilopascals";
    type Pressure_mbar = Real (final quantity="Pressure", final unit="mbar") "Pressure in millibars";
    type Power_kW = Real (final quantity="Power", final unit="kW") "Power in kilowatts";
    type Energy_kJ = Real (final quantity="Energy", final unit="kJ") "Energy in kilojoules";

    annotation (Documentation(info="<html>
<p>Type definitions of non-SI units in the manner of <a href=\"modelica://Modelica.Units.NonSI\">Modelica.Units.NonSI</a>, for the units that package does not define and that requirements written in engineering practice use (feet and thousands of feet for altitudes, kg/min for air flows, kPa and mbar for cabin pressures, milliseconds, kilowatts). The corresponding conversion functions are in <a href=\"modelica://Requirements.Units.Conversions\">Conversions</a>. A quantity that <code>Modelica.Units.NonSI</code> already defines (degC, bar, rpm, km/h, min, h, ...) is not repeated here.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end NonSI;

  package Conversions "Conversion functions to/from the non-SI units of Requirements.Units.NonSI"
    extends Modelica.Icons.Package;

    function to_ms "Convert from second to millisecond"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Time s "Value in second";
      output NonSI.Time_ms ms "Value in millisecond";
    algorithm
      ms := s*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_ms;

    function from_ms "Convert from millisecond to second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Time_ms ms "Value in millisecond";
      output Modelica.Units.SI.Time s "Value in second";
    algorithm
      s := ms/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_ms;

    function to_mm "Convert from metre to millimetre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Length m "Value in metre";
      output NonSI.Length_mm mm "Value in millimetre";
    algorithm
      mm := m*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mm;

    function from_mm "Convert from millimetre to metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Length_mm mm "Value in millimetre";
      output Modelica.Units.SI.Length m "Value in metre";
    algorithm
      m := mm/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mm;

    function to_cm "Convert from metre to centimetre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Length m "Value in metre";
      output NonSI.Length_cm cm "Value in centimetre";
    algorithm
      cm := m*100;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_cm;

    function from_cm "Convert from centimetre to metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Length_cm cm "Value in centimetre";
      output Modelica.Units.SI.Length m "Value in metre";
    algorithm
      m := cm/100;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_cm;

    function to_km "Convert from metre to kilometre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Length m "Value in metre";
      output NonSI.Length_km km "Value in kilometre";
    algorithm
      km := m/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_km;

    function from_km "Convert from kilometre to metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Length_km km "Value in kilometre";
      output Modelica.Units.SI.Length m "Value in metre";
    algorithm
      m := km*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_km;

    function to_ft "Convert from metre to foot"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Length m "Value in metre";
      output NonSI.Length_ft ft "Value in foot";
    algorithm
      ft := m/0.3048;
      annotation (Inline=true, Documentation(info="<html><p>The international foot, 0.3048 m exactly.</p><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_ft;

    function from_ft "Convert from foot to metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Length_ft ft "Value in foot";
      output Modelica.Units.SI.Length m "Value in metre";
    algorithm
      m := ft*0.3048;
      annotation (Inline=true, Documentation(info="<html><p>The international foot, 0.3048 m exactly.</p><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_ft;

    function to_kft "Convert from metre to thousands of feet"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Length m "Value in metre";
      output NonSI.Length_kft kft "Value in thousands of feet";
    algorithm
      kft := m/304.8;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kft;

    function from_kft "Convert from thousands of feet to metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Length_kft kft "Value in thousands of feet";
      output Modelica.Units.SI.Length m "Value in metre";
    algorithm
      m := kft*304.8;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kft;

    function to_g "Convert from kilogram to gram"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Mass kg "Value in kilogram";
      output NonSI.Mass_g g "Value in gram";
    algorithm
      g := kg*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_g;

    function from_g "Convert from gram to kilogram"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Mass_g g "Value in gram";
      output Modelica.Units.SI.Mass kg "Value in kilogram";
    algorithm
      kg := g/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_g;

    function to_kgpmin "Convert from kilogram per second to kilogram per minute"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.MassFlowRate kgps "Value in kilogram per second";
      output NonSI.MassFlowRate_kgpmin kgpmin "Value in kilogram per minute";
    algorithm
      kgpmin := kgps*60;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kgpmin;

    function from_kgpmin "Convert from kilogram per minute to kilogram per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.MassFlowRate_kgpmin kgpmin "Value in kilogram per minute";
      output Modelica.Units.SI.MassFlowRate kgps "Value in kilogram per second";
    algorithm
      kgps := kgpmin/60;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kgpmin;

    function to_ftps "Convert from metre per second to foot per second"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Velocity mps "Value in metre per second";
      output NonSI.Velocity_ftps ftps "Value in foot per second";
    algorithm
      ftps := mps/0.3048;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_ftps;

    function from_ftps "Convert from foot per second to metre per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Velocity_ftps ftps "Value in foot per second";
      output Modelica.Units.SI.Velocity mps "Value in metre per second";
    algorithm
      mps := ftps*0.3048;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_ftps;

    function to_ftpmin "Convert from metre per second to foot per minute"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Velocity mps "Value in metre per second";
      output NonSI.Velocity_ftpmin ftpmin "Value in foot per minute";
    algorithm
      ftpmin := mps/0.00508;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_ftpmin;

    function from_ftpmin "Convert from foot per minute to metre per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Velocity_ftpmin ftpmin "Value in foot per minute";
      output Modelica.Units.SI.Velocity mps "Value in metre per second";
    algorithm
      mps := ftpmin*0.00508;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_ftpmin;

    function to_kPa "Convert from pascal to kilopascal"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Pressure Pa "Value in pascal";
      output NonSI.Pressure_kPa kPa "Value in kilopascal";
    algorithm
      kPa := Pa/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kPa;

    function from_kPa "Convert from kilopascal to pascal"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Pressure_kPa kPa "Value in kilopascal";
      output Modelica.Units.SI.Pressure Pa "Value in pascal";
    algorithm
      Pa := kPa*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kPa;

    function to_mbar "Convert from pascal to millibar"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Pressure Pa "Value in pascal";
      output NonSI.Pressure_mbar mbar "Value in millibar";
    algorithm
      mbar := Pa/100;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mbar;

    function from_mbar "Convert from millibar to pascal"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Pressure_mbar mbar "Value in millibar";
      output Modelica.Units.SI.Pressure Pa "Value in pascal";
    algorithm
      Pa := mbar*100;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mbar;

    function to_kW "Convert from watt to kilowatt"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Power W "Value in watt";
      output NonSI.Power_kW kW "Value in kilowatt";
    algorithm
      kW := W/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kW;

    function from_kW "Convert from kilowatt to watt"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Power_kW kW "Value in kilowatt";
      output Modelica.Units.SI.Power W "Value in watt";
    algorithm
      W := kW*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kW;

    function to_kJ "Convert from joule to kilojoule"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Energy J "Value in joule";
      output NonSI.Energy_kJ kJ "Value in kilojoule";
    algorithm
      kJ := J/1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kJ;

    function from_kJ "Convert from kilojoule to joule"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Energy_kJ kJ "Value in kilojoule";
      output Modelica.Units.SI.Energy J "Value in joule";
    algorithm
      J := kJ*1000;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kJ;

    annotation (Documentation(info="<html>
<p>Conversion functions in the manner of <a href=\"modelica://Modelica.Units.Conversions\">Modelica.Units.Conversions</a> for the non-SI units of <a href=\"modelica://Requirements.Units.NonSI\">NonSI</a>: <code>from_&lt;unit&gt;</code> converts a value written in the non-SI unit to the SI unit, <code>to_&lt;unit&gt;</code> the reverse; every function is inlined. A check model, hand-written or generated from a requirement statement, can write every quantity of the statement as <code>from_&lt;unit&gt;(&lt;value as written&gt;)</code>, so the model reads like the statement and the conversion is this library's, not the author's (or a generator's) arithmetic; a plant variable that is in a non-SI unit is converted the same way into the SI output the check reads, which keeps the original unit in its <code>displayUnit</code>. Units that <code>Modelica.Units.Conversions</code> already covers (degC, bar, rpm, km/h, min, h, ...) are taken from there.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end Conversions;

  annotation (Documentation(info="<html>
<p>Non-SI unit types and their conversions to and from SI, complementing <a href=\"modelica://Modelica.Units\">Modelica.Units</a>: a requirement is written in the units its domain uses (an altitude in kft, an air flow in kg/min, a cabin pressure in mbar), a model computes in SI, and the conversion between the two must be one function with one factor, in the library, never a number typed into a generated model. <a href=\"modelica://Requirements.Examples.Elementary.Units.Conversions\">Examples.Elementary.Units.Conversions</a> asserts every factor.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
end Units;
