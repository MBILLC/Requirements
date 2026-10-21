/* RequirementsCsv.h - MA-HS-CSV reader behind Requirements.Sources.PartialSignalsFromFile

   Copyright (c) 2026 Model Based Innovation LLC. All rights reserved.

   Reads a Modelica Association MA-HS-CSV file (https://github.com/modelica/ma-hs-csv,
   beta of 2026: RFC 4180 records, a header row of unique column names, the first
   column the non-decreasing independent variable, consecutive rows with the same
   time representing an event, values in XML-Schema lexical forms) into memory
   once, in the external object's constructor, and answers value queries with the
   semantics written down in Requirements.Sources.PartialSignalsFromFile:

     Real     columns are linear between rows; at a duplicate-time group the value
              jumps at that instant from the group's first row to its last row.
     Boolean  and Integer columns are piecewise constant: the value of the last row
              whose time is <= t, stepping at the row's time.
     Events   are the times at which any requested Boolean or Integer column
              changes, or at which any requested column changes inside a
              duplicate-time group. nextTimeEvent() walks them; the value
              functions take the event bracket (nextTimeEvent, pre(nextTimeEvent))
              so the value on either side of an event is unambiguous during event
              iteration, exactly as Modelica.Blocks.Sources.CombiTimeTable does.
     Groups   are rows whose times are within a relative 1e-10 of the group's first
              row (exactly equal, or a few ulps apart): one instant, the first row's
              time.
     Outside  the file's time range the first/last row is held (extrapolateHold),
              or an error is raised.

   Header-only and C89 on purpose: Modelon Impact's OCT compiles every Include
   with `gcc -std=c89 -pedantic` and pastes it into a translation unit other than
   the one that calls the functions, so the functions must have external linkage
   (no `static`) and the file may be included exactly once per model build. omc
   and Dymola paste it into a single translation unit as well. Nothing here
   depends on anything but libc and ModelicaUtilities.h. Arrays in fields (space
   separated) are NOT supported: a numeric field with a space is rejected.

   Spec pinned against: modelica/ma-hs-csv README, beta, September 2026.
*/
#ifndef REQUIREMENTS_CSV_H
#define REQUIREMENTS_CSV_H

#define REQUIREMENTS_CSV_EPS 1e-10   /* rows this close in time (relative) are one event group */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <errno.h>
#include "ModelicaUtilities.h"

#define REQUIREMENTS_CSV_VERSION "0.1"

typedef struct {
    char* fileName;
    size_t nRows;
    double* time;             /* nRows */
    size_t nReal;
    double* real;             /* column-major: real[c*nRows + i] */
    size_t nBoolean;
    unsigned char* boolean;   /* column-major */
    size_t nInteger;
    int* integer;             /* column-major */
    size_t nEvents;
    double* events;           /* sorted, unique */
    int hold;                 /* 1: hold first/last row outside [tMin, tMax]; 0: error */
    size_t last;              /* cached row index for the search */
} RequirementsCsv_File;

/* ------------------------------------------------------------------ helpers */

/* One RFC 4180 field starting at *p. Writes the unescaped field into a newly
   allocated string, advances *p past the field's terminating comma or record
   end, and reports what terminated it: ',' or '\n' (LF / CR LF) or 0 (end). */
static char* RequirementsCsv_field(const char** p, int* terminator, int* quoted)
{
    const char* s = *p;
    char* out;
    size_t cap = 32, n = 0;
    out = (char*)malloc(cap);
    if (out == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    *quoted = 0;
    if (*s == '"') {
        *quoted = 1;
        s++;
        for (;;) {
            if (*s == 0) {
                ModelicaError("RequirementsCsv: unterminated quoted field\n");
            }
            if (*s == '"') {
                if (s[1] == '"') { s++; }           /* "" -> " */
                else { s++; break; }               /* closing quote */
            }
            if (n + 1 >= cap) {
                cap *= 2;
                out = (char*)realloc(out, cap);
                if (out == NULL) ModelicaError("RequirementsCsv: out of memory\n");
            }
            out[n++] = *s++;
        }
        /* only a comma, a line break or the end may follow a closing quote */
        if (*s != ',' && *s != '\r' && *s != '\n' && *s != 0) {
            ModelicaFormatError("RequirementsCsv: text after a closing quote: \"%.20s\"\n", s);
        }
    }
    else {
        while (*s != ',' && *s != '\r' && *s != '\n' && *s != 0) {
            if (*s == '"') {
                ModelicaError("RequirementsCsv: a double quote inside an unquoted field\n");
            }
            if (n + 1 >= cap) {
                cap *= 2;
                out = (char*)realloc(out, cap);
                if (out == NULL) ModelicaError("RequirementsCsv: out of memory\n");
            }
            out[n++] = *s++;
        }
    }
    out[n] = 0;
    if (*s == ',') { *terminator = ','; s++; }
    else if (*s == '\r') { *terminator = '\n'; s++; if (*s == '\n') s++; }
    else if (*s == '\n') { *terminator = '\n'; s++; }
    else { *terminator = 0; }
    *p = s;
    return out;
}

/* XML Schema `double`: decimal or scientific, INF, +INF, -INF, NaN. No spaces. */
static double RequirementsCsv_parseReal(const char* s, const char* what, size_t row)
{
    char* end;
    double v;
    if (*s == 0) ModelicaFormatError("RequirementsCsv: empty %s field in data row %lu\n", what, (unsigned long)row);
    if (strcmp(s, "NaN") == 0) {
        v = 0.0; return v / v;             /* quiet NaN without C99's NAN macro */
    }
    if (strcmp(s, "INF") == 0 || strcmp(s, "+INF") == 0) return HUGE_VAL;
    if (strcmp(s, "-INF") == 0) return -HUGE_VAL;
    v = strtod(s, &end);
    if (end == s || *end != 0) {
        if (strchr(s, ' ') != NULL)
            ModelicaFormatError("RequirementsCsv: %s field \"%s\" in data row %lu contains a space -- arrays are not supported\n", what, s, (unsigned long)row);
        ModelicaFormatError("RequirementsCsv: %s field \"%s\" in data row %lu is not a Float64\n", what, s, (unsigned long)row);
    }
    return v;
}

/* XML Schema `boolean`: true, false, 1, 0. */
static unsigned char RequirementsCsv_parseBoolean(const char* s, size_t row)
{
    if (strcmp(s, "true") == 0 || strcmp(s, "1") == 0) return 1;
    if (strcmp(s, "false") == 0 || strcmp(s, "0") == 0) return 0;
    ModelicaFormatError("RequirementsCsv: field \"%s\" in data row %lu is not a Boolean (true/false/1/0)\n", s, (unsigned long)row);
    return 0;
}

/* XML Schema integer in the range of a C int. */
static int RequirementsCsv_parseInteger(const char* s, size_t row)
{
    char* end;
    long v;
    if (*s == 0) ModelicaFormatError("RequirementsCsv: empty Integer field in data row %lu\n", (unsigned long)row);
    errno = 0;
    v = strtol(s, &end, 10);
    if (end == s || *end != 0) {
        if (strchr(s, ' ') != NULL)
            ModelicaFormatError("RequirementsCsv: Integer field \"%s\" in data row %lu contains a space -- arrays are not supported\n", s, (unsigned long)row);
        ModelicaFormatError("RequirementsCsv: field \"%s\" in data row %lu is not an Integer\n", s, (unsigned long)row);
    }
    /* long is 32 bits on Windows: strtol saturates with ERANGE there */
    if (errno == ERANGE || v > 2147483647L || v < -2147483647L - 1L) {
        ModelicaFormatError("RequirementsCsv: Integer field \"%s\" in data row %lu is out of range\n", s, (unsigned long)row);
    }
    return (int)v;
}

/* index of `name` in the header, or -1 */
static long RequirementsCsv_findName(char** header, size_t nCols, const char* name)
{
    size_t j;
    for (j = 0; j < nCols; j++) {
        if (strcmp(header[j], name) == 0) return (long)j;
    }
    return -1;
}

/* Largest row index i with time[i] <= t, given tMin <= t; cached. */
static size_t RequirementsCsv_findRow(RequirementsCsv_File* f, double t)
{
    size_t lo, hi, last = f->last;
    const double* time = f->time;
    if (last >= f->nRows) last = 0;
    /* fast paths around the cached index */
    if (time[last] <= t) {
        if (last + 1 >= f->nRows || t < time[last + 1]) {
            /* still inside the same interval; but move to the last row of a duplicate group */
            while (last + 1 < f->nRows && time[last + 1] <= t) last++;
            f->last = last;
            return last;
        }
        lo = last;
        hi = f->nRows - 1;
    }
    else {
        lo = 0;
        hi = last;
    }
    /* binary search for the last index with time <= t in [lo, hi] */
    while (lo < hi) {
        size_t mid = lo + (hi - lo + 1) / 2;
        if (time[mid] <= t) lo = mid; else hi = mid - 1;
    }
    while (lo + 1 < f->nRows && time[lo + 1] <= t) lo++;
    f->last = lo;
    return lo;
}

/* A query time within a relative REQUIREMENTS_CSV_EPS of a row's time is that time.
   PartialSignalsFromFile wakes on a state event (its `fileEvent`), which the integrator
   locates only to its root-finding tolerance, possibly a hair before the row: without this,
   nextTimeEvent() would return the same event again and the values would be the row
   before's. */
static double RequirementsCsv_snap(RequirementsCsv_File* f, double t)
{
    size_t i;
    double r;
    if (f->nRows == 0) return t;
    if (t < f->time[0]) i = 0;
    else {
        i = RequirementsCsv_findRow(f, t);
        if (i + 1 < f->nRows && f->time[i + 1] - t < t - f->time[i]) i++;
    }
    r = f->time[i];
    return fabs(t - r) <= REQUIREMENTS_CSV_EPS * (fabs(r) > 1.0 ? fabs(r) : 1.0) ? r : t;
}

/* First row index of the duplicate-time group that row i belongs to. */
static size_t RequirementsCsv_groupFirst(const RequirementsCsv_File* f, size_t i)
{
    while (i > 0 && f->time[i - 1] == f->time[i]) i--;
    return i;
}

/* Where does t sit, and which side of an event are we on?
   Sets *iLast (last row with time <= t), *before (left side of an event at t)
   and *outside (-1 / +1 when t is beyond the file's range and held). */
static void RequirementsCsv_locate(RequirementsCsv_File* f, double t, double tNext, double tPre,
                                   size_t* iLast, int* before, int* outside)
{
    const double tMin = f->time[0];
    const double tMax = f->time[f->nRows - 1];
    *before = 0;
    *outside = 0;
    if (t < tMin) {
        if (!f->hold) ModelicaFormatError("RequirementsCsv: time %g is before the first row (%g) of \"%s\"\n", t, tMin, f->fileName);
        *iLast = 0;
        *outside = -1;
        return;
    }
    if (t > tMax) {
        if (!f->hold) ModelicaFormatError("RequirementsCsv: time %g is after the last row (%g) of \"%s\"\n", t, tMax, f->fileName);
        *iLast = f->nRows - 1;
        *outside = 1;
        return;
    }
    *iLast = RequirementsCsv_findRow(f, t);
    /* At a scheduled event instant, before the when-clause has fired,
       nextTimeEvent == pre(nextTimeEvent) == t: the model is being evaluated
       on the left side of the event. Once the when-clause has advanced
       nextTimeEvent past t, or between events, the right side applies. */
    if (tNext == tPre && t >= tPre && f->time[*iLast] == t) *before = 1;
}

/* ---------------------------------------------------------------- API: open */

void* RequirementsCsv_open(const char* fileName,
                           const char** realNames, size_t nReal,
                           const char** booleanNames, size_t nBoolean,
                           const char** integerNames, size_t nInteger,
                           int extrapolateHold)
{
    RequirementsCsv_File* f;
    FILE* fp;
    char* text;
    const char* p;
    size_t length, nCols = 0, nRows = 0, j, c, k, g;
    char** header = NULL;
    long* realCol = NULL;
    long* booleanCol = NULL;
    long* integerCol = NULL;
    int terminator, quoted;
    size_t headerCap = 8;

    /* ---- read the whole file */
    fp = fopen(fileName, "rb");
    if (fp == NULL) ModelicaFormatError("RequirementsCsv: cannot open \"%s\"\n", fileName);
    if (fseek(fp, 0, SEEK_END) != 0) { fclose(fp); ModelicaFormatError("RequirementsCsv: cannot seek in \"%s\"\n", fileName); }
    length = (size_t)ftell(fp);
    rewind(fp);
    text = (char*)malloc(length + 1);
    if (text == NULL) { fclose(fp); ModelicaError("RequirementsCsv: out of memory\n"); }
    if (fread(text, 1, length, fp) != length) { fclose(fp); free(text); ModelicaFormatError("RequirementsCsv: cannot read \"%s\"\n", fileName); }
    fclose(fp);
    text[length] = 0;
    p = text;
    /* a UTF-8 byte-order mark is tolerated and skipped */
    if (length >= 3 && (unsigned char)p[0] == 0xEF && (unsigned char)p[1] == 0xBB && (unsigned char)p[2] == 0xBF) p += 3;

    /* ---- header row */
    header = (char**)malloc(headerCap * sizeof(char*));
    if (header == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    for (;;) {
        char* name = RequirementsCsv_field(&p, &terminator, &quoted);
        if (nCols >= headerCap) {
            headerCap *= 2;
            header = (char**)realloc(header, headerCap * sizeof(char*));
            if (header == NULL) ModelicaError("RequirementsCsv: out of memory\n");
        }
        header[nCols++] = name;
        if (terminator != ',') break;
    }
    if (terminator == 0 && *p == 0 && nCols == 1 && header[0][0] == 0) {
        ModelicaFormatError("RequirementsCsv: \"%s\" is empty\n", fileName);
    }
    for (j = 0; j < nCols; j++) {
        for (c = j + 1; c < nCols; c++) {
            if (strcmp(header[j], header[c]) == 0)
                ModelicaFormatError("RequirementsCsv: column name \"%s\" appears twice in the header of \"%s\"\n", header[j], fileName);
        }
    }

    /* ---- resolve the requested names against the header */
    realCol = (long*)malloc((nReal + 1) * sizeof(long));
    booleanCol = (long*)malloc((nBoolean + 1) * sizeof(long));
    integerCol = (long*)malloc((nInteger + 1) * sizeof(long));
    if (realCol == NULL || booleanCol == NULL || integerCol == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    for (j = 0; j < nReal; j++) {
        realCol[j] = RequirementsCsv_findName(header, nCols, realNames[j]);
        if (realCol[j] < 0) ModelicaFormatError("RequirementsCsv: Real column \"%s\" is not in the header of \"%s\"\n", realNames[j], fileName);
        if (realCol[j] == 0) ModelicaFormatError("RequirementsCsv: \"%s\" is the independent (time) column of \"%s\" and cannot be read as a signal\n", realNames[j], fileName);
    }
    for (j = 0; j < nBoolean; j++) {
        booleanCol[j] = RequirementsCsv_findName(header, nCols, booleanNames[j]);
        if (booleanCol[j] < 0) ModelicaFormatError("RequirementsCsv: Boolean column \"%s\" is not in the header of \"%s\"\n", booleanNames[j], fileName);
        if (booleanCol[j] == 0) ModelicaFormatError("RequirementsCsv: \"%s\" is the independent (time) column of \"%s\" and cannot be read as a signal\n", booleanNames[j], fileName);
    }
    for (j = 0; j < nInteger; j++) {
        integerCol[j] = RequirementsCsv_findName(header, nCols, integerNames[j]);
        if (integerCol[j] < 0) ModelicaFormatError("RequirementsCsv: Integer column \"%s\" is not in the header of \"%s\"\n", integerNames[j], fileName);
        if (integerCol[j] == 0) ModelicaFormatError("RequirementsCsv: \"%s\" is the independent (time) column of \"%s\" and cannot be read as a signal\n", integerNames[j], fileName);
    }

    /* ---- the object */
    f = (RequirementsCsv_File*)calloc(1, sizeof(RequirementsCsv_File));
    if (f == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    f->fileName = (char*)malloc(strlen(fileName) + 1);
    if (f->fileName == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    strcpy(f->fileName, fileName);
    f->nReal = nReal;
    f->nBoolean = nBoolean;
    f->nInteger = nInteger;
    f->hold = extrapolateHold ? 1 : 0;

    /* ---- data rows: first pass counts records, second converts; the
            column-major arrays need nRows before the first value lands */
    {
        const char* q = p;
        while (*q != 0) {
            /* a record ends at LF or CR LF; count non-empty records */
            const char* lineStart = q;
            int inQuote = 0;
            while (*q != 0) {
                if (*q == '"') inQuote = !inQuote;
                else if (!inQuote && (*q == '\n' || *q == '\r')) break;
                q++;
            }
            if (q > lineStart) nRows++;
            if (*q == '\r') q++;
            if (*q == '\n') q++;
        }
    }
    if (nRows == 0) ModelicaFormatError("RequirementsCsv: \"%s\" has a header but no data rows\n", fileName);
    f->nRows = nRows;
    f->time = (double*)malloc(nRows * sizeof(double));
    f->real = (double*)malloc((nRows * nReal + 1) * sizeof(double));
    f->boolean = (unsigned char*)malloc(nRows * nBoolean + 1);
    f->integer = (int*)malloc((nRows * nInteger + 1) * sizeof(int));
    if (f->time == NULL || f->real == NULL || f->boolean == NULL || f->integer == NULL) ModelicaError("RequirementsCsv: out of memory\n");

    for (k = 0; k < nRows; k++) {
        size_t col = 0;
        /* skip empty lines (a trailing newline, a blank line) */
        while (*p == '\r' || *p == '\n') p++;
        if (*p == 0) ModelicaFormatError("RequirementsCsv: \"%s\": expected %lu data rows, found %lu\n", fileName, (unsigned long)nRows, (unsigned long)k);
        for (;;) {
            char* field = RequirementsCsv_field(&p, &terminator, &quoted);
            if (col >= nCols) {
                free(field);
                ModelicaFormatError("RequirementsCsv: data row %lu of \"%s\" has more than %lu fields\n", (unsigned long)(k + 1), fileName, (unsigned long)nCols);
            }
            if (col == 0) {
                f->time[k] = RequirementsCsv_parseReal(field, "time", k + 1);
                if (k > 0 && f->time[k] < f->time[k - 1])
                    ModelicaFormatError("RequirementsCsv: time decreases from %.17g to %.17g at data row %lu of \"%s\"\n", f->time[k - 1], f->time[k], (unsigned long)(k + 1), fileName);
                if (f->time[k] != f->time[k])
                    ModelicaFormatError("RequirementsCsv: time is NaN at data row %lu of \"%s\"\n", (unsigned long)(k + 1), fileName);
            }
            else {
                for (j = 0; j < nReal; j++) if ((size_t)realCol[j] == col) f->real[j * nRows + k] = RequirementsCsv_parseReal(field, realNames[j], k + 1);
                for (j = 0; j < nBoolean; j++) if ((size_t)booleanCol[j] == col) f->boolean[j * nRows + k] = RequirementsCsv_parseBoolean(field, k + 1);
                for (j = 0; j < nInteger; j++) if ((size_t)integerCol[j] == col) f->integer[j * nRows + k] = RequirementsCsv_parseInteger(field, k + 1);
            }
            free(field);
            col++;
            if (terminator != ',') break;
        }
        if (col != nCols) {
            ModelicaFormatError("RequirementsCsv: data row %lu of \"%s\" has %lu fields, the header has %lu\n", (unsigned long)(k + 1), fileName, (unsigned long)col, (unsigned long)nCols);
        }
    }

    /* ---- rows closer in time than a relative REQUIREMENTS_CSV_EPS are one event group: each
       takes the time of the group's first row. A simulator's result can hold two event instants
       a few ulps apart (3.1e-10 s at 28248 s in a year of the TIER plant); as two time events, the
       second is due before the solver can move, OCT drops it as already past, the when-clause of
       PartialSignalsFromFile never fires again and every Boolean and Integer column holds its value
       for the rest of the run. The tolerance is Modelica.Blocks.Tables' (1e-10, relative). */
    for (k = 1, g = 0; k < nRows; k++) {
        if (f->time[k] - f->time[g] <= REQUIREMENTS_CSV_EPS * (fabs(f->time[g]) > 1.0 ? fabs(f->time[g]) : 1.0))
            f->time[k] = f->time[g];
        else
            g = k;
    }

    /* ---- event times */
    f->events = (double*)malloc((nRows + 1) * sizeof(double));
    if (f->events == NULL) ModelicaError("RequirementsCsv: out of memory\n");
    f->nEvents = 0;
    for (k = 1; k < nRows; k++) {
        int change = 0;
        int dup = (f->time[k] == f->time[k - 1]);
        for (j = 0; j < nBoolean && !change; j++) if (f->boolean[j * nRows + k] != f->boolean[j * nRows + k - 1]) change = 1;
        for (j = 0; j < nInteger && !change; j++) if (f->integer[j * nRows + k] != f->integer[j * nRows + k - 1]) change = 1;
        if (dup) {
            for (j = 0; j < nReal && !change; j++) {
                double a = f->real[j * nRows + k], b = f->real[j * nRows + k - 1];
                if (a != b && (a == a || b == b)) change = 1;   /* NaN != NaN is not a change */
            }
        }
        if (change && (f->nEvents == 0 || f->events[f->nEvents - 1] != f->time[k])) {
            f->events[f->nEvents++] = f->time[k];
        }
    }

    for (j = 0; j < nCols; j++) free(header[j]);
    free(header);
    free(realCol);
    free(booleanCol);
    free(integerCol);
    free(text);
    return f;
}

void RequirementsCsv_close(void* obj)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    if (f == NULL) return;
    free(f->fileName);
    free(f->time);
    free(f->real);
    free(f->boolean);
    free(f->integer);
    free(f->events);
    free(f);
}

/* ------------------------------------------------------------- API: queries */

/* Smallest event time strictly after t (t snapped to a row's time first), or DBL_MAX when
   there is none. */
double RequirementsCsv_nextTimeEvent(void* obj, double t)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    size_t lo = 0, hi;
    if (f == NULL || f->nEvents == 0) return DBL_MAX;
    t = RequirementsCsv_snap(f, t);
    if (f->events[f->nEvents - 1] <= t) return DBL_MAX;
    hi = f->nEvents - 1;
    /* first index with events[i] > t */
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        if (f->events[mid] > t) hi = mid; else lo = mid + 1;
    }
    return f->events[lo];
}

double RequirementsCsv_getReal(void* obj, int column, double t, double tNext, double tPre)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    size_t i, i0;
    int before, outside;
    const double* v;
    if (f == NULL) ModelicaError("RequirementsCsv: getReal on a closed file\n");
    if (column < 1 || (size_t)column > f->nReal) ModelicaFormatError("RequirementsCsv: Real column index %d is out of range 1..%lu\n", column, (unsigned long)f->nReal);
    v = f->real + (size_t)(column - 1) * f->nRows;
    t = RequirementsCsv_snap(f, t);
    RequirementsCsv_locate(f, t, tNext, tPre, &i, &before, &outside);
    if (outside != 0) return v[i];
    if (before) {
        /* left side of the event at t: the first row of the group at t */
        return v[RequirementsCsv_groupFirst(f, i)];
    }
    if (f->time[i] == t || i + 1 >= f->nRows) return v[i];
    /* linear between the last row of the group at time[i] and the next row */
    i0 = i;
    return v[i0] + (v[i0 + 1] - v[i0]) * (t - f->time[i0]) / (f->time[i0 + 1] - f->time[i0]);
}

/* Time derivative of the i-th Real column at t times der_t: the slope of the
   linear segment t lies in (the segment to the right of a row, the segment to
   the left of an event's first row when evaluated on the left side), zero
   outside the file's range where the first/last row is held. At the file's
   last row -- the final instant of a run that reads the file to its end --
   the slope of the last segment (the one ending at that row, or at the first
   row of a final event group), so a derived signal does not drop to zero in
   the run's last stored row. The derivative annotation of
   Requirements.Internal.CSV.getReal, so der(reader.x) is available to a
   SignalAnalysis.ExactDerivative in a check model reading a file. */
double RequirementsCsv_getRealDer(void* obj, int column, double t, double tNext, double tPre, double der_t)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    size_t i, i0;
    int before, outside;
    const double* v;
    if (f == NULL) ModelicaError("RequirementsCsv: getRealDer on a closed file\n");
    if (column < 1 || (size_t)column > f->nReal) ModelicaFormatError("RequirementsCsv: Real column index %d is out of range 1..%lu\n", column, (unsigned long)f->nReal);
    v = f->real + (size_t)(column - 1) * f->nRows;
    t = RequirementsCsv_snap(f, t);
    RequirementsCsv_locate(f, t, tNext, tPre, &i, &before, &outside);
    if (outside != 0) return 0.0;
    if (before) {
        i0 = RequirementsCsv_groupFirst(f, i);
        if (i0 == 0) return 0.0;
        return (v[i0] - v[i0 - 1]) / (f->time[i0] - f->time[i0 - 1]) * der_t;
    }
    if (i + 1 >= f->nRows) {
        /* the last row: the slope of the segment ending at it (or at the first row of a final event group) */
        i0 = RequirementsCsv_groupFirst(f, i);
        if (i0 == 0) return 0.0;
        return (v[i0] - v[i0 - 1]) / (f->time[i0] - f->time[i0 - 1]) * der_t;
    }
    return (v[i + 1] - v[i]) / (f->time[i + 1] - f->time[i]) * der_t;
}

static size_t RequirementsCsv_discreteRow(RequirementsCsv_File* f, double t, double tNext, double tPre)
{
    size_t i;
    int before, outside;
    t = RequirementsCsv_snap(f, t);
    RequirementsCsv_locate(f, t, tNext, tPre, &i, &before, &outside);
    if (outside != 0) return i;
    if (before) {
        /* left side of the event at t: the last row before the group at t */
        size_t i0 = RequirementsCsv_groupFirst(f, i);
        return i0 > 0 ? i0 - 1 : i0;
    }
    return i;
}

int RequirementsCsv_getBoolean(void* obj, int column, double t, double tNext, double tPre)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    if (f == NULL) ModelicaError("RequirementsCsv: getBoolean on a closed file\n");
    if (column < 1 || (size_t)column > f->nBoolean) ModelicaFormatError("RequirementsCsv: Boolean column index %d is out of range 1..%lu\n", column, (unsigned long)f->nBoolean);
    return f->boolean[(size_t)(column - 1) * f->nRows + RequirementsCsv_discreteRow(f, t, tNext, tPre)] ? 1 : 0;
}

int RequirementsCsv_getInteger(void* obj, int column, double t, double tNext, double tPre)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    if (f == NULL) ModelicaError("RequirementsCsv: getInteger on a closed file\n");
    if (column < 1 || (size_t)column > f->nInteger) ModelicaFormatError("RequirementsCsv: Integer column index %d is out of range 1..%lu\n", column, (unsigned long)f->nInteger);
    return f->integer[(size_t)(column - 1) * f->nRows + RequirementsCsv_discreteRow(f, t, tNext, tPre)];
}

int RequirementsCsv_getRows(void* obj)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    return f == NULL ? 0 : (int)f->nRows;
}

int RequirementsCsv_getEvents(void* obj)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    return f == NULL ? 0 : (int)f->nEvents;
}

void RequirementsCsv_getTimeRange(void* obj, double* tMin, double* tMax)
{
    RequirementsCsv_File* f = (RequirementsCsv_File*)obj;
    if (f == NULL) ModelicaError("RequirementsCsv: getTimeRange on a closed file\n");
    *tMin = f->time[0];
    *tMax = f->time[f->nRows - 1];
}

#endif /* REQUIREMENTS_CSV_H */
