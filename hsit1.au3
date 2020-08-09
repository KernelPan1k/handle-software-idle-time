#RequireAdmin
#NoTrayIcon
#include-once

#include <MsgBoxConstants.au3>
#include <WinAPIProc.au3>
#include <Misc.au3>

OnAutoItExitRegister("OnExit")
AutoItSetOption("MustDeclareVars", 1)

Local Const $iInactive = 1000 * 30 ;~ Edit time end recording: 1000 * 30 = 30 seconds
Local Const $iBeforeRunning = 1000 * 10
Local Const $iWait = 50
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"
Local Const $sRunScript = $sBinary & " /nosplash"
Local Const $TOOL_NAME = "WsssM"
Local Const $sBandicanClass = "[CLASS:Bandicam2.x]"
Local Const $ERROR_ALREADY_EXISTS = 183
Local Const $ERROR_ACCESS_DENIED = 5
Local $hWinBandicam = Null
Local $bIsRunning = False
Local $iMouseX = Null
Local $iMouseY = Null
Local $bUser32 = Null
Local $bKernel32 = Null
Local $bShell32 = Null
Local $hTimer = Null
Local $bIsXP = False
Local $iWin = 2

If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
	$bIsXP = True
	$iWin = 1
EndIf

Func OnExit()
	If $bUser32 <> Null Then
		DllClose($bUser32)
	EndIf

	If $bKernel32 <> Null Then
		DllClose($bKernel32)
	EndIf

	If $bShell32 <> Null Then
		DllClose($bShell32)
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

;~ https://www.autoitscript.com/forum/topic/103871-_systray-udf/

Func _SysTrayGetButtonInfo($iIndex, $iInfo = 1)
	Local Const $TB_GETBUTTON = 1047
;~  Local Const $TB_GETBUTTONTEXT = 1099
;~  Local Const $TB_GETBUTTONINFO = 1089
	Local Const $TB_GETITEMRECT = 1053
	Local Const $ACCESS = BitOR(0x0008, 0x0010, 0x0400) ; VM_OPERATION, VM_READ, QUERY_INFORMATION
	Local $TBBUTTON
	If @OSArch = "X86" Then
		$TBBUTTON = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
	Else ; X64
		$TBBUTTON = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
	EndIf
	Local $TRAYDATA
	If @OSArch = "X86" Then
		$TRAYDATA = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
	Else
		$TRAYDATA = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
	EndIf
	Local $trayHwnd = _FindTrayToolbarWindow()
	If $trayHwnd = -1 Then Return SetError(1, 0, -1)
	Local $return, $err = 0
	Local $ret = DllCall($bUser32, "dword", "GetWindowThreadProcessId", "hwnd", $trayHwnd, "dword*", 0)
	If @error Or Not $ret[2] Then SetError(2, 0, -1)
	Local $pId = $ret[2]
	Local $procHandle = DllCall($bKernel32, "handle", "OpenProcess", "dword", $ACCESS, "bool", False, "dword", $pId)
	If @error Or Not $procHandle[0] Then Return SetError(3, 0, -1)
	Local $lpData = DllCall($bKernel32, "ptr", "VirtualAllocEx", "handle", $procHandle[0], "ptr", 0, "ulong", DllStructGetSize($TBBUTTON), "dword", 0x1000, "dword", 0x04)
	If Not @error And $lpData[0] Then
		$ret = DllCall($bUser32, "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETBUTTON, "wparam", $iIndex, "lparam", $lpData[0])
		If Not @error And $ret[0] Then
			DllCall($bKernel32, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $TBBUTTON, "ulong", DllStructGetSize($TBBUTTON), "ulong*", 0)
			Switch $iInfo
				Case 2
					; TRAYDATA structure
					DllCall($bKernel32, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 6), "struct*", $TRAYDATA, "ulong", DllStructGetSize($TRAYDATA), "ulong*", 0)
					$return = $TRAYDATA
				Case 3
					; tooltip
					$return = ""
					If BitShift(DllStructGetData($TBBUTTON, 7), 16) <> 0 Then
						Local $intTip = DllStructCreate("wchar[1024]")
						; we have a pointer to a string, otherwise it is an internal resource identifier
						DllCall($bKernel32, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 7), "struct*", $intTip, "ulong", DllStructGetSize($intTip), "ulong*", 0)
						$return = DllStructGetData($intTip, 1)
						;else internal resource
					EndIf
				Case 4
					; icon position
					If Not BitAND(DllStructGetData($TBBUTTON, 3), 8) Then ; 8 = TBSTATE_HIDDEN
						Local $pos[2], $RECT = DllStructCreate("int;int;int;int")
						DllCall($bUser32, "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETITEMRECT, "wparam", $iIndex, "lparam", $lpData[0])
						DllCall($bKernel32, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $RECT, "ulong", DllStructGetSize($RECT), "ulong*", 0)
						$ret = DllCall($bUser32, "int", "MapWindowPoints", "hwnd", $trayHwnd, "ptr", 0, "struct*", $RECT, "uint", 2)
						$pos[0] = DllStructGetData($RECT, 1)
						$pos[1] = DllStructGetData($RECT, 2)
						$return = $pos
					Else
						$return = -1
					EndIf
				Case Else
					; TBBUTTON
					$return = $TBBUTTON
			EndSwitch
		Else
			$err = 5
		EndIf
		DllCall($bKernel32, "bool", "VirtualFreeEx", "handle", $procHandle[0], "ptr", $lpData[0], "ulong", 0, "dword", 0x8000)
	Else
		$err = 4
	EndIf
	DllCall($bKernel32, "bool", "CloseHandle", "handle", $procHandle[0])
	If $err Then
		Return SetError($err, 0, -1)
	Else
		Return $return
	EndIf
EndFunc   ;==>_SysTrayGetButtonInfo

Func _FindTrayToolbarWindow()
	Local $hwnd, $ret = -1
	If $iWin = 1 Then
		$hwnd = DllCall($bUser32, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
		If @error Then Return -1
		$hwnd = DllCall($bUser32, "hwnd", "FindWindowEx", "hwnd", $hwnd[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
		If @error Then Return -1
		If @OSVersion <> "WIN_2000" Then
			$hwnd = DllCall($bUser32, "hwnd", "FindWindowEx", "hwnd", $hwnd[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
			If @error Then Return -1
		EndIf
		$hwnd = DllCall($bUser32, "hwnd", "FindWindowEx", "hwnd", $hwnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hwnd[0]
	ElseIf $iWin = 2 Then
		; NotifyIconOverflowWindow for Windows 7
		$hwnd = DllCall($bUser32, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
		If @error Then Return -1
		$hwnd = DllCall($bUser32, "hwnd", "FindWindowEx", "hwnd", $hwnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hwnd[0]
	EndIf
	Return $ret
EndFunc   ;==>_FindTrayToolbarWindow

Func _SysTrayIconCount()
	Local Const $TB_BUTTONCOUNT = 1048
	Local $hwnd = _FindTrayToolbarWindow()
	If $hwnd = -1 Then Return -1
	Local $count = DllCall($bUser32, "lresult", "SendMessageW", "hwnd", $hwnd, "uint", $TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
	If @error Then Return -1
	Return $count[0]
EndFunc   ;==>_SysTrayIconCount

Func _SysTrayIconHandle($iIndex)
	Local $TRAYDATA = _SysTrayGetButtonInfo($iIndex)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Ptr(DllStructGetData($TRAYDATA, 1))
	EndIf
EndFunc   ;==>_SysTrayIconHandle

Func _SysTrayIconTitles()
	Local $count = _SysTrayIconCount()
	If $count <= 0 Then Return -1
	Local $titles[$count]
	; Get icon owner window"s title
	For $i = 0 To $count - 1
		$titles[$i] = WinGetTitle(_SysTrayIconHandle($i))
	Next
	Return $titles
EndFunc   ;==>_SysTrayIconTitles

Func _SysTrayIconRemove($index)
	Local Const $TB_DELETEBUTTON = 1046
	Local $TRAYDATA = _SysTrayGetButtonInfo($index, 2)
	If @error Then Return SetError(@error, 0, -1)
	Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
			 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
			 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
	DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
	DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
	DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
	Local $ret = DllCall($bShell32, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $NOTIFYICONDATA) ; NIM_DELETE
	DllCall($bUser32, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
	If IsArray($ret) And $ret[0] Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_SysTrayIconRemove

Func RefreshSysTray()
	If $bUser32 = Null Then
		$bUser32 = DllOpen('user32.dll')
	EndIf

	If $bKernel32 = Null Then
		$bKernel32 = DllOpen('kernel32.dll')
	EndIf

	If $bShell32 = Null Then
		$bShell32 = DllOpen('shell32.dll')
	EndIf

	Local $titles = _SysTrayIconTitles()

	For $i = 0 To (UBound($titles) - 1)
		If $titles[$i] = "" Then
			_SysTrayIconRemove($i)
		EndIf
	Next
EndFunc   ;==>RefreshSysTray

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
		RefreshSysTray()
	Else
		CheckBandyCam()
	EndIf
EndFunc   ;==>RunScript

Func StopScript()
	If $bIsRunning = False Then Return
	$bIsRunning = False
	$hTimer = Null

	If $bIsXP = False Then
		Run($sStopScript)
	Else
		Send("+{F12}")
		Sleep(1000)
		ProcessClose("bdcam.exe")
	EndIf

	RefreshSysTray()
EndFunc   ;==>StopScript

Func CheckBandyCam()
	If Not ProcessExists("bdcam.exe") Then
		Run($sRunScript)
		WinWait($sBandicanClass)
		$hWinBandicam = WinGetHandle($sBandicanClass)
		WinSetState($hWinBandicam, "", @SW_HIDE)
		ResetVars()

		If $bIsXP = True Then
			$bIsRunning = True
		EndIf

		RefreshSysTray()
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

	If $bIsXP = False Then
		$iTime = $iTime + $iWait

		If $iTime > 5000 Then
			$iTime = 0
			CheckBandyCam()
		EndIf
	EndIf

	WinSetState($hWinBandicam, "", @SW_HIDE)
WEnd

Exit

