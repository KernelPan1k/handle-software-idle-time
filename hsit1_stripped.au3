#NoTrayIcon
#RequireAdmin
Global Const $0 = 0
Global Const $1 = 1
Global Const $2 = 2
Global Const $3 = 2
Global Const $4 = 0
Global Const $5 = 1
Func _3(Const $6 = @error, Const $7 = @extended)
Local $8 = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($6, $7, $8[0])
EndFunc
Global Const $9 = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $a = _1g()
Func _1g()
Local $b = DllStructCreate($9)
DllStructSetData($b, 1, DllStructGetSize($b))
Local $c = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $b)
If @error Or Not $c[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($b, 2), -8), DllStructGetData($b, 3))
EndFunc
Func _3z($d, $e = True, $f = 0)
Local $c = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $f, 'bool', $e, 'wstr', $d)
If @error Then Return SetError(@error, @extended, 0)
Return $c[0]
EndFunc
Func _5w($g, $h = "user32.dll")
Local $i = DllCall($h, "short", "GetAsyncKeyState", "int", "0x" & $g)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($i[0], 0x8000) <> 0
EndFunc
Global Const $j = 11
Global $k[$j]
Global Const $l = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($m, $n, $o)
If $k[3] = $k[4] Then
If Not $k[7] Then
$k[5] *= -1
$k[7] = 1
EndIf
Else
$k[7] = 1
EndIf
$k[6] = $k[3]
Local $p = _6b($o, $m, $k[3])
Local $q = _6b($o, $n, $k[3])
If $k[8] = 1 Then
If(StringIsFloat($p) Or StringIsInt($p)) Then $p = Number($p)
If(StringIsFloat($q) Or StringIsInt($q)) Then $q = Number($q)
EndIf
Local $r
If $k[8] < 2 Then
$r = 0
If $p < $q Then
$r = -1
ElseIf $p > $q Then
$r = 1
EndIf
Else
$r = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $p, 'wstr', $q)[0]
EndIf
$r = $r * $k[5]
Return $r
EndFunc
Func _6b($o, $s, $t = 0)
Local $u = DllStructCreate("wchar Text[4096]")
Local $v = DllStructGetPtr($u)
Local $w = DllStructCreate($l)
DllStructSetData($w, "SubItem", $t)
DllStructSetData($w, "TextMax", 4096)
DllStructSetData($w, "Text", $v)
If IsHWnd($o) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $o, "uint", 0x1073, "wparam", $s, "struct*", $w)
Else
Local $x = DllStructGetPtr($w)
GUICtrlSendMsg($o, 0x1073, $s, $x)
EndIf
Return DllStructGetData($u, "Text")
EndFunc
Func _6l(ByRef $y, $0z)
If Not IsArray($y) Then Return SetError(1, 0, -1)
Local $10 = UBound($y, $1) - 1
If IsArray($0z) Then
If UBound($0z, $0) <> 1 Or UBound($0z, $1) < 2 Then Return SetError(4, 0, -1)
Else
Local $11, $12, $13
$0z = StringStripWS($0z, 8)
$12 = StringSplit($0z, ";")
$0z = ""
For $14 = 1 To $12[0]
If Not StringRegExp($12[$14], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$13 = StringSplit($12[$14], "-")
Switch $13[0]
Case 1
$0z &= $13[1] & ";"
Case 2
If Number($13[2]) >= Number($13[1]) Then
$11 = $13[1] - 1
Do
$11 += 1
$0z &= $11 & ";"
Until $11 = $13[2]
EndIf
EndSwitch
Next
$0z = StringSplit(StringTrimRight($0z, 1), ";")
EndIf
If $0z[1] < 0 Or $0z[$0z[0]] > $10 Then Return SetError(5, 0, -1)
Local $15 = 0
Switch UBound($y, $0)
Case 1
For $14 = 1 To $0z[0]
$y[$0z[$14]] = ChrW(0xFAB1)
Next
For $16 = 0 To $10
If $y[$16] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $16 <> $15 Then
$y[$15] = $y[$16]
EndIf
$15 += 1
EndIf
Next
ReDim $y[$10 - $0z[0] + 1]
Case 2
Local $17 = UBound($y, $2) - 1
For $14 = 1 To $0z[0]
$y[$0z[$14]][0] = ChrW(0xFAB1)
Next
For $16 = 0 To $10
If $y[$16][0] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $16 <> $15 Then
For $18 = 0 To $17
$y[$15][$18] = $y[$16][$18]
Next
EndIf
$15 += 1
EndIf
Next
ReDim $y[$10 - $0z[0] + 1][$17 + 1]
Case Else
Return SetError(2, 0, False)
EndSwitch
Return UBound($y, $1)
EndFunc
Func _6x(ByRef $y, $19 = 0, $1a = 0)
If $19 = Default Then $19 = 0
If $1a = Default Then $1a = 0
If Not IsArray($y) Then Return SetError(1, 0, 0)
If UBound($y, $0) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($y) Then Return SetError(4, 0, 0)
Local $1b, $1c = UBound($y) - 1
If $1a < 1 Or $1a > $1c Then $1a = $1c
If $19 < 0 Then $19 = 0
If $19 > $1a Then Return SetError(2, 0, 0)
For $14 = $19 To Int(($19 + $1a - 1) / 2)
$1b = $y[$14]
$y[$14] = $y[$1a]
$y[$1a] = $1b
$1a -= 1
Next
Return 1
EndFunc
Func _7l($1d, $1e = "*", $1f = $4, $1g = False)
Local $1h = "|", $1i = "", $1j = "", $1k = ""
$1d = StringRegExpReplace($1d, "[\\/]+$", "") & "\"
If $1f = Default Then $1f = $4
If $1g Then $1k = $1d
If $1e = Default Then $1e = "*"
If Not FileExists($1d) Then Return SetError(1, 0, 0)
If StringRegExp($1e, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($1f = 0 Or $1f = 1 Or $1f = 2) Then Return SetError(3, 0, 0)
Local $1l = FileFindFirstFile($1d & $1e)
If @error Then Return SetError(4, 0, 0)
While 1
$1j = FileFindNextFile($1l)
If @error Then ExitLoop
If($1f + @extended = 2) Then ContinueLoop
$1i &= $1h & $1k & $1j
WEnd
FileClose($1l)
If $1i = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($1i, 1), $1h)
EndFunc
OnAutoItExitRegister("_81")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Local Const $1m = 1000 * 30
Local Const $1n = 1000 * 10
Local Const $1o = 50
Local Const $1p = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $1q = $1p & " /record"
Local Const $1r = $1p & " /stop"
Local Const $1s = $1p & " /nosplash"
Local Const $1t = "WsssM"
Local Const $1u = "[CLASS:Bandicam2.x]"
Local $1v[1] = [0]
Local Const $1w = 183
Local Const $1x = 5
Local Const $1y = 100
Local $1z = Null
Local $20 = False
Local $21 = Null
Local $22 = Null
Local $23 = Null
Local $24 = Null
Local $25 = Null
Local $26 = Null
Local $27 = False
Local $28 = False
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$27 = True
EndIf
Func _81()
If $23 <> Null Then
DllClose($23)
$23 = Null
EndIf
If $24 <> Null Then
DllClose($24)
$24 = Null
EndIf
If $25 <> Null Then
DllClose($25)
$25 = Null
EndIf
EndFunc
Func _82()
If $23 = Null Then
$23 = DllOpen('user32.dll')
EndIf
Return $23
EndFunc
Func _83()
If $24 = Null Then
$24 = DllOpen('kernel32.dll')
EndIf
Return $24
EndFunc
Func _84()
If $25 = Null Then
$25 = DllOpen('shell32.dll')
EndIf
Return $25
EndFunc
Func _85()
Local $29 = 0
_3z($1t & "_MUTEX", True, 0)
$29 = _3()
Return $29 == $1w Or $29 == $1x
EndFunc
If _85() Then
Exit
EndIf
Func _86($2a = 1)
Local Const $2b = 1048
Local $o = _8b($2a)
If $o = -1 Then Return -1
Local $2c = _82()
Local $2d = DllCall($2c, "lresult", "SendMessageW", "hwnd", $o, "uint", $2b, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $2d[0]
EndFunc
Func _87($2a = 1)
Local $2d = _86($2a)
If $2d <= 0 Then Return -1
Local $2e[$2d]
For $14 = 0 To $2d - 1
$2e[$14] = WinGetTitle(_89($14, $2a))
Next
Return $2e
EndFunc
Func _88($s, $2a = 1, $2f = 1)
Local Const $2g = 1047
Local Const $2h = 1053
Local $2c = _82()
Local $2i = _83()
Local Const $2j = BitOR(0x0008, 0x0010, 0x0400)
Local $2k
If @OSArch = "X86" Then
$2k = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$2k = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $2l
If @OSArch = "X86" Then
$2l = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$2l = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $2m = _8b($2a)
If $2m = -1 Then Return SetError(1, 0, -1)
Local $2n, $2o = 0
Local $2p = DllCall($2c, "dword", "GetWindowThreadProcessId", "hwnd", $2m, "dword*", 0)
If @error Or Not $2p[2] Then SetError(2, 0, -1)
Local $2q = $2p[2]
Local $2r = DllCall($2i, "handle", "OpenProcess", "dword", $2j, "bool", False, "dword", $2q)
If @error Or Not $2r[0] Then Return SetError(3, 0, -1)
Local $2s = DllCall($2i, "ptr", "VirtualAllocEx", "handle", $2r[0], "ptr", 0, "ulong", DllStructGetSize($2k), "dword", 0x1000, "dword", 0x04)
If Not @error And $2s[0] Then
$2p = DllCall($2c, "lresult", "SendMessageW", "hwnd", $2m, "uint", $2g, "wparam", $s, "lparam", $2s[0])
If Not @error And $2p[0] Then
DllCall($2i, "bool", "ReadProcessMemory", "handle", $2r[0], "ptr", $2s[0], "struct*", $2k, "ulong", DllStructGetSize($2k), "ulong*", 0)
Switch $2f
Case 2
DllCall($2i, "bool", "ReadProcessMemory", "handle", $2r[0], "ptr", DllStructGetData($2k, 6), "struct*", $2l, "ulong", DllStructGetSize($2l), "ulong*", 0)
$2n = $2l
Case 3
$2n = ""
If BitShift(DllStructGetData($2k, 7), 16) <> 0 Then
Local $2t = DllStructCreate("wchar[1024]")
DllCall($2i, "bool", "ReadProcessMemory", "handle", $2r[0], "ptr", DllStructGetData($2k, 7), "struct*", $2t, "ulong", DllStructGetSize($2t), "ulong*", 0)
$2n = DllStructGetData($2t, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($2k, 3), 8) Then
Local $2u[2], $2v = DllStructCreate("int;int;int;int")
DllCall($2c, "lresult", "SendMessageW", "hwnd", $2m, "uint", $2h, "wparam", $s, "lparam", $2s[0])
DllCall($2i, "bool", "ReadProcessMemory", "handle", $2r[0], "ptr", $2s[0], "struct*", $2v, "ulong", DllStructGetSize($2v), "ulong*", 0)
$2p = DllCall($2c, "int", "MapWindowPoints", "hwnd", $2m, "ptr", 0, "struct*", $2v, "uint", 2)
$2u[0] = DllStructGetData($2v, 1)
$2u[1] = DllStructGetData($2v, 2)
$2n = $2u
Else
$2n = -1
EndIf
Case Else
$2n = $2k
EndSwitch
Else
$2o = 5
EndIf
DllCall($2i, "bool", "VirtualFreeEx", "handle", $2r[0], "ptr", $2s[0], "ulong", 0, "dword", 0x8000)
Else
$2o = 4
EndIf
DllCall($2i, "bool", "CloseHandle", "handle", $2r[0])
If $2o Then
Return SetError($2o, 0, -1)
Else
Return $2n
EndIf
EndFunc
Func _89($s, $2a = 1)
Local $2l = _88($s, $2a, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($2l, 1))
EndIf
EndFunc
Func _8a($2w, $2a = 1)
Local $2c = _82()
Local $2x = _84()
Local $2l = _88($2w, $2a, 2)
If @error Then Return SetError(@error, 0, -1)
Local $2y = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($2y, 1, DllStructGetSize($2y))
DllStructSetData($2y, 2, Ptr(DllStructGetData($2l, 1)))
DllStructSetData($2y, 3, DllStructGetData($2l, 2))
Local $2p = DllCall($2x, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $2y)
DllCall($2c, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($2p) And $2p[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _8b($2a = 1)
Local $o, $2p = -1
Local $2c = _82()
If $2a = 1 Then
$o = DllCall($2c, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$o = DllCall($2c, "hwnd", "FindWindowEx", "hwnd", $o[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$o = DllCall($2c, "hwnd", "FindWindowEx", "hwnd", $o[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$o = DllCall($2c, "hwnd", "FindWindowEx", "hwnd", $o[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$2p = $o[0]
ElseIf $2a = 2 Then
$o = DllCall($2c, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$o = DllCall($2c, "hwnd", "FindWindowEx", "hwnd", $o[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$2p = $o[0]
EndIf
Return $2p
EndFunc
Local $2z = ""
If @OSArch = "X64" Then $2z = "64"
Local $30 = "HKCU" & $2z & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($30, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($30, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($30, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($30, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($30, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($30, "bStartMinimized", "REG_DWORD", 1)
RegWrite($30, "nTargetMode", "REG_DWORD", 1)
RegWrite($30, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($30, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($30, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($30, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $27 = True Then
RegWrite($30, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($30, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
Func _8c()
Local $31 = RegRead($30, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($31) Then Return
Local $32 = _7l($31, "*.avi", $5, True)
If @error <> 0 Or $32[0] < $1y Then Return
_6l($32, 0)
_6x($32)
For $14 = $1y To UBound($32) - 1
FileDelete($32[$14])
Next
EndFunc
Func _8d()
Local $2a = 1
If $27 = False Then $2a = 2
Local $33 = _87($2a)
For $14 = 0 To UBound($33) - 1
If StringRegExp($33[$14], "(?i).*Bandicam.*") Then
_8a($14, $2a)
EndIf
Next
EndFunc
Func _8e()
$20 = False
$21 = Null
$22 = Null
$26 = Null
EndFunc
Func _8f()
$26 = Null
If $20 = True Then Return
$20 = True
If $27 = False Then
Run($1q)
Else
Send("^!+9")
EndIf
_8d()
EndFunc
Func _8g()
If $20 = False Then Return
$20 = False
$26 = Null
If $27 = False Then
Run($1r)
Else
Send("^!+9")
$28 = True
EndIf
_8d()
_8c()
EndFunc
Func _8h($34)
Local $s = $1v[0] + 1
ReDim $1v[$s + 1]
$1v[$s] = $34
$1v[0] = $s
EndFunc
Func _8i()
Local $35 = WinList()
For $14 = 1 To $35[0][0]
If $35[$14][0] = "" And BitAND(WinGetState($35[$14][1]), $3) Then
Local $36 = $35[$14][1]
Local $37 = $35[$14][0]
Local $38 = WinGetPos($36)
Local $39 = $38[0]
Local $3a = $38[1]
Local $3b = $38[2]
Local $3c = $38[3]
If $3a > -50 And $3a < 20 And $3c > 0 And $3c < 80 And $3b > 0 And $39 > -80 And $37 = "" Then
_8h($36)
EndIf
EndIf
Next
EndFunc
Func _8j()
WinSetState($1z, "", @SW_HIDE)
If UBound($1v) = 1 Then Return
For $14 = 1 To $1v[0]
WinSetState($1v[$14], "", @SW_HIDE)
Next
EndFunc
Func _8k()
If Not ProcessExists("bdcam.exe") Then
Run($1s)
WinWait($1u)
$1z = WinGetHandle($1u)
WinSetState($1z, "", @SW_HIDE)
Local $3d[1] = [0]
$1v = $3d
Sleep(2500)
_8e()
_8i()
_8j()
EndIf
_8d()
EndFunc
Func _8l()
Local $2c = _82()
Local $3e = False
Local $3f = MouseGetPos()
If $3f[0] <> $21 Or $3f[1] <> $22 Then
$3e = True
EndIf
$21 = $3f[0]
$22 = $3f[1]
If $3e Then Return True
If $28 = True Then
$28 = False
Return False
EndIf
For $14 = 1 To 221
If _5w(Hex($14), $2c) Then
Return True
EndIf
Next
Return False
EndFunc
Func _8m()
If $20 = False Then
Return False
EndIf
If $26 = Null Then
$26 = TimerInit()
Return False
EndIf
Local $3g = TimerDiff($26)
Return $3g > $1m
EndFunc
If ProcessExists("bdcam.exe") Then
_8d()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_8c()
_8k()
Sleep($1n)
Local $3h = 0
Local $3f = MouseGetPos()
$21 = $3f[0]
$22 = $3f[1]
While True
Sleep($1o)
If _8l() Then
_8f()
ElseIf _8m() Then
_8g()
EndIf
$3h = $3h + $1o
If $3h > 5000 Then
$3h = 0
_8k()
EndIf
_8j()
WEnd
