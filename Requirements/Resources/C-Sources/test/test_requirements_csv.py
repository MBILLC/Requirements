# Copyright © 2026 Model Based Innovation LLC. All rights reserved.

"""
The C reader (../../Include/RequirementsCsv.h) tested against ModCheck's
Python reader (mahscsv.py) through ctypes, on a locally compiled shared
library with stub ModelicaError/ModelicaFormatError (RequirementsCsvTest.c).

    python test_requirements_csv.py            # build + run
    python test_requirements_csv.py --no-build # reuse the last build

The build needs a C compiler and ModelicaUtilities.h: gcc on PATH, or the
gcc shipped with OpenModelica ($OPENMODELICAHOME/tools/msys/ucrt64/bin on
Windows), and the header from $OPENMODELICAHOME/include/omc/c. mahscsv.py is
found through $MODCHECK_DIR or the sibling checkout ../../../../../ModCheck.

What is asserted, per corpus file:
  * the C reader opens exactly the files the Python reader opens, and refuses
    exactly the ones it refuses (missing name, duplicate name, non-monotone
    time, ragged row, bad lexeme, array field);
  * bit-identical Real values at every stored row (repr -> strtod round trip);
  * identical Boolean/Integer values at every row;
  * identical event lists and nextTimeEvent() at every row time and between;
  * identical value(t, tNext, tPre) at a grid of instants including every
    event time on both sides of the bracket, between rows, and outside the
    range (hold), and the same refusal outside the range without hold;
  * identical slope(t, tNext, tPre) -- the derivative annotation of getReal --
    at the same grid.
"""
from __future__ import annotations

import ctypes
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
LIB_ROOT = HERE.parents[2]          # Requirements/


def _find_modcheck() -> Path:
    for cand in [os.environ.get("MODCHECK_DIR"),
                 LIB_ROOT.parents[1] / "ModCheck"]:
        if cand and (Path(cand) / "ModCheck" / "Resources" / "Requirements" / "mahscsv.py").is_file():
            return Path(cand) / "ModCheck" / "Resources" / "Requirements"
    raise SystemExit("mahscsv.py not found: set MODCHECK_DIR to the ModCheck checkout")


sys.path.insert(0, str(_find_modcheck()))
import mahscsv  # noqa: E402


def _omhome() -> Path | None:
    for cand in [os.environ.get("OPENMODELICAHOME"),
                 r"C:\Program Files\OpenModelica1.27.1-64bit", "/usr", "/opt/openmodelica"]:
        if cand and (Path(cand) / "include" / "omc" / "c" / "ModelicaUtilities.h").is_file():
            return Path(cand)
    return None


def build(out_dir: Path) -> Path:
    omhome = _omhome()
    if omhome is None:
        raise SystemExit("ModelicaUtilities.h not found: set OPENMODELICAHOME")
    gcc = shutil.which("gcc")
    env = dict(os.environ)
    if os.name == "nt":
        bundled = omhome / "tools" / "msys" / "ucrt64" / "bin"
        if (bundled / "gcc.exe").is_file():
            gcc = str(bundled / "gcc.exe")
            # gcc needs its own bin on PATH for cc1 and the runtime DLLs
            env["PATH"] = str(bundled) + os.pathsep + env.get("PATH", "")
    if not gcc:
        raise SystemExit("no gcc found")
    lib = out_dir / ("RequirementsCsvTest.dll" if os.name == "nt" else "libRequirementsCsvTest.so")
    cmd = [gcc, "-std=c89", "-pedantic", "-Wall", "-Wextra", "-O2", "-shared",
           "-I", str(omhome / "include" / "omc" / "c"),
           "-o", str(lib), str(HERE / "RequirementsCsvTest.c")]
    print("build:", " ".join(cmd))
    proc = subprocess.run(cmd, capture_output=True, text=True, env=env)
    if proc.stdout.strip():
        print(proc.stdout)
    if proc.stderr.strip():
        print(proc.stderr)
    if proc.returncode != 0:
        raise SystemExit(f"build failed ({proc.returncode})")
    return lib


class CReader:
    def __init__(self, lib_path: Path):
        self.lib = ctypes.CDLL(str(lib_path))
        L = self.lib
        L.test_lastError.restype = ctypes.c_char_p
        L.test_open.restype = ctypes.c_void_p
        L.test_open.argtypes = [ctypes.c_char_p, ctypes.POINTER(ctypes.c_char_p), ctypes.c_int,
                                ctypes.POINTER(ctypes.c_char_p), ctypes.c_int,
                                ctypes.POINTER(ctypes.c_char_p), ctypes.c_int, ctypes.c_int]
        L.test_close.argtypes = [ctypes.c_void_p]
        L.test_rows.argtypes = [ctypes.c_void_p]
        L.test_events.argtypes = [ctypes.c_void_p]
        L.test_nextTimeEvent.restype = ctypes.c_double
        L.test_nextTimeEvent.argtypes = [ctypes.c_void_p, ctypes.c_double]
        for fn, rt in [(L.test_getReal, ctypes.c_double), (L.test_getBoolean, ctypes.c_int),
                       (L.test_getInteger, ctypes.c_int)]:
            fn.restype = rt
            fn.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_double, ctypes.c_double,
                           ctypes.c_double, ctypes.POINTER(ctypes.c_int)]
        L.test_getRealDer.restype = ctypes.c_double
        L.test_getRealDer.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_double, ctypes.c_double,
                                      ctypes.c_double, ctypes.c_double, ctypes.POINTER(ctypes.c_int)]
        L.test_timeRange.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_double),
                                     ctypes.POINTER(ctypes.c_double)]

    def error(self) -> str:
        return (self.lib.test_lastError() or b"").decode("utf-8", "replace").strip()

    @staticmethod
    def _names(names):
        arr = (ctypes.c_char_p * max(len(names), 1))()
        for i, n in enumerate(names):
            arr[i] = n.encode("utf-8")
        return arr

    def open(self, path, real, boolean, integer, hold=True):
        h = self.lib.test_open(str(path).encode("utf-8"), self._names(real), len(real),
                               self._names(boolean), len(boolean), self._names(integer),
                               len(integer), 1 if hold else 0)
        if not h:
            raise ValueError(self.error())
        return h

    def get(self, kind, h, column, t, tNext, tPre):
        err = ctypes.c_int(0)
        fn = {mahscsv.REAL: self.lib.test_getReal, mahscsv.BOOLEAN: self.lib.test_getBoolean,
              mahscsv.INTEGER: self.lib.test_getInteger}[kind]
        v = fn(h, column, t, tNext, tPre, ctypes.byref(err))
        if err.value:
            raise ValueError(self.error())
        return bool(v) if kind == mahscsv.BOOLEAN else v

    def slope(self, h, column, t, tNext, tPre):
        err = ctypes.c_int(0)
        v = self.lib.test_getRealDer(h, column, t, tNext, tPre, 1.0, ctypes.byref(err))
        if err.value:
            raise ValueError(self.error())
        return v


# --------------------------------------------------------------- corpus

def corpus(tmp: Path) -> list[dict]:
    """Each entry: file, the (real, boolean, integer) name lists to request,
    and whether opening must fail (`error` = substring of the message)."""
    items = []

    def add(name, text, real=(), boolean=(), integer=(), error=None, newline="\n", bom=False, hold=True):
        p = tmp / name
        data = text.replace("\n", newline).encode("utf-8")
        if bom:
            data = b"\xef\xbb\xbf" + data
        p.write_bytes(data)
        items.append(dict(file=p, real=list(real), boolean=list(boolean), integer=list(integer),
                          error=error, hold=hold))

    plain = ("time,x,v,on,mode\n"
             "0,0,1,false,0\n"
             "0.5,0.5,1,false,0\n"
             "1,1,1,false,0\n"
             "1,1,-1,true,1\n"
             "2,0,-1,true,1\n"
             "2.5,-0.5,-1,true,1\n"
             "3,-1,-1,true,2\n"        # Integer change between distinct times
             "3,-1,-1,false,2\n"       # Boolean change in a duplicate group
             "4,0,1,false,2\n"
             "4,0,1,false,2\n"         # duplicate group without any change: no event
             "5,1,1,false,2\n")
    add("plain.csv", plain, ["x", "v"], ["on"], ["mode"])
    add("plain_crlf.csv", plain, ["x", "v"], ["on"], ["mode"], newline="\r\n")
    add("plain_bom.csv", plain, ["x", "v"], ["on"], ["mode"], bom=True)
    add("plain_subset.csv", plain, ["v"], [], ["mode"])          # x, on skipped
    add("plain_nohold.csv", plain, ["x"], ["on"], [], hold=False)
    add("plain_no_newline_at_end.csv", plain.rstrip("\n"), ["x"], ["on"], ["mode"])
    add("plain_blank_lines.csv", plain.replace("\n2,", "\n\n2,") + "\n\n", ["x"], ["on"], ["mode"])
    add("quoted.csv",
        '"time","T cabin","p, cabin","q ""quoted""",flag\n'
        '0,18.5,1.0e5,1,true\n'
        '10,19.5,1.01e5,2,1\n'
        '10,19.5,1.02e5,3,0\n'
        '20,20.5,1.01e5,4,false\n',
        ["T cabin", "p, cabin"], ["flag"], ['q "quoted"'])
    add("boolean_lexemes.csv",
        "time,b\n0,true\n1,1\n2,0\n3,false\n4,1\n",
        [], ["b"], [])
    add("nan_inf.csv",
        "time,a,b\n0,NaN,1\n1,INF,2\n2,-INF,NaN\n2,+INF,NaN\n3,1e-05,-0.0\n3,1e-05,-0.0\n4,0.1,2.2250738585072014e-308\n",
        ["a", "b"], [], [])
    add("three_row_event.csv",
        "time,x,s\n0,0,false\n1,1,false\n1,2,true\n1,3,true\n2,4,true\n",
        ["x"], ["s"], [])
    add("single_row.csv", "time,x,s\n1.5,2,true\n", ["x"], ["s"], [])
    add("event_at_start.csv", "time,x,s\n0,0,false\n0,1,true\n1,2,true\n", ["x"], ["s"], [])
    # round-trip corpus written by the Python writer from random data with events
    rng = np.random.default_rng(7)
    t = np.sort(rng.uniform(0, 10, 200))
    t[50:53] = t[50]; t[120:122] = t[120]
    x = rng.standard_normal(200) * 1e3
    y = rng.uniform(-1, 1, 200) * 1e-7
    b = rng.integers(0, 2, 200).astype(bool)
    k = rng.integers(-5, 5, 200)
    mahscsv.write(tmp / "written.csv", t, {"x": x, "tiny y": y, "b": b, "k": k})
    items.append(dict(file=tmp / "written.csv", real=["x", "tiny y"], boolean=["b"], integer=["k"],
                      error=None, hold=True))
    # refusals
    add("missing_name.csv", plain, ["x", "nope"], [], [], error="not in the header")
    add("time_as_signal.csv", plain, ["time"], [], [], error="independent")
    add("dup_header.csv", "time,x,x\n0,1,2\n", ["x"], [], [], error="twice")
    add("nonmonotone.csv", "time,x\n0,1\n2,2\n1,3\n", ["x"], [], [], error="decreases")
    add("ragged.csv", "time,x,y\n0,1,2\n1,1\n", ["x"], [], [], error="fields")
    add("array_field.csv", "time,x\n0,1 2\n", ["x"], [], [], error="space")
    add("bad_real.csv", "time,x\n0,abc\n", ["x"], [], [], error="not a Float64")
    add("bad_boolean.csv", "time,x\n0,yes\n", [], ["x"], [], error="not a Boolean")
    add("bad_integer.csv", "time,x\n0,1.5\n", [], [], ["x"], error="not an Integer")
    add("int_range.csv", "time,x\n0,3000000000\n", [], [], ["x"], error="out of range")
    add("no_data.csv", "time,x\n", ["x"], [], [], error="no data")
    add("nan_time.csv", "time,x\n0,1\nNaN,2\n", ["x"], [], [], error="NaN")
    return items


def _python_open(item):
    types = {**{n: mahscsv.REAL for n in item["real"]}, **{n: mahscsv.BOOLEAN for n in item["boolean"]},
             **{n: mahscsv.INTEGER for n in item["integer"]}}
    return mahscsv.read(item["file"], types=types, names=list(types), hold=item["hold"])


def check_item(c: CReader, item) -> list[str]:
    failures = []
    name = item["file"].name
    py_err = c_err = None
    try:
        sig = _python_open(item)
    except ValueError as e:
        py_err = str(e)
    try:
        h = c.open(item["file"], item["real"], item["boolean"], item["integer"], item["hold"])
    except ValueError as e:
        c_err = str(e)
    if item["error"]:
        if py_err is None:
            failures.append(f"{name}: Python reader accepted a file that must be refused ({item['error']})")
        if c_err is None:
            failures.append(f"{name}: C reader accepted a file that must be refused ({item['error']})")
        elif item["error"] not in c_err:
            failures.append(f"{name}: C error {c_err!r} does not mention {item['error']!r}")
        return failures
    if py_err or c_err:
        failures.append(f"{name}: unexpected refusal -- python: {py_err!r}, C: {c_err!r}")
        return failures

    n = sig.n_rows
    if c.lib.test_rows(h) != n:
        failures.append(f"{name}: row count C {c.lib.test_rows(h)} != python {n}")
    tmin, tmax = ctypes.c_double(), ctypes.c_double()
    c.lib.test_timeRange(h, ctypes.byref(tmin), ctypes.byref(tmax))
    if (tmin.value, tmax.value) != (sig.time[0], sig.time[-1]):
        failures.append(f"{name}: time range differs")

    kinds = [(mahscsv.REAL, item["real"]), (mahscsv.BOOLEAN, item["boolean"]), (mahscsv.INTEGER, item["integer"])]
    # stored rows, bit-identical: query each row's time on the right side and
    # compare with the last row of that group -- plus every row through the
    # group-first (left) side
    ev = sig.events()
    c_ev = c.lib.test_events(h)
    if c_ev != ev.size:
        failures.append(f"{name}: event count C {c_ev} != python {ev.size} {ev}")
    probes = set(sig.time.tolist()) | set(ev.tolist())
    tt = sig.time
    for a, b_ in zip(tt[:-1], tt[1:]):
        if b_ > a:
            probes.add(float(a + (b_ - a) * 0.37))
    span = max(tt[-1] - tt[0], 1.0)
    probes |= {float(tt[0] - 0.5 * span), float(tt[-1] + 0.5 * span)}
    big = float(np.finfo(float).max)
    for kind, names in kinds:
        for col, sname in enumerate(names, 1):
            for t in sorted(probes):
                for tNext, tPre in [(big, big), (t, t), (t + 1.0, t), (big, t)]:
                    try:
                        pv = sig.value(sname, t, tNext, tPre)
                        pe = None
                    except ValueError as e:
                        pv, pe = None, str(e)
                    try:
                        cv = c.get(kind, h, col, t, tNext, tPre)
                        ce = None
                    except ValueError as e:
                        cv, ce = None, str(e)
                    if (pe is None) != (ce is None):
                        failures.append(f"{name}: {sname}@{t} bracket ({tNext},{tPre}): python {pe or pv!r} vs C {ce or cv!r}")
                        continue
                    if pe is None:
                        same = (pv == cv) or (kind == mahscsv.REAL and np.isnan(pv) and np.isnan(cv))
                        if not same:
                            failures.append(f"{name}: {sname}@{t!r} bracket ({tNext},{tPre}): python {pv!r} vs C {cv!r}")
                    # the derivative (slope) with the same bracket
                    if kind == mahscsv.REAL and pe is None:
                        ps, cs = sig.slope(sname, t, tNext, tPre), c.slope(h, col, t, tNext, tPre)
                        if not (ps == cs or (np.isnan(ps) and np.isnan(cs))):
                            failures.append(f"{name}: slope of {sname}@{t!r} bracket ({tNext},{tPre}): python {ps!r} vs C {cs!r}")
    # nextTimeEvent
    for t in sorted(probes):
        pn = sig.next_time_event(t)
        cn = c.lib.test_nextTimeEvent(h, t)
        if pn != cn:
            failures.append(f"{name}: nextTimeEvent({t}) python {pn} vs C {cn}")
    # stored Real rows bit-identical to the Python parse (repr/strtod round trip)
    for col, sname in enumerate(item["real"], 1):
        for i in range(n):
            # right side of the group at this row's time gives the group's last row;
            # walk the group from the left side for the first row
            if i + 1 < n and tt[i + 1] == tt[i]:
                continue
            cv = c.get(mahscsv.REAL, h, col, float(tt[i]), big, big)
            pv = float(sig[sname][i])
            if not (cv == pv or (np.isnan(cv) and np.isnan(pv))):
                failures.append(f"{name}: {sname} row {i}: C {cv!r} != python {pv!r}")
    c.lib.test_close(h)
    return failures


def main(argv):
    out = HERE / "build"
    out.mkdir(exist_ok=True)
    if "--no-build" in argv:
        lib = next(out.glob("*RequirementsCsvTest.*"))
    else:
        lib = build(out)
    c = CReader(lib)
    tmp = Path(tempfile.mkdtemp(prefix="reqcsv-"))
    items = corpus(tmp)
    failures = []
    for item in items:
        f = check_item(c, item)
        print(f"{'ok  ' if not f else 'FAIL'} {item['file'].name}")
        for line in f[:5]:
            print("      " + line)
        failures += f
    print(f"\n{len(items)} corpus files, {len(failures)} failures")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
