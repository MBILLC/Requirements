within Requirements;
package Internal "Library of internal components (should not be directly used)"
   extends Modelica.Icons.InternalPackage;
  connector SortingPort
    "Connector used to force a particular ordering of equations and to pass information about satisfied requirements"

     Real dummy1 annotation(HideResult=true);
     Real dummy2 annotation(HideResult=true);
     flow Real status "Return 0 (Violated), 1 (Untested), ... 2 (Satisfied)" annotation(HideResult=true);
     flow Real one "Return 1 (to calculate number of requirement blocks"  annotation(HideResult=true);
  end SortingPort;

  impure function initializeLogFile
    "Initialize log file (remove existing file and add a blank line"
     input String logFile;
     input Real dummyInput;
     output Real dummy "Dummy value to control sorting of equations";
  algorithm
     // Remove file, if it exists
     Modelica.Utilities.Files.removeFile(logFile);

     // Generate log file and store an empty line
     Modelica.Utilities.Streams.print(" ", logFile);
     dummy :=1.0;
  annotation(__iti_Impure = true);
  end initializeLogFile;

  impure function printViolationsToLogFile
    "Print information about one requirement to log file"
     import Modelica.Utilities.Streams.print;
     input String logFile "Name of log file";
     input String checkedComponentName "Full path name of checked component";
     input String requirementName "Full path name of requirement model";
     input String requirementText "Text of requirement";
     input Boolean atLeastOneFailure
      "= true, if requirement is violated (at least one failure)";
     input Boolean untested
      "= true, if requirement is untested, otherwise requirement is tested and satisfied";
    input Modelica.Units.SI.Time firstFailureTime
      "Time instant of first failure (if atLeastOneFailure=true)";
     input Integer attempts = 1
      "Number of phases in which the property was applicable (not Undefined)";
     output Real ok "Dummy variable needed for sorting";
  protected
     String text = Modelica.Utilities.Strings.replace(requirementText,"\n"," ");
  algorithm
     // One line per requirement: <verdict>,<observation>,<requirement>[,<first failure time>],<attempts>,<text>
     if atLeastOneFailure then
        print("Violated," + checkedComponentName +
              "," + requirementName +
              "," + String(firstFailureTime) +
              "," + String(attempts) +
              "," + text,
              logFile);

     elseif untested then
        print("Untested," + checkedComponentName +
              "," + requirementName +
              "," + String(attempts) +
              "," + text,
              logFile);
     else
        print("Satisfied," + checkedComponentName +
              "," + requirementName +
              "," + String(attempts) +
              "," + text,
              logFile);
     end if;
     ok := 1.0;
  annotation(__iti_Impure = true);
  end printViolationsToLogFile;

  impure function printViolationsToOutput
    "Print violated, untested and satisfied requirements to output window"
     import Modelica.Utilities.Streams.*;
     import Modelica.Utilities.Strings.*;
     import Requirements.Internal.*;

     input String logFile "Name of log file where the data is present";
     input String htmlFile
      "Name of html file where log shall be written in a nicely formatted form";
     input String rootName "Name of root model (used to print heading)";
     input Real ok
      "Only provided to guarantee that printViolationsToOutput is called after logFile was generated";
     input Real satisfaction
      "Satisfaction of all requirements in % (0% ... 100%)";
    input Modelica.Units.SI.Time satisfactionTime
      "Input satisfaction is with respect to satisfactionTime";
     input Boolean printViolated = true
      "= true, if violated requirements shall be printed";
     input Boolean printUntested = true
      "= true, if untested requirements shall be printed";
     input Boolean printSatisfied = true
      "= true, if satisfied requirements shall be printed";
  protected
     Integer nLines(min=1) = countLines(logFile);
     String violated[ nLines-1]=fill("", nLines-1);
     String untested[ nLines-1]=fill("", nLines-1);
     String satisfied[nLines-1]=fill("", nLines-1);
     String line;
     String element;
     String instance;
     String reqName;
     String reqTime;
     String reqText;
     String attempts;
     Integer nViolated=0;
     Integer nUntested=0;
     Integer nSatisfied=0;
     Integer nRequirements;
     Integer index;
     String  fullHtmlFile=Modelica.Utilities.Files.fullPathName(htmlFile);
  algorithm
     // Parse file
     for i in  2:nLines loop
        // Read next line
        line := readLine(logFile, i);

        // Extract type of requirement
        (element, line) := removeFirstElement(line);
        if element=="Violated" then
           nViolated := nViolated + 1;
           violated[nViolated] :=line;
        elseif element=="Untested" then
           nUntested := nUntested + 1;
           untested[nUntested] :=line;
        elseif element=="Satisfied" then
           nSatisfied := nSatisfied + 1;
           satisfied[nSatisfied] :=line;
        end if;
     end for;
     close(logFile);
     nRequirements :=nViolated + nUntested + nSatisfied;

     // Remove html file, if it exists
     print("... HTML log: " + fullHtmlFile);
     Modelica.Utilities.Files.removeFile(htmlFile);

     // Print html heading
  print("<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta content=\"text/html; charset=utf-8\" http-equiv=\"content-type\">
  <title>Requirements log</title>
  <style type=\"text/css\">
    *     {font-size: 11pt; font-family: Arial,sans-serif; }
    table {margin: 14px 0 14px 40px; border: 0px solid rgb(200, 200, 200); border-collapse: collapse; page-break-inside: avoid; }
    td, th{border: 1px solid rgb(200, 200, 200); vertical-align: top; padding: 4px; line-height: 1.2;}
    h1    {font-size: 12pt; color:darkgreen;}
    h2    {margin: 15px 0 10px 20px;}
    p     {margin-left: 40px;}
  </style>
</head><body>",   htmlFile);

     // Print heading
     print("\n-------- " + String(satisfaction,format="3.1f") +
           " % of " + rootName + " requirements are satisfied at time = " +
           String(satisfactionTime) + " s -------------");
     print("\n<h1>" + String(satisfaction,format="3.1f") +
           " % of " + rootName + " requirements are satisfied at time = " +
           String(satisfactionTime) + " s</h1>", htmlFile);

     // Print file to output window
     if printViolated then
        print("Requirements violated ("       + String(nViolated) + " of "
                                              + String(nRequirements) + "):");
        print("\n<h2>Requirements violated (" + String(nViolated) + " of "
                                              + String(nRequirements) + ")</h2>", htmlFile);
        if nViolated == 0 then
           print("   None");
           print("\n<p>None</p>", htmlFile);
        else
           print("\n<table>\n" +
                 "<tr style=\"background-color:rgb(230, 230, 230);\">\n" +
                 "    <td>Observation</td>\n" +
                 "    <td>Requirement</td>\n" +
                 "    <td align=\"right\">First violation at</td>\n"+
                 "    <td align=\"right\">Attempts</td>\n"+
                 "    <td>Description</td>\n" +
                 "    </tr>", htmlFile);

           for i in 1:nViolated loop
              (instance,reqName,reqText,reqTime,attempts) :=getElements(violated[i], true);
              print("<tr><td>" + instance + "</td>\n" +
                    "    <td>" + reqName  + "</td>\n" +
                    "    <td align=\"right\">" + reqTime + " s</td>\n" +
                    "    <td align=\"right\">" + attempts + "</td>\n" +
                    "    <td>" + reqText  + "</td>\n" +
                    "    </tr>", htmlFile);
              if reqText<>"" then
                 reqText :=": " + reqText;
              end if;
              print("   " + instance + " (" + reqName + " first violation at " + reqTime + " s, " + attempts + " attempts)" + reqText);
           end for;
           print("</table>", htmlFile);
        end if;
        print("");
     end if;

     if printUntested then
        print("Requirements untested ("       + String(nUntested) + " of "
                                              + String(nRequirements) + "):");
        print("\n<h2>Requirements untested (" + String(nUntested) + " of "
                                              + String(nRequirements) + ")</h2>", htmlFile);

        if nUntested == 0 then
           print("   None");
           print("\n<p>None</p>", htmlFile);
        else
           print("\n<table>\n" +
                 "<tr style=\"background-color:rgb(230, 230, 230);\">\n" +
                 "    <td>Observation</td>\n" +
                 "    <td>Requirement</td>\n" +
                 "    <td align=\"right\">Attempts</td>\n" +
                 "    <td>Description</td>\n" +
                 "    </tr>", htmlFile);

           for i in 1:nUntested loop
              (instance,reqName,reqText,reqTime,attempts) :=getElements(untested[i], false);
              print("<tr><td>" + instance + "</td>\n" +
                    "    <td>" + reqName  + "</td>\n" +
                    "    <td align=\"right\">" + attempts + "</td>\n" +
                    "    <td>" + reqText  + "</td>\n" +
                    "    </tr>", htmlFile);

              if reqText<>"" then
                 reqText :=": " + reqText;
              end if;
              print("   " + instance + " (" + reqName + ", " + attempts + " attempts)" + reqText);
           end for;
           print("</table>", htmlFile);
        end if;
        print("");
     end if;

     if printSatisfied then
        print("Requirements satisfied ("       + String(nSatisfied) + " of "
                                               + String(nRequirements) + "):");
        print("\n<h2>Requirements satisfied (" + String(nSatisfied) + " of "
                                               + String(nRequirements) + ")</h2>", htmlFile);

        if nSatisfied == 0 then
           print("   None");
           print("\n<p>None</p>", htmlFile);
        else
           print("\n<table>\n" +
                 "<tr style=\"background-color:rgb(230, 230, 230);\">\n" +
                 "    <td>Observation</td>\n" +
                 "    <td>Requirement</td>\n" +
                 "    <td align=\"right\">Attempts</td>\n" +
                 "    <td>Description</td>\n" +
                 "    </tr>", htmlFile);

           for i in 1:nSatisfied loop
              (instance,reqName,reqText,reqTime,attempts) :=getElements(satisfied[i], false);
              print("<tr><td>" + instance + "</td>\n" +
                    "    <td>" + reqName  + "</td>\n" +
                    "    <td align=\"right\">" + attempts + "</td>\n" +
                    "    <td>" + reqText  + "</td>\n" +
                    "    </tr>", htmlFile);
              if reqText<>"" then
                 reqText :=": " + reqText;
              end if;
              print("   " + instance + " (" + reqName + ", " + attempts + " attempts)" + reqText);
           end for;
           print("</table>", htmlFile);
        end if;
     end if;

     print("");

     // Close html file
     print("</body></html>", htmlFile);

  annotation(__iti_Impure = true);
  end printViolationsToOutput;

  function removeFirstName "Remove first name of a Modelica path name"
     import Modelica.Utilities.Strings.*;
     input String path;
     output String tail
      "= path where part upto first \".\" is removed (if \".\" not present, tail=path)";
  protected
     Integer startIndex;
     Integer endIndex;
  algorithm
     startIndex :=find(path, ".");
     endIndex :=length(path);
     if startIndex == 0 or endIndex <= startIndex then
        tail :=path;
     else
        tail :=substring(path, startIndex + 1,  endIndex);
     end if;
  end removeFirstName;

  function getFirstName "Get first name of a Modelica path name"
     import Modelica.Utilities.Strings.*;
     input String path;
     output String head
      "= path upto but not including the first \".\" (if \".\" not present, head=path)";
  protected
     Integer startIndex;
     Integer endIndex;
  algorithm
     startIndex :=find(path, ".");
     if startIndex == 0 then
        head :=path;
     elseif startIndex == 1 then
        head := "";
     else
        head :=substring(path, 1,  startIndex-1);
     end if;
  end getFirstName;

  function removeFirstElement
    "Remove first part of one line of the log file (until \",\")"
     import Modelica.Utilities.Strings.*;
     input String line "One line of log file";
     output String element "Removed element (without ',')";
     output String updatedLine
      "= path where part upto first \",\" is removed (if \",\" not present, updatedLine=line)";
  protected
     Integer startIndex;
     Integer endIndex;
  algorithm
     startIndex :=find(line, ",");
     if startIndex == 0 then
        element :=line;
        updatedLine :="";
     else
       if startIndex == 1 then
          element:="";
       else
          element := substring(line,1,startIndex-1);
       end if;

       endIndex :=length(line);
       if endIndex > startIndex then
          updatedLine :=substring(line, startIndex + 1,  endIndex);
       else
          updatedLine :="";
       end if;
     end if;
  end removeFirstElement;

  function getElements "Extract the elements from a log line"
    import Modelica.Utilities.Strings.*;
    input String line;
    input Boolean violated "=true, if violated requirement";
    output String checkedComponentName "Full path name of checked component";
    output String requirementName "Last name of requirement model";
    output String requirementText "Text of requirement";
    output String firstFailureTime
      "Time instant of first failure (if violated=true; otherwise dummy";
    output String attempts "Number of phases in which the property was applicable";
  protected
     String line2;
     String reqFullName;
     Integer startIndex;
     Integer len;
  algorithm
     (checkedComponentName, line2) :=removeFirstElement(line);
     (reqFullName, line2) := removeFirstElement(line2);
     if violated then
        (firstFailureTime, line2) :=removeFirstElement(line2);
     else
        firstFailureTime:="???";
     end if;
     (attempts, line2) :=removeFirstElement(line2);
     requirementText :=line2;

     // Remove first two names from reqFullName
     /*
   requirementName := reqFullName;
   startIndex :=find(reqFullName, ".");
   len :=length(reqFullName);
   if startIndex > 0 and startIndex < len then
      startIndex := find(reqFullName, ".", startIndex+1);
      if startIndex > 0 then
         startIndex :=startIndex + 1;
         if startIndex <= len then
            requirementName := substring(reqFullName, startIndex, len);
         end if;
      end if;
    end if;
    */
     // Remove first name from reqFullName
     requirementName := reqFullName;
     startIndex :=find(reqFullName, ".");
     len :=length(reqFullName);
     if startIndex > 0 and startIndex < len then
        startIndex :=startIndex + 1;
        if startIndex <= len then
           requirementName := substring(reqFullName, startIndex, len);
        end if;
      end if;
  end getElements;

  package SlidingWindow
     extends Modelica.Icons.Package;
     constant Integer nBuffer = 20 "Length of buffer";
     record Buffer "Memory of sliding window"
      Modelica.Units.SI.Time T "Length of sliding window";
      Modelica.Units.SI.Time t0 "Time instant where sliding time window starts";
      Modelica.Units.SI.Time t[nBuffer] "Time instants";
        Boolean b[nBuffer] "Values at corresponding time instants";
        Integer first "Index of first element in buffer";
        Integer last "Index of last element in buffer";
        Integer nElem "Number of elements in the buffer";
     end Buffer;

     function init "Initialize a sliding window buffer"
      input Modelica.Units.SI.Time T "Length of window";
      input Modelica.Units.SI.Time t0 "Initial time instant";
        output Buffer buffer = Buffer(T=T, t0=t0, t=fill(0, nBuffer), b=fill(false, nBuffer), first=0, last=0, nElem=0) "Initialized buffer";
     algorithm
     end init;

     impure function push
      "Store an element on the sliding window buffer and remove elements that are older as the window length"
        import Modelica.Utilities.Streams.print;
        input Buffer buffer "Memory of sliding window";
        input Real t "Time instant of v to be stored in buffer";
        input Boolean b=false
        "Value b at time instant t to be stored in buffer";
        output Buffer newBuffer "Updated memory of sliding window";
    protected
        constant Real eps = 1000*Modelica.Constants.eps;
      Modelica.Units.SI.Time tOld=t - (1 - eps)*buffer.T;
        Integer first = buffer.first;
        Integer last = buffer.last;
        Integer nElem = buffer.nElem;
        Boolean finished=false;
        Integer i = 0;
     algorithm
        // Remove old values from buffer
        if nElem > 0 then
          if last > first then
             i :=last;
             while i <= nBuffer loop
                if buffer.t[i] <= tOld then
                   i :=i + 1;
                   nElem :=nElem - 1;
                else
                   finished :=true;
                   break;
                end if;
             end while;
             last :=if i > nBuffer then 1 else i;
           end if;

          if not finished then
             i :=last;
             while i <= first loop
                if buffer.t[i] <= tOld then
                   i :=i + 1;
                   nElem :=nElem - 1;
                 else
                   break;
                 end if;
              end while;
          end if;

          if nElem > 0 then
             last :=i;
          else
             first :=0;
             last :=0;
          end if;
        end if;

        // Print warning if buffer too small
        if nElem >= nBuffer then
           print("... warning: buffer of sliding window too small at time = " +String(t) + " s (results will be for smaller sliding time window)");
        end if;

        // Store time and value in buffer
        newBuffer :=buffer;
        if nElem > 0 then
           first :=if first + 1 <= nBuffer then first + 1 else 1;
        else
           first :=1;
           last :=1;
        end if;
        nElem :=nElem + 1;
        newBuffer.first :=first;
        newBuffer.last :=last;
        newBuffer.nElem :=nElem;
        newBuffer.t[first] :=t;
        newBuffer.b[first] :=b;
        annotation(__iti_Impure = true);
     end push;

     function removeOldest
      "Remove all elements from the buffer that are about to leave the sliding time window"
        input Buffer buffer "Memory of sliding window";
        input Real t "Actual time instant";
        output Buffer newBuffer "Updated memory of sliding window";
    protected
        constant Real eps = 1000*Modelica.Constants.eps;
      Modelica.Units.SI.Time tOld=t - (1 - eps)*buffer.T;
        Integer first = buffer.first;
        Integer last = buffer.last;
        Integer nElem = buffer.nElem;
        Boolean finished=false;
        Integer i = 0;
     algorithm
        // Remove old values from buffer
        if nElem > 0 then
          if last > first then
             i :=last;
             while i <= nBuffer loop
                if buffer.t[i] <= tOld then
                   i :=i + 1;
                   nElem :=nElem - 1;
                else
                   finished :=true;
                   break;
                end if;
             end while;
             last :=if i > nBuffer then 1 else i;
          end if;

          if not finished then
             i :=last;
             while i <= first loop
                if buffer.t[i] <= tOld then
                   i :=i + 1;
                   nElem :=nElem - 1;
                 else
                   break;
                 end if;
              end while;
          end if;

          if nElem > 0 then
             last :=i;
          else
             first :=0;
             last :=0;
          end if;
       end if;

       newBuffer :=buffer;
       newBuffer.first :=first;
       newBuffer.last :=last;
       newBuffer.nElem :=nElem;
     end removeOldest;

     function nextLeaving
      "Return time instant when the oldest element is leaving the buffer"
        input Buffer buffer "Memory of sliding window";
        input Real t "Actual time instant";
      output Modelica.Units.SI.Time t_next
        "Next time instant where the oldest value (t,b) in the buffer is leaving the time window";
     algorithm
        t_next :=if buffer.nElem > 0 then buffer.t[buffer.last] + buffer.T else
                                          t - buffer.T - buffer.T;
        annotation(Inline=true);
     end nextLeaving;

     function firstValue "Returns the newest value"
        input Buffer buffer "Memory of sliding window";
        output Boolean b "Newest value";
     algorithm
        assert(buffer.nElem > 0, "No value in buffer");
        b := buffer.b[buffer.first];
     end firstValue;

     function lastValue "Returns the oldest value"
        input Buffer buffer "Memory of sliding window";
        output Boolean b "Newest value";
     algorithm
        assert(buffer.nElem > 0, "No value in buffer");
        b := buffer.b[buffer.last];
     end lastValue;

     function indexValue "Returns the value at buffer index"
        input Buffer buffer "Memory of sliding window";
        input Integer index(min=1)
        "Index of time value (index >= 1; index=1: first)";
        output Boolean b "Value at buffer index";
    protected
        Integer first = buffer.first;
        Integer nElem = buffer.nElem;
     algorithm
        assert(index >= 1 and index <= nElem, "Index not in range 1 ... buffer.nElem");

        if first >= index then
           b :=buffer.b[first - index + 1];
        else
           b :=buffer.b[nBuffer - (index - first) + 1];
        end if;
     end indexValue;

     function indexTime "Returns the time value at buffer index"
        input Buffer buffer "Memory of sliding window";
        input Integer index(min=1)
        "Index of time value (index >= 1; index=1: first)";
      output Modelica.Units.SI.Time t "Time value at index of buffer";
    protected
        Integer first = buffer.first;
        Integer nElem = buffer.nElem;
     algorithm
        assert(index >= 1 and index <= nElem, "Index not in range 1 ... buffer.nElem");

        if first >= index then
           t :=buffer.t[first - index + 1];
        else
           t :=buffer.t[nBuffer - (index - first) + 1];
        end if;
     end indexTime;

     function numberOfValues "Returns the number of values in the buffer"
        input Buffer buffer "Memory of sliding window";
        output Integer result "Number of values in the buffer";
     algorithm
        result :=buffer.nElem;
        annotation(Inline=true);
     end numberOfValues;

     function maxDuration
      "Returns the maximum duration where buffer value is true in the sliding time window"
        input Buffer buffer "Memory of sliding window";
      input Modelica.Units.SI.Time t "Actual time instant";
        input Boolean b = false
        "Actual value at t (used if no element is in the buffer)";
      output Modelica.Units.SI.Time duration
        "Maximum duration where buffer value is true in window";
    protected
      Modelica.Units.SI.Time T=buffer.T;
      Modelica.Units.SI.Time t1;
      Modelica.Units.SI.Time t2;
        Integer nElem = buffer.nElem;
        Integer iStart;
     algorithm
        if nElem < 1 then
           duration :=if b then min(T, t-buffer.t0) else 0;
           return;
        end if;

        if firstValue(buffer) then
           t1 :=indexTime(buffer, 1);
           duration :=max(0, min(t - t1, T));
           iStart :=3;
        else
           duration :=0;
           iStart :=2;
        end if;

        for i in iStart:2:nElem loop
           assert( not indexValue(buffer,i - 1) and indexValue(buffer,i), "Values in buffer not correct");
           t1 :=indexTime(buffer, i - 1);
           t2 :=indexTime(buffer, i);
           if t1 <= t - T then
              return;
           end if;
           if t2 > t - T then
              duration := max(duration, t1-t2);
           else
              duration := max(duration, t1-(t-T));
              return;
           end if;
        end for;

        if not lastValue(buffer) then
           t1 :=indexTime(buffer, nElem);
           t2 :=max(buffer.t0, t - T);
           if t1 > t2 then
              duration :=max(duration, t1 - t2);
           end if;
        end if;
     end maxDuration;

     function accumulatedDuration
      "Returns the accumulated duration where buffer value is true in the sliding time window"
        input Buffer buffer "Memory of sliding window";
      input Modelica.Units.SI.Time t "Actual time instant";
        input Boolean b = false
        "Actual value at t (used if no element is in the buffer)";
      output Modelica.Units.SI.Time duration
        "Accumulated duration where buffer value is true in window";
    protected
      Modelica.Units.SI.Time T=buffer.T;
      Modelica.Units.SI.Time t1;
      Modelica.Units.SI.Time t2;
        Integer nElem = buffer.nElem;
        Integer iStart;
     algorithm
        if nElem < 1 then
           duration :=if b then min(T, t-buffer.t0) else 0;
           return;
        end if;

        if firstValue(buffer) then
           t1 :=indexTime(buffer, 1);
           duration :=max(0, min(t - t1, T));
           iStart :=3;
        else
           duration :=0;
           iStart :=2;
        end if;

        for i in iStart:2:nElem loop
           assert( not indexValue(buffer,i - 1) and indexValue(buffer,i), "Values in buffer not correct");
           t1 :=indexTime(buffer, i - 1);
           t2 :=indexTime(buffer, i);
           if t1 <= t - T then
              return;
           end if;
           if t2 > t - T then
              duration := duration + (t1-t2);
           else
              duration := duration + (t1-(t-T));
              return;
           end if;
        end for;

        if not lastValue(buffer) then
           t1 :=indexTime(buffer, nElem);
           t2 :=max(buffer.t0, t - T);
           if t1 > t2 then
              duration := duration + (t1 - t2);
           end if;
        end if;
     end accumulatedDuration;
  end SlidingWindow;

  package TestSlidingWindow
     extends Modelica.Icons.Package;

    function testMinDuration
       import Modelica.Utilities.Streams.print;

    protected
       SlidingWindow.Buffer buffer;
      Modelica.Units.SI.Time duration;
       constant Real eps = 1e-10;
    algorithm
       buffer :=SlidingWindow.init(4, 0);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 2.1, false);
       buffer :=SlidingWindow.push(buffer, 3.2, true);
       buffer :=SlidingWindow.push(buffer, 4.5, false);
       buffer :=SlidingWindow.push(buffer, 5.3, true);
       buffer :=SlidingWindow.push(buffer, 6.4, false);
       buffer :=SlidingWindow.removeOldest(buffer, 6.5);
       duration :=SlidingWindow.maxDuration(buffer, 6.7);
       print("1: duration = " + String(duration) + " (should be 1.3 s)");
       assert( abs(duration - 1.3)<=eps, "1: Wrong duration");

       buffer :=SlidingWindow.init(4, 0);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 3.2, false);
       buffer :=SlidingWindow.push(buffer, 4.5, true);
       buffer :=SlidingWindow.push(buffer, 5.3, false);
       buffer :=SlidingWindow.push(buffer, 5.5, true);
       buffer :=SlidingWindow.removeOldest(buffer, 5.6);

       duration :=SlidingWindow.maxDuration(buffer, 5.7);
       print("2: duration = " + String(duration) + " (should be 1.5 s)");
       assert( abs(duration - 1.5)<=eps, "2: Wrong duration");

       duration :=SlidingWindow.maxDuration(buffer, 9.7);
       print("3: duration = " + String(duration) + " (should be 4 s)");
       assert( abs(duration - 4)<=eps, "3: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       duration :=SlidingWindow.maxDuration(buffer, 1.0, true);
       print("4: duration = " + String(duration) + " (should be 0 s)");
       assert( abs(duration)<=eps, "4: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 3.0, false);
       buffer :=SlidingWindow.removeOldest(buffer, 4.0);

       duration :=SlidingWindow.maxDuration(buffer, 4.0, false);
       print("5: duration = " + String(duration) + " (should be 1 s)");
       assert( abs(duration - 1.0)<=eps, "5: Wrong duration");

       duration :=SlidingWindow.maxDuration(buffer, 4.1, false);
       print("6: duration = " + String(duration) + " (should be 0.9 s)");
       assert( abs(duration - 0.9)<=eps, "6: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);

       duration :=SlidingWindow.maxDuration(buffer, 2.5, true);
       print("7: duration = " + String(duration) + " (should be 1.5 s)");
       assert( abs(duration - 1.5)<=eps, "7: Wrong duration");
    annotation(__iti_Impure = true);
    end testMinDuration;

    function testAccumulatedDuration
       import Modelica.Utilities.Streams.print;

    protected
       SlidingWindow.Buffer buffer;
      Modelica.Units.SI.Time duration;
       constant Real eps = 1e-10;
    algorithm
       buffer :=SlidingWindow.init(4, 0);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 2.1, false);
       buffer :=SlidingWindow.push(buffer, 3.2, true);
       buffer :=SlidingWindow.push(buffer, 4.5, false);
       buffer :=SlidingWindow.push(buffer, 5.3, true);
       buffer :=SlidingWindow.push(buffer, 6.4, false);
       buffer :=SlidingWindow.removeOldest(buffer, 6.5);

       // 6.4-5.3 + 4.5-3.2
       duration :=SlidingWindow.accumulatedDuration(buffer, 6.7);
       print("1: duration = " + String(duration) + " (should be 2.4 s)");
       assert( abs(duration - 2.4)<=eps, "1: Wrong duration");

       buffer :=SlidingWindow.init(4, 0);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 3.2, false);
       buffer :=SlidingWindow.push(buffer, 4.5, true);
       buffer :=SlidingWindow.push(buffer, 5.3, false);
       buffer :=SlidingWindow.push(buffer, 5.5, true);
       buffer :=SlidingWindow.removeOldest(buffer, 5.6);

       // 5.7-5.5 + 5.3-4.5 + 3.2-1.7
       duration :=SlidingWindow.accumulatedDuration(buffer, 5.7);
       print("2: duration = " + String(duration) + " (should be 2.5 s)");
       assert( abs(duration - 2.5)<=eps, "2: Wrong duration");

       duration :=SlidingWindow.accumulatedDuration(buffer, 9.7);
       print("3: duration = " + String(duration) + " (should be 4 s)");
       assert( abs(duration - 4)<=eps, "3: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       duration :=SlidingWindow.accumulatedDuration(buffer, 1.0, true);
       print("4: duration = " + String(duration) + " (should be 0 s)");
       assert( abs(duration)<=eps, "4: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);
       buffer :=SlidingWindow.push(buffer, 3.0, false);
       buffer :=SlidingWindow.removeOldest(buffer, 4.0);

       duration :=SlidingWindow.accumulatedDuration(buffer, 4.0, false);
       print("5: duration = " + String(duration) + " (should be 1 s)");
       assert( abs(duration - 1.0)<=eps, "5: Wrong duration");

       duration :=SlidingWindow.accumulatedDuration(buffer, 4.1, false);
       print("6: duration = " + String(duration) + " (should be 0.9 s)");
       assert( abs(duration - 0.9)<=eps, "6: Wrong duration");

       buffer :=SlidingWindow.init(2, 0);
       buffer :=SlidingWindow.push(buffer, 0.0, false);
       buffer :=SlidingWindow.push(buffer, 1.0, true);

       duration :=SlidingWindow.accumulatedDuration(buffer, 2.5, true);
       print("7: duration = " + String(duration) + " (should be 1.5 s)");
       assert( abs(duration - 1.5)<=eps, "7: Wrong duration");
    annotation(__iti_Impure = true);
    end testAccumulatedDuration;
  end TestSlidingWindow;

  package CSV "MA-HS-CSV file reader: the external object and its access functions (used by Sources.PartialSignalsFromFile)"
    extends Modelica.Icons.InternalPackage;

    class File "MA-HS-CSV file read into memory once; the requested columns by name and type"
      extends ExternalObject;

      function constructor "Open the file, resolve the requested column names against its header, convert the columns"
        input String fileName "Absolute path of the MA-HS-CSV file";
        input String realNames[:] "Header names of the columns read as Real";
        input String booleanNames[:] "Header names of the columns read as Boolean";
        input String integerNames[:] "Header names of the columns read as Integer";
        input Boolean extrapolateHold "= true: hold the first/last row outside the file's time range; = false: error";
        output File file;
        external "C" file = RequirementsCsv_open(fileName, realNames, size(realNames, 1), booleanNames, size(booleanNames, 1), integerNames, size(integerNames, 1), extrapolateHold)
          annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
      end constructor;

      function destructor "Release the file's memory"
        input File file;
        external "C" RequirementsCsv_close(file)
          annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
      end destructor;
      annotation(Documentation(info="<html>
<p>External object holding one MA-HS-CSV file: read completely in the constructor, columns not requested are skipped. See
<a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">Sources.PartialSignalsFromFile</a> for the format and the value semantics.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
    end File;

    pure function nextTimeEvent "Smallest event time of the file strictly after t (a huge value when there is none)"
      input File file;
      input Real t "Current time";
      output Real tEvent "Next event time > t";
      external "C" tEvent = RequirementsCsv_nextTimeEvent(file, t)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
      annotation(Documentation(info="<html>
<p>An event of the file is an instant at which a requested Boolean or Integer column changes, or at which any requested column changes inside a group of rows with the same time.</p>
</html>"));
    end nextTimeEvent;

    pure function getReal "Value of the i-th Real column at time t (linear between rows; the event bracket picks the side of an event)"
      input File file;
      input Integer column "Index into the realNames the file was opened with";
      input Real t "Current time";
      input Real nextTimeEvent "The block's nextTimeEvent";
      input Real preNextTimeEvent "pre(nextTimeEvent)";
      output Real y;
      external "C" y = RequirementsCsv_getReal(file, column, t, nextTimeEvent, preNextTimeEvent)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
      annotation(derivative(noDerivative=nextTimeEvent, noDerivative=preNextTimeEvent) = getRealDer,
        Documentation(info="<html>
<p>The <code>derivative</code> annotation names <a href=\"modelica://Requirements.Internal.CSV.getRealDer\">getRealDer</a>
(the slope of the linear segment), as <code>Modelica.Blocks.Sources.CombiTimeTable</code> does for its table
function, so <code>der(reader.x)</code> &mdash; a <code>SignalAnalysis.ExactDerivative</code> on a reader output &mdash; translates.</p>
</html>"));
    end getReal;

    pure function getRealDer "Time derivative of the i-th Real column at time t (the slope of the linear segment, the last segment's at the last row; zero outside the file's range)"
      input File file;
      input Integer column "Index into the realNames the file was opened with";
      input Real t "Current time";
      input Real nextTimeEvent "The block's nextTimeEvent";
      input Real preNextTimeEvent "pre(nextTimeEvent)";
      input Real der_t "der(t)";
      output Real der_y;
      external "C" der_y = RequirementsCsv_getRealDer(file, column, t, nextTimeEvent, preNextTimeEvent, der_t)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
      annotation(Documentation(info="<html>
<p>On the left side of an event (the bracket as in <code>getReal</code>) the slope of the segment ending at the event's first row;
otherwise the slope of the segment starting at the last row at or before <code>t</code>; at the file's last row the slope of the segment ending there (or at the first row of a final event group), so a derived signal keeps its value in the final stored row of a run that reads the file to its end; zero outside the file's range, where the first / last row is held.</p>
</html>"));
    end getRealDer;

    pure function getBoolean "Value of the i-th Boolean column at time t (piecewise constant)"
      input File file;
      input Integer column "Index into the booleanNames the file was opened with";
      input Real t "Current time";
      input Real nextTimeEvent "The block's nextTimeEvent";
      input Real preNextTimeEvent "pre(nextTimeEvent)";
      output Boolean y;
      external "C" y = RequirementsCsv_getBoolean(file, column, t, nextTimeEvent, preNextTimeEvent)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
    end getBoolean;

    pure function getInteger "Value of the i-th Integer column at time t (piecewise constant)"
      input File file;
      input Integer column "Index into the integerNames the file was opened with";
      input Real t "Current time";
      input Real nextTimeEvent "The block's nextTimeEvent";
      input Real preNextTimeEvent "pre(nextTimeEvent)";
      output Integer y;
      external "C" y = RequirementsCsv_getInteger(file, column, t, nextTimeEvent, preNextTimeEvent)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
    end getInteger;

    pure function getRows "Number of data rows in the file"
      input File file;
      output Integer n;
      external "C" n = RequirementsCsv_getRows(file)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
    end getRows;

    pure function getTimeRange "First and last time of the file"
      input File file;
      output Real tMin;
      output Real tMax;
      external "C" RequirementsCsv_getTimeRange(file, tMin, tMax)
        annotation(Include="#include \"RequirementsCsv.h\"", IncludeDirectory="modelica://Requirements/Resources/Include");
    end getTimeRange;
    annotation(Documentation(info="<html>
<p>The external object <code>File</code> and the functions
<a href=\"modelica://Requirements.Sources.PartialSignalsFromFile\">Sources.PartialSignalsFromFile</a> and the blocks extending it call.
The C implementation is header-only, <code>Resources/Include/RequirementsCsv.h</code> (C89, external linkage, no dependency beyond libc and
<code>ModelicaUtilities.h</code>), pulled in through the <code>Include</code> annotation of every function; <code>Resources/C-Sources/RequirementsCsv.c</code>
is the same code as a compilation unit for a <code>Library=</code> build. <code>Resources/C-Sources/test/</code> tests the C reader against ModCheck's Python reader.</p>
<p>Copyright &copy; 2026 Model Based Innovation LLC. All rights reserved.</p>
</html>"));
  end CSV;
end Internal;
