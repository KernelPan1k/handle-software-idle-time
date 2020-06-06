#include <Timers.au3>

Local Const $iWait = 500
Local Const $iInactive = 100000
Local Const $sStartScript = "something ..."
Local Const $sStopScript = "something ..."

Local $bIsRunning = False

Func RunScript()
   If $bIsRunning = True Then
	  Return
   EndIf

   $bIsRunning = True
   Run($sStartScript)
EndFunc

Func StopScript()
   If $bIsRunning = False Then
	  Return
   EndIf

   $bIsRunning = False
   Run($sStopScript)
EndFunc

While True
   Sleep($iWait)

   Local $iIdleTime = _Timer_GetIdleTime()

   If $iIdleTime > $iInactive Then
	  StopScript()
   ElseIf $iIdleTime <= $iWait Then
	  RunScript()
   EndIf
WEnd
