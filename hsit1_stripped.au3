#NoTrayIcon
#RequireAdmin
Global Const $0 = 0
Global Const $1 = 1
Global Const $2 = 2
Global Const $3 = 2
Global Const $4 = 1
Global Const $5 = 0
Global Const $6 = 4
Global Const $7 = 8
Global Const $8 = 16
Global Const $9 = 0
Global Const $a = 0
Global Const $b = 1
Global Const $c = 1
Global Const $d = 2
Global Const $e = 2
Global Const $f = 1
Global Const $g = 2
Global Const $h = 2
Func _3(Const $i = @error, Const $j = @extended)
Local $k = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($i, $j, $k[0])
EndFunc
Global Const $l = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $m = _1g()
Func _0z($n)
Local $o = "wstr"
If $n = "" Then
$n = 0
$o = "ptr"
EndIf
Local $k = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $o, $n)
If @error Then Return SetError(@error, @extended, 0)
Return $k[0]
EndFunc
Func _1g()
Local $p = DllStructCreate($l)
DllStructSetData($p, 1, DllStructGetSize($p))
Local $q = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $p)
If @error Or Not $q[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($p, 2), -8), DllStructGetData($p, 3))
EndFunc
Func _3z($r, $s = True, $t = 0)
Local $q = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $t, 'bool', $s, 'wstr', $r)
If @error Then Return SetError(@error, @extended, 0)
Return $q[0]
EndFunc
Global Const $u = Ptr(-1)
Global Const $v = Ptr(-1)
Global Const $w = 13
Global Const $x = 14
Global Const $y = 0x0100
Global Const $0z = 0x2000
Global Const $10 = 0x8000
Global Const $11 = BitShift($y, 8)
Global Const $12 = BitShift($0z, 8)
Global Const $13 = BitShift($10, 8)
Func _d7($14, $15, $16, $17)
Local $k = DllCall("user32.dll", "lresult", "CallNextHookEx", "handle", $14, "int", $15, "wparam", $16, "lparam", $17)
If @error Then Return SetError(@error, @extended, -1)
Return $k[0]
EndFunc
Func _fi($18, $19, $1a, $1b = 0)
Local $k = DllCall("user32.dll", "handle", "SetWindowsHookEx", "int", $18, "ptr", $19, "handle", $1a, "dword", $1b)
If @error Then Return SetError(@error, @extended, 0)
Return $k[0]
EndFunc
Func _fq($14)
Local $k = DllCall("user32.dll", "bool", "UnhookWindowsHookEx", "handle", $14)
If @error Then Return SetError(@error, @extended, False)
Return $k[0]
EndFunc
Global Const $1c = 0x00040000
Global Const $1d = 0x0100
Global Const $1e = 11
Global $1f[$1e]
Global Const $1g = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($1h, $1i, $1j)
If $1f[3] = $1f[4] Then
If Not $1f[7] Then
$1f[5] *= -1
$1f[7] = 1
EndIf
Else
$1f[7] = 1
EndIf
$1f[6] = $1f[3]
Local $1k = _su($1j, $1h, $1f[3])
Local $1l = _su($1j, $1i, $1f[3])
If $1f[8] = 1 Then
If(StringIsFloat($1k) Or StringIsInt($1k)) Then $1k = Number($1k)
If(StringIsFloat($1l) Or StringIsInt($1l)) Then $1l = Number($1l)
EndIf
Local $1m
If $1f[8] < 2 Then
$1m = 0
If $1k < $1l Then
$1m = -1
ElseIf $1k > $1l Then
$1m = 1
EndIf
Else
$1m = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $1k, 'wstr', $1l)[0]
EndIf
$1m = $1m * $1f[5]
Return $1m
EndFunc
Func _su($1j, $1n, $1o = 0)
Local $1p = DllStructCreate("wchar Text[4096]")
Local $1q = DllStructGetPtr($1p)
Local $1r = DllStructCreate($1g)
DllStructSetData($1r, "SubItem", $1o)
DllStructSetData($1r, "TextMax", 4096)
DllStructSetData($1r, "Text", $1q)
If IsHWnd($1j) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $1j, "uint", 0x1073, "wparam", $1n, "struct*", $1r)
Else
Local $1s = DllStructGetPtr($1r)
GUICtrlSendMsg($1j, 0x1073, $1n, $1s)
EndIf
Return DllStructGetData($1p, "Text")
EndFunc
Func _t3(ByRef $1t, Const ByRef $1u, $1v = 0)
If $1v = Default Then $1v = 0
If Not IsArray($1t) Then Return SetError(1, 0, -1)
If Not IsArray($1u) Then Return SetError(2, 0, -1)
Local $1w = UBound($1t, $0)
Local $1x = UBound($1u, $0)
Local $1y = UBound($1t, $1)
Local $1z = UBound($1u, $1)
If $1v < 0 Or $1v > $1z - 1 Then Return SetError(6, 0, -1)
Switch $1w
Case 1
If $1x <> 1 Then Return SetError(4, 0, -1)
ReDim $1t[$1y + $1z - $1v]
For $20 = $1v To $1z - 1
$1t[$1y + $20 - $1v] = $1u[$20]
Next
Case 2
If $1x <> 2 Then Return SetError(4, 0, -1)
Local $21 = UBound($1t, $2)
If UBound($1u, $2) <> $21 Then Return SetError(5, 0, -1)
ReDim $1t[$1y + $1z - $1v][$21]
For $20 = $1v To $1z - 1
For $22 = 0 To $21 - 1
$1t[$1y + $20 - $1v][$22] = $1u[$20][$22]
Next
Next
Case Else
Return SetError(3, 0, -1)
EndSwitch
Return UBound($1t, $1)
EndFunc
Func _th(Const ByRef $23, $24, $1v = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 1, $1o = -1, $29 = False)
If $1v = Default Then $1v = 0
If $25 = Default Then $25 = 0
If $26 = Default Then $26 = 0
If $27 = Default Then $27 = 0
If $28 = Default Then $28 = 1
If $1o = Default Then $1o = -1
If $29 = Default Then $29 = False
If Not IsArray($23) Then Return SetError(1, 0, -1)
Local $2a = UBound($23) - 1
If $2a = -1 Then Return SetError(3, 0, -1)
Local $2b = UBound($23, $2) - 1
Local $2c = False
If $27 = 2 Then
$27 = 0
$2c = True
EndIf
If $29 Then
If UBound($23, $0) = 1 Then Return SetError(5, 0, -1)
If $25 < 1 Or $25 > $2b Then $25 = $2b
If $1v < 0 Then $1v = 0
If $1v > $25 Then Return SetError(4, 0, -1)
Else
If $25 < 1 Or $25 > $2a Then $25 = $2a
If $1v < 0 Then $1v = 0
If $1v > $25 Then Return SetError(4, 0, -1)
EndIf
Local $2d = 1
If Not $28 Then
Local $2e = $1v
$1v = $25
$25 = $2e
$2d = -1
EndIf
Switch UBound($23, $0)
Case 1
If Not $27 Then
If Not $26 Then
For $20 = $1v To $25 Step $2d
If $2c And VarGetType($23[$20]) <> VarGetType($24) Then ContinueLoop
If $23[$20] = $24 Then Return $20
Next
Else
For $20 = $1v To $25 Step $2d
If $2c And VarGetType($23[$20]) <> VarGetType($24) Then ContinueLoop
If $23[$20] == $24 Then Return $20
Next
EndIf
Else
For $20 = $1v To $25 Step $2d
If $27 = 3 Then
If StringRegExp($23[$20], $24) Then Return $20
Else
If StringInStr($23[$20], $24, $26) > 0 Then Return $20
EndIf
Next
EndIf
Case 2
Local $2f
If $29 Then
$2f = $2a
If $1o > $2f Then $1o = $2f
If $1o < 0 Then
$1o = 0
Else
$2f = $1o
EndIf
Else
$2f = $2b
If $1o > $2f Then $1o = $2f
If $1o < 0 Then
$1o = 0
Else
$2f = $1o
EndIf
EndIf
For $22 = $1o To $2f
If Not $27 Then
If Not $26 Then
For $20 = $1v To $25 Step $2d
If $29 Then
If $2c And VarGetType($23[$22][$20]) <> VarGetType($24) Then ContinueLoop
If $23[$22][$20] = $24 Then Return $20
Else
If $2c And VarGetType($23[$20][$22]) <> VarGetType($24) Then ContinueLoop
If $23[$20][$22] = $24 Then Return $20
EndIf
Next
Else
For $20 = $1v To $25 Step $2d
If $29 Then
If $2c And VarGetType($23[$22][$20]) <> VarGetType($24) Then ContinueLoop
If $23[$22][$20] == $24 Then Return $20
Else
If $2c And VarGetType($23[$20][$22]) <> VarGetType($24) Then ContinueLoop
If $23[$20][$22] == $24 Then Return $20
EndIf
Next
EndIf
Else
For $20 = $1v To $25 Step $2d
If $27 = 3 Then
If $29 Then
If StringRegExp($23[$22][$20], $24) Then Return $20
Else
If StringRegExp($23[$20][$22], $24) Then Return $20
EndIf
Else
If $29 Then
If StringInStr($23[$22][$20], $24, $26) > 0 Then Return $20
Else
If StringInStr($23[$20][$22], $24, $26) > 0 Then Return $20
EndIf
EndIf
Next
EndIf
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Func _tm(ByRef $23, $2g, $2h, $2i = True)
If $2g > $2h Then Return
Local $2j = $2h - $2g + 1
Local $20, $22, $2k, $2l, $2m, $2n, $2o, $2p
If $2j < 45 Then
If $2i Then
$20 = $2g
While $20 < $2h
$22 = $20
$2l = $23[$20 + 1]
While $2l < $23[$22]
$23[$22 + 1] = $23[$22]
$22 -= 1
If $22 + 1 = $2g Then ExitLoop
WEnd
$23[$22 + 1] = $2l
$20 += 1
WEnd
Else
While 1
If $2g >= $2h Then Return 1
$2g += 1
If $23[$2g] < $23[$2g - 1] Then ExitLoop
WEnd
While 1
$2k = $2g
$2g += 1
If $2g > $2h Then ExitLoop
$2n = $23[$2k]
$2o = $23[$2g]
If $2n < $2o Then
$2o = $2n
$2n = $23[$2g]
EndIf
$2k -= 1
While $2n < $23[$2k]
$23[$2k + 2] = $23[$2k]
$2k -= 1
WEnd
$23[$2k + 2] = $2n
While $2o < $23[$2k]
$23[$2k + 1] = $23[$2k]
$2k -= 1
WEnd
$23[$2k + 1] = $2o
$2g += 1
WEnd
$2p = $23[$2h]
$2h -= 1
While $2p < $23[$2h]
$23[$2h + 1] = $23[$2h]
$2h -= 1
WEnd
$23[$2h + 1] = $2p
EndIf
Return 1
EndIf
Local $2q = BitShift($2j, 3) + BitShift($2j, 6) + 1
Local $2r, $2s, $2t, $2u, $2v, $2w
$2t = Ceiling(($2g + $2h) / 2)
$2s = $2t - $2q
$2r = $2s - $2q
$2u = $2t + $2q
$2v = $2u + $2q
If $23[$2s] < $23[$2r] Then
$2w = $23[$2s]
$23[$2s] = $23[$2r]
$23[$2r] = $2w
EndIf
If $23[$2t] < $23[$2s] Then
$2w = $23[$2t]
$23[$2t] = $23[$2s]
$23[$2s] = $2w
If $2w < $23[$2r] Then
$23[$2s] = $23[$2r]
$23[$2r] = $2w
EndIf
EndIf
If $23[$2u] < $23[$2t] Then
$2w = $23[$2u]
$23[$2u] = $23[$2t]
$23[$2t] = $2w
If $2w < $23[$2s] Then
$23[$2t] = $23[$2s]
$23[$2s] = $2w
If $2w < $23[$2r] Then
$23[$2s] = $23[$2r]
$23[$2r] = $2w
EndIf
EndIf
EndIf
If $23[$2v] < $23[$2u] Then
$2w = $23[$2v]
$23[$2v] = $23[$2u]
$23[$2u] = $2w
If $2w < $23[$2t] Then
$23[$2u] = $23[$2t]
$23[$2t] = $2w
If $2w < $23[$2s] Then
$23[$2t] = $23[$2s]
$23[$2s] = $2w
If $2w < $23[$2r] Then
$23[$2s] = $23[$2r]
$23[$2r] = $2w
EndIf
EndIf
EndIf
EndIf
Local $2x = $2g
Local $2y = $2h
If(($23[$2r] <> $23[$2s]) And($23[$2s] <> $23[$2t]) And($23[$2t] <> $23[$2u]) And($23[$2u] <> $23[$2v])) Then
Local $2z = $23[$2s]
Local $30 = $23[$2u]
$23[$2s] = $23[$2g]
$23[$2u] = $23[$2h]
Do
$2x += 1
Until $23[$2x] >= $2z
Do
$2y -= 1
Until $23[$2y] <= $30
$2k = $2x
While $2k <= $2y
$2m = $23[$2k]
If $2m < $2z Then
$23[$2k] = $23[$2x]
$23[$2x] = $2m
$2x += 1
ElseIf $2m > $30 Then
While $23[$2y] > $30
$2y -= 1
If $2y + 1 = $2k Then ExitLoop 2
WEnd
If $23[$2y] < $2z Then
$23[$2k] = $23[$2x]
$23[$2x] = $23[$2y]
$2x += 1
Else
$23[$2k] = $23[$2y]
EndIf
$23[$2y] = $2m
$2y -= 1
EndIf
$2k += 1
WEnd
$23[$2g] = $23[$2x - 1]
$23[$2x - 1] = $2z
$23[$2h] = $23[$2y + 1]
$23[$2y + 1] = $30
_tm($23, $2g, $2x - 2, True)
_tm($23, $2y + 2, $2h, False)
If($2x < $2r) And($2v < $2y) Then
While $23[$2x] = $2z
$2x += 1
WEnd
While $23[$2y] = $30
$2y -= 1
WEnd
$2k = $2x
While $2k <= $2y
$2m = $23[$2k]
If $2m = $2z Then
$23[$2k] = $23[$2x]
$23[$2x] = $2m
$2x += 1
ElseIf $2m = $30 Then
While $23[$2y] = $30
$2y -= 1
If $2y + 1 = $2k Then ExitLoop 2
WEnd
If $23[$2y] = $2z Then
$23[$2k] = $23[$2x]
$23[$2x] = $2z
$2x += 1
Else
$23[$2k] = $23[$2y]
EndIf
$23[$2y] = $2m
$2y -= 1
EndIf
$2k += 1
WEnd
EndIf
_tm($23, $2x, $2y, False)
Else
Local $31 = $23[$2t]
$2k = $2x
While $2k <= $2y
If $23[$2k] = $31 Then
$2k += 1
ContinueLoop
EndIf
$2m = $23[$2k]
If $2m < $31 Then
$23[$2k] = $23[$2x]
$23[$2x] = $2m
$2x += 1
Else
While $23[$2y] > $31
$2y -= 1
WEnd
If $23[$2y] < $31 Then
$23[$2k] = $23[$2x]
$23[$2x] = $23[$2y]
$2x += 1
Else
$23[$2k] = $31
EndIf
$23[$2y] = $2m
$2y -= 1
EndIf
$2k += 1
WEnd
_tm($23, $2g, $2x - 1, True)
_tm($23, $2y + 1, $2h, False)
EndIf
EndFunc
Func _u5($32, $33 = "*", $34 = $5, $35 = $9, $36 = $a, $37 = $c)
If Not FileExists($32) Then Return SetError(1, 1, "")
If $33 = Default Then $33 = "*"
If $34 = Default Then $34 = $5
If $35 = Default Then $35 = $9
If $36 = Default Then $36 = $a
If $37 = Default Then $37 = $c
If $35 > 1 Or Not IsInt($35) Then Return SetError(1, 6, "")
Local $38 = False
If StringLeft($32, 4) == "\\?\" Then
$38 = True
EndIf
Local $39 = ""
If StringRight($32, 1) = "\" Then
$39 = "\"
Else
$32 = $32 & "\"
EndIf
Local $3a[100] = [1]
$3a[1] = $32
Local $3b = 0, $3c = ""
If BitAND($34, $6) Then
$3b += 2
$3c &= "H"
$34 -= $6
EndIf
If BitAND($34, $7) Then
$3b += 4
$3c &= "S"
$34 -= $7
EndIf
Local $3d = 0
If BitAND($34, $8) Then
$3d = 0x400
$34 -= $8
EndIf
Local $3e = 0
If $35 < 0 Then
StringReplace($32, "\", "", 0, $e)
$3e = @extended - $35
EndIf
Local $3f = "", $3g = "", $3h = "*"
Local $3i = StringSplit($33, "|")
Switch $3i[0]
Case 3
$3g = $3i[3]
ContinueCase
Case 2
$3f = $3i[2]
ContinueCase
Case 1
$3h = $3i[1]
EndSwitch
Local $3j = ".+"
If $3h <> "*" Then
If Not _u8($3j, $3h) Then Return SetError(1, 2, "")
EndIf
Local $3k = ".+"
Switch $34
Case 0
Switch $35
Case 0
$3k = $3j
EndSwitch
Case 2
$3k = $3j
EndSwitch
Local $3l = ":"
If $3f <> "" Then
If Not _u8($3l, $3f) Then Return SetError(1, 3, "")
EndIf
Local $3m = ":"
If $35 Then
If $3g Then
If Not _u8($3m, $3g) Then Return SetError(1, 4, "")
EndIf
If $34 = 2 Then
$3m = $3l
EndIf
Else
$3m = $3l
EndIf
If Not($34 = 0 Or $34 = 1 Or $34 = 2) Then Return SetError(1, 5, "")
If Not($36 = 0 Or $36 = 1 Or $36 = 2) Then Return SetError(1, 7, "")
If Not($37 = 0 Or $37 = 1 Or $37 = 2) Then Return SetError(1, 8, "")
If $3d Then
Local $3n = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $1a = DllOpen('kernel32.dll'), $3o
EndIf
Local $3p[100] = [0]
Local $3q = $3p, $3r = $3p, $3s = $3p
Local $3t = False, $3u = 0, $3v = "", $3w = "", $3x = ""
Local $3y = 0, $3z = ''
Local $40[100][2] = [[0, 0]]
While $3a[0] > 0
$3v = $3a[$3a[0]]
$3a[0] -= 1
Switch $37
Case 1
$3x = StringReplace($3v, $32, "")
Case 2
If $38 Then
$3x = StringTrimLeft($3v, 4)
Else
$3x = $3v
EndIf
EndSwitch
If $3d Then
$3o = DllCall($1a, 'handle', 'FindFirstFileW', 'wstr', $3v & "*", 'struct*', $3n)
If @error Or Not $3o[0] Then
ContinueLoop
EndIf
$3u = $3o[0]
Else
$3u = FileFindFirstFile($3v & "*")
If $3u = -1 Then
ContinueLoop
EndIf
EndIf
If $34 = 0 And $36 And $37 Then
_u7($40, $3x, $3q[0] + 1)
EndIf
$3z = ''
While 1
If $3d Then
$3o = DllCall($1a, 'int', 'FindNextFileW', 'handle', $3u, 'struct*', $3n)
If @error Or Not $3o[0] Then
ExitLoop
EndIf
$3w = DllStructGetData($3n, "FileName")
If $3w = ".." Then
ContinueLoop
EndIf
$3y = DllStructGetData($3n, "FileAttributes")
If $3b And BitAND($3y, $3b) Then
ContinueLoop
EndIf
If BitAND($3y, $3d) Then
ContinueLoop
EndIf
$3t = False
If BitAND($3y, 16) Then
$3t = True
EndIf
Else
$3t = False
$3w = FileFindNextFile($3u, 1)
If @error Then
ExitLoop
EndIf
$3z = @extended
If StringInStr($3z, "D") Then
$3t = True
EndIf
If StringRegExp($3z, "[" & $3c & "]") Then
ContinueLoop
EndIf
EndIf
If $3t Then
Select
Case $35 < 0
StringReplace($3v, "\", "", 0, $e)
If @extended < $3e Then
ContinueCase
EndIf
Case $35 = 1
If Not StringRegExp($3w, $3m) Then
_u7($3a, $3v & $3w & "\")
EndIf
EndSelect
EndIf
If $36 Then
If $3t Then
If StringRegExp($3w, $3k) And Not StringRegExp($3w, $3m) Then
_u7($3s, $3x & $3w & $39)
EndIf
Else
If StringRegExp($3w, $3j) And Not StringRegExp($3w, $3l) Then
If $3v = $32 Then
_u7($3r, $3x & $3w)
Else
_u7($3q, $3x & $3w)
EndIf
EndIf
EndIf
Else
If $3t Then
If $34 <> 1 And StringRegExp($3w, $3k) And Not StringRegExp($3w, $3m) Then
_u7($3p, $3x & $3w & $39)
EndIf
Else
If $34 <> 2 And StringRegExp($3w, $3j) And Not StringRegExp($3w, $3l) Then
_u7($3p, $3x & $3w)
EndIf
EndIf
EndIf
WEnd
If $3d Then
DllCall($1a, 'int', 'FindClose', 'ptr', $3u)
Else
FileClose($3u)
EndIf
WEnd
If $3d Then
DllClose($1a)
EndIf
If $36 Then
Switch $34
Case 2
If $3s[0] = 0 Then Return SetError(1, 9, "")
ReDim $3s[$3s[0] + 1]
$3p = $3s
_tm($3p, 1, $3p[0])
Case 1
If $3r[0] = 0 And $3q[0] = 0 Then Return SetError(1, 9, "")
If $37 = 0 Then
_u6($3p, $3r, $3q)
_tm($3p, 1, $3p[0])
Else
_u6($3p, $3r, $3q, 1)
EndIf
Case 0
If $3r[0] = 0 And $3s[0] = 0 Then Return SetError(1, 9, "")
If $37 = 0 Then
_u6($3p, $3r, $3q)
$3p[0] += $3s[0]
ReDim $3s[$3s[0] + 1]
_t3($3p, $3s, 1)
_tm($3p, 1, $3p[0])
Else
Local $3p[$3q[0] + $3r[0] + $3s[0] + 1]
$3p[0] = $3q[0] + $3r[0] + $3s[0]
_tm($3r, 1, $3r[0])
For $20 = 1 To $3r[0]
$3p[$20] = $3r[$20]
Next
Local $41 = $3r[0] + 1
_tm($3s, 1, $3s[0])
Local $42 = ""
For $20 = 1 To $3s[0]
$3p[$41] = $3s[$20]
$41 += 1
If $39 Then
$42 = $3s[$20]
Else
$42 = $3s[$20] & "\"
EndIf
Local $43 = 0, $44 = 0
For $22 = 1 To $40[0][0]
If $42 = $40[$22][0] Then
$44 = $40[$22][1]
If $22 = $40[0][0] Then
$43 = $3q[0]
Else
$43 = $40[$22 + 1][1] - 1
EndIf
If $36 = 1 Then
_tm($3q, $44, $43)
EndIf
For $2k = $44 To $43
$3p[$41] = $3q[$2k]
$41 += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $3p[0] = 0 Then Return SetError(1, 9, "")
ReDim $3p[$3p[0] + 1]
EndIf
Return $3p
EndFunc
Func _u6(ByRef $45, $46, $47, $36 = 0)
ReDim $46[$46[0] + 1]
If $36 = 1 Then _tm($46, 1, $46[0])
$45 = $46
$45[0] += $47[0]
ReDim $47[$47[0] + 1]
If $36 = 1 Then _tm($47, 1, $47[0])
_t3($45, $47, 1)
EndFunc
Func _u7(ByRef $48, $49, $4a = -1)
If $4a = -1 Then
$48[0] += 1
If UBound($48) <= $48[0] Then ReDim $48[UBound($48) * 2]
$48[$48[0]] = $49
Else
$48[0][0] += 1
If UBound($48) <= $48[0][0] Then ReDim $48[UBound($48) * 2][2]
$48[$48[0][0]][0] = $49
$48[$48[0][0]][1] = $4a
EndIf
EndFunc
Func _u8(ByRef $33, $4b)
If StringRegExp($4b, "\\|/|:|\<|\>|\|") Then Return 0
$4b = StringReplace(StringStripWS(StringRegExpReplace($4b, "\s*;\s*", ";"), BitOR($f, $g)), ";", "|")
$4b = StringReplace(StringReplace(StringRegExpReplace($4b, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$33 = "(?i)^(" & $4b & ")\z"
Return 1
EndFunc
OnAutoItExitRegister("_ul")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Func _uk()
Local Const $4c = 183
Local Const $4d = 5
Local Const $4e = "WsssM"
Local $4f = 0
_3z($4e & "_MUTEX", True, 0)
$4f = _3()
Return $4f == $4c Or $4f == $4d
EndFunc
If _uk() Then
Exit
EndIf
Opt("SendKeyDownDelay", 100)
Local Const $4g = 1000 * 30
Local Const $4h = 2000 * 10
Local Const $4i = 500
Local Const $4j = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $4k = $4j & " /record"
Local Const $4l = $4j & " /stop"
Local Const $4m = $4j & " /nosplash"
Local Const $4n = "[CLASS:Bandicam2.x]"
Local $4o = 107374182400
Local $4p = Null
Local $4q = Null
Local $4r = Null
Local $4s = Null
Local $4t = False
Local $4u = False
Local $4v = Null
Local $4w = True
Local $4x = False
Local $4y = 20
Local $4z = False
Local $50[1] = [0]
Local $51 = Null
Local $52 = Null
Local $53 = 0
Local $54 = 1500
Local $55 = Null
Local $56 = Null
Local $57 = Null
Local $58 = Null
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$4t = True
$4o = 16106127360
EndIf
If UBound($cmdline) > 1 Then
For $20 = 1 To UBound($cmdline) - 1
Local $59 = StringSplit($cmdline[$20], "=", $h)
Local $5a = StringUpper($59[0])
Local $5b = Number($59[1])
If $5a = "HIDESYSTRAY" Then
If $5b = 0 Then
$4w = False
Else
$4w = True
EndIf
ElseIf $5a = "KEYPRESS" Then
Opt("SendKeyDownDelay", $5b)
ElseIf $5a = "MAXATTEMPT" Then
$4y = $5b
ElseIf $5a = "USERACTIVITY" Then
If $5b = 0 Then
$4x = False
Else
$4x = True
EndIf
EndIf
Next
EndIf
Func _ul()
Dim $4p
Dim $4q
Dim $4r
If $4p <> Null Then
DllClose($4p)
$4p = Null
EndIf
If $4q <> Null Then
DllClose($4q)
$4q = Null
EndIf
If $4r <> Null Then
DllClose($4r)
$4r = Null
EndIf
_fq($58)
DllCallbackFree($56)
_fq($57)
DllCallbackFree($55)
EndFunc
Func _um()
If $4p = Null Then
$4p = DllOpen('user32.dll')
EndIf
Return $4p
EndFunc
Func _un()
If $4q = Null Then
$4q = DllOpen('kernel32.dll')
EndIf
Return $4q
EndFunc
Func _uo()
If $4r = Null Then
$4r = DllOpen('shell32.dll')
EndIf
Return $4r
EndFunc
Func _up($5c = 1)
Local Const $5d = 1048
Local $1j = _uu($5c)
If $1j = -1 Then Return -1
Local $5e = _um()
Local $5f = DllCall($5e, "lresult", "SendMessageW", "hwnd", $1j, "uint", $5d, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $5f[0]
EndFunc
Func _uq($5c = 1)
Local $5f = _up($5c)
If $5f <= 0 Then Return -1
Local $5g[$5f]
For $20 = 0 To $5f - 1
$5g[$20] = WinGetTitle(_us($20, $5c))
Next
Return $5g
EndFunc
Func _ur($1n, $5c = 1, $5h = 1)
Local Const $5i = 1047
Local Const $5j = 1053
Local $5e = _um()
Local $5k = _un()
Local Const $5l = BitOR(0x0008, 0x0010, 0x0400)
Local $5m
If @OSArch = "X86" Then
$5m = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$5m = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $5n
If @OSArch = "X86" Then
$5n = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$5n = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $5o = _uu($5c)
If $5o = -1 Then Return SetError(1, 0, -1)
Local $5p, $5q = 0
Local $5r = DllCall($5e, "dword", "GetWindowThreadProcessId", "hwnd", $5o, "dword*", 0)
If @error Or Not $5r[2] Then SetError(2, 0, -1)
Local $5s = $5r[2]
Local $5t = DllCall($5k, "handle", "OpenProcess", "dword", $5l, "bool", False, "dword", $5s)
If @error Or Not $5t[0] Then Return SetError(3, 0, -1)
Local $5u = DllCall($5k, "ptr", "VirtualAllocEx", "handle", $5t[0], "ptr", 0, "ulong", DllStructGetSize($5m), "dword", 0x1000, "dword", 0x04)
If Not @error And $5u[0] Then
$5r = DllCall($5e, "lresult", "SendMessageW", "hwnd", $5o, "uint", $5i, "wparam", $1n, "lparam", $5u[0])
If Not @error And $5r[0] Then
DllCall($5k, "bool", "ReadProcessMemory", "handle", $5t[0], "ptr", $5u[0], "struct*", $5m, "ulong", DllStructGetSize($5m), "ulong*", 0)
Switch $5h
Case 2
DllCall($5k, "bool", "ReadProcessMemory", "handle", $5t[0], "ptr", DllStructGetData($5m, 6), "struct*", $5n, "ulong", DllStructGetSize($5n), "ulong*", 0)
$5p = $5n
Case 3
$5p = ""
If BitShift(DllStructGetData($5m, 7), 16) <> 0 Then
Local $5v = DllStructCreate("wchar[1024]")
DllCall($5k, "bool", "ReadProcessMemory", "handle", $5t[0], "ptr", DllStructGetData($5m, 7), "struct*", $5v, "ulong", DllStructGetSize($5v), "ulong*", 0)
$5p = DllStructGetData($5v, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($5m, 3), 8) Then
Local $5w[2], $5x = DllStructCreate("int;int;int;int")
DllCall($5e, "lresult", "SendMessageW", "hwnd", $5o, "uint", $5j, "wparam", $1n, "lparam", $5u[0])
DllCall($5k, "bool", "ReadProcessMemory", "handle", $5t[0], "ptr", $5u[0], "struct*", $5x, "ulong", DllStructGetSize($5x), "ulong*", 0)
$5r = DllCall($5e, "int", "MapWindowPoints", "hwnd", $5o, "ptr", 0, "struct*", $5x, "uint", 2)
$5w[0] = DllStructGetData($5x, 1)
$5w[1] = DllStructGetData($5x, 2)
$5p = $5w
Else
$5p = -1
EndIf
Case Else
$5p = $5m
EndSwitch
Else
$5q = 5
EndIf
DllCall($5k, "bool", "VirtualFreeEx", "handle", $5t[0], "ptr", $5u[0], "ulong", 0, "dword", 0x8000)
Else
$5q = 4
EndIf
DllCall($5k, "bool", "CloseHandle", "handle", $5t[0])
If $5q Then
Return SetError($5q, 0, -1)
Else
Return $5p
EndIf
EndFunc
Func _us($1n, $5c = 1)
Local $5n = _ur($1n, $5c, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($5n, 1))
EndIf
EndFunc
Func _ut($5y, $5c = 1)
Local $5e = _um()
Local $5z = _uo()
Local $5n = _ur($5y, $5c, 2)
If @error Then Return SetError(@error, 0, -1)
Local $60 = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($60, 1, DllStructGetSize($60))
DllStructSetData($60, 2, Ptr(DllStructGetData($5n, 1)))
DllStructSetData($60, 3, DllStructGetData($5n, 2))
Local $5r = DllCall($5z, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $60)
DllCall($5e, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($5r) And $5r[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _uu($5c = 1)
Local $1j, $5r = -1
Local $5e = _um()
If $5c = 1 Then
$1j = DllCall($5e, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$1j = DllCall($5e, "hwnd", "FindWindowEx", "hwnd", $1j[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$1j = DllCall($5e, "hwnd", "FindWindowEx", "hwnd", $1j[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$1j = DllCall($5e, "hwnd", "FindWindowEx", "hwnd", $1j[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$5r = $1j[0]
ElseIf $5c = 2 Then
$1j = DllCall($5e, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$1j = DllCall($5e, "hwnd", "FindWindowEx", "hwnd", $1j[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$5r = $1j[0]
EndIf
Return $5r
EndFunc
Local $61 = ""
If @OSArch = "X64" Then $61 = "64"
Local $62 = "HKCU" & $61 & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($62, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($62, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($62, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($62, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($62, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($62, "bStartMinimized", "REG_DWORD", 1)
RegWrite($62, "nTargetMode", "REG_DWORD", 1)
RegWrite($62, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($62, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($62, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($62, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $4t = True Then
RegWrite($62, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($62, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
$4v = RegRead($62, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($4v) Then $4v = Null
Func _uv()
If Not $4v Then Return
Local $63 = DirGetSize($4v)
If $63 < $4o Then Return
Local $64 = _u5($4v, "*.avi;*.mp4;*.bfix", $4, $9, $b, $d)
If @error = 1 Or $64 = "" Or UBound($64) < 2 Then Return
For $20 = 1 To UBound($64) - 1
Local $65 = FileGetSize($64[$20])
FileDelete($64[$20])
$63 = $63 - $65
If $63 < $4o Then ExitLoop
Next
EndFunc
Func _uw()
If $4w = False Then Return
Local $5c = 1
If $4t = False Then $5c = 2
Local $66 = _uq($5c)
For $20 = 0 To UBound($66) - 1
If StringRegExp($66[$20], "(?i).*Bandicam.*") Then
_ut($20, $5c)
EndIf
Next
EndFunc
Func _ux()
$4z = False
$4s = Null
EndFunc
Func _uy()
$4s = Null
If $4z = True Then Return
$4z = True
If $4t = False Then
Run($4k)
Else
$4u = True
Send("^!+9")
EndIf
EndFunc
Func _uz()
If $4z = False Then Return
$4z = False
$4s = Null
If $4t = False Then
Run($4l)
Else
$4u = True
Send("^!+9")
EndIf
_uv()
EndFunc
Func _v0($67)
If _th($50, $67, 1) = -1 Then
Local $1n = $50[0] + 1
ReDim $50[$1n + 1]
$50[$1n] = $67
$50[0] = $1n
EndIf
EndFunc
Func _v1($68)
Local $48 = WinList()
For $20 = 1 To $48[0][0]
If $48[$20][0] = "" And BitAND(WinGetState($48[$20][1]), $3) Then
Local $69 = $48[$20][1]
Local $6a = $48[$20][0]
Local $6b = WinGetPos($69)
Local $6c = $6b[0]
Local $6d = $6b[1]
Local $6e = $6b[2]
Local $6f = $6b[3]
If $6d > -50 And $6d < 20 And $6f > 0 And $6f < 80 And $6e > 0 And $6c > -80 And $6a = "" Then
_v0($69)
EndIf
EndIf
Next
If UBound($50) < 2 Then
Local $6g = $68 + 1
If $4y = -1 Or $6g < $4y Then
Sleep(2000)
_v1($6g)
EndIf
EndIf
EndFunc
Func _v2()
WinSetState($51, "", @SW_HIDE)
If UBound($50) = 1 Then Return
For $20 = 1 To $50[0]
WinSetState($50[$20], "", @SW_HIDE)
Next
EndFunc
Func _v3()
If Not ProcessExists("bdcam.exe") Then
Run($4m)
WinWait($4n)
$51 = WinGetHandle($4n)
WinSetState($51, "", @SW_HIDE)
Local $6h[1] = [0]
$50 = $6h
Sleep(2500)
_ux()
_v1(1)
_v2()
_uw()
EndIf
EndFunc
Func _v4()
If $4z = False Then
Return False
EndIf
If $4s = Null Then
$4s = TimerInit()
Return False
EndIf
Local $6i = TimerDiff($4s)
If $6i > $4g Then
_uz()
EndIf
EndFunc
Func _v5($6j, $16, $17)
ConsoleWrite("1 ")
If $6j < 0 Then
Return _d7($57, $6j, $16, $17)
EndIf
If $4u = True Then
ConsoleWrite("2 ")
$4u = False
Return _d7($57, $6j, $16, $17)
EndIf
ConsoleWrite("3 ")
If $16 = $1d Then
ConsoleWrite("4 ")
_uy()
EndIf
Return _d7($57, $6j, $16, $17)
EndFunc
Func _v6()
$52 = Null
$53 = 0
EndFunc
Func _v7($6j, $16, $17)
If $4x = False Then
_uy()
Return _d7($58, $6j, $16, $17)
EndIf
If $4z = True Then
_v6()
Return _d7($58, $6j, $16, $17)
EndIf
Local $6i = 0
$53 = $53 + 1
If $52 = Null Then
$52 = TimerInit()
Return _d7($58, $6j, $16, $17)
Else
$6i = TimerDiff($52)
EndIf
If $6i < $54 Then
Return _d7($58, $6j, $16, $17)
EndIf
Local $2e = $53
_v6()
If $2e > 3 Then
_uy()
EndIf
Return _d7($58, $6j, $16, $17)
EndFunc
Func _v8()
Local $6k = _0z(0)
$56 = DllCallbackRegister("_v7", "long", "int;wparam;lparam")
$58 = _fi($x, DllCallbackGetPtr($56), $6k)
EndFunc
Func _v9()
Local $6l = _0z(0)
$55 = DllCallbackRegister("_v5", "long", "int;wparam;lparam")
$57 = _fi($w, DllCallbackGetPtr($55), $6l)
EndFunc
If ProcessExists("bdcam.exe") Then
ProcessClose("bdcam.exe")
Sleep(5000)
EndIf
_uv()
_v3()
Sleep($4h)
_v8()
_v9()
Local $6m = 0
Local $6n = 0
While True
Sleep($4i)
_v4()
$6m = $6m + $4i
$6n = $6n + 1
If $6n = 2 Then
$6n = 0
_v2()
EndIf
If $6m > 15000 Then
$6m = 0
_v3()
EndIf
WEnd
