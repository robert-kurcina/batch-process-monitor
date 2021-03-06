::===================================================================
:: PROCESS MONITORING SCRIPT
:: -------------------------
::
:: Name:       check.running.processes.bat
:: Purpose:    write output list for all processes from input list not running
:: Author:     Robert Kurcina https://github.com/robert-kurcina
:: Revision:   2018-05-31 at 2239 PST
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
SETLOCAL ENABLEDELAYEDEXPANSION

:: script global variables
SET me=~%n0

::-------------------------------------------------------------------
:: entry point for re-running the script
::-------------------------------------------------------------------
SET ID=0
SET exit_value=0

CALL:SUB_loadlist
CALL:SUB_console
ENDLOCAL

::-------------------------------------------------------------------
:: force execution to quit at the end of the "main" logic
::-------------------------------------------------------------------
EXIT /B %exit_value%


::===================================================================
:: check if tasklist process entry is running
::-------------------------------------------------------------------
:SUB_checkrunning

SET processname=%~1%
TASKLIST /FO LIST | find "%processname%" | FIND /I /N "%processname%">NUL

IF "%ERRORLEVEL%" EQU "0" (
  ECHO RUNNING: %processname%
)

IF "%ERRORLEVEL%" NEQ "0" (
  SET /A ID=ID+1
  SET stopped[%ID%]=%processname%
  SET exit_value=2
  ECHO STOPPED: %processname%
)

EXIT /B 0



::===================================================================
:: invoke the subroutine function against each process item
::-------------------------------------------------------------------
:SUB_loadlist

ECHO.
ECHO CHECKING processes
FOR /F "delims=;" %%A IN (monitored.processes.txt) DO (
    CALL:SUB_checkrunning "%%A"
)

EXIT /B 0


::===================================================================
:: output the stopped list to console
::-------------------------------------------------------------------
:SUB_console

ECHO.

IF "%exit_value%" NEQ "0" (
  ECHO STOPPED:
  FOR /L %%n IN (0,1,%ID%) DO (
     SET str=!stopped[%%n]!
     IF DEFINED str ECHO !stopped[%%n]!
  )
)

EXIT /B 0
