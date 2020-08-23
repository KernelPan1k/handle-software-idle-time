#NoTrayIcon
#RequireAdmin
Func _3(Const $0 = @error, Const $1 = @extended)
Local $2 = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($0, $1, $2[0])
EndFunc
Global Const $3 = 2
Global Const $4 = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $5 = _1g()
Func _1g()
Local $6 = DllStructCreate($4)
DllStructSetData($6, 1, DllStructGetSize($6))
Local $7 = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $6)
If @error Or Not $7[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($6, 2), -8), DllStructGetData($6, 3))
EndFunc
Func _3z($8, $9 = True, $a = 0)
Local $7 = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $a, 'bool', $9, 'wstr', $8)
If @error Then Return SetError(@error, @extended, 0)
Return $7[0]
EndFunc
Func _5w($b, $c = "user32.dll")
Local $d = DllCall($c, "short", "GetAsyncKeyState", "int", "0x" & $b)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($d[0], 0x8000) <> 0
EndFunc
OnAutoItExitRegister("_61")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Local Const $e = 1000 * 30
Local Const $f = 1000 * 10
Local Const $g = 50
Local Const $h = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $i = $h & " /record"
Local Const $j = $h & " /stop"
Local Const $k = $h & " /nosplash"
Local Const $l = "WsssM"
Local Const $m = "[CLASS:Bandicam2.x]"
Local $n[1] = [0]
Local Const $o = 183
Local Const $p = 5
Local $q = Null
Local $r = False
Local $s = Null
Local $t = Null
Local $u = Null
Local $v = Null
Local $w = Null
Local $x = Null
Local $y = False
Local $0z = False
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$y = True
EndIf
Func _61()
If $u <> Null Then
DllClose($u)
$u = Null
EndIf
If $v <> Null Then
DllClose($v)
$v = Null
EndIf
If $w <> Null Then
DllClose($w)
$w = Null
EndIf
EndFunc
Func _62()
If $u = Null Then
$u = DllOpen('user32.dll')
EndIf
Return $u
EndFunc
Func _63()
If $v = Null Then
$v = DllOpen('kernel32.dll')
EndIf
Return $v
EndFunc
Func _64()
If $w = Null Then
$w = DllOpen('shell32.dll')
EndIf
Return $w
EndFunc
Func _65()
Local $10 = 0
_3z($l & "_MUTEX", True, 0)
$10 = _3()
Return $10 == $o Or $10 == $p
EndFunc
If _65() Then
Exit
EndIf
Func _66($11 = 1)
Local Const $12 = 1048
Local $13 = _6b($11)
If $13 = -1 Then Return -1
Local $14 = _62()
Local $15 = DllCall($14, "lresult", "SendMessageW", "hwnd", $13, "uint", $12, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $15[0]
EndFunc
Func _67($11 = 1)
Local $15 = _66($11)
If $15 <= 0 Then Return -1
Local $16[$15]
For $17 = 0 To $15 - 1
$16[$17] = WinGetTitle(_69($17, $11))
Next
Return $16
EndFunc
Func _68($18, $11 = 1, $19 = 1)
Local Const $1a = 1047
Local Const $1b = 1053
Local $14 = _62()
Local $1c = _63()
Local Const $1d = BitOR(0x0008, 0x0010, 0x0400)
Local $1e
If @OSArch = "X86" Then
$1e = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$1e = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $1f
If @OSArch = "X86" Then
$1f = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$1f = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $1g = _6b($11)
If $1g = -1 Then Return SetError(1, 0, -1)
Local $1h, $1i = 0
Local $1j = DllCall($14, "dword", "GetWindowThreadProcessId", "hwnd", $1g, "dword*", 0)
If @error Or Not $1j[2] Then SetError(2, 0, -1)
Local $1k = $1j[2]
Local $1l = DllCall($1c, "handle", "OpenProcess", "dword", $1d, "bool", False, "dword", $1k)
If @error Or Not $1l[0] Then Return SetError(3, 0, -1)
Local $1m = DllCall($1c, "ptr", "VirtualAllocEx", "handle", $1l[0], "ptr", 0, "ulong", DllStructGetSize($1e), "dword", 0x1000, "dword", 0x04)
If Not @error And $1m[0] Then
$1j = DllCall($14, "lresult", "SendMessageW", "hwnd", $1g, "uint", $1a, "wparam", $18, "lparam", $1m[0])
If Not @error And $1j[0] Then
DllCall($1c, "bool", "ReadProcessMemory", "handle", $1l[0], "ptr", $1m[0], "struct*", $1e, "ulong", DllStructGetSize($1e), "ulong*", 0)
Switch $19
Case 2
DllCall($1c, "bool", "ReadProcessMemory", "handle", $1l[0], "ptr", DllStructGetData($1e, 6), "struct*", $1f, "ulong", DllStructGetSize($1f), "ulong*", 0)
$1h = $1f
Case 3
$1h = ""
If BitShift(DllStructGetData($1e, 7), 16) <> 0 Then
Local $1n = DllStructCreate("wchar[1024]")
DllCall($1c, "bool", "ReadProcessMemory", "handle", $1l[0], "ptr", DllStructGetData($1e, 7), "struct*", $1n, "ulong", DllStructGetSize($1n), "ulong*", 0)
$1h = DllStructGetData($1n, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($1e, 3), 8) Then
Local $1o[2], $1p = DllStructCreate("int;int;int;int")
DllCall($14, "lresult", "SendMessageW", "hwnd", $1g, "uint", $1b, "wparam", $18, "lparam", $1m[0])
DllCall($1c, "bool", "ReadProcessMemory", "handle", $1l[0], "ptr", $1m[0], "struct*", $1p, "ulong", DllStructGetSize($1p), "ulong*", 0)
$1j = DllCall($14, "int", "MapWindowPoints", "hwnd", $1g, "ptr", 0, "struct*", $1p, "uint", 2)
$1o[0] = DllStructGetData($1p, 1)
$1o[1] = DllStructGetData($1p, 2)
$1h = $1o
Else
$1h = -1
EndIf
Case Else
$1h = $1e
EndSwitch
Else
$1i = 5
EndIf
DllCall($1c, "bool", "VirtualFreeEx", "handle", $1l[0], "ptr", $1m[0], "ulong", 0, "dword", 0x8000)
Else
$1i = 4
EndIf
DllCall($1c, "bool", "CloseHandle", "handle", $1l[0])
If $1i Then
Return SetError($1i, 0, -1)
Else
Return $1h
EndIf
EndFunc
Func _69($18, $11 = 1)
Local $1f = _68($18, $11, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($1f, 1))
EndIf
EndFunc
Func _6a($1q, $11 = 1)
Local $14 = _62()
Local $1r = _64()
Local $1f = _68($1q, $11, 2)
If @error Then Return SetError(@error, 0, -1)
Local $1s = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($1s, 1, DllStructGetSize($1s))
DllStructSetData($1s, 2, Ptr(DllStructGetData($1f, 1)))
DllStructSetData($1s, 3, DllStructGetData($1f, 2))
Local $1j = DllCall($1r, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $1s)
DllCall($14, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($1j) And $1j[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _6b($11 = 1)
Local $13, $1j = -1
Local $14 = _62()
If $11 = 1 Then
$13 = DllCall($14, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$13 = DllCall($14, "hwnd", "FindWindowEx", "hwnd", $13[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$13 = DllCall($14, "hwnd", "FindWindowEx", "hwnd", $13[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$13 = DllCall($14, "hwnd", "FindWindowEx", "hwnd", $13[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$1j = $13[0]
ElseIf $11 = 2 Then
$13 = DllCall($14, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$13 = DllCall($14, "hwnd", "FindWindowEx", "hwnd", $13[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$1j = $13[0]
EndIf
Return $1j
EndFunc
Local $1t = ""
If @OSArch = "X64" Then $1t = "64"
Local $1u = "HKCU" & $1t & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($1u, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($1u, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($1u, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($1u, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($1u, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($1u, "bStartMinimized", "REG_DWORD", 1)
RegWrite($1u, "nTargetMode", "REG_DWORD", 1)
RegWrite($1u, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($1u, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($1u, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($1u, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $y = True Then
RegWrite($1u, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($1u, "dwVideoHotkey", "REG_DWORD", 327869)
EndIf
Func _6c()
Local $11 = 1
If $y = False Then $11 = 2
Local $1v = _67($11)
For $17 = 0 To UBound($1v) - 1
If StringRegExp($1v[$17], "(?i).*Bandicam.*") Then
_6a($17, $11)
EndIf
Next
EndFunc
Func _6d()
$r = False
$s = Null
$t = Null
$x = Null
EndFunc
Func _6e()
$x = Null
If $r = True Then Return
$r = True
If $y = False Then
Run($i)
Else
Send("^!{-}")
EndIf
_6c()
EndFunc
Func _6f()
If $r = False Then Return
$r = False
$x = Null
If $y = False Then
Run($j)
Else
Send("^!{-}")
$0z = True
EndIf
_6c()
EndFunc
Func _6g($1w)
Local $18 = $n[0] + 1
ReDim $n[$18 + 1]
$n[$18] = $1w
$n[0] = $18
EndFunc
Func _6h()
Local $1x = WinList()
For $17 = 1 To $1x[0][0]
If $1x[$17][0] = "" And BitAND(WinGetState($1x[$17][1]), $3) Then
Local $1y = $1x[$17][1]
Local $1z = $1x[$17][0]
Local $20 = WinGetPos($1y)
Local $21 = $20[1]
Local $22 = $20[2]
Local $23 = $20[3]
If $21 = 0 And $23 > 0 And $23 < 50 And $22 > 0 And $1z = "" Then
_6g($1y)
EndIf
EndIf
Next
EndFunc
Func _6i()
WinSetState($q, "", @SW_HIDE)
If UBound($n) = 1 Then Return
For $17 = 1 To $n[0]
WinSetState($n[$17], "", @SW_HIDE)
Next
EndFunc
Func _6j()
If Not ProcessExists("bdcam.exe") Then
Run($k)
WinWait($m)
$q = WinGetHandle($m)
Local $24[1] = [0]
$n = $24
Sleep(1000)
_6d()
_6h()
_6i()
EndIf
_6c()
EndFunc
Func _6k()
Local $14 = _62()
Local $25 = False
Local $26 = MouseGetPos()
If $26[0] <> $s Or $26[1] <> $t Then
$25 = True
EndIf
$s = $26[0]
$t = $26[1]
If $25 Then Return True
If $0z = True Then
$0z = False
Return False
EndIf
For $17 = 1 To 221
If _5w(Hex($17), $14) Then
Return True
EndIf
Next
Return False
EndFunc
Func _6l()
If $r = False Then
Return False
EndIf
If $x = Null Then
$x = TimerInit()
Return False
EndIf
Local $27 = TimerDiff($x)
Return $27 > $e
EndFunc
If ProcessExists("bdcam.exe") Then
_6c()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_6j()
Sleep($f)
Local $28 = 0
Local $26 = MouseGetPos()
$s = $26[0]
$t = $26[1]
While True
Sleep($g)
If _6k() Then
_6e()
ElseIf _6l() Then
_6f()
EndIf
$28 = $28 + $g
If $28 > 5000 Then
$28 = 0
_6j()
EndIf
_6i()
WEnd
