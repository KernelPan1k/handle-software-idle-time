#RequireAdmin
#include <MsgBoxConstants.au3>

Local Const $iWait = 100
Local Const $iInactive = 30000
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"
Local $bIsRunning = False
Local $iMouseX = Null
Local $iMouseY = Null
Local $bUser32 = Null
Local $hTimer = Null

Func RunScript()
	$hTimer = Null

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
	$hTimer = Null

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

Func UserIsActive()
	If $bUser32 = Null Then
		$bUser32 = DllOpen('user32.dll')
	EndIf

	Local $bIsActive = False
	Local $aMousePos = MouseGetPos()

	If $aMousePos[0] <> $iMouseX Then
		If $iMouseX <> Null Then
			$bIsActive = True
		EndIf
	EndIf

	If $aMousePos[1] <> $iMouseY Then
		If $iMouseY <> Null Then
			$bIsActive = True
		EndIf
	EndIf

	$iMouseX = $aMousePos[0]
	$iMouseY = $aMousePos[1]

	If $bIsActive Then
		Return True
	EndIf

	For $i = 1 To 94
		Local $aReturn = DllCall($bUser32, "short", "GetAsyncKeyState", "int", "0x" & Hex($i))

		If @error <> 0 Then
			ContinueLoop
		EndIf

		If BitAND($aReturn[0], 0x8000) <> 0 Then
			Return True
		EndIf
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

While True
	Sleep($iWait)

	Local $userIsActive = UserIsActive()

	If $userIsActive Then
		RunScript()
	ElseIf MustQuitScript() Then
		StopScript()
	EndIf
WEnd

DllClose($bUser32)

Exit

