#NoTrayIcon
#RequireAdmin
Global Const $0 = 2
Global Const $1 = 0
Global Const $2 = 1
Func _3(Const $3 = @error, Const $4 = @extended)
Local $5 = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($3, $4, $5[0])
EndFunc
Global Const $6 = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $7 = _1g()
Func _1g()
Local $8 = DllStructCreate($6)
DllStructSetData($8, 1, DllStructGetSize($8))
Local $9 = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $8)
If @error Or Not $9[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($8, 2), -8), DllStructGetData($8, 3))
EndFunc
Func _3z($a, $b = True, $c = 0)
Local $9 = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $c, 'bool', $b, 'wstr', $a)
If @error Then Return SetError(@error, @extended, 0)
Return $9[0]
EndFunc
Func _5w($d, $e = "user32.dll")
Local $f = DllCall($e, "short", "GetAsyncKeyState", "int", "0x" & $d)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($f[0], 0x8000) <> 0
EndFunc
Global Const $g = 11
Global $h[$g]
Global Const $i = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($j, $k, $l)
If $h[3] = $h[4] Then
If Not $h[7] Then
$h[5] *= -1
$h[7] = 1
EndIf
Else
$h[7] = 1
EndIf
$h[6] = $h[3]
Local $m = _6b($l, $j, $h[3])
Local $n = _6b($l, $k, $h[3])
If $h[8] = 1 Then
If(StringIsFloat($m) Or StringIsInt($m)) Then $m = Number($m)
If(StringIsFloat($n) Or StringIsInt($n)) Then $n = Number($n)
EndIf
Local $o
If $h[8] < 2 Then
$o = 0
If $m < $n Then
$o = -1
ElseIf $m > $n Then
$o = 1
EndIf
Else
$o = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $m, 'wstr', $n)[0]
EndIf
$o = $o * $h[5]
Return $o
EndFunc
Func _6b($l, $p, $q = 0)
Local $r = DllStructCreate("wchar Text[4096]")
Local $s = DllStructGetPtr($r)
Local $t = DllStructCreate($i)
DllStructSetData($t, "SubItem", $q)
DllStructSetData($t, "TextMax", 4096)
DllStructSetData($t, "Text", $s)
If IsHWnd($l) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $l, "uint", 0x1073, "wparam", $p, "struct*", $t)
Else
Local $u = DllStructGetPtr($t)
GUICtrlSendMsg($l, 0x1073, $p, $u)
EndIf
Return DllStructGetData($r, "Text")
EndFunc
Func _7l($v, $w = "*", $x = $1, $y = False)
Local $0z = "|", $10 = "", $11 = "", $12 = ""
$v = StringRegExpReplace($v, "[\\/]+$", "") & "\"
If $x = Default Then $x = $1
If $y Then $12 = $v
If $w = Default Then $w = "*"
If Not FileExists($v) Then Return SetError(1, 0, 0)
If StringRegExp($w, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($x = 0 Or $x = 1 Or $x = 2) Then Return SetError(3, 0, 0)
Local $13 = FileFindFirstFile($v & $w)
If @error Then Return SetError(4, 0, 0)
While 1
$11 = FileFindNextFile($13)
If @error Then ExitLoop
If($x + @extended = 2) Then ContinueLoop
$10 &= $0z & $12 & $11
WEnd
FileClose($13)
If $10 = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($10, 1), $0z)
EndFunc
OnAutoItExitRegister("_81")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Local Const $14 = 1000 * 30
Local Const $15 = 1000 * 10
Local Const $16 = 50
Local Const $17 = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $18 = $17 & " /record"
Local Const $19 = $17 & " /stop"
Local Const $1a = $17 & " /nosplash"
Local Const $1b = "WsssM"
Local Const $1c = "[CLASS:Bandicam2.x]"
Local $1d[1] = [0]
Local Const $1e = 183
Local Const $1f = 5
Local $1g = 107374182400
Local $1h = Null
Local $1i = False
Local $1j = Null
Local $1k = Null
Local $1l = Null
Local $1m = Null
Local $1n = Null
Local $1o = Null
Local $1p = False
Local $1q = False
Local $1r = Null
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$1p = True
$1g = 16106127360
EndIf
Func _81()
If $1l <> Null Then
DllClose($1l)
$1l = Null
EndIf
If $1m <> Null Then
DllClose($1m)
$1m = Null
EndIf
If $1n <> Null Then
DllClose($1n)
$1n = Null
EndIf
EndFunc
Func _82()
If $1l = Null Then
$1l = DllOpen('user32.dll')
EndIf
Return $1l
EndFunc
Func _83()
If $1m = Null Then
$1m = DllOpen('kernel32.dll')
EndIf
Return $1m
EndFunc
Func _84()
If $1n = Null Then
$1n = DllOpen('shell32.dll')
EndIf
Return $1n
EndFunc
Func _85()
Local $1s = 0
_3z($1b & "_MUTEX", True, 0)
$1s = _3()
Return $1s == $1e Or $1s == $1f
EndFunc
If _85() Then
Exit
EndIf
Func _86($1t = 1)
Local Const $1u = 1048
Local $l = _8b($1t)
If $l = -1 Then Return -1
Local $1v = _82()
Local $1w = DllCall($1v, "lresult", "SendMessageW", "hwnd", $l, "uint", $1u, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $1w[0]
EndFunc
Func _87($1t = 1)
Local $1w = _86($1t)
If $1w <= 0 Then Return -1
Local $1x[$1w]
For $1y = 0 To $1w - 1
$1x[$1y] = WinGetTitle(_89($1y, $1t))
Next
Return $1x
EndFunc
Func _88($p, $1t = 1, $1z = 1)
Local Const $20 = 1047
Local Const $21 = 1053
Local $1v = _82()
Local $22 = _83()
Local Const $23 = BitOR(0x0008, 0x0010, 0x0400)
Local $24
If @OSArch = "X86" Then
$24 = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$24 = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $25
If @OSArch = "X86" Then
$25 = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$25 = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $26 = _8b($1t)
If $26 = -1 Then Return SetError(1, 0, -1)
Local $27, $28 = 0
Local $29 = DllCall($1v, "dword", "GetWindowThreadProcessId", "hwnd", $26, "dword*", 0)
If @error Or Not $29[2] Then SetError(2, 0, -1)
Local $2a = $29[2]
Local $2b = DllCall($22, "handle", "OpenProcess", "dword", $23, "bool", False, "dword", $2a)
If @error Or Not $2b[0] Then Return SetError(3, 0, -1)
Local $2c = DllCall($22, "ptr", "VirtualAllocEx", "handle", $2b[0], "ptr", 0, "ulong", DllStructGetSize($24), "dword", 0x1000, "dword", 0x04)
If Not @error And $2c[0] Then
$29 = DllCall($1v, "lresult", "SendMessageW", "hwnd", $26, "uint", $20, "wparam", $p, "lparam", $2c[0])
If Not @error And $29[0] Then
DllCall($22, "bool", "ReadProcessMemory", "handle", $2b[0], "ptr", $2c[0], "struct*", $24, "ulong", DllStructGetSize($24), "ulong*", 0)
Switch $1z
Case 2
DllCall($22, "bool", "ReadProcessMemory", "handle", $2b[0], "ptr", DllStructGetData($24, 6), "struct*", $25, "ulong", DllStructGetSize($25), "ulong*", 0)
$27 = $25
Case 3
$27 = ""
If BitShift(DllStructGetData($24, 7), 16) <> 0 Then
Local $2d = DllStructCreate("wchar[1024]")
DllCall($22, "bool", "ReadProcessMemory", "handle", $2b[0], "ptr", DllStructGetData($24, 7), "struct*", $2d, "ulong", DllStructGetSize($2d), "ulong*", 0)
$27 = DllStructGetData($2d, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($24, 3), 8) Then
Local $2e[2], $2f = DllStructCreate("int;int;int;int")
DllCall($1v, "lresult", "SendMessageW", "hwnd", $26, "uint", $21, "wparam", $p, "lparam", $2c[0])
DllCall($22, "bool", "ReadProcessMemory", "handle", $2b[0], "ptr", $2c[0], "struct*", $2f, "ulong", DllStructGetSize($2f), "ulong*", 0)
$29 = DllCall($1v, "int", "MapWindowPoints", "hwnd", $26, "ptr", 0, "struct*", $2f, "uint", 2)
$2e[0] = DllStructGetData($2f, 1)
$2e[1] = DllStructGetData($2f, 2)
$27 = $2e
Else
$27 = -1
EndIf
Case Else
$27 = $24
EndSwitch
Else
$28 = 5
EndIf
DllCall($22, "bool", "VirtualFreeEx", "handle", $2b[0], "ptr", $2c[0], "ulong", 0, "dword", 0x8000)
Else
$28 = 4
EndIf
DllCall($22, "bool", "CloseHandle", "handle", $2b[0])
If $28 Then
Return SetError($28, 0, -1)
Else
Return $27
EndIf
EndFunc
Func _89($p, $1t = 1)
Local $25 = _88($p, $1t, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($25, 1))
EndIf
EndFunc
Func _8a($2g, $1t = 1)
Local $1v = _82()
Local $2h = _84()
Local $25 = _88($2g, $1t, 2)
If @error Then Return SetError(@error, 0, -1)
Local $2i = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($2i, 1, DllStructGetSize($2i))
DllStructSetData($2i, 2, Ptr(DllStructGetData($25, 1)))
DllStructSetData($2i, 3, DllStructGetData($25, 2))
Local $29 = DllCall($2h, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $2i)
DllCall($1v, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($29) And $29[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _8b($1t = 1)
Local $l, $29 = -1
Local $1v = _82()
If $1t = 1 Then
$l = DllCall($1v, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$l = DllCall($1v, "hwnd", "FindWindowEx", "hwnd", $l[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$l = DllCall($1v, "hwnd", "FindWindowEx", "hwnd", $l[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$l = DllCall($1v, "hwnd", "FindWindowEx", "hwnd", $l[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$29 = $l[0]
ElseIf $1t = 2 Then
$l = DllCall($1v, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$l = DllCall($1v, "hwnd", "FindWindowEx", "hwnd", $l[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$29 = $l[0]
EndIf
Return $29
EndFunc
Local $2j = ""
If @OSArch = "X64" Then $2j = "64"
Local $2k = "HKCU" & $2j & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($2k, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($2k, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($2k, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($2k, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($2k, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($2k, "bStartMinimized", "REG_DWORD", 1)
RegWrite($2k, "nTargetMode", "REG_DWORD", 1)
RegWrite($2k, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($2k, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($2k, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($2k, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $1p = True Then
RegWrite($2k, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($2k, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
$1r = RegRead($2k, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($1r) Then $1r = Null
Func _8c()
If Not $1r Then Return
Local $2l = DirGetSize($1r)
If $2l < $1g Then Return
Local $2m = _7l($1r, "*.avi", $2, True)
If @error <> 0 Or UBound($2m) < 2 Then Return
For $1y = 1 To UBound($2m) - 1
Local $2n = FileGetSize($2m[$1y])
FileDelete($2m[$1y])
$2l = $2l - $2n
If $2l < $1g Then ExitLoop
Next
EndFunc
Func _8d()
Local $1t = 1
If $1p = False Then $1t = 2
Local $2o = _87($1t)
For $1y = 0 To UBound($2o) - 1
If StringRegExp($2o[$1y], "(?i).*Bandicam.*") Then
_8a($1y, $1t)
EndIf
Next
EndFunc
Func _8e()
$1i = False
$1j = Null
$1k = Null
$1o = Null
EndFunc
Func _8f()
$1o = Null
If $1i = True Then Return
$1i = True
If $1p = False Then
Run($18)
Else
Send("^!+9")
EndIf
_8d()
EndFunc
Func _8g()
If $1i = False Then Return
$1i = False
$1o = Null
If $1p = False Then
Run($19)
Else
Send("^!+9")
$1q = True
EndIf
_8d()
_8c()
EndFunc
Func _8h($2p)
Local $p = $1d[0] + 1
ReDim $1d[$p + 1]
$1d[$p] = $2p
$1d[0] = $p
EndFunc
Func _8i()
Local $2q = WinList()
For $1y = 1 To $2q[0][0]
If $2q[$1y][0] = "" And BitAND(WinGetState($2q[$1y][1]), $0) Then
Local $2r = $2q[$1y][1]
Local $2s = $2q[$1y][0]
Local $2t = WinGetPos($2r)
Local $2u = $2t[0]
Local $2v = $2t[1]
Local $2w = $2t[2]
Local $2x = $2t[3]
If $2v > -50 And $2v < 20 And $2x > 0 And $2x < 80 And $2w > 0 And $2u > -80 And $2s = "" Then
_8h($2r)
EndIf
EndIf
Next
EndFunc
Func _8j()
WinSetState($1h, "", @SW_HIDE)
If UBound($1d) = 1 Then Return
For $1y = 1 To $1d[0]
WinSetState($1d[$1y], "", @SW_HIDE)
Next
EndFunc
Func _8k()
If Not ProcessExists("bdcam.exe") Then
Run($1a)
WinWait($1c)
$1h = WinGetHandle($1c)
WinSetState($1h, "", @SW_HIDE)
Local $2y[1] = [0]
$1d = $2y
Sleep(2500)
_8e()
_8i()
_8j()
EndIf
_8d()
EndFunc
Func _8l()
Local $1v = _82()
Local $2z = False
Local $30 = MouseGetPos()
If $30[0] <> $1j Or $30[1] <> $1k Then
$2z = True
EndIf
$1j = $30[0]
$1k = $30[1]
If $2z Then Return True
If $1q = True Then
$1q = False
Return False
EndIf
For $1y = 1 To 221
If _5w(Hex($1y), $1v) Then
Return True
EndIf
Next
Return False
EndFunc
Func _8m()
If $1i = False Then
Return False
EndIf
If $1o = Null Then
$1o = TimerInit()
Return False
EndIf
Local $31 = TimerDiff($1o)
Return $31 > $14
EndFunc
If ProcessExists("bdcam.exe") Then
_8d()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_8c()
_8k()
Sleep($15)
Local $32 = 0
Local $30 = MouseGetPos()
$1j = $30[0]
$1k = $30[1]
While True
Sleep($16)
If _8l() Then
_8f()
ElseIf _8m() Then
_8g()
EndIf
$32 = $32 + $16
If $32 > 5000 Then
$32 = 0
_8k()
EndIf
_8j()
WEnd
