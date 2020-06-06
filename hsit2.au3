#RequireAdmin
#include <Timers.au3>
#include <MsgBoxConstants.au3>

Local Const $iWait = 500
Local Const $iInactive = 30000
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"

Local $bIsRunning = False

Func RunScript()
	If $bIsRunning = True Then
		Return
	EndIf

	$bIsRunning = True

	Run($sStartScript)
EndFunc   ;==>RunScript

Func StopScript()
	If $bIsRunning = False Then
		Return
	EndIf

	$bIsRunning = False

	Run($sStopScript)
EndFunc   ;==>StopScript

If Not ProcessExists("bdcam.exe") Then
	Local $iPID = Run($sBinary & " /nosplash", "", @SW_HIDE)

	If @error <> 0 Then
		MsgBox($MB_SYSTEMMODAL, "", "bdcam.exe is not running")
		Exit 1
	EndIf
EndIf

Sleep(10000)

While True
	Sleep($iWait)

	Local $iIdleTime = _Timer_GetIdleTime()

	If $iIdleTime > $iInactive Then
		StopScript()
	ElseIf $iIdleTime <= $iWait Then
		RunScript()
	EndIf
WEnd
