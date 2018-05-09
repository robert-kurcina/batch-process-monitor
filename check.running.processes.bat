::===================================================================
:: PROCESS MONITORING SCRIPT
:: -------------------------
::
:: Name:       check.running.processes.bat
:: Purpose:    write output list for all processes from input list not running
:: Author:     Robert Kurcina https://github.com/robert-kurcina
:: Revision:   2018-05-09 at 1634 PST
::
:: GIVEN
:: -------------------------
:: provide a file named monitored.processes.txt in the same folder with a list of processes
:: where each process name is on its own line
::
:: ACTION
:: -------------------------
:: for each process which is NOT RUNNING, a file stopped.processes.txt will be
:: appended with that process name, with one entry per line
::
:: that file will be deleted at the start of this script's execution
:: this script will execute once per 5 minutes
::-------------------------------------------------------------------
@ECHO OFF
SETLOCAL enabledelayedexpansion

:: script global variables
SET me=~%n0

::-------------------------------------------------------------------
:: entry point for re-running the script
::-------------------------------------------------------------------
:GLOBAL_loop

SET ID=0

:: invoke the subroutine function against each process item
ECHO ---
ECHO CHECKING processes
FOR /F "delims=;" %%A IN (sample.monitored.processes.txt) DO (
    CALL:SUB_checkrunning "%%A"
)

ECHO ---
ECHO STOPPED processes
FOR /L %%n IN (0,1,%ID%) DO (
   ECHO - !output[%%n]!
)

ENDLOCAL

::-------------------------------------------------------------------
:: force execution to quit at the end of the "main" logic
::-------------------------------------------------------------------
::TIMEOUT 300 /NOBREAK
::GOTO:GLOBAL_loop
EXIT /B %ERRORLEVEL%

::===================================================================
:: check if tasklist process entry is running
::-------------------------------------------------------------------
:SUB_checkrunning

set processname=%~1%
tasklist /FI "IMAGENAME eq %processname%" 2>NUL | FIND /I /N "%processname%">NUL

IF "%ERRORLEVEL%" EQU "0" (
  ECHO %processname% is running!!
)

IF "%ERRORLEVEL%" NEQ "0" (
  SET /A ID=ID+1
  SET output[%ID%]=%processname%
  ECHO - %processname% is not running!!
)

EXIT /B 0

::----------------------------------
