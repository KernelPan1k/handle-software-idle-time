#RequireAdmin
#NoTrayIcon
#include-once

#Region
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sci 1
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rm /sf=1 /sv=1 /mi
#EndRegion

#include <WinAPIProc.au3>
#include <Misc.au3>

OnAutoItExitRegister("OnExit")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)

Local Const $iInactive = 1000 * 30 ;~ Edit time end recording: 1000 * 30 = 30 seconds
Local Const $iBeforeRunning = 1000 * 10
Local Const $iWait = 50
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"
Local Const $sRunScript = $sBinary & " /nosplash"
Local Const $TOOL_NAME = "WsssM"
Local Const $sBandicanClass = "[CLASS:Bandicam2.x]"
Local Const $sBandicanControlSelector = "[X:0; Y:0; W:350; H:22]"
Local Const $ERROR_ALREADY_EXISTS = 183
Local Const $ERROR_ACCESS_DENIED = 5
Local $hWinBandicam = Null
Local $hWinControlBandicam = Null
Local $bIsRunning = False
Local $iMouseX = Null
Local $iMouseY = Null
Local $bUser32 = Null
Local $hTimer = Null
Local $bIsXP = False
Local $bSkeep = False

If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
	$bIsXP = True
EndIf

Func OnExit()
	If $bUser32 <> Null Then
		DllClose($bUser32)
	EndIf
EndFunc   ;==>OnExit

Func IsInstanceRunning()
	Local $iErrorCode = 0 ;
	_WinAPI_CreateMutex($TOOL_NAME & "_MUTEX", True, 0)
	$iErrorCode = _WinAPI_GetLastError()
	Return $iErrorCode == $ERROR_ALREADY_EXISTS Or $iErrorCode == $ERROR_ACCESS_DENIED
EndFunc   ;==>IsInstanceRunning

If IsInstanceRunning() Then
	Exit
EndIf

If $bIsXP = True Then
	Local $s64Bit = ""
	If @OSArch = "X64" Then $s64Bit = "64"
	Local $sKey = "HKCU" & $s64Bit & "\Software\BANDISOFT\BANDICAM\OPTION"
	RegWrite($sKey, "nTargetOpacity", "REG_DWORD", 0)
	RegWrite($sKey, "dwVideoHotkey", "REG_DWORD", 327869)
EndIf

Func ResetVars()
	$bIsRunning = False
	$iMouseX = Null
	$iMouseY = Null
	$hTimer = Null
EndFunc   ;==>ResetVars

Func RunScript()
	$hTimer = Null
	If $bIsRunning = True Then Return
	$bIsRunning = True
	If $bIsXP = False Then
		Run($sStartScript)
	Else
		Send("^!{-}")
	EndIf
EndFunc   ;==>RunScript

Func StopScript()
	If $bIsRunning = False Then Return
	$bIsRunning = False
	$hTimer = Null

	If $bIsXP = False Then
		Run($sStopScript)
	Else
		Send("^!{-}")
		$bSkeep = True
	EndIf
EndFunc   ;==>StopScript

Func CheckBandyCam()
	If Not ProcessExists("bdcam.exe") Then
		Run($sRunScript)

		WinWait($sBandicanClass)
		$hWinBandicam = WinGetHandle($sBandicanClass)
		WinSetState($hWinBandicam, "", @SW_HIDE)
		WinSetState("classname=Shell_TrayWnd", "", @SW_HIDE)

		ResetVars()

		If $bIsXP = True Then
			Send("^!h")
		EndIf
	EndIf
EndFunc   ;==>CheckBandyCam

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

	If $bIsActive Then Return True

	If $bSkeep = True Then
		$bSkeep = False
		Return False
	EndIf

	For $i = 1 To 221
		If _IsPressed(Hex($i), $bUser32) Then
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

ProcessClose("bdcam.exe")
WinSetState("classname=Shell_TrayWnd", "", @SW_HIDE)

CheckBandyCam()

Sleep($iBeforeRunning)

Local $iTime = 0
Local $aMousePos = MouseGetPos()
$iMouseX = $aMousePos[0]
$iMouseY = $aMousePos[1]

While True
	Sleep($iWait)

	If UserIsActive() Then
		RunScript()
	ElseIf MustQuitScript() Then
		StopScript()
	EndIf

	$iTime = $iTime + $iWait

	If $iTime > 5000 Then
		$iTime = 0
		CheckBandyCam()
	EndIf

	WinSetState($hWinBandicam, "", @SW_HIDE)
WEnd

Exit
