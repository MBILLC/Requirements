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
    type AngularVelocity_degps = Real (final quantity="AngularVelocity", final unit="deg/s") "Angular velocity in degrees per second";
    type AngularAcceleration_degps2 = Real (final quantity="AngularAcceleration", final unit="deg/s2") "Angular acceleration in degrees per second squared";
    type VolumeFlowRate_lpmin = Real (final quantity="VolumeFlowRate", final unit="l/min") "Volume flow rate in litres per minute (pumps, coolant loops)";
    type VolumeFlowRate_m3ph = Real (final quantity="VolumeFlowRate", final unit="m3/h") "Volume flow rate in cubic metres per hour (pumps, HVAC)";
    type SpecificEnergy_kJpkg = Real (final quantity="SpecificEnergy", final unit="kJ/kg") "Specific energy (a specific enthalpy) in kilojoules per kilogram";
    type MassFraction_gpkg = Real (final quantity="MassFraction", final unit="g/kg") "Mass fraction in grams per kilogram (humidity ratios)";
    type Inductance_mH = Real (final quantity="Inductance", final unit="mH") "Inductance in millihenries";
    type Inductance_uH = Real (final quantity="Inductance", final unit="uH") "Inductance in microhenries";
    type MagneticFlux_mWb = Real (final quantity="MagneticFlux", final unit="mWb") "Magnetic flux in milliwebers";
    type Resistance_kOhm = Real (final quantity="Resistance", final unit="kOhm") "Resistance in kilohms";
    type Resistance_MOhm = Real (final quantity="Resistance", final unit="MOhm") "Resistance in megohms (insulation resistances)";
    type Resistance_mOhm = Real (final quantity="Resistance", final unit="mOhm") "Resistance in milliohms (contact and shunt resistances)";
    type Capacitance_uF = Real (final quantity="Capacitance", final unit="uF") "Capacitance in microfarads";
    type Capacitance_nF = Real (final quantity="Capacitance", final unit="nF") "Capacitance in nanofarads";
    type Capacitance_pF = Real (final quantity="Capacitance", final unit="pF") "Capacitance in picofarads";
    type ApparentPower_kVA = Real (final quantity="Power", final unit="kV.A") "Apparent power in kilovolt-amperes";
    type ReactivePower_kvar = Real (final quantity="Power", final unit="kvar") "Reactive power in kilovars";
    type SpecificHeatCapacity_kJpkgK = Real (final quantity="SpecificHeatCapacity", final unit="kJ/(kg.K)") "Specific heat capacity in kilojoules per kilogram kelvin";
    type Density_gpcm3 = Real (final quantity="Density", final unit="g/cm3") "Density in grams per cubic centimetre";
    type DynamicViscosity_mPas = Real (final quantity="DynamicViscosity", final unit="mPa.s") "Dynamic viscosity in millipascal seconds (centipoise)";
    type Area_cm2 = Real (final quantity="Area", final unit="cm2") "Area in square centimetres";
    type Area_mm2 = Real (final quantity="Area", final unit="mm2") "Area in square millimetres";
    type MagneticFluxDensity_mT = Real (final quantity="MagneticFluxDensity", final unit="mT") "Magnetic flux density in millitesla";
    type PressureSlope_barps = Real (final quantity="PressureSlope", final unit="bar/s") "Pressure slope in bars per second";

    annotation (Documentation(info="<html>
<p>Type definitions of non-SI units in the manner of <a href=\"modelica://Modelica.Units.NonSI\">Modelica.Units.NonSI</a>, for the units that package does not define and that requirements written in engineering practice use (feet and thousands of feet for altitudes, kg/min for air flows, kPa and mbar for cabin pressures, milliseconds, kilowatts), and the display units of the quantities the MSL's connectors carry (deg/s, l/min and m3/h, kJ/kg, g/kg, mH and uH, mWb) and of the quantities of its components (kOhm, MOhm and mOhm, uF, nF and pF, kV.A, kvar, kJ/(kg.K), g/cm3, mPa.s, cm2 and mm2, mT, bar/s). The corresponding conversion functions are in <a href=\"modelica://Requirements.Units.Conversions\">Conversions</a>. A quantity that <code>Modelica.Units.NonSI</code> already defines (degC, bar, rpm, km/h, min, h, ...) is not repeated here.</p>
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

    function to_degps "Convert from radian per second to degree per second"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.AngularVelocity radps "Value in radian per second";
      output NonSI.AngularVelocity_degps degps "Value in degree per second";
    algorithm
      degps := (180/Modelica.Constants.pi)*radps;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_degps;

    function from_degps "Convert from degree per second to radian per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.AngularVelocity_degps degps "Value in degree per second";
      output Modelica.Units.SI.AngularVelocity radps "Value in radian per second";
    algorithm
      radps := (Modelica.Constants.pi/180)*degps;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_degps;

    function to_degps2 "Convert from radian per second squared to degree per second squared"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.AngularAcceleration radps2 "Value in radian per second squared";
      output NonSI.AngularAcceleration_degps2 degps2 "Value in degree per second squared";
    algorithm
      degps2 := (180/Modelica.Constants.pi)*radps2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_degps2;

    function from_degps2 "Convert from degree per second squared to radian per second squared"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.AngularAcceleration_degps2 degps2 "Value in degree per second squared";
      output Modelica.Units.SI.AngularAcceleration radps2 "Value in radian per second squared";
    algorithm
      radps2 := (Modelica.Constants.pi/180)*degps2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_degps2;

    function to_lpmin "Convert from cubic metre per second to litre per minute"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.VolumeFlowRate m3ps "Value in cubic metre per second";
      output NonSI.VolumeFlowRate_lpmin lpmin "Value in litre per minute";
    algorithm
      lpmin := 60000*m3ps;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_lpmin;

    function from_lpmin "Convert from litre per minute to cubic metre per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.VolumeFlowRate_lpmin lpmin "Value in litre per minute";
      output Modelica.Units.SI.VolumeFlowRate m3ps "Value in cubic metre per second";
    algorithm
      m3ps := (1/60000)*lpmin;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_lpmin;

    function to_m3ph "Convert from cubic metre per second to cubic metre per hour"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.VolumeFlowRate m3ps "Value in cubic metre per second";
      output NonSI.VolumeFlowRate_m3ph m3ph "Value in cubic metre per hour";
    algorithm
      m3ph := 3600*m3ps;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_m3ph;

    function from_m3ph "Convert from cubic metre per hour to cubic metre per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.VolumeFlowRate_m3ph m3ph "Value in cubic metre per hour";
      output Modelica.Units.SI.VolumeFlowRate m3ps "Value in cubic metre per second";
    algorithm
      m3ps := (1/3600)*m3ph;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_m3ph;

    function to_kJpkg "Convert from joule per kilogram to kilojoule per kilogram"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.SpecificEnergy Jpkg "Value in joule per kilogram";
      output NonSI.SpecificEnergy_kJpkg kJpkg "Value in kilojoule per kilogram";
    algorithm
      kJpkg := (1/1000)*Jpkg;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kJpkg;

    function from_kJpkg "Convert from kilojoule per kilogram to joule per kilogram"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.SpecificEnergy_kJpkg kJpkg "Value in kilojoule per kilogram";
      output Modelica.Units.SI.SpecificEnergy Jpkg "Value in joule per kilogram";
    algorithm
      Jpkg := 1000*kJpkg;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kJpkg;

    function to_gpkg "Convert from kilogram per kilogram to gram per kilogram"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Media.Interfaces.Types.MassFraction kgpkg "Value in kilogram per kilogram";
      output NonSI.MassFraction_gpkg gpkg "Value in gram per kilogram";
    algorithm
      gpkg := 1000*kgpkg;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_gpkg;

    function from_gpkg "Convert from gram per kilogram to kilogram per kilogram"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.MassFraction_gpkg gpkg "Value in gram per kilogram";
      output Modelica.Media.Interfaces.Types.MassFraction kgpkg "Value in kilogram per kilogram";
    algorithm
      kgpkg := (1/1000)*gpkg;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_gpkg;

    function to_mH "Convert from henry to millihenry"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Inductance H "Value in henry";
      output NonSI.Inductance_mH mH "Value in millihenry";
    algorithm
      mH := 1000*H;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mH;

    function from_mH "Convert from millihenry to henry"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Inductance_mH mH "Value in millihenry";
      output Modelica.Units.SI.Inductance H "Value in henry";
    algorithm
      H := (1/1000)*mH;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mH;

    function to_uH "Convert from henry to microhenry"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Inductance H "Value in henry";
      output NonSI.Inductance_uH uH "Value in microhenry";
    algorithm
      uH := 1000000*H;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_uH;

    function from_uH "Convert from microhenry to henry"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Inductance_uH uH "Value in microhenry";
      output Modelica.Units.SI.Inductance H "Value in henry";
    algorithm
      H := (1/1000000)*uH;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_uH;

    function to_mWb "Convert from weber to milliweber"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.MagneticFlux Wb "Value in weber";
      output NonSI.MagneticFlux_mWb mWb "Value in milliweber";
    algorithm
      mWb := 1000*Wb;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mWb;

    function from_mWb "Convert from milliweber to weber"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.MagneticFlux_mWb mWb "Value in milliweber";
      output Modelica.Units.SI.MagneticFlux Wb "Value in weber";
    algorithm
      Wb := (1/1000)*mWb;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mWb;

    function to_kOhm "Convert from ohm to kilohm"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Resistance Ohm "Value in ohm";
      output NonSI.Resistance_kOhm kOhm "Value in kilohm";
    algorithm
      kOhm := (1/1000)*Ohm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kOhm;

    function from_kOhm "Convert from kilohm to ohm"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Resistance_kOhm kOhm "Value in kilohm";
      output Modelica.Units.SI.Resistance Ohm "Value in ohm";
    algorithm
      Ohm := 1000*kOhm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kOhm;

    function to_MOhm "Convert from ohm to megohm"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Resistance Ohm "Value in ohm";
      output NonSI.Resistance_MOhm MOhm "Value in megohm";
    algorithm
      MOhm := (1/1000000)*Ohm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_MOhm;

    function from_MOhm "Convert from megohm to ohm"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Resistance_MOhm MOhm "Value in megohm";
      output Modelica.Units.SI.Resistance Ohm "Value in ohm";
    algorithm
      Ohm := 1000000*MOhm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_MOhm;

    function to_mOhm "Convert from ohm to milliohm"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Resistance Ohm "Value in ohm";
      output NonSI.Resistance_mOhm mOhm "Value in milliohm";
    algorithm
      mOhm := 1000*Ohm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mOhm;

    function from_mOhm "Convert from milliohm to ohm"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Resistance_mOhm mOhm "Value in milliohm";
      output Modelica.Units.SI.Resistance Ohm "Value in ohm";
    algorithm
      Ohm := (1/1000)*mOhm;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mOhm;

    function to_uF "Convert from farad to microfarad"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Capacitance F "Value in farad";
      output NonSI.Capacitance_uF uF "Value in microfarad";
    algorithm
      uF := 1000000*F;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_uF;

    function from_uF "Convert from microfarad to farad"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Capacitance_uF uF "Value in microfarad";
      output Modelica.Units.SI.Capacitance F "Value in farad";
    algorithm
      F := (1/1000000)*uF;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_uF;

    function to_nF "Convert from farad to nanofarad"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Capacitance F "Value in farad";
      output NonSI.Capacitance_nF nF "Value in nanofarad";
    algorithm
      nF := 1000000000*F;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_nF;

    function from_nF "Convert from nanofarad to farad"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Capacitance_nF nF "Value in nanofarad";
      output Modelica.Units.SI.Capacitance F "Value in farad";
    algorithm
      F := (1/1000000000)*nF;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_nF;

    function to_pF "Convert from farad to picofarad"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Capacitance F "Value in farad";
      output NonSI.Capacitance_pF pF "Value in picofarad";
    algorithm
      pF := 1000000000000*F;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_pF;

    function from_pF "Convert from picofarad to farad"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Capacitance_pF pF "Value in picofarad";
      output Modelica.Units.SI.Capacitance F "Value in farad";
    algorithm
      F := (1/1000000000000)*pF;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_pF;

    function to_kVA "Convert from volt-ampere to kilovolt-ampere"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.ApparentPower VA "Value in volt-ampere";
      output NonSI.ApparentPower_kVA kVA "Value in kilovolt-ampere";
    algorithm
      kVA := (1/1000)*VA;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kVA;

    function from_kVA "Convert from kilovolt-ampere to volt-ampere"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.ApparentPower_kVA kVA "Value in kilovolt-ampere";
      output Modelica.Units.SI.ApparentPower VA "Value in volt-ampere";
    algorithm
      VA := 1000*kVA;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kVA;

    function to_kvar "Convert from var to kilovar"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.ReactivePower var "Value in var";
      output NonSI.ReactivePower_kvar kvar "Value in kilovar";
    algorithm
      kvar := (1/1000)*var;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kvar;

    function from_kvar "Convert from kilovar to var"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.ReactivePower_kvar kvar "Value in kilovar";
      output Modelica.Units.SI.ReactivePower var "Value in var";
    algorithm
      var := 1000*kvar;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kvar;

    function to_kJpkgK "Convert from joule per kilogram kelvin to kilojoule per kilogram kelvin"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.SpecificHeatCapacity J_kgK "Value in joule per kilogram kelvin";
      output NonSI.SpecificHeatCapacity_kJpkgK kJ_kgK "Value in kilojoule per kilogram kelvin";
    algorithm
      kJ_kgK := (1/1000)*J_kgK;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_kJpkgK;

    function from_kJpkgK "Convert from kilojoule per kilogram kelvin to joule per kilogram kelvin"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.SpecificHeatCapacity_kJpkgK kJ_kgK "Value in kilojoule per kilogram kelvin";
      output Modelica.Units.SI.SpecificHeatCapacity J_kgK "Value in joule per kilogram kelvin";
    algorithm
      J_kgK := 1000*kJ_kgK;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_kJpkgK;

    function to_gpcm3 "Convert from kilogram per cubic metre to gram per cubic centimetre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Density kg_m3 "Value in kilogram per cubic metre";
      output NonSI.Density_gpcm3 g_cm3 "Value in gram per cubic centimetre";
    algorithm
      g_cm3 := (1/1000)*kg_m3;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_gpcm3;

    function from_gpcm3 "Convert from gram per cubic centimetre to kilogram per cubic metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Density_gpcm3 g_cm3 "Value in gram per cubic centimetre";
      output Modelica.Units.SI.Density kg_m3 "Value in kilogram per cubic metre";
    algorithm
      kg_m3 := 1000*g_cm3;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_gpcm3;

    function to_mPas "Convert from pascal second to millipascal second"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.DynamicViscosity Pas "Value in pascal second";
      output NonSI.DynamicViscosity_mPas mPas "Value in millipascal second";
    algorithm
      mPas := 1000*Pas;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mPas;

    function from_mPas "Convert from millipascal second to pascal second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.DynamicViscosity_mPas mPas "Value in millipascal second";
      output Modelica.Units.SI.DynamicViscosity Pas "Value in pascal second";
    algorithm
      Pas := (1/1000)*mPas;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mPas;

    function to_cm2 "Convert from square metre to square centimetre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Area m2 "Value in square metre";
      output NonSI.Area_cm2 cm2 "Value in square centimetre";
    algorithm
      cm2 := 10000*m2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_cm2;

    function from_cm2 "Convert from square centimetre to square metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Area_cm2 cm2 "Value in square centimetre";
      output Modelica.Units.SI.Area m2 "Value in square metre";
    algorithm
      m2 := (1/10000)*cm2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_cm2;

    function to_mm2 "Convert from square metre to square millimetre"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.Area m2 "Value in square metre";
      output NonSI.Area_mm2 mm2 "Value in square millimetre";
    algorithm
      mm2 := 1000000*m2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mm2;

    function from_mm2 "Convert from square millimetre to square metre"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.Area_mm2 mm2 "Value in square millimetre";
      output Modelica.Units.SI.Area m2 "Value in square metre";
    algorithm
      m2 := (1/1000000)*mm2;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mm2;

    function to_mT "Convert from tesla to millitesla"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.MagneticFluxDensity T "Value in tesla";
      output NonSI.MagneticFluxDensity_mT mT "Value in millitesla";
    algorithm
      mT := 1000*T;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_mT;

    function from_mT "Convert from millitesla to tesla"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.MagneticFluxDensity_mT mT "Value in millitesla";
      output Modelica.Units.SI.MagneticFluxDensity T "Value in tesla";
    algorithm
      T := (1/1000)*mT;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_mT;

    function to_barps "Convert from pascal per second to bar per second"
      extends Modelica.Units.Icons.Conversion;
      input Modelica.Units.SI.PressureSlope Pa_s "Value in pascal per second";
      output NonSI.PressureSlope_barps bar_s "Value in bar per second";
    algorithm
      bar_s := (1/100000)*Pa_s;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end to_barps;

    function from_barps "Convert from bar per second to pascal per second"
      extends Modelica.Units.Icons.Conversion;
      input NonSI.PressureSlope_barps bar_s "Value in bar per second";
      output Modelica.Units.SI.PressureSlope Pa_s "Value in pascal per second";
    algorithm
      Pa_s := 100000*bar_s;
      annotation (Inline=true, Documentation(info="<html><p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p></html>"));
    end from_barps;

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
