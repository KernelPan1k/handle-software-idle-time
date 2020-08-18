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

; ----------------------------------------------------------------------------
;
; Author:         Tuape
; Modified:       Erik Pilsits
;
; Script Function:
;   Systray UDF - Functions for reading icon info from system tray / removing
;   any icon.
;
; Last Update: 5/13/2013
;
; ----------------------------------------------------------------------------

;===============================================================================
;
; Function Name:    _SysTrayIconCount($iWin = 1)
; Description:      Returns number of icons on systray
;                   Note: Hidden icons are also reported
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns number of icons found
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconCount($iWin = 1)
	Local Const $TB_BUTTONCOUNT = 1048
	Local $hWnd = _FindTrayToolbarWindow($iWin)
	If $hWnd = -1 Then Return -1
	Local $count = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
	If @error Then Return -1
	Return $count[0]
EndFunc   ;==>_SysTrayIconCount

;===============================================================================
;
; Function Name:    _SysTrayIconTitles($iWin = 1)
; Description:      Get list of all window titles that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all window titles
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
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

;===============================================================================
;
; Function Name:    _SysTrayIconPids($iWin = 1)
; Description:      Get list of all processes id's that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process id's
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPids($iWin = 1)
	Local $count = _SysTrayIconCount($iWin)
	If $count <= 0 Then Return -1
	Local $processes[$count]
	For $i = 0 To $count - 1
		$processes[$i] = WinGetProcess(_SysTrayIconHandle($i, $iWin))
	Next
	Return $processes
EndFunc   ;==>_SysTrayIconPids

;===============================================================================
;
; Function Name:    _SysTrayIconProcesses($iWin = 1)
; Description:      Get list of all processes that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process names
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconProcesses($iWin = 1)
	Local $pids = _SysTrayIconPids($iWin)
	If Not IsArray($pids) Then Return -1
	Local $processes[UBound($pids)]
	; List all processes
	Local $list = ProcessList()
	For $i = 0 To UBound($pids) - 1
		For $j = 1 To $list[0][0]
			If $pids[$i] = $list[$j][1] Then
				$processes[$i] = $list[$j][0]
				ExitLoop
			EndIf
		Next
	Next
	Return $processes
EndFunc   ;==>_SysTrayIconProcesses

;===============================================================================
;
; Function Name:    _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
; Description:      Get list of all processes id"s that have systray icon
; Parameter(s):     $test       - process name / window title text / process PID
;                   $mode
;                   | 0         - get index by process name (default)
;                   | 1         - get index by window title
;                   | 2         - get index by process PID
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns index of found icon
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
	Local $ret = -1, $compare = -1
	If $mode < 0 Or $mode > 2 Or Not IsInt($mode) Then Return -1
	Switch $mode
		Case 0
			$compare = _SysTrayIconProcesses($iWin)
		Case 1
			$compare = _SysTrayIconTitles($iWin)
		Case 2
			$compare = _SysTrayIconPids($iWin)
	EndSwitch
	If Not IsArray($compare) Then Return -1
	For $i = 0 To UBound($compare) - 1
		If $compare[$i] = $test Then
			$ret = $i
			ExitLoop
		EndIf
	Next
	Return $ret
EndFunc   ;==>_SysTrayIconIndex

; INTERNAL =====================================================================
;
; Function Name:    _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 0)
; Description:      Gets Tray Button Info
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;                   $iInfo      - Info to return
;                   | 1         - TBBUTTON structure
;                   | 2         - TRAYDATA structure
;                   | 3         - tooltip
;                   | 4         - icon position
; Requirement(s):
; Return Value(s):  On Success - Returns requested info
;                   On Failure - Sets @error and returns -1
;                   | 1        - Failed to find tray window
;                   | 2        - Failed to get tray window PID
;                   | 3        - Failed to open process
;                   | 4        - Failed to allocate memory
;                   | 5        - Failed to get TBBUTTON info
;
; Author(s):        Erik Pilsits, Tuape
;
;===============================================================================
Func _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 1)
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
	Local $trayHwnd = _FindTrayToolbarWindow($iWin)
	If $trayHwnd = -1 Then Return SetError(1, 0, -1)
	Local $return, $err = 0
	Local $ret = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $trayHwnd, "dword*", 0)
	If @error Or Not $ret[2] Then SetError(2, 0, -1)
	Local $pId = $ret[2]
	Local $procHandle = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $ACCESS, "bool", False, "dword", $pId)
	If @error Or Not $procHandle[0] Then Return SetError(3, 0, -1)
	Local $lpData = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $procHandle[0], "ptr", 0, "ulong", DllStructGetSize($TBBUTTON), "dword", 0x1000, "dword", 0x04)
	If Not @error And $lpData[0] Then
		$ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETBUTTON, "wparam", $iIndex, "lparam", $lpData[0])
		If Not @error And $ret[0] Then
			DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $TBBUTTON, "ulong", DllStructGetSize($TBBUTTON), "ulong*", 0)
			Switch $iInfo
				Case 2
					; TRAYDATA structure
					DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 6), "struct*", $TRAYDATA, "ulong", DllStructGetSize($TRAYDATA), "ulong*", 0)
					$return = $TRAYDATA
				Case 3
					; tooltip
					$return = ""
					If BitShift(DllStructGetData($TBBUTTON, 7), 16) <> 0 Then
						Local $intTip = DllStructCreate("wchar[1024]")
						; we have a pointer to a string, otherwise it is an internal resource identifier
						DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 7), "struct*", $intTip, "ulong", DllStructGetSize($intTip), "ulong*", 0)
						$return = DllStructGetData($intTip, 1)
						;else internal resource
					EndIf
				Case 4
					; icon position
					If Not BitAND(DllStructGetData($TBBUTTON, 3), 8) Then ; 8 = TBSTATE_HIDDEN
						Local $pos[2], $RECT = DllStructCreate("int;int;int;int")
						DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETITEMRECT, "wparam", $iIndex, "lparam", $lpData[0])
						DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $RECT, "ulong", DllStructGetSize($RECT), "ulong*", 0)
						$ret = DllCall("user32.dll", "int", "MapWindowPoints", "hwnd", $trayHwnd, "ptr", 0, "struct*", $RECT, "uint", 2)
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
		DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $procHandle[0], "ptr", $lpData[0], "ulong", 0, "dword", 0x8000)
	Else
		$err = 4
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $procHandle[0])
	If $err Then
		Return SetError($err, 0, -1)
	Else
		Return $return
	EndIf
EndFunc   ;==>_SysTrayGetButtonInfo

;===============================================================================
;
; Function Name:    _SysTrayIconHandle($iIndex, $iWin = 1)
; Description:      Gets hwnd of window associated with systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns hwnd of found icon
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHandle($iIndex, $iWin = 1)
	Local $TRAYDATA = _SysTrayGetButtonInfo($iIndex, $iWin, 2)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Ptr(DllStructGetData($TRAYDATA, 1))
	EndIf
EndFunc   ;==>_SysTrayIconHandle

;===============================================================================
;
; Function Name:    _SysTrayIconTooltip($iIndex, $iWin = 1)
; Description:      Gets the tooltip text of systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns tooltip text of icon
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconTooltip($iIndex, $iWin = 1)
	Local $ret = _SysTrayGetButtonInfo($iIndex, $iWin, 3)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return $ret
	EndIf
EndFunc   ;==>_SysTrayIconTooltip

;===============================================================================
;
; Function Name:    _SysTrayIconPos($iIndex, $iWin = 1)
; Description:      Gets x & y position of systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns array, x [0] and y [1] position of icon
;                   On Failure - Sets @error and returns -1
;                   | -1       - Icon is hidden (Autohide on XP, etc)
;                   | See _SysTrayGetButtonInfo for additional @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPos($iIndex, $iWin = 1)
	Local $ret = _SysTrayGetButtonInfo($iIndex, $iWin, 4)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		If $ret = -1 Then
			Return SetError(-1, 0, -1)
		Else
			Return $ret
		EndIf
	EndIf
EndFunc   ;==>_SysTrayIconPos

;===============================================================================
;
; Function Name:    _SysTrayIconVisible($iIndex, $iWin = 1)
; Description:      Gets the visibility of a systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns True (visible) or False (hidden)
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconVisible($iIndex, $iWin = 1)
	Local $TBBUTTON = _SysTrayGetButtonInfo($iIndex, $iWin, 1)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
	EndIf
EndFunc   ;==>_SysTrayIconVisible

;===============================================================================
;
; Function Name:    _SysTrayIconHide($index, $iFlag, $iWin = 1)
; Description:      Hides / unhides any icon on systray
;
; Parameter(s):     $index      - icon index. Can be queried with _SysTrayIconIndex()
;                   $iFlag      - hide (1) or show (0) icon
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns 1 if operation was successfull or 0 if
;                   icon was already hidden/unhidden
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHide($index, $iFlag, $iWin = 1)
;~     Local Const $TB_HIDEBUTTON = 0x0404 ; WM_USER + 4
	Local $TBBUTTON = _SysTrayGetButtonInfo($index, $iWin, 1)
	If @error Then Return SetError(@error, 0, -1)
	Local $visible = Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
	If ($iFlag And Not $visible) Or (Not $iFlag And $visible) Then
		Return 0
	Else
		Local $TRAYDATA = _SysTrayGetButtonInfo($index, $iWin, 2)
		If @error Then Return SetError(@error, 0, -1)
		Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
				 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
				 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
		DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
		DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
		DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
		DllStructSetData($NOTIFYICONDATA, 4, 8) ; NIF_STATE
		DllStructSetData($NOTIFYICONDATA, 8, $iFlag) ; dw_State, 0 or 1 = NIS_HIDDEN
		DllStructSetData($NOTIFYICONDATA, 9, 1) ; dwStateMask
		Local $ret = DllCall("shell32.dll", "bool", "Shell_NotifyIconW", "dword", 0x1, "struct*", $NOTIFYICONDATA) ; NIM_MODIFY
		DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
		If IsArray($ret) And $ret[0] Then
			Return 1
		Else
			Return 0
		EndIf
;~      $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_HIDEBUTTON, "wparam", DllStructGetData($TBBUTTON, 2), "lparam", $iHide)
;~      If @error Or Not $ret[0] Then
;~          $return = -1
;~      Else
;~          $return = $ret[0]
;~      EndIf
	EndIf
EndFunc   ;==>_SysTrayIconHide

;===============================================================================
;
; Function Name:    _SysTrayIconMove($curPos, $newPos, $iWin = 1)
; Description:      Moves systray icon
;
; Parameter(s):     $curPos     - icon's current index (0 based)
;                   $newPos     - icon's new position
;                                 ($curPos+1 = one step to right, $curPos-1 = one step to left)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):   AutoIt3 Beta
; Return Value(s):  On Success - Returns 1 if operation was successfull, 0 if not
;                   On Failure - Sets @error and returns -1
;                   | 1        - Bad parameters
;                   | 2        - Failed to find tray window
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconMove($curPos, $newPos, $iWin = 1)
	Local Const $TB_MOVEBUTTON = 0x0452 ; WM_USER + 82
	Local $iconCount = _SysTrayIconCount($iWin)
	If $curPos < 0 Or $newPos < 0 Or $curPos > $iconCount - 1 Or $newPos > $iconCount - 1 Or Not IsInt($curPos) Or Not IsInt($newPos) Then Return SetError(1, 0, -1)
	Local $hWnd = _FindTrayToolbarWindow($iWin)
	If $hWnd = -1 Then Return SetError(2, 0, -1)
	Local $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_MOVEBUTTON, "wparam", $curPos, "lparam", $newPos)
	If @error Or Not $ret[0] Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_SysTrayIconMove

;===============================================================================
;
; Function Name:    _SysTrayIconRemove($index, $iWin = 1)
; Description:      Removes systray icon completely.
;
; Parameter(s):     $index      - Icon index (first icon is 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Return Value(s):  On Success - Returns 1 if icon successfully removed, 0 if not
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconRemove($index, $iWin = 1)
	Local Const $TB_DELETEBUTTON = 1046
	Local $TRAYDATA = _SysTrayGetButtonInfo($index, $iWin, 2)
	If @error Then Return SetError(@error, 0, -1)
	Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
			 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
			 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
	DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
	DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
	DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
	Local $ret = DllCall("shell32.dll", "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $NOTIFYICONDATA) ; NIM_DELETE
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
	If IsArray($ret) And $ret[0] Then
		Return 1
	Else
		Return 0
	EndIf
;~  Local $hWnd = _FindTrayToolbarWindow($iWin)
;~  If $hwnd = -1 Then Return -1
;~  Local $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_DELETEBUTTON, "wparam", $index, "lparam", 0)
;~  If @error Or Not $ret[0] Then Return -1
;~  Return $ret[0]
EndFunc   ;==>_SysTrayIconRemove

;===============================================================================
;
; Function Name:    _FindTrayToolbarWindow($iWin = 1)
; Description:      Utility function for finding Toolbar window hwnd
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns Toolbar window hwnd
;                   On Failure - returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _FindTrayToolbarWindow($iWin = 1)
	Local $hWnd, $ret = -1
	If $iWin = 1 Then
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
		If @error Then Return -1
		If @OSVersion <> "WIN_2000" Then
			$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
			If @error Then Return -1
		EndIf
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hWnd[0]
	ElseIf $iWin = 2 Then
		; NotifyIconOverflowWindow for Windows 7
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
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

If $bIsXP = True Then
	RegWrite($sKey, "bVideoHotkey", "REG_DWORD", 1)
	RegWrite($sKey, "dwVideoHotkey", "REG_DWORD", 327869)
EndIf

Func HideIcon()
	Local $iWin = 1

	If $bIsXP = False Then $iWin = 2

	Local $aIcons = _SysTrayIconTitles($iWin)

	For $i = 0 To UBound($aIcons) - 1
		If StringRegExp($aIcons[$i], "(?i)Bandicam") Then
			_SysTrayIconRemove($i, $iWin)
		EndIf
	Next
EndFunc   ;==>HideIcon

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

		ResetVars()

		If $bIsXP = True Then
			$hWinControlBandicam = WinGetHandle($sBandicanControlSelector)
			WinSetState($hWinControlBandicam, "", @SW_HIDE)
		EndIf

		HideIcon()
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
	WinSetState($hWinControlBandicam, "", @SW_HIDE)
WEnd
