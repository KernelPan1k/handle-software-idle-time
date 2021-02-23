#NoTrayIcon
#RequireAdmin
#include-once

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sci 1
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rm /sf=1 /sv=1 /mi
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <File.au3>
#include <Array.au3>

OnAutoItExitRegister("OnExit")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)

Func IsInstanceRunning()
	Local Const $ERROR_ALREADY_EXISTS = 183
	Local Const $ERROR_ACCESS_DENIED = 5
	Local Const $TOOL_NAME = "WsssM"
	Local $iErrorCode = 0 ;
	_WinAPI_CreateMutex($TOOL_NAME & "_MUTEX", True, 0)
	$iErrorCode = _WinAPI_GetLastError()
	Return $iErrorCode == $ERROR_ALREADY_EXISTS Or $iErrorCode == $ERROR_ACCESS_DENIED
EndFunc   ;==>IsInstanceRunning

If IsInstanceRunning() Then
	Exit
EndIf

Opt("SendKeyDownDelay", 100)

;~ Users vars
Local Const $iInactive = 1000 * 30 ;~ Edit time end recording: 1000 * 30 = 30 seconds
Local Const $iBeforeRunning = 2000 * 10
Local Const $iWait = 500

;~ DLL
Local $bUser32 = Null
Local $bKernel32 = Null
Local $bShell32 = Null

;~ Timer
Local $hTimer = Null

;~ Functions
Local Const $sBinary = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $sStartScript = $sBinary & " /record"
Local Const $sStopScript = $sBinary & " /stop"
Local Const $sRunScript = $sBinary & " /nosplash"
Local Const $sBandicanClass = "[CLASS:Bandicam2.x]"
Local $iKeepVideo = 107374182400
Local $bIsXP = False
Local $iSkip = 0
Local $sOutputPath = Null
Local $bHideSystray = True
Local $bUserActivity = True
Local $iMaxAttempt = 20
Local $bIsRunning = False
Local $bdCamIdle = 0

;~ Handles
Local $aHandles[1] = [0]
Local $hWinBandicam = Null

;~ Active
Local $hActiveTimer = Null
Local $iActiveCount = 0
Local $iActiveSleep = 1500

;~ HOOK
Local $hStub_KeyProc = Null
Local $hStub_MouseProc = Null
Local $hHookKeyboard = Null
Local $hHookMouse = Null

If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
	$bIsXP = True
	$iKeepVideo = 16106127360
EndIf

If UBound($CmdLine) > 1 Then
	For $i = 1 To UBound($CmdLine) - 1
		Local $sCurrent = StringSplit($CmdLine[$i], "=", $STR_NOCOUNT)
		Local $sParam = StringUpper($sCurrent[0])
		Local $iVal = Number($sCurrent[1])

		If $sParam = "HIDESYSTRAY" Then
			If $iVal = 0 Then
				$bHideSystray = False
			Else
				$bHideSystray = True
			EndIf

		ElseIf $sParam = "KEYPRESS" Then
			Opt("SendKeyDownDelay", $iVal)

		ElseIf $sParam = "MAXATTEMPT" Then
			$iMaxAttempt = $iVal

		ElseIf $sParam = "USERACTIVITY" Then
			If $iVal = 0 Then
				$bUserActivity = False
			Else
				$bUserActivity = True
			EndIf
		EndIf
	Next
EndIf

Func OnExit()
	Dim $bUser32
	Dim $bKernel32
	Dim $bShell32
	Dim $hHookMouse
	Dim $hHookKeyboard
	Dim $hStub_MouseProc
	Dim $hStub_KeyProc

	If $bUser32 <> Null Then
		DllClose($bUser32)
		$bUser32 = Null
	EndIf

	If $bKernel32 <> Null Then
		DllClose($bKernel32)
		$bKernel32 = Null
	EndIf

	If $bShell32 <> Null Then
		DllClose($bShell32)
		$bShell32 = Null
	EndIf

	If $hHookMouse <> Null Then
		_WinAPI_UnhookWindowsHookEx($hHookMouse)
	EndIf

	If $hStub_MouseProc <> Null Then
		DllCallbackFree($hStub_MouseProc)
	EndIf

	If $hHookKeyboard <> Null Then
		_WinAPI_UnhookWindowsHookEx($hHookKeyboard)
	EndIf

	If $hStub_KeyProc <> Null Then
		DllCallbackFree($hStub_KeyProc)
	EndIf
EndFunc   ;==>OnExit

Func getUser32dll()
	If $bUser32 = Null Then
		$bUser32 = DllOpen('user32.dll')
	EndIf

	Return $bUser32
EndFunc   ;==>getUser32dll

Func getKernel32dll()
	If $bKernel32 = Null Then
		$bKernel32 = DllOpen('kernel32.dll')
	EndIf

	Return $bKernel32
EndFunc   ;==>getKernel32dll

Func getShell32dll()
	If $bShell32 = Null Then
		$bShell32 = DllOpen('shell32.dll')
	EndIf

	Return $bShell32
EndFunc   ;==>getShell32dll

;~ Function about systray were found here (https://www.autoitscript.com/forum/topic/103871-_systray-udf/) and adapted
Func _SysTrayIconCount($iWin = 1)
	Local Const $TB_BUTTONCOUNT = 1048
	Local $hWnd = _FindTrayToolbarWindow($iWin)
	If $hWnd = -1 Then Return -1
	Local $bU32Dll = getUser32dll()
	Local $count = DllCall($bU32Dll, "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
	If @error Then Return -1
	Return $count[0]
EndFunc   ;==>_SysTrayIconCount

Func _SysTrayIconTitles($iWin = 1)
	Local $count = _SysTrayIconCount($iWin)
	If $count <= 0 Then Return -1
	Local $titles[$count]
	; Get icon owner window"s title
	For $i = 0 To $count - 1
		$titles[$i] = WinGetTitle(_SysTrayIconHandle($i, $iWin))
	Next
	Return $titles
EndFunc   ;==>_SysTrayIconTitles

Func _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 1)
	Local Const $TB_GETBUTTON = 1047
	Local Const $TB_GETITEMRECT = 1053
	Local $bU32Dll = getUser32dll()
	Local $bK32Dll = getKernel32dll()
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
	Local $trayHwnd = _FindTrayToolbarWindow($iWin)
	If $trayHwnd = -1 Then Return SetError(1, 0, -1)
	Local $return, $err = 0
	Local $ret = DllCall($bU32Dll, "dword", "GetWindowThreadProcessId", "hwnd", $trayHwnd, "dword*", 0)
	If @error Or Not $ret[2] Then SetError(2, 0, -1)
	Local $pId = $ret[2]
	Local $procHandle = DllCall($bK32Dll, "handle", "OpenProcess", "dword", $ACCESS, "bool", False, "dword", $pId)
	If @error Or Not $procHandle[0] Then Return SetError(3, 0, -1)
	Local $lpData = DllCall($bK32Dll, "ptr", "VirtualAllocEx", "handle", $procHandle[0], "ptr", 0, "ulong", DllStructGetSize($TBBUTTON), "dword", 0x1000, "dword", 0x04)
	If Not @error And $lpData[0] Then
		$ret = DllCall($bU32Dll, "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETBUTTON, "wparam", $iIndex, "lparam", $lpData[0])
		If Not @error And $ret[0] Then
			DllCall($bK32Dll, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $TBBUTTON, "ulong", DllStructGetSize($TBBUTTON), "ulong*", 0)
			Switch $iInfo
				Case 2
					; TRAYDATA structure
					DllCall($bK32Dll, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 6), "struct*", $TRAYDATA, "ulong", DllStructGetSize($TRAYDATA), "ulong*", 0)
					$return = $TRAYDATA
				Case 3
					; tooltip
					$return = ""
					If BitShift(DllStructGetData($TBBUTTON, 7), 16) <> 0 Then
						Local $intTip = DllStructCreate("wchar[1024]")
						; we have a pointer to a string, otherwise it is an internal resource identifier
						DllCall($bK32Dll, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 7), "struct*", $intTip, "ulong", DllStructGetSize($intTip), "ulong*", 0)
						$return = DllStructGetData($intTip, 1)
						;else internal resource
					EndIf
				Case 4
					; icon position
					If Not BitAND(DllStructGetData($TBBUTTON, 3), 8) Then ; 8 = TBSTATE_HIDDEN
						Local $pos[2], $RECT = DllStructCreate("int;int;int;int")
						DllCall($bU32Dll, "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETITEMRECT, "wparam", $iIndex, "lparam", $lpData[0])
						DllCall($bK32Dll, "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $RECT, "ulong", DllStructGetSize($RECT), "ulong*", 0)
						$ret = DllCall($bU32Dll, "int", "MapWindowPoints", "hwnd", $trayHwnd, "ptr", 0, "struct*", $RECT, "uint", 2)
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
		DllCall($bK32Dll, "bool", "VirtualFreeEx", "handle", $procHandle[0], "ptr", $lpData[0], "ulong", 0, "dword", 0x8000)
	Else
		$err = 4
	EndIf
	DllCall($bK32Dll, "bool", "CloseHandle", "handle", $procHandle[0])
	If $err Then
		Return SetError($err, 0, -1)
	Else
		Return $return
	EndIf
EndFunc   ;==>_SysTrayGetButtonInfo

Func _SysTrayIconHandle($iIndex, $iWin = 1)
	Local $TRAYDATA = _SysTrayGetButtonInfo($iIndex, $iWin, 2)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Ptr(DllStructGetData($TRAYDATA, 1))
	EndIf
EndFunc   ;==>_SysTrayIconHandle

Func _SysTrayIconRemove($index, $iWin = 1)
	Local Const $TB_DELETEBUTTON = 1046
	Local $bU32Dll = getUser32dll()
	Local $bS32Dll = getShell32dll()
	Local $TRAYDATA = _SysTrayGetButtonInfo($index, $iWin, 2)
	If @error Then Return SetError(@error, 0, -1)
	Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
			 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
			 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
	DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
	DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
	DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
	Local $ret = DllCall($bS32Dll, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $NOTIFYICONDATA) ; NIM_DELETE
	DllCall($bU32Dll, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
	If IsArray($ret) And $ret[0] Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_SysTrayIconRemove

Func _FindTrayToolbarWindow($iWin = 1)
	Local $hWnd, $ret = -1
	Local $bU32Dll = getUser32dll()
	If $iWin = 1 Then
		$hWnd = DllCall($bU32Dll, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall($bU32Dll, "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
		If @error Then Return -1
		If @OSVersion <> "WIN_2000" Then
			$hWnd = DllCall($bU32Dll, "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
			If @error Then Return -1
		EndIf
		$hWnd = DllCall($bU32Dll, "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hWnd[0]
	ElseIf $iWin = 2 Then
		; NotifyIconOverflowWindow for Windows 7
		$hWnd = DllCall($bU32Dll, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall($bU32Dll, "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hWnd[0]
	EndIf
	Return $ret
EndFunc   ;==>_FindTrayToolbarWindow

Local $s64Bit = ""
If @OSArch = "X64" Then $s64Bit = "64"
Local $sKey = "HKCU" & $s64Bit & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($sKey, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($sKey, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($sKey, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($sKey, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($sKey, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($sKey, "bStartMinimized", "REG_DWORD", 1)
RegWrite($sKey, "nTargetMode", "REG_DWORD", 1)
RegWrite($sKey, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($sKey, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($sKey, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($sKey, "nScreenRecordingSubMode", "REG_DWORD", 1)

If $bIsXP = True Then
	RegWrite($sKey, "bVideoHotkey", "REG_DWORD", 1)
	RegWrite($sKey, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf

$sOutputPath = RegRead($sKey, "sOutputFolder")

If @error <> 0 Or 1 <> FileExists($sOutputPath) Then _
		$sOutputPath = Null


Func PurgeOldVideo()
	If Not $sOutputPath Then _
			Return

	Local $iSize = DirGetSize($sOutputPath)

	If $iSize < $iKeepVideo Then _
			Return

	Local $aFileList = _FileListToArrayRec($sOutputPath, "*.avi;*.mp4;*.bfix", $FLTA_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)

	If @error = 1 Or $aFileList = "" Or UBound($aFileList) < 2 Then _
			Return

	For $i = 1 To UBound($aFileList) - 1
		Local $iFileSize = FileGetSize($aFileList[$i])
		FileDelete($aFileList[$i])
		$iSize = $iSize - $iFileSize

		If $iSize < $iKeepVideo Then _
				ExitLoop
	Next
EndFunc   ;==>PurgeOldVideo

Func HideIcon()
	If $bHideSystray = False Then _
			Return

	Local $iWin = 1

	If $bIsXP = False Then $iWin = 2

	Local $aIcons = _SysTrayIconTitles($iWin)

	For $i = 0 To UBound($aIcons) - 1
		If StringRegExp($aIcons[$i], "(?i).*Bandicam.*") Then
			_SysTrayIconRemove($i, $iWin)
		EndIf
	Next
EndFunc   ;==>HideIcon

Func ResetVars()
	$bIsRunning = False
	$hTimer = Null
EndFunc   ;==>ResetVars

Func RunScript()
	$hTimer = Null
	If $bIsRunning = True Then Return
	$bIsRunning = True

	If $bIsXP = False Then
		Run($sStartScript)
	Else
		Send("^!+9")
	EndIf
EndFunc   ;==>RunScript

Func StopScript()
	If $bIsRunning = False Then Return
	$bIsRunning = False
	$hTimer = Null

	If $bIsXP = False Then
		Run($sStopScript)
	Else
		$iSkip = 1
		Send("^!+9")
	EndIf

	PurgeOldVideo()
EndFunc   ;==>StopScript

Func AddInHandleList($h)
	If _ArraySearch($aHandles, $h, 1) = -1 Then
		Local $iIndex = $aHandles[0] + 1
		ReDim $aHandles[$iIndex + 1]
		$aHandles[$iIndex] = $h
		$aHandles[0] = $iIndex
	EndIf
EndFunc   ;==>AddInHandleList

Func GetAllWindHandle($iN)
	Local $aList = WinList()

	For $i = 1 To $aList[0][0]
		If $aList[$i][0] = "" And BitAND(WinGetState($aList[$i][1]), $WIN_STATE_VISIBLE) Then
			Local $cHandle = $aList[$i][1]
			Local $cTitle = $aList[$i][0]
			Local $aPos = WinGetPos($cHandle)
			Local $iX = $aPos[0]
			Local $iY = $aPos[1]
			Local $iW = $aPos[2]
			Local $iH = $aPos[3]

			If $iY > -50 And $iY < 20 _
					And $iH > 0 And $iH < 80 _
					And $iW > 0 _
					And $iX > -80 _
					And $cTitle = "" Then
				AddInHandleList($cHandle)
			EndIf
		EndIf
	Next

	If UBound($aHandles) < 2 Then
		Local $iT = $iN + 1

		If $iMaxAttempt = -1 Or $iT < $iMaxAttempt Then
			Sleep(2000)
			GetAllWindHandle($iT)
		EndIf
	EndIf
EndFunc   ;==>GetAllWindHandle

Func HideWindows()
	WinSetState($hWinBandicam, "", @SW_HIDE)

	If UBound($aHandles) = 1 Then Return

	For $i = 1 To $aHandles[0]
		WinSetState($aHandles[$i], "", @SW_HIDE)
	Next
EndFunc   ;==>HideWindows

Func CheckBandyCam()
	If Not ProcessExists("bdcam.exe") Then
		Run($sRunScript)

		WinWait($sBandicanClass)
		$hWinBandicam = WinGetHandle($sBandicanClass)
		WinSetState($hWinBandicam, "", @SW_HIDE)
		Local $aTmp[1] = [0]
		$aHandles = $aTmp
		Sleep(2500)
		ResetVars()
		GetAllWindHandle(1)
		HideWindows()
		HideIcon()
	EndIf
EndFunc   ;==>CheckBandyCam

Func MustQuitScript()
	If $bIsRunning = False Then
		Return
	EndIf

	If $hTimer = Null Then
		$hTimer = TimerInit()
		Return
	EndIf

	Local $fDiff = TimerDiff($hTimer)

	If $fDiff > $iInactive Then
		StopScript()
	EndIf
EndFunc   ;==>MustQuitScript

Func KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)

	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
	EndIf

	$hTimer = Null

	If $iSkip > 0 Then
		Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
	EndIf

	If $wParam = $WM_KEYDOWN Then
		RunScript()
	EndIf

	Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
EndFunc   ;==>KeyProc

Func ResetActivityVars()
	$hActiveTimer = Null
	$iActiveCount = 0
EndFunc   ;==>ResetActivityVars

Func MouseProc($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
	EndIf

	$bdCamIdle = $bdCamIdle + 1

	If $bdCamIdle < 3 Then
		Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
	EndIf

	$hTimer = Null

	If $bUserActivity = False Then
		RunScript()
		Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
	EndIf

	If $bIsRunning = True Then
		ResetActivityVars()
		Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
	EndIf

	Local $fDiff = 0
	$iActiveCount = $iActiveCount + 1

	If $hActiveTimer = Null Then
		$hActiveTimer = TimerInit()
		Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
	Else
		$fDiff = TimerDiff($hActiveTimer)
	EndIf

	If $fDiff < $iActiveSleep Then
		Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
	EndIf

	Local $iTmp = $iActiveCount
	ResetActivityVars()

	If $iTmp > 10 Then
		RunScript()
	EndIf

	Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)
EndFunc   ;==>MouseProc

Func InitMouseHook()
	Local $hmodMouse = _WinAPI_GetModuleHandle(0)
	$hStub_MouseProc = DllCallbackRegister("MouseProc", "long", "int;wparam;lparam")
	$hHookMouse = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($hStub_MouseProc), $hmodMouse)
EndFunc   ;==>InitMouseHook

Func InitKeyBoardHook()
	Local $hmodKey = _WinAPI_GetModuleHandle(0)
	$hStub_KeyProc = DllCallbackRegister("KeyProc", "long", "int;wparam;lparam")
	$hHookKeyboard = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmodKey)
EndFunc   ;==>InitKeyBoardHook


If ProcessExists("bdcam.exe") Then
	ProcessClose("bdcam.exe")
	Sleep(5000)
EndIf

PurgeOldVideo()
CheckBandyCam()

Sleep($iBeforeRunning)

InitMouseHook()
InitKeyBoardHook()

Local $iTime = 0
Local $iNbrLoop = 0

While True
	Sleep($iWait)

	$bdCamIdle = 0

;~ 	Please refactore me
	If $iSkip > 0 Then
		$iSkip = $iSkip + 1
	EndIf

;~ 	Please refactore me
	If $iSkip >= 3 Then
		$iSkip = 0
	EndIf

	MustQuitScript()

	$iTime = $iTime + $iWait
	$iNbrLoop = $iNbrLoop + 1

;~ Try to improve perf on very old machines
	If $iNbrLoop = 2 Then
		$iNbrLoop = 0
		HideWindows()
	EndIf

;~ Try to improve perf on very old machines
	If $iTime > 15000 Then
		$iTime = 0
		CheckBandyCam()
	EndIf
WEnd
