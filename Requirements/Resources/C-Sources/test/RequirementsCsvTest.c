/* RequirementsCsvTest.c - the reader compiled as a shared library for the ctypes
   test (test_requirements_csv.py), with ModelicaError/ModelicaFormatError
   replaced by stubs that record the message and longjmp back into the
   wrapper, so an error is a return value instead of a process exit.

   Copyright (c) 2026 Model Based Innovation LLC. All rights reserved. */
#include <setjmp.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "ModelicaUtilities.h"

#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

/* GCC's builtin setjmp/longjmp pair: mingw-w64's longjmp unwinds the stack
   through SEH, which fails (STATUS_BAD_STACK) when the jump crosses the
   noreturn ModelicaFormatError frame; the builtins just restore registers. */
#if defined(__GNUC__)
#define TEST_SETJMP(e)    __builtin_setjmp(e)
#define TEST_LONGJMP(e)   __builtin_longjmp(e, 1)
static void* env[5];
#else
#define TEST_SETJMP(e)    setjmp(e)
#define TEST_LONGJMP(e)   longjmp(e, 1)
static jmp_buf env;
#endif
static char message[4096];

void ModelicaError(const char* s)
{
    strncpy(message, s, sizeof(message) - 1);
    message[sizeof(message) - 1] = 0;
    TEST_LONGJMP(env);
}

void ModelicaFormatError(const char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    vsnprintf(message, sizeof(message), fmt, args);
    va_end(args);
    TEST_LONGJMP(env);
}

void ModelicaMessage(const char* s) { (void)s; }
void ModelicaFormatMessage(const char* fmt, ...) { (void)fmt; }

#include "../../Include/RequirementsCsv.h"

EXPORT const char* test_lastError(void) { return message; }

EXPORT void* test_open(const char* fileName, const char** realNames, int nReal,
                       const char** booleanNames, int nBoolean,
                       const char** integerNames, int nInteger, int hold)
{
    message[0] = 0;
    if (TEST_SETJMP(env)) return NULL;
    return RequirementsCsv_open(fileName, realNames, (size_t)nReal, booleanNames, (size_t)nBoolean,
                                integerNames, (size_t)nInteger, hold);
}

EXPORT void test_close(void* f) { RequirementsCsv_close(f); }

EXPORT int test_rows(void* f) { return RequirementsCsv_getRows(f); }
EXPORT int test_events(void* f) { return RequirementsCsv_getEvents(f); }
EXPORT double test_nextTimeEvent(void* f, double t) { return RequirementsCsv_nextTimeEvent(f, t); }

EXPORT double test_getReal(void* f, int column, double t, double tNext, double tPre, int* err)
{
    message[0] = 0;
    if (TEST_SETJMP(env)) { *err = 1; return 0.0; }
    *err = 0;
    return RequirementsCsv_getReal(f, column, t, tNext, tPre);
}

EXPORT int test_getBoolean(void* f, int column, double t, double tNext, double tPre, int* err)
{
    message[0] = 0;
    if (TEST_SETJMP(env)) { *err = 1; return 0; }
    *err = 0;
    return RequirementsCsv_getBoolean(f, column, t, tNext, tPre);
}

EXPORT int test_getInteger(void* f, int column, double t, double tNext, double tPre, int* err)
{
    message[0] = 0;
    if (TEST_SETJMP(env)) { *err = 1; return 0; }
    *err = 0;
    return RequirementsCsv_getInteger(f, column, t, tNext, tPre);
}

EXPORT void test_timeRange(void* f, double* tMin, double* tMax) { RequirementsCsv_getTimeRange(f, tMin, tMax); }
