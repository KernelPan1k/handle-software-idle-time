#RequireAdmin
#include <MsgBoxConstants.au3>
#include <WinAPIProc.au3>

;~ #################################
;~ Editable temps avant fin enregistrement: 1000 * 30 = 30 seconds
Local Const $iInactive = 1000 * 30
;~ #################################

Local Const $iBeforeRunning = 1000 * 10
Local Const $iWait = 150
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"
Local Const $TOOL_NAME = "WsssM"
Local Const $ERROR_ALREADY_EXISTS = 183
Local Const $ERROR_ACCESS_DENIED = 5
Local $bIsRunning = False
Local $iMouseX = Null
Local $iMouseY = Null
Local $bUser32 = Null
Local $hTimer = Null

Func IsInstanceRunning()
	Local $iErrorCode = 0 ;
	_WinAPI_CreateMutex($TOOL_NAME & "_MUTEX", True, 0)
	$iErrorCode = _WinAPI_GetLastError()
	Return $iErrorCode == $ERROR_ALREADY_EXISTS Or $iErrorCode == $ERROR_ACCESS_DENIED
EndFunc   ;==>IsInstanceRunning

If (IsInstanceRunning()) Then
	ConsoleWrite("Already in running")
	Exit
EndIf

Func RunScript()
	$hTimer = Null

	If $bIsRunning = True Then _
			Return

	$bIsRunning = True

	Run($sStartScript)
EndFunc   ;==>RunScript

Func StopScript()
	If $bIsRunning = False Then _
			Return

	$bIsRunning = False
	$hTimer = Null

	Run($sStopScript)
EndFunc   ;==>StopScript

Func RunBandyCam()
	ConsoleWrite(1)
	If Not ProcessExists("bdcam.exe") Then
		$bIsRunning = False
		$hTimer = Null
		Run($sBinary & " /nosplash")
	EndIf
	ConsoleWrite(2)
EndFunc   ;==>RunBandyCam

RunBandyCam()

Sleep($iBeforeRunning)

Func UserIsActive()
	If $bUser32 = Null Then
		$bUser32 = DllOpen('user32.dll')
	EndIf

	Local $bIsActive = False
	Local $aMousePos = MouseGetPos()

	If $aMousePos[0] <> $iMouseX _
			Or $aMousePos[1] <> $iMouseY Then
		$bIsActive = True
	EndIf

	$iMouseX = $aMousePos[0]
	$iMouseY = $aMousePos[1]

	If $bIsActive Then _
			Return True

	For $i = 1 To 94
		Local $aReturn = DllCall($bUser32, "short", "GetAsyncKeyState", "int", "0x" & Hex($i))

		If @error <> 0 Then _
				ContinueLoop

		If BitAND($aReturn[0], 0x8000) <> 0 Then _
				Return True
	Next

	Return False
EndFunc   ;==>UserIsActive

Func MustQuitScript()
	If $bIsRunning = False Then
		Return False
	EndIf

	If $hTimer = Null Then
		$hTimer = TimerInit()
		Return False
	EndIf

	Local $fDiff = TimerDiff($hTimer)

	Return $fDiff > $iInactive
EndFunc   ;==>MustQuitScript

Local $iCpt = 0

While True
	Sleep($iWait)

	Local $userIsActive = UserIsActive()

	If $userIsActive Then
		RunScript()
	ElseIf MustQuitScript() Then
		StopScript()
	EndIf

	$iCpt = $iCpt + 1

	If $iCpt >= 20 Then
		$iCpt = 0
		RunBandyCam()
	EndIf
WEnd

DllClose($bUser32)

Exit
