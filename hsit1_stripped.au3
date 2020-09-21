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
Func _1g()
Local $n = DllStructCreate($l)
DllStructSetData($n, 1, DllStructGetSize($n))
Local $o = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $n)
If @error Or Not $o[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($n, 2), -8), DllStructGetData($n, 3))
EndFunc
Func _3z($p, $q = True, $r = 0)
Local $o = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $r, 'bool', $q, 'wstr', $p)
If @error Then Return SetError(@error, @extended, 0)
Return $o[0]
EndFunc
Func _5w($s, $t = "user32.dll")
Local $u = DllCall($t, "short", "GetAsyncKeyState", "int", "0x" & $s)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($u[0], 0x8000) <> 0
EndFunc
Global Const $v = 11
Global $w[$v]
Global Const $x = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($y, $0z, $10)
If $w[3] = $w[4] Then
If Not $w[7] Then
$w[5] *= -1
$w[7] = 1
EndIf
Else
$w[7] = 1
EndIf
$w[6] = $w[3]
Local $11 = _6b($10, $y, $w[3])
Local $12 = _6b($10, $0z, $w[3])
If $w[8] = 1 Then
If(StringIsFloat($11) Or StringIsInt($11)) Then $11 = Number($11)
If(StringIsFloat($12) Or StringIsInt($12)) Then $12 = Number($12)
EndIf
Local $13
If $w[8] < 2 Then
$13 = 0
If $11 < $12 Then
$13 = -1
ElseIf $11 > $12 Then
$13 = 1
EndIf
Else
$13 = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $11, 'wstr', $12)[0]
EndIf
$13 = $13 * $w[5]
Return $13
EndFunc
Func _6b($10, $14, $15 = 0)
Local $16 = DllStructCreate("wchar Text[4096]")
Local $17 = DllStructGetPtr($16)
Local $18 = DllStructCreate($x)
DllStructSetData($18, "SubItem", $15)
DllStructSetData($18, "TextMax", 4096)
DllStructSetData($18, "Text", $17)
If IsHWnd($10) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $10, "uint", 0x1073, "wparam", $14, "struct*", $18)
Else
Local $19 = DllStructGetPtr($18)
GUICtrlSendMsg($10, 0x1073, $14, $19)
EndIf
Return DllStructGetData($16, "Text")
EndFunc
Func _6k(ByRef $1a, Const ByRef $1b, $1c = 0)
If $1c = Default Then $1c = 0
If Not IsArray($1a) Then Return SetError(1, 0, -1)
If Not IsArray($1b) Then Return SetError(2, 0, -1)
Local $1d = UBound($1a, $0)
Local $1e = UBound($1b, $0)
Local $1f = UBound($1a, $1)
Local $1g = UBound($1b, $1)
If $1c < 0 Or $1c > $1g - 1 Then Return SetError(6, 0, -1)
Switch $1d
Case 1
If $1e <> 1 Then Return SetError(4, 0, -1)
ReDim $1a[$1f + $1g - $1c]
For $1h = $1c To $1g - 1
$1a[$1f + $1h - $1c] = $1b[$1h]
Next
Case 2
If $1e <> 2 Then Return SetError(4, 0, -1)
Local $1i = UBound($1a, $2)
If UBound($1b, $2) <> $1i Then Return SetError(5, 0, -1)
ReDim $1a[$1f + $1g - $1c][$1i]
For $1h = $1c To $1g - 1
For $1j = 0 To $1i - 1
$1a[$1f + $1h - $1c][$1j] = $1b[$1h][$1j]
Next
Next
Case Else
Return SetError(3, 0, -1)
EndSwitch
Return UBound($1a, $1)
EndFunc
Func _6y(Const ByRef $1k, $1l, $1c = 0, $1m = 0, $1n = 0, $1o = 0, $1p = 1, $15 = -1, $1q = False)
If $1c = Default Then $1c = 0
If $1m = Default Then $1m = 0
If $1n = Default Then $1n = 0
If $1o = Default Then $1o = 0
If $1p = Default Then $1p = 1
If $15 = Default Then $15 = -1
If $1q = Default Then $1q = False
If Not IsArray($1k) Then Return SetError(1, 0, -1)
Local $1r = UBound($1k) - 1
If $1r = -1 Then Return SetError(3, 0, -1)
Local $1s = UBound($1k, $2) - 1
Local $1t = False
If $1o = 2 Then
$1o = 0
$1t = True
EndIf
If $1q Then
If UBound($1k, $0) = 1 Then Return SetError(5, 0, -1)
If $1m < 1 Or $1m > $1s Then $1m = $1s
If $1c < 0 Then $1c = 0
If $1c > $1m Then Return SetError(4, 0, -1)
Else
If $1m < 1 Or $1m > $1r Then $1m = $1r
If $1c < 0 Then $1c = 0
If $1c > $1m Then Return SetError(4, 0, -1)
EndIf
Local $1u = 1
If Not $1p Then
Local $1v = $1c
$1c = $1m
$1m = $1v
$1u = -1
EndIf
Switch UBound($1k, $0)
Case 1
If Not $1o Then
If Not $1n Then
For $1h = $1c To $1m Step $1u
If $1t And VarGetType($1k[$1h]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1h] = $1l Then Return $1h
Next
Else
For $1h = $1c To $1m Step $1u
If $1t And VarGetType($1k[$1h]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1h] == $1l Then Return $1h
Next
EndIf
Else
For $1h = $1c To $1m Step $1u
If $1o = 3 Then
If StringRegExp($1k[$1h], $1l) Then Return $1h
Else
If StringInStr($1k[$1h], $1l, $1n) > 0 Then Return $1h
EndIf
Next
EndIf
Case 2
Local $1w
If $1q Then
$1w = $1r
If $15 > $1w Then $15 = $1w
If $15 < 0 Then
$15 = 0
Else
$1w = $15
EndIf
Else
$1w = $1s
If $15 > $1w Then $15 = $1w
If $15 < 0 Then
$15 = 0
Else
$1w = $15
EndIf
EndIf
For $1j = $15 To $1w
If Not $1o Then
If Not $1n Then
For $1h = $1c To $1m Step $1u
If $1q Then
If $1t And VarGetType($1k[$1j][$1h]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1j][$1h] = $1l Then Return $1h
Else
If $1t And VarGetType($1k[$1h][$1j]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1h][$1j] = $1l Then Return $1h
EndIf
Next
Else
For $1h = $1c To $1m Step $1u
If $1q Then
If $1t And VarGetType($1k[$1j][$1h]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1j][$1h] == $1l Then Return $1h
Else
If $1t And VarGetType($1k[$1h][$1j]) <> VarGetType($1l) Then ContinueLoop
If $1k[$1h][$1j] == $1l Then Return $1h
EndIf
Next
EndIf
Else
For $1h = $1c To $1m Step $1u
If $1o = 3 Then
If $1q Then
If StringRegExp($1k[$1j][$1h], $1l) Then Return $1h
Else
If StringRegExp($1k[$1h][$1j], $1l) Then Return $1h
EndIf
Else
If $1q Then
If StringInStr($1k[$1j][$1h], $1l, $1n) > 0 Then Return $1h
Else
If StringInStr($1k[$1h][$1j], $1l, $1n) > 0 Then Return $1h
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
Func _73(ByRef $1k, $1x, $1y, $1z = True)
If $1x > $1y Then Return
Local $20 = $1y - $1x + 1
Local $1h, $1j, $21, $22, $23, $24, $25, $26
If $20 < 45 Then
If $1z Then
$1h = $1x
While $1h < $1y
$1j = $1h
$22 = $1k[$1h + 1]
While $22 < $1k[$1j]
$1k[$1j + 1] = $1k[$1j]
$1j -= 1
If $1j + 1 = $1x Then ExitLoop
WEnd
$1k[$1j + 1] = $22
$1h += 1
WEnd
Else
While 1
If $1x >= $1y Then Return 1
$1x += 1
If $1k[$1x] < $1k[$1x - 1] Then ExitLoop
WEnd
While 1
$21 = $1x
$1x += 1
If $1x > $1y Then ExitLoop
$24 = $1k[$21]
$25 = $1k[$1x]
If $24 < $25 Then
$25 = $24
$24 = $1k[$1x]
EndIf
$21 -= 1
While $24 < $1k[$21]
$1k[$21 + 2] = $1k[$21]
$21 -= 1
WEnd
$1k[$21 + 2] = $24
While $25 < $1k[$21]
$1k[$21 + 1] = $1k[$21]
$21 -= 1
WEnd
$1k[$21 + 1] = $25
$1x += 1
WEnd
$26 = $1k[$1y]
$1y -= 1
While $26 < $1k[$1y]
$1k[$1y + 1] = $1k[$1y]
$1y -= 1
WEnd
$1k[$1y + 1] = $26
EndIf
Return 1
EndIf
Local $27 = BitShift($20, 3) + BitShift($20, 6) + 1
Local $28, $29, $2a, $2b, $2c, $2d
$2a = Ceiling(($1x + $1y) / 2)
$29 = $2a - $27
$28 = $29 - $27
$2b = $2a + $27
$2c = $2b + $27
If $1k[$29] < $1k[$28] Then
$2d = $1k[$29]
$1k[$29] = $1k[$28]
$1k[$28] = $2d
EndIf
If $1k[$2a] < $1k[$29] Then
$2d = $1k[$2a]
$1k[$2a] = $1k[$29]
$1k[$29] = $2d
If $2d < $1k[$28] Then
$1k[$29] = $1k[$28]
$1k[$28] = $2d
EndIf
EndIf
If $1k[$2b] < $1k[$2a] Then
$2d = $1k[$2b]
$1k[$2b] = $1k[$2a]
$1k[$2a] = $2d
If $2d < $1k[$29] Then
$1k[$2a] = $1k[$29]
$1k[$29] = $2d
If $2d < $1k[$28] Then
$1k[$29] = $1k[$28]
$1k[$28] = $2d
EndIf
EndIf
EndIf
If $1k[$2c] < $1k[$2b] Then
$2d = $1k[$2c]
$1k[$2c] = $1k[$2b]
$1k[$2b] = $2d
If $2d < $1k[$2a] Then
$1k[$2b] = $1k[$2a]
$1k[$2a] = $2d
If $2d < $1k[$29] Then
$1k[$2a] = $1k[$29]
$1k[$29] = $2d
If $2d < $1k[$28] Then
$1k[$29] = $1k[$28]
$1k[$28] = $2d
EndIf
EndIf
EndIf
EndIf
Local $2e = $1x
Local $2f = $1y
If(($1k[$28] <> $1k[$29]) And($1k[$29] <> $1k[$2a]) And($1k[$2a] <> $1k[$2b]) And($1k[$2b] <> $1k[$2c])) Then
Local $2g = $1k[$29]
Local $2h = $1k[$2b]
$1k[$29] = $1k[$1x]
$1k[$2b] = $1k[$1y]
Do
$2e += 1
Until $1k[$2e] >= $2g
Do
$2f -= 1
Until $1k[$2f] <= $2h
$21 = $2e
While $21 <= $2f
$23 = $1k[$21]
If $23 < $2g Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $23
$2e += 1
ElseIf $23 > $2h Then
While $1k[$2f] > $2h
$2f -= 1
If $2f + 1 = $21 Then ExitLoop 2
WEnd
If $1k[$2f] < $2g Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $1k[$2f]
$2e += 1
Else
$1k[$21] = $1k[$2f]
EndIf
$1k[$2f] = $23
$2f -= 1
EndIf
$21 += 1
WEnd
$1k[$1x] = $1k[$2e - 1]
$1k[$2e - 1] = $2g
$1k[$1y] = $1k[$2f + 1]
$1k[$2f + 1] = $2h
_73($1k, $1x, $2e - 2, True)
_73($1k, $2f + 2, $1y, False)
If($2e < $28) And($2c < $2f) Then
While $1k[$2e] = $2g
$2e += 1
WEnd
While $1k[$2f] = $2h
$2f -= 1
WEnd
$21 = $2e
While $21 <= $2f
$23 = $1k[$21]
If $23 = $2g Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $23
$2e += 1
ElseIf $23 = $2h Then
While $1k[$2f] = $2h
$2f -= 1
If $2f + 1 = $21 Then ExitLoop 2
WEnd
If $1k[$2f] = $2g Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $2g
$2e += 1
Else
$1k[$21] = $1k[$2f]
EndIf
$1k[$2f] = $23
$2f -= 1
EndIf
$21 += 1
WEnd
EndIf
_73($1k, $2e, $2f, False)
Else
Local $2i = $1k[$2a]
$21 = $2e
While $21 <= $2f
If $1k[$21] = $2i Then
$21 += 1
ContinueLoop
EndIf
$23 = $1k[$21]
If $23 < $2i Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $23
$2e += 1
Else
While $1k[$2f] > $2i
$2f -= 1
WEnd
If $1k[$2f] < $2i Then
$1k[$21] = $1k[$2e]
$1k[$2e] = $1k[$2f]
$2e += 1
Else
$1k[$21] = $2i
EndIf
$1k[$2f] = $23
$2f -= 1
EndIf
$21 += 1
WEnd
_73($1k, $1x, $2e - 1, True)
_73($1k, $2f + 1, $1y, False)
EndIf
EndFunc
Func _7m($2j, $2k = "*", $2l = $5, $2m = $9, $2n = $a, $2o = $c)
If Not FileExists($2j) Then Return SetError(1, 1, "")
If $2k = Default Then $2k = "*"
If $2l = Default Then $2l = $5
If $2m = Default Then $2m = $9
If $2n = Default Then $2n = $a
If $2o = Default Then $2o = $c
If $2m > 1 Or Not IsInt($2m) Then Return SetError(1, 6, "")
Local $2p = False
If StringLeft($2j, 4) == "\\?\" Then
$2p = True
EndIf
Local $2q = ""
If StringRight($2j, 1) = "\" Then
$2q = "\"
Else
$2j = $2j & "\"
EndIf
Local $2r[100] = [1]
$2r[1] = $2j
Local $2s = 0, $2t = ""
If BitAND($2l, $6) Then
$2s += 2
$2t &= "H"
$2l -= $6
EndIf
If BitAND($2l, $7) Then
$2s += 4
$2t &= "S"
$2l -= $7
EndIf
Local $2u = 0
If BitAND($2l, $8) Then
$2u = 0x400
$2l -= $8
EndIf
Local $2v = 0
If $2m < 0 Then
StringReplace($2j, "\", "", 0, $e)
$2v = @extended - $2m
EndIf
Local $2w = "", $2x = "", $2y = "*"
Local $2z = StringSplit($2k, "|")
Switch $2z[0]
Case 3
$2x = $2z[3]
ContinueCase
Case 2
$2w = $2z[2]
ContinueCase
Case 1
$2y = $2z[1]
EndSwitch
Local $30 = ".+"
If $2y <> "*" Then
If Not _7p($30, $2y) Then Return SetError(1, 2, "")
EndIf
Local $31 = ".+"
Switch $2l
Case 0
Switch $2m
Case 0
$31 = $30
EndSwitch
Case 2
$31 = $30
EndSwitch
Local $32 = ":"
If $2w <> "" Then
If Not _7p($32, $2w) Then Return SetError(1, 3, "")
EndIf
Local $33 = ":"
If $2m Then
If $2x Then
If Not _7p($33, $2x) Then Return SetError(1, 4, "")
EndIf
If $2l = 2 Then
$33 = $32
EndIf
Else
$33 = $32
EndIf
If Not($2l = 0 Or $2l = 1 Or $2l = 2) Then Return SetError(1, 5, "")
If Not($2n = 0 Or $2n = 1 Or $2n = 2) Then Return SetError(1, 7, "")
If Not($2o = 0 Or $2o = 1 Or $2o = 2) Then Return SetError(1, 8, "")
If $2u Then
Local $34 = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $35 = DllOpen('kernel32.dll'), $36
EndIf
Local $37[100] = [0]
Local $38 = $37, $39 = $37, $3a = $37
Local $3b = False, $3c = 0, $3d = "", $3e = "", $3f = ""
Local $3g = 0, $3h = ''
Local $3i[100][2] = [[0, 0]]
While $2r[0] > 0
$3d = $2r[$2r[0]]
$2r[0] -= 1
Switch $2o
Case 1
$3f = StringReplace($3d, $2j, "")
Case 2
If $2p Then
$3f = StringTrimLeft($3d, 4)
Else
$3f = $3d
EndIf
EndSwitch
If $2u Then
$36 = DllCall($35, 'handle', 'FindFirstFileW', 'wstr', $3d & "*", 'struct*', $34)
If @error Or Not $36[0] Then
ContinueLoop
EndIf
$3c = $36[0]
Else
$3c = FileFindFirstFile($3d & "*")
If $3c = -1 Then
ContinueLoop
EndIf
EndIf
If $2l = 0 And $2n And $2o Then
_7o($3i, $3f, $38[0] + 1)
EndIf
$3h = ''
While 1
If $2u Then
$36 = DllCall($35, 'int', 'FindNextFileW', 'handle', $3c, 'struct*', $34)
If @error Or Not $36[0] Then
ExitLoop
EndIf
$3e = DllStructGetData($34, "FileName")
If $3e = ".." Then
ContinueLoop
EndIf
$3g = DllStructGetData($34, "FileAttributes")
If $2s And BitAND($3g, $2s) Then
ContinueLoop
EndIf
If BitAND($3g, $2u) Then
ContinueLoop
EndIf
$3b = False
If BitAND($3g, 16) Then
$3b = True
EndIf
Else
$3b = False
$3e = FileFindNextFile($3c, 1)
If @error Then
ExitLoop
EndIf
$3h = @extended
If StringInStr($3h, "D") Then
$3b = True
EndIf
If StringRegExp($3h, "[" & $2t & "]") Then
ContinueLoop
EndIf
EndIf
If $3b Then
Select
Case $2m < 0
StringReplace($3d, "\", "", 0, $e)
If @extended < $2v Then
ContinueCase
EndIf
Case $2m = 1
If Not StringRegExp($3e, $33) Then
_7o($2r, $3d & $3e & "\")
EndIf
EndSelect
EndIf
If $2n Then
If $3b Then
If StringRegExp($3e, $31) And Not StringRegExp($3e, $33) Then
_7o($3a, $3f & $3e & $2q)
EndIf
Else
If StringRegExp($3e, $30) And Not StringRegExp($3e, $32) Then
If $3d = $2j Then
_7o($39, $3f & $3e)
Else
_7o($38, $3f & $3e)
EndIf
EndIf
EndIf
Else
If $3b Then
If $2l <> 1 And StringRegExp($3e, $31) And Not StringRegExp($3e, $33) Then
_7o($37, $3f & $3e & $2q)
EndIf
Else
If $2l <> 2 And StringRegExp($3e, $30) And Not StringRegExp($3e, $32) Then
_7o($37, $3f & $3e)
EndIf
EndIf
EndIf
WEnd
If $2u Then
DllCall($35, 'int', 'FindClose', 'ptr', $3c)
Else
FileClose($3c)
EndIf
WEnd
If $2u Then
DllClose($35)
EndIf
If $2n Then
Switch $2l
Case 2
If $3a[0] = 0 Then Return SetError(1, 9, "")
ReDim $3a[$3a[0] + 1]
$37 = $3a
_73($37, 1, $37[0])
Case 1
If $39[0] = 0 And $38[0] = 0 Then Return SetError(1, 9, "")
If $2o = 0 Then
_7n($37, $39, $38)
_73($37, 1, $37[0])
Else
_7n($37, $39, $38, 1)
EndIf
Case 0
If $39[0] = 0 And $3a[0] = 0 Then Return SetError(1, 9, "")
If $2o = 0 Then
_7n($37, $39, $38)
$37[0] += $3a[0]
ReDim $3a[$3a[0] + 1]
_6k($37, $3a, 1)
_73($37, 1, $37[0])
Else
Local $37[$38[0] + $39[0] + $3a[0] + 1]
$37[0] = $38[0] + $39[0] + $3a[0]
_73($39, 1, $39[0])
For $1h = 1 To $39[0]
$37[$1h] = $39[$1h]
Next
Local $3j = $39[0] + 1
_73($3a, 1, $3a[0])
Local $3k = ""
For $1h = 1 To $3a[0]
$37[$3j] = $3a[$1h]
$3j += 1
If $2q Then
$3k = $3a[$1h]
Else
$3k = $3a[$1h] & "\"
EndIf
Local $3l = 0, $3m = 0
For $1j = 1 To $3i[0][0]
If $3k = $3i[$1j][0] Then
$3m = $3i[$1j][1]
If $1j = $3i[0][0] Then
$3l = $38[0]
Else
$3l = $3i[$1j + 1][1] - 1
EndIf
If $2n = 1 Then
_73($38, $3m, $3l)
EndIf
For $21 = $3m To $3l
$37[$3j] = $38[$21]
$3j += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $37[0] = 0 Then Return SetError(1, 9, "")
ReDim $37[$37[0] + 1]
EndIf
Return $37
EndFunc
Func _7n(ByRef $3n, $3o, $3p, $2n = 0)
ReDim $3o[$3o[0] + 1]
If $2n = 1 Then _73($3o, 1, $3o[0])
$3n = $3o
$3n[0] += $3p[0]
ReDim $3p[$3p[0] + 1]
If $2n = 1 Then _73($3p, 1, $3p[0])
_6k($3n, $3p, 1)
EndFunc
Func _7o(ByRef $3q, $3r, $3s = -1)
If $3s = -1 Then
$3q[0] += 1
If UBound($3q) <= $3q[0] Then ReDim $3q[UBound($3q) * 2]
$3q[$3q[0]] = $3r
Else
$3q[0][0] += 1
If UBound($3q) <= $3q[0][0] Then ReDim $3q[UBound($3q) * 2][2]
$3q[$3q[0][0]][0] = $3r
$3q[$3q[0][0]][1] = $3s
EndIf
EndFunc
Func _7p(ByRef $2k, $3t)
If StringRegExp($3t, "\\|/|:|\<|\>|\|") Then Return 0
$3t = StringReplace(StringStripWS(StringRegExpReplace($3t, "\s*;\s*", ";"), BitOR($f, $g)), ";", "|")
$3t = StringReplace(StringReplace(StringRegExpReplace($3t, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$2k = "(?i)^(" & $3t & ")\z"
Return 1
EndFunc
OnAutoItExitRegister("_82")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Func _81()
Local Const $3u = 183
Local Const $3v = 5
Local Const $3w = "WsssM"
Local $3x = 0
_3z($3w & "_MUTEX", True, 0)
$3x = _3()
Return $3x == $3u Or $3x == $3v
EndFunc
If _81() Then
Exit
EndIf
Opt("SendKeyDownDelay", 100)
Local Const $3y = 1000 * 30
Local Const $3z = 1000 * 10
Local Const $40 = 50
Local Const $41 = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $42 = $41 & " /record"
Local Const $43 = $41 & " /stop"
Local Const $44 = $41 & " /nosplash"
Local Const $45 = "[CLASS:Bandicam2.x]"
Local $46 = 107374182400
Local $47 = Null
Local $48 = Null
Local $49 = Null
Local $4a = Null
Local $4b = Null
Local $4c = False
Local $4d = False
Local $4e = Null
Local $4f = 540000
Local $4g = True
Local $4h = True
Local $4i = False
Local $4j = 20
Local $4k[1] = [0]
Local $4l = Null
Local $4m = False
Local $4n = Null
Local $4o = Null
Local $4p = Null
Local $4q = 0
Local $4r = 3000
Local $4s = Null
Local $4t = 0
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$4c = True
$46 = 16106127360
EndIf
If UBound($cmdline) > 1 Then
For $1h = 1 To UBound($cmdline) - 1
Local $4u = StringSplit($cmdline[$1h], "=", $h)
Local $4v = StringUpper($4u[0])
Local $4w = Number($4u[1])
If $4v = "HIDESYSTRAY" Then
If $4w = 0 Then
$4h = False
Else
$4h = True
EndIf
ElseIf $4v = "KEYPRESS" Then
Opt("SendKeyDownDelay", $4w)
ElseIf $4v = "MAXATTEMPT" Then
$4j = $4w
ElseIf $4v = "USERACTIVITY" Then
If $4w = 0 Then
$4i = False
Else
$4i = True
EndIf
EndIf
Next
EndIf
Func _82()
Dim $47
Dim $48
Dim $49
If $47 <> Null Then
DllClose($47)
$47 = Null
EndIf
If $48 <> Null Then
DllClose($48)
$48 = Null
EndIf
If $49 <> Null Then
DllClose($49)
$49 = Null
EndIf
EndFunc
Func _83()
If $47 = Null Then
$47 = DllOpen('user32.dll')
EndIf
Return $47
EndFunc
Func _84()
If $48 = Null Then
$48 = DllOpen('kernel32.dll')
EndIf
Return $48
EndFunc
Func _85()
If $49 = Null Then
$49 = DllOpen('shell32.dll')
EndIf
Return $49
EndFunc
Func _86($4x = 1)
Local Const $4y = 1048
Local $10 = _8b($4x)
If $10 = -1 Then Return -1
Local $4z = _83()
Local $50 = DllCall($4z, "lresult", "SendMessageW", "hwnd", $10, "uint", $4y, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $50[0]
EndFunc
Func _87($4x = 1)
Local $50 = _86($4x)
If $50 <= 0 Then Return -1
Local $51[$50]
For $1h = 0 To $50 - 1
$51[$1h] = WinGetTitle(_89($1h, $4x))
Next
Return $51
EndFunc
Func _88($14, $4x = 1, $52 = 1)
Local Const $53 = 1047
Local Const $54 = 1053
Local $4z = _83()
Local $55 = _84()
Local Const $56 = BitOR(0x0008, 0x0010, 0x0400)
Local $57
If @OSArch = "X86" Then
$57 = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$57 = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $58
If @OSArch = "X86" Then
$58 = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$58 = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $59 = _8b($4x)
If $59 = -1 Then Return SetError(1, 0, -1)
Local $5a, $5b = 0
Local $5c = DllCall($4z, "dword", "GetWindowThreadProcessId", "hwnd", $59, "dword*", 0)
If @error Or Not $5c[2] Then SetError(2, 0, -1)
Local $5d = $5c[2]
Local $5e = DllCall($55, "handle", "OpenProcess", "dword", $56, "bool", False, "dword", $5d)
If @error Or Not $5e[0] Then Return SetError(3, 0, -1)
Local $5f = DllCall($55, "ptr", "VirtualAllocEx", "handle", $5e[0], "ptr", 0, "ulong", DllStructGetSize($57), "dword", 0x1000, "dword", 0x04)
If Not @error And $5f[0] Then
$5c = DllCall($4z, "lresult", "SendMessageW", "hwnd", $59, "uint", $53, "wparam", $14, "lparam", $5f[0])
If Not @error And $5c[0] Then
DllCall($55, "bool", "ReadProcessMemory", "handle", $5e[0], "ptr", $5f[0], "struct*", $57, "ulong", DllStructGetSize($57), "ulong*", 0)
Switch $52
Case 2
DllCall($55, "bool", "ReadProcessMemory", "handle", $5e[0], "ptr", DllStructGetData($57, 6), "struct*", $58, "ulong", DllStructGetSize($58), "ulong*", 0)
$5a = $58
Case 3
$5a = ""
If BitShift(DllStructGetData($57, 7), 16) <> 0 Then
Local $5g = DllStructCreate("wchar[1024]")
DllCall($55, "bool", "ReadProcessMemory", "handle", $5e[0], "ptr", DllStructGetData($57, 7), "struct*", $5g, "ulong", DllStructGetSize($5g), "ulong*", 0)
$5a = DllStructGetData($5g, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($57, 3), 8) Then
Local $5h[2], $5i = DllStructCreate("int;int;int;int")
DllCall($4z, "lresult", "SendMessageW", "hwnd", $59, "uint", $54, "wparam", $14, "lparam", $5f[0])
DllCall($55, "bool", "ReadProcessMemory", "handle", $5e[0], "ptr", $5f[0], "struct*", $5i, "ulong", DllStructGetSize($5i), "ulong*", 0)
$5c = DllCall($4z, "int", "MapWindowPoints", "hwnd", $59, "ptr", 0, "struct*", $5i, "uint", 2)
$5h[0] = DllStructGetData($5i, 1)
$5h[1] = DllStructGetData($5i, 2)
$5a = $5h
Else
$5a = -1
EndIf
Case Else
$5a = $57
EndSwitch
Else
$5b = 5
EndIf
DllCall($55, "bool", "VirtualFreeEx", "handle", $5e[0], "ptr", $5f[0], "ulong", 0, "dword", 0x8000)
Else
$5b = 4
EndIf
DllCall($55, "bool", "CloseHandle", "handle", $5e[0])
If $5b Then
Return SetError($5b, 0, -1)
Else
Return $5a
EndIf
EndFunc
Func _89($14, $4x = 1)
Local $58 = _88($14, $4x, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($58, 1))
EndIf
EndFunc
Func _8a($5j, $4x = 1)
Local $4z = _83()
Local $5k = _85()
Local $58 = _88($5j, $4x, 2)
If @error Then Return SetError(@error, 0, -1)
Local $5l = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($5l, 1, DllStructGetSize($5l))
DllStructSetData($5l, 2, Ptr(DllStructGetData($58, 1)))
DllStructSetData($5l, 3, DllStructGetData($58, 2))
Local $5c = DllCall($5k, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $5l)
DllCall($4z, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($5c) And $5c[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _8b($4x = 1)
Local $10, $5c = -1
Local $4z = _83()
If $4x = 1 Then
$10 = DllCall($4z, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$10 = DllCall($4z, "hwnd", "FindWindowEx", "hwnd", $10[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$10 = DllCall($4z, "hwnd", "FindWindowEx", "hwnd", $10[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$10 = DllCall($4z, "hwnd", "FindWindowEx", "hwnd", $10[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$5c = $10[0]
ElseIf $4x = 2 Then
$10 = DllCall($4z, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$10 = DllCall($4z, "hwnd", "FindWindowEx", "hwnd", $10[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$5c = $10[0]
EndIf
Return $5c
EndFunc
Local $5m = ""
If @OSArch = "X64" Then $5m = "64"
Local $5n = "HKCU" & $5m & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($5n, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($5n, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($5n, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($5n, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($5n, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($5n, "bStartMinimized", "REG_DWORD", 1)
RegWrite($5n, "nTargetMode", "REG_DWORD", 1)
RegWrite($5n, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($5n, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($5n, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($5n, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $4c = True Then
RegWrite($5n, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($5n, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
$4e = RegRead($5n, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($4e) Then $4e = Null
Func _8c()
If Not $4e Then Return
Local $5o = DirGetSize($4e)
If $5o < $46 Then Return
Local $5p = _7m($4e, "*.avi;*.mp4;*.bfix", $4, $9, $b, $d)
If @error = 1 Or $5p = "" Or UBound($5p) < 2 Then Return
For $1h = 1 To UBound($5p) - 1
Local $5q = FileGetSize($5p[$1h])
FileDelete($5p[$1h])
$5o = $5o - $5q
If $5o < $46 Then ExitLoop
Next
EndFunc
Func _8d()
If $4h = False Then Return
Local $4x = 1
If $4c = False Then $4x = 2
Local $5r = _87($4x)
For $1h = 0 To UBound($5r) - 1
If StringRegExp($5r[$1h], "(?i).*Bandicam.*") Then
_8a($1h, $4x)
EndIf
Next
EndFunc
Func _8e()
$4m = False
$4n = Null
$4o = Null
$4a = Null
$4b = Null
EndFunc
Func _8f()
$4a = Null
If $4m = True Then Return
$4m = True
If $4c = False Then
Run($42)
Else
Send("^!+9")
EndIf
If $4g = False Then
$4b = TimerInit()
EndIf
_8d()
EndFunc
Func _8g()
If $4m = False Then Return
$4m = False
$4a = Null
$4b = Null
If $4c = False Then
Run($43)
Else
Send("^!+9")
$4d = True
EndIf
_8d()
_8c()
EndFunc
Func _8h($5s)
If _6y($4k, $5s, 1) = -1 Then
Local $14 = $4k[0] + 1
ReDim $4k[$14 + 1]
$4k[$14] = $5s
$4k[0] = $14
EndIf
EndFunc
Func _8i($5t)
Local $3q = WinList()
For $1h = 1 To $3q[0][0]
If $3q[$1h][0] = "" And BitAND(WinGetState($3q[$1h][1]), $3) Then
Local $5u = $3q[$1h][1]
Local $5v = $3q[$1h][0]
Local $5w = WinGetPos($5u)
Local $5x = $5w[0]
Local $5y = $5w[1]
Local $5z = $5w[2]
Local $60 = $5w[3]
If $5y > -50 And $5y < 20 And $60 > 0 And $60 < 80 And $5z > 0 And $5x > -80 And $5v = "" Then
_8h($5u)
EndIf
EndIf
Next
If UBound($4k) < 2 Then
Local $61 = $5t + 1
If $4j = -1 Or $61 < $4j Then
Sleep(2000)
_8i($61)
EndIf
EndIf
EndFunc
Func _8j()
WinSetState($4l, "", @SW_HIDE)
If UBound($4k) = 1 Then Return
For $1h = 1 To $4k[0]
WinSetState($4k[$1h], "", @SW_HIDE)
Next
EndFunc
Func _8k()
If Not ProcessExists("bdcam.exe") Then
Run($44)
WinWait($45)
$4l = WinGetHandle($45)
WinSetState($4l, "", @SW_HIDE)
Local $62[1] = [0]
$4k = $62
Sleep(2500)
_8e()
_8i(1)
_8j()
EndIf
_8d()
EndFunc
Func _8l()
Local $4z = _83()
Local $63 = 0
Local $64 = MouseGetPos()
If $64[0] <> $4n Or $64[1] <> $4o Then
$63 = 1
EndIf
$4n = $64[0]
$4o = $64[1]
If $63 <> 0 Then Return $63
If $4d = True Then
$4d = False
Return 0
EndIf
For $1h = 1 To 221
If _5w(Hex($1h), $4z) Then
Return $1h
EndIf
Next
Return 0
EndFunc
Func _8m()
$4p = Null
$4q = 0
EndFunc
Func _8n($4w)
If $4i = False Then
Return $4w <> 0
EndIf
If $4t = 1 Then
$4t = 2
$4r = TimerDiff($4s) + 1000
$4s = Null
EndIf
If $4t = 0 Then
$4t = 1
$4s = TimerInit()
EndIf
If $4m = True Then
_8m()
Return False
EndIf
If $4w > 1 Then
_8m()
Return True
EndIf
Local $65 = 0
$4q = $4q + $4w
If $4p = Null Then
$4p = TimerInit()
Return False
Else
$65 = TimerDiff($4p)
EndIf
If $65 < $4r Then
Return False
EndIf
Local $1v = $4q
_8m()
If $1v > 1 Then
Return True
EndIf
Return False
EndFunc
Func _8o()
If $4m = False Then
Return False
EndIf
If $4a = Null Then
$4a = TimerInit()
Return False
EndIf
Local $65 = TimerDiff($4a)
Return $65 > $3y
EndFunc
Func _8p()
If $4m = False Then
Return False
EndIf
If $4b = Null Then
Return False
EndIf
Local $65 = TimerDiff($4b)
Return $65 > $4f
EndFunc
If ProcessExists("bdcam.exe") Then
_8d()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_8c()
_8k()
Sleep($3z)
Local $66 = 0
Local $64 = MouseGetPos()
$4n = $64[0]
$4o = $64[1]
While True
Sleep($40)
Local $67 = _8l()
If _8n($67) Then
_8f()
ElseIf _8o() Then
_8g()
EndIf
If $4g = False And _8p() Then
_8g()
Sleep(1000)
_8f()
EndIf
$66 = $66 + $40
If $66 > 5000 Then
$66 = 0
_8k()
EndIf
_8j()
WEnd
