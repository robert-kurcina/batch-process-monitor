# batch-process-monitor
Overview:
1. Given a list of process names ```monitored.processes.txt``` check if each entry in that list is running.
2. Output to ```stopped.processes.txt``` each process name not found.
3. The file ```stopped.processes.txt``` is deleted at the start of each execution of this batch file

# sample process list
Here's a sample list of processes pulled from the DOS command ```tasklist``` .

This creates the following;
```
NewtecModulatorElmManager
NMX Designer.exe
NMX Operator.exe
NmxNgServerController.exe
NMXValidatorService.exe
NsgStatManager.exe
ProViewElmManagerModule.e
```

```NOTE: the processes names are clipped here.```
From the DOS prompt, the process names are truncated to 25 characters in length. Additionally, some of the process names contain spaces. This may cause a problem in finding a matching entry on the task list.

# key subroutine
This is the primary function of the batch file. The subroutine ```SUB_checkrunning``` receives a processname from the ```monitored.processes.txt``` list and compares it against the entries found within ```TASKLIST``` which is Windows' active process list. If it does not find a match, it will append to the ```stoppped.processes.txt```. Here it creates an array of stopped processes via ```stopped[%ID%]=%processname%``` for utilization later.
```
:SUB_checkrunning

SET processname=%~1%
TASKLIST /FI "IMAGENAME eq %processname%" 2>NUL | FIND /I /N "%processname%">NUL

IF "%ERRORLEVEL%" EQU "0" (
  ECHO - %processname% is RUNNING!!
)

IF "%ERRORLEVEL%" NEQ "0" (
  SET /A ID=ID+1
  SET stopped[%ID%]=%processname%
  ECHO - %processname% is STOPPED!!
)

EXIT /B 0
```
