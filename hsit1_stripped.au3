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
Func _3(Const $h = @error, Const $i = @extended)
Local $j = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($h, $i, $j[0])
EndFunc
Global Const $k = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $l = _1g()
Func _1g()
Local $m = DllStructCreate($k)
DllStructSetData($m, 1, DllStructGetSize($m))
Local $n = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $m)
If @error Or Not $n[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($m, 2), -8), DllStructGetData($m, 3))
EndFunc
Func _3z($o, $p = True, $q = 0)
Local $n = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $q, 'bool', $p, 'wstr', $o)
If @error Then Return SetError(@error, @extended, 0)
Return $n[0]
EndFunc
Func _5w($r, $s = "user32.dll")
Local $t = DllCall($s, "short", "GetAsyncKeyState", "int", "0x" & $r)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($t[0], 0x8000) <> 0
EndFunc
Global Const $u = 11
Global $v[$u]
Global Const $w = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($x, $y, $0z)
If $v[3] = $v[4] Then
If Not $v[7] Then
$v[5] *= -1
$v[7] = 1
EndIf
Else
$v[7] = 1
EndIf
$v[6] = $v[3]
Local $10 = _6b($0z, $x, $v[3])
Local $11 = _6b($0z, $y, $v[3])
If $v[8] = 1 Then
If(StringIsFloat($10) Or StringIsInt($10)) Then $10 = Number($10)
If(StringIsFloat($11) Or StringIsInt($11)) Then $11 = Number($11)
EndIf
Local $12
If $v[8] < 2 Then
$12 = 0
If $10 < $11 Then
$12 = -1
ElseIf $10 > $11 Then
$12 = 1
EndIf
Else
$12 = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $10, 'wstr', $11)[0]
EndIf
$12 = $12 * $v[5]
Return $12
EndFunc
Func _6b($0z, $13, $14 = 0)
Local $15 = DllStructCreate("wchar Text[4096]")
Local $16 = DllStructGetPtr($15)
Local $17 = DllStructCreate($w)
DllStructSetData($17, "SubItem", $14)
DllStructSetData($17, "TextMax", 4096)
DllStructSetData($17, "Text", $16)
If IsHWnd($0z) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $0z, "uint", 0x1073, "wparam", $13, "struct*", $17)
Else
Local $18 = DllStructGetPtr($17)
GUICtrlSendMsg($0z, 0x1073, $13, $18)
EndIf
Return DllStructGetData($15, "Text")
EndFunc
Func _6k(ByRef $19, Const ByRef $1a, $1b = 0)
If $1b = Default Then $1b = 0
If Not IsArray($19) Then Return SetError(1, 0, -1)
If Not IsArray($1a) Then Return SetError(2, 0, -1)
Local $1c = UBound($19, $0)
Local $1d = UBound($1a, $0)
Local $1e = UBound($19, $1)
Local $1f = UBound($1a, $1)
If $1b < 0 Or $1b > $1f - 1 Then Return SetError(6, 0, -1)
Switch $1c
Case 1
If $1d <> 1 Then Return SetError(4, 0, -1)
ReDim $19[$1e + $1f - $1b]
For $1g = $1b To $1f - 1
$19[$1e + $1g - $1b] = $1a[$1g]
Next
Case 2
If $1d <> 2 Then Return SetError(4, 0, -1)
Local $1h = UBound($19, $2)
If UBound($1a, $2) <> $1h Then Return SetError(5, 0, -1)
ReDim $19[$1e + $1f - $1b][$1h]
For $1g = $1b To $1f - 1
For $1i = 0 To $1h - 1
$19[$1e + $1g - $1b][$1i] = $1a[$1g][$1i]
Next
Next
Case Else
Return SetError(3, 0, -1)
EndSwitch
Return UBound($19, $1)
EndFunc
Func _6y(Const ByRef $1j, $1k, $1b = 0, $1l = 0, $1m = 0, $1n = 0, $1o = 1, $14 = -1, $1p = False)
If $1b = Default Then $1b = 0
If $1l = Default Then $1l = 0
If $1m = Default Then $1m = 0
If $1n = Default Then $1n = 0
If $1o = Default Then $1o = 1
If $14 = Default Then $14 = -1
If $1p = Default Then $1p = False
If Not IsArray($1j) Then Return SetError(1, 0, -1)
Local $1q = UBound($1j) - 1
If $1q = -1 Then Return SetError(3, 0, -1)
Local $1r = UBound($1j, $2) - 1
Local $1s = False
If $1n = 2 Then
$1n = 0
$1s = True
EndIf
If $1p Then
If UBound($1j, $0) = 1 Then Return SetError(5, 0, -1)
If $1l < 1 Or $1l > $1r Then $1l = $1r
If $1b < 0 Then $1b = 0
If $1b > $1l Then Return SetError(4, 0, -1)
Else
If $1l < 1 Or $1l > $1q Then $1l = $1q
If $1b < 0 Then $1b = 0
If $1b > $1l Then Return SetError(4, 0, -1)
EndIf
Local $1t = 1
If Not $1o Then
Local $1u = $1b
$1b = $1l
$1l = $1u
$1t = -1
EndIf
Switch UBound($1j, $0)
Case 1
If Not $1n Then
If Not $1m Then
For $1g = $1b To $1l Step $1t
If $1s And VarGetType($1j[$1g]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1g] = $1k Then Return $1g
Next
Else
For $1g = $1b To $1l Step $1t
If $1s And VarGetType($1j[$1g]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1g] == $1k Then Return $1g
Next
EndIf
Else
For $1g = $1b To $1l Step $1t
If $1n = 3 Then
If StringRegExp($1j[$1g], $1k) Then Return $1g
Else
If StringInStr($1j[$1g], $1k, $1m) > 0 Then Return $1g
EndIf
Next
EndIf
Case 2
Local $1v
If $1p Then
$1v = $1q
If $14 > $1v Then $14 = $1v
If $14 < 0 Then
$14 = 0
Else
$1v = $14
EndIf
Else
$1v = $1r
If $14 > $1v Then $14 = $1v
If $14 < 0 Then
$14 = 0
Else
$1v = $14
EndIf
EndIf
For $1i = $14 To $1v
If Not $1n Then
If Not $1m Then
For $1g = $1b To $1l Step $1t
If $1p Then
If $1s And VarGetType($1j[$1i][$1g]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1i][$1g] = $1k Then Return $1g
Else
If $1s And VarGetType($1j[$1g][$1i]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1g][$1i] = $1k Then Return $1g
EndIf
Next
Else
For $1g = $1b To $1l Step $1t
If $1p Then
If $1s And VarGetType($1j[$1i][$1g]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1i][$1g] == $1k Then Return $1g
Else
If $1s And VarGetType($1j[$1g][$1i]) <> VarGetType($1k) Then ContinueLoop
If $1j[$1g][$1i] == $1k Then Return $1g
EndIf
Next
EndIf
Else
For $1g = $1b To $1l Step $1t
If $1n = 3 Then
If $1p Then
If StringRegExp($1j[$1i][$1g], $1k) Then Return $1g
Else
If StringRegExp($1j[$1g][$1i], $1k) Then Return $1g
EndIf
Else
If $1p Then
If StringInStr($1j[$1i][$1g], $1k, $1m) > 0 Then Return $1g
Else
If StringInStr($1j[$1g][$1i], $1k, $1m) > 0 Then Return $1g
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
Func _73(ByRef $1j, $1w, $1x, $1y = True)
If $1w > $1x Then Return
Local $1z = $1x - $1w + 1
Local $1g, $1i, $20, $21, $22, $23, $24, $25
If $1z < 45 Then
If $1y Then
$1g = $1w
While $1g < $1x
$1i = $1g
$21 = $1j[$1g + 1]
While $21 < $1j[$1i]
$1j[$1i + 1] = $1j[$1i]
$1i -= 1
If $1i + 1 = $1w Then ExitLoop
WEnd
$1j[$1i + 1] = $21
$1g += 1
WEnd
Else
While 1
If $1w >= $1x Then Return 1
$1w += 1
If $1j[$1w] < $1j[$1w - 1] Then ExitLoop
WEnd
While 1
$20 = $1w
$1w += 1
If $1w > $1x Then ExitLoop
$23 = $1j[$20]
$24 = $1j[$1w]
If $23 < $24 Then
$24 = $23
$23 = $1j[$1w]
EndIf
$20 -= 1
While $23 < $1j[$20]
$1j[$20 + 2] = $1j[$20]
$20 -= 1
WEnd
$1j[$20 + 2] = $23
While $24 < $1j[$20]
$1j[$20 + 1] = $1j[$20]
$20 -= 1
WEnd
$1j[$20 + 1] = $24
$1w += 1
WEnd
$25 = $1j[$1x]
$1x -= 1
While $25 < $1j[$1x]
$1j[$1x + 1] = $1j[$1x]
$1x -= 1
WEnd
$1j[$1x + 1] = $25
EndIf
Return 1
EndIf
Local $26 = BitShift($1z, 3) + BitShift($1z, 6) + 1
Local $27, $28, $29, $2a, $2b, $2c
$29 = Ceiling(($1w + $1x) / 2)
$28 = $29 - $26
$27 = $28 - $26
$2a = $29 + $26
$2b = $2a + $26
If $1j[$28] < $1j[$27] Then
$2c = $1j[$28]
$1j[$28] = $1j[$27]
$1j[$27] = $2c
EndIf
If $1j[$29] < $1j[$28] Then
$2c = $1j[$29]
$1j[$29] = $1j[$28]
$1j[$28] = $2c
If $2c < $1j[$27] Then
$1j[$28] = $1j[$27]
$1j[$27] = $2c
EndIf
EndIf
If $1j[$2a] < $1j[$29] Then
$2c = $1j[$2a]
$1j[$2a] = $1j[$29]
$1j[$29] = $2c
If $2c < $1j[$28] Then
$1j[$29] = $1j[$28]
$1j[$28] = $2c
If $2c < $1j[$27] Then
$1j[$28] = $1j[$27]
$1j[$27] = $2c
EndIf
EndIf
EndIf
If $1j[$2b] < $1j[$2a] Then
$2c = $1j[$2b]
$1j[$2b] = $1j[$2a]
$1j[$2a] = $2c
If $2c < $1j[$29] Then
$1j[$2a] = $1j[$29]
$1j[$29] = $2c
If $2c < $1j[$28] Then
$1j[$29] = $1j[$28]
$1j[$28] = $2c
If $2c < $1j[$27] Then
$1j[$28] = $1j[$27]
$1j[$27] = $2c
EndIf
EndIf
EndIf
EndIf
Local $2d = $1w
Local $2e = $1x
If(($1j[$27] <> $1j[$28]) And($1j[$28] <> $1j[$29]) And($1j[$29] <> $1j[$2a]) And($1j[$2a] <> $1j[$2b])) Then
Local $2f = $1j[$28]
Local $2g = $1j[$2a]
$1j[$28] = $1j[$1w]
$1j[$2a] = $1j[$1x]
Do
$2d += 1
Until $1j[$2d] >= $2f
Do
$2e -= 1
Until $1j[$2e] <= $2g
$20 = $2d
While $20 <= $2e
$22 = $1j[$20]
If $22 < $2f Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $22
$2d += 1
ElseIf $22 > $2g Then
While $1j[$2e] > $2g
$2e -= 1
If $2e + 1 = $20 Then ExitLoop 2
WEnd
If $1j[$2e] < $2f Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $1j[$2e]
$2d += 1
Else
$1j[$20] = $1j[$2e]
EndIf
$1j[$2e] = $22
$2e -= 1
EndIf
$20 += 1
WEnd
$1j[$1w] = $1j[$2d - 1]
$1j[$2d - 1] = $2f
$1j[$1x] = $1j[$2e + 1]
$1j[$2e + 1] = $2g
_73($1j, $1w, $2d - 2, True)
_73($1j, $2e + 2, $1x, False)
If($2d < $27) And($2b < $2e) Then
While $1j[$2d] = $2f
$2d += 1
WEnd
While $1j[$2e] = $2g
$2e -= 1
WEnd
$20 = $2d
While $20 <= $2e
$22 = $1j[$20]
If $22 = $2f Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $22
$2d += 1
ElseIf $22 = $2g Then
While $1j[$2e] = $2g
$2e -= 1
If $2e + 1 = $20 Then ExitLoop 2
WEnd
If $1j[$2e] = $2f Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $2f
$2d += 1
Else
$1j[$20] = $1j[$2e]
EndIf
$1j[$2e] = $22
$2e -= 1
EndIf
$20 += 1
WEnd
EndIf
_73($1j, $2d, $2e, False)
Else
Local $2h = $1j[$29]
$20 = $2d
While $20 <= $2e
If $1j[$20] = $2h Then
$20 += 1
ContinueLoop
EndIf
$22 = $1j[$20]
If $22 < $2h Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $22
$2d += 1
Else
While $1j[$2e] > $2h
$2e -= 1
WEnd
If $1j[$2e] < $2h Then
$1j[$20] = $1j[$2d]
$1j[$2d] = $1j[$2e]
$2d += 1
Else
$1j[$20] = $2h
EndIf
$1j[$2e] = $22
$2e -= 1
EndIf
$20 += 1
WEnd
_73($1j, $1w, $2d - 1, True)
_73($1j, $2e + 1, $1x, False)
EndIf
EndFunc
Func _7m($2i, $2j = "*", $2k = $5, $2l = $9, $2m = $a, $2n = $c)
If Not FileExists($2i) Then Return SetError(1, 1, "")
If $2j = Default Then $2j = "*"
If $2k = Default Then $2k = $5
If $2l = Default Then $2l = $9
If $2m = Default Then $2m = $a
If $2n = Default Then $2n = $c
If $2l > 1 Or Not IsInt($2l) Then Return SetError(1, 6, "")
Local $2o = False
If StringLeft($2i, 4) == "\\?\" Then
$2o = True
EndIf
Local $2p = ""
If StringRight($2i, 1) = "\" Then
$2p = "\"
Else
$2i = $2i & "\"
EndIf
Local $2q[100] = [1]
$2q[1] = $2i
Local $2r = 0, $2s = ""
If BitAND($2k, $6) Then
$2r += 2
$2s &= "H"
$2k -= $6
EndIf
If BitAND($2k, $7) Then
$2r += 4
$2s &= "S"
$2k -= $7
EndIf
Local $2t = 0
If BitAND($2k, $8) Then
$2t = 0x400
$2k -= $8
EndIf
Local $2u = 0
If $2l < 0 Then
StringReplace($2i, "\", "", 0, $e)
$2u = @extended - $2l
EndIf
Local $2v = "", $2w = "", $2x = "*"
Local $2y = StringSplit($2j, "|")
Switch $2y[0]
Case 3
$2w = $2y[3]
ContinueCase
Case 2
$2v = $2y[2]
ContinueCase
Case 1
$2x = $2y[1]
EndSwitch
Local $2z = ".+"
If $2x <> "*" Then
If Not _7p($2z, $2x) Then Return SetError(1, 2, "")
EndIf
Local $30 = ".+"
Switch $2k
Case 0
Switch $2l
Case 0
$30 = $2z
EndSwitch
Case 2
$30 = $2z
EndSwitch
Local $31 = ":"
If $2v <> "" Then
If Not _7p($31, $2v) Then Return SetError(1, 3, "")
EndIf
Local $32 = ":"
If $2l Then
If $2w Then
If Not _7p($32, $2w) Then Return SetError(1, 4, "")
EndIf
If $2k = 2 Then
$32 = $31
EndIf
Else
$32 = $31
EndIf
If Not($2k = 0 Or $2k = 1 Or $2k = 2) Then Return SetError(1, 5, "")
If Not($2m = 0 Or $2m = 1 Or $2m = 2) Then Return SetError(1, 7, "")
If Not($2n = 0 Or $2n = 1 Or $2n = 2) Then Return SetError(1, 8, "")
If $2t Then
Local $33 = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $34 = DllOpen('kernel32.dll'), $35
EndIf
Local $36[100] = [0]
Local $37 = $36, $38 = $36, $39 = $36
Local $3a = False, $3b = 0, $3c = "", $3d = "", $3e = ""
Local $3f = 0, $3g = ''
Local $3h[100][2] = [[0, 0]]
While $2q[0] > 0
$3c = $2q[$2q[0]]
$2q[0] -= 1
Switch $2n
Case 1
$3e = StringReplace($3c, $2i, "")
Case 2
If $2o Then
$3e = StringTrimLeft($3c, 4)
Else
$3e = $3c
EndIf
EndSwitch
If $2t Then
$35 = DllCall($34, 'handle', 'FindFirstFileW', 'wstr', $3c & "*", 'struct*', $33)
If @error Or Not $35[0] Then
ContinueLoop
EndIf
$3b = $35[0]
Else
$3b = FileFindFirstFile($3c & "*")
If $3b = -1 Then
ContinueLoop
EndIf
EndIf
If $2k = 0 And $2m And $2n Then
_7o($3h, $3e, $37[0] + 1)
EndIf
$3g = ''
While 1
If $2t Then
$35 = DllCall($34, 'int', 'FindNextFileW', 'handle', $3b, 'struct*', $33)
If @error Or Not $35[0] Then
ExitLoop
EndIf
$3d = DllStructGetData($33, "FileName")
If $3d = ".." Then
ContinueLoop
EndIf
$3f = DllStructGetData($33, "FileAttributes")
If $2r And BitAND($3f, $2r) Then
ContinueLoop
EndIf
If BitAND($3f, $2t) Then
ContinueLoop
EndIf
$3a = False
If BitAND($3f, 16) Then
$3a = True
EndIf
Else
$3a = False
$3d = FileFindNextFile($3b, 1)
If @error Then
ExitLoop
EndIf
$3g = @extended
If StringInStr($3g, "D") Then
$3a = True
EndIf
If StringRegExp($3g, "[" & $2s & "]") Then
ContinueLoop
EndIf
EndIf
If $3a Then
Select
Case $2l < 0
StringReplace($3c, "\", "", 0, $e)
If @extended < $2u Then
ContinueCase
EndIf
Case $2l = 1
If Not StringRegExp($3d, $32) Then
_7o($2q, $3c & $3d & "\")
EndIf
EndSelect
EndIf
If $2m Then
If $3a Then
If StringRegExp($3d, $30) And Not StringRegExp($3d, $32) Then
_7o($39, $3e & $3d & $2p)
EndIf
Else
If StringRegExp($3d, $2z) And Not StringRegExp($3d, $31) Then
If $3c = $2i Then
_7o($38, $3e & $3d)
Else
_7o($37, $3e & $3d)
EndIf
EndIf
EndIf
Else
If $3a Then
If $2k <> 1 And StringRegExp($3d, $30) And Not StringRegExp($3d, $32) Then
_7o($36, $3e & $3d & $2p)
EndIf
Else
If $2k <> 2 And StringRegExp($3d, $2z) And Not StringRegExp($3d, $31) Then
_7o($36, $3e & $3d)
EndIf
EndIf
EndIf
WEnd
If $2t Then
DllCall($34, 'int', 'FindClose', 'ptr', $3b)
Else
FileClose($3b)
EndIf
WEnd
If $2t Then
DllClose($34)
EndIf
If $2m Then
Switch $2k
Case 2
If $39[0] = 0 Then Return SetError(1, 9, "")
ReDim $39[$39[0] + 1]
$36 = $39
_73($36, 1, $36[0])
Case 1
If $38[0] = 0 And $37[0] = 0 Then Return SetError(1, 9, "")
If $2n = 0 Then
_7n($36, $38, $37)
_73($36, 1, $36[0])
Else
_7n($36, $38, $37, 1)
EndIf
Case 0
If $38[0] = 0 And $39[0] = 0 Then Return SetError(1, 9, "")
If $2n = 0 Then
_7n($36, $38, $37)
$36[0] += $39[0]
ReDim $39[$39[0] + 1]
_6k($36, $39, 1)
_73($36, 1, $36[0])
Else
Local $36[$37[0] + $38[0] + $39[0] + 1]
$36[0] = $37[0] + $38[0] + $39[0]
_73($38, 1, $38[0])
For $1g = 1 To $38[0]
$36[$1g] = $38[$1g]
Next
Local $3i = $38[0] + 1
_73($39, 1, $39[0])
Local $3j = ""
For $1g = 1 To $39[0]
$36[$3i] = $39[$1g]
$3i += 1
If $2p Then
$3j = $39[$1g]
Else
$3j = $39[$1g] & "\"
EndIf
Local $3k = 0, $3l = 0
For $1i = 1 To $3h[0][0]
If $3j = $3h[$1i][0] Then
$3l = $3h[$1i][1]
If $1i = $3h[0][0] Then
$3k = $37[0]
Else
$3k = $3h[$1i + 1][1] - 1
EndIf
If $2m = 1 Then
_73($37, $3l, $3k)
EndIf
For $20 = $3l To $3k
$36[$3i] = $37[$20]
$3i += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $36[0] = 0 Then Return SetError(1, 9, "")
ReDim $36[$36[0] + 1]
EndIf
Return $36
EndFunc
Func _7n(ByRef $3m, $3n, $3o, $2m = 0)
ReDim $3n[$3n[0] + 1]
If $2m = 1 Then _73($3n, 1, $3n[0])
$3m = $3n
$3m[0] += $3o[0]
ReDim $3o[$3o[0] + 1]
If $2m = 1 Then _73($3o, 1, $3o[0])
_6k($3m, $3o, 1)
EndFunc
Func _7o(ByRef $3p, $3q, $3r = -1)
If $3r = -1 Then
$3p[0] += 1
If UBound($3p) <= $3p[0] Then ReDim $3p[UBound($3p) * 2]
$3p[$3p[0]] = $3q
Else
$3p[0][0] += 1
If UBound($3p) <= $3p[0][0] Then ReDim $3p[UBound($3p) * 2][2]
$3p[$3p[0][0]][0] = $3q
$3p[$3p[0][0]][1] = $3r
EndIf
EndFunc
Func _7p(ByRef $2j, $3s)
If StringRegExp($3s, "\\|/|:|\<|\>|\|") Then Return 0
$3s = StringReplace(StringStripWS(StringRegExpReplace($3s, "\s*;\s*", ";"), BitOR($f, $g)), ";", "|")
$3s = StringReplace(StringReplace(StringRegExpReplace($3s, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$2j = "(?i)^(" & $3s & ")\z"
Return 1
EndFunc
OnAutoItExitRegister("_81")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Opt("SendKeyDownDelay", 100)
Local Const $3t = 1000 * 30
Local Const $3u = 1000 * 10
Local Const $3v = 50
Local Const $3w = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $3x = $3w & " /record"
Local Const $3y = $3w & " /stop"
Local Const $3z = $3w & " /nosplash"
Local Const $40 = "WsssM"
Local Const $41 = "[CLASS:Bandicam2.x]"
Local $42[1] = [0]
Local Const $43 = 183
Local Const $44 = 5
Local $45 = 107374182400
Local $46 = Null
Local $47 = False
Local $48 = Null
Local $49 = Null
Local $4a = Null
Local $4b = Null
Local $4c = Null
Local $4d = Null
Local $4e = Null
Local $4f = False
Local $4g = False
Local $4h = Null
Local $4i = 540000
Local $4j = True
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$4f = True
$45 = 16106127360
EndIf
Func _81()
If $4a <> Null Then
DllClose($4a)
$4a = Null
EndIf
If $4b <> Null Then
DllClose($4b)
$4b = Null
EndIf
If $4c <> Null Then
DllClose($4c)
$4c = Null
EndIf
EndFunc
Func _82()
If $4a = Null Then
$4a = DllOpen('user32.dll')
EndIf
Return $4a
EndFunc
Func _83()
If $4b = Null Then
$4b = DllOpen('kernel32.dll')
EndIf
Return $4b
EndFunc
Func _84()
If $4c = Null Then
$4c = DllOpen('shell32.dll')
EndIf
Return $4c
EndFunc
Func _85()
Local $4k = 0
_3z($40 & "_MUTEX", True, 0)
$4k = _3()
Return $4k == $43 Or $4k == $44
EndFunc
If _85() Then
Exit
EndIf
Func _86($4l = 1)
Local Const $4m = 1048
Local $0z = _8b($4l)
If $0z = -1 Then Return -1
Local $4n = _82()
Local $4o = DllCall($4n, "lresult", "SendMessageW", "hwnd", $0z, "uint", $4m, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $4o[0]
EndFunc
Func _87($4l = 1)
Local $4o = _86($4l)
If $4o <= 0 Then Return -1
Local $4p[$4o]
For $1g = 0 To $4o - 1
$4p[$1g] = WinGetTitle(_89($1g, $4l))
Next
Return $4p
EndFunc
Func _88($13, $4l = 1, $4q = 1)
Local Const $4r = 1047
Local Const $4s = 1053
Local $4n = _82()
Local $4t = _83()
Local Const $4u = BitOR(0x0008, 0x0010, 0x0400)
Local $4v
If @OSArch = "X86" Then
$4v = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$4v = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $4w
If @OSArch = "X86" Then
$4w = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$4w = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $4x = _8b($4l)
If $4x = -1 Then Return SetError(1, 0, -1)
Local $4y, $4z = 0
Local $50 = DllCall($4n, "dword", "GetWindowThreadProcessId", "hwnd", $4x, "dword*", 0)
If @error Or Not $50[2] Then SetError(2, 0, -1)
Local $51 = $50[2]
Local $52 = DllCall($4t, "handle", "OpenProcess", "dword", $4u, "bool", False, "dword", $51)
If @error Or Not $52[0] Then Return SetError(3, 0, -1)
Local $53 = DllCall($4t, "ptr", "VirtualAllocEx", "handle", $52[0], "ptr", 0, "ulong", DllStructGetSize($4v), "dword", 0x1000, "dword", 0x04)
If Not @error And $53[0] Then
$50 = DllCall($4n, "lresult", "SendMessageW", "hwnd", $4x, "uint", $4r, "wparam", $13, "lparam", $53[0])
If Not @error And $50[0] Then
DllCall($4t, "bool", "ReadProcessMemory", "handle", $52[0], "ptr", $53[0], "struct*", $4v, "ulong", DllStructGetSize($4v), "ulong*", 0)
Switch $4q
Case 2
DllCall($4t, "bool", "ReadProcessMemory", "handle", $52[0], "ptr", DllStructGetData($4v, 6), "struct*", $4w, "ulong", DllStructGetSize($4w), "ulong*", 0)
$4y = $4w
Case 3
$4y = ""
If BitShift(DllStructGetData($4v, 7), 16) <> 0 Then
Local $54 = DllStructCreate("wchar[1024]")
DllCall($4t, "bool", "ReadProcessMemory", "handle", $52[0], "ptr", DllStructGetData($4v, 7), "struct*", $54, "ulong", DllStructGetSize($54), "ulong*", 0)
$4y = DllStructGetData($54, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($4v, 3), 8) Then
Local $55[2], $56 = DllStructCreate("int;int;int;int")
DllCall($4n, "lresult", "SendMessageW", "hwnd", $4x, "uint", $4s, "wparam", $13, "lparam", $53[0])
DllCall($4t, "bool", "ReadProcessMemory", "handle", $52[0], "ptr", $53[0], "struct*", $56, "ulong", DllStructGetSize($56), "ulong*", 0)
$50 = DllCall($4n, "int", "MapWindowPoints", "hwnd", $4x, "ptr", 0, "struct*", $56, "uint", 2)
$55[0] = DllStructGetData($56, 1)
$55[1] = DllStructGetData($56, 2)
$4y = $55
Else
$4y = -1
EndIf
Case Else
$4y = $4v
EndSwitch
Else
$4z = 5
EndIf
DllCall($4t, "bool", "VirtualFreeEx", "handle", $52[0], "ptr", $53[0], "ulong", 0, "dword", 0x8000)
Else
$4z = 4
EndIf
DllCall($4t, "bool", "CloseHandle", "handle", $52[0])
If $4z Then
Return SetError($4z, 0, -1)
Else
Return $4y
EndIf
EndFunc
Func _89($13, $4l = 1)
Local $4w = _88($13, $4l, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($4w, 1))
EndIf
EndFunc
Func _8a($57, $4l = 1)
Local $4n = _82()
Local $58 = _84()
Local $4w = _88($57, $4l, 2)
If @error Then Return SetError(@error, 0, -1)
Local $59 = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($59, 1, DllStructGetSize($59))
DllStructSetData($59, 2, Ptr(DllStructGetData($4w, 1)))
DllStructSetData($59, 3, DllStructGetData($4w, 2))
Local $50 = DllCall($58, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $59)
DllCall($4n, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($50) And $50[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _8b($4l = 1)
Local $0z, $50 = -1
Local $4n = _82()
If $4l = 1 Then
$0z = DllCall($4n, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$0z = DllCall($4n, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$0z = DllCall($4n, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$0z = DllCall($4n, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$50 = $0z[0]
ElseIf $4l = 2 Then
$0z = DllCall($4n, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$0z = DllCall($4n, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$50 = $0z[0]
EndIf
Return $50
EndFunc
Local $5a = ""
If @OSArch = "X64" Then $5a = "64"
Local $5b = "HKCU" & $5a & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($5b, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($5b, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($5b, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($5b, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($5b, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($5b, "bStartMinimized", "REG_DWORD", 1)
RegWrite($5b, "nTargetMode", "REG_DWORD", 1)
RegWrite($5b, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($5b, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($5b, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($5b, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $4f = True Then
RegWrite($5b, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($5b, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
$4h = RegRead($5b, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($4h) Then $4h = Null
Func _8c()
If Not $4h Then Return
Local $5c = DirGetSize($4h)
If $5c < $45 Then Return
Local $5d = _7m($4h, "*.avi;*.mp4;*.bfix", $4, $9, $b, $d)
If @error = 1 Or $5d = "" Or UBound($5d) < 2 Then Return
For $1g = 1 To UBound($5d) - 1
Local $5e = FileGetSize($5d[$1g])
FileDelete($5d[$1g])
$5c = $5c - $5e
If $5c < $45 Then ExitLoop
Next
EndFunc
Func _8d()
Local $4l = 1
If $4f = False Then $4l = 2
Local $5f = _87($4l)
For $1g = 0 To UBound($5f) - 1
If StringRegExp($5f[$1g], "(?i).*Bandicam.*") Then
_8a($1g, $4l)
EndIf
Next
EndFunc
Func _8e()
$47 = False
$48 = Null
$49 = Null
$4d = Null
$4e = Null
EndFunc
Func _8f()
$4d = Null
If $47 = True Then Return
$47 = True
If $4f = False Then
Run($3x)
Else
Send("^!+9")
EndIf
If $4j = False Then
$4e = TimerInit()
EndIf
_8d()
EndFunc
Func _8g()
If $47 = False Then Return
$47 = False
$4d = Null
$4e = Null
If $4f = False Then
Run($3y)
Else
Send("^!+9")
$4g = True
EndIf
_8d()
_8c()
EndFunc
Func _8h($5g)
If _6y($42, $5g, 1) = -1 Then
Local $13 = $42[0] + 1
ReDim $42[$13 + 1]
$42[$13] = $5g
$42[0] = $13
EndIf
EndFunc
Func _8i($5h)
Local $3p = WinList()
For $1g = 1 To $3p[0][0]
If $3p[$1g][0] = "" And BitAND(WinGetState($3p[$1g][1]), $3) Then
Local $5i = $3p[$1g][1]
Local $5j = $3p[$1g][0]
Local $5k = WinGetPos($5i)
Local $5l = $5k[0]
Local $5m = $5k[1]
Local $5n = $5k[2]
Local $5o = $5k[3]
If $5m > -50 And $5m < 20 And $5o > 0 And $5o < 80 And $5n > 0 And $5l > -80 And $5j = "" Then
_8h($5i)
EndIf
EndIf
Next
If UBound($42) < 2 Then
Local $5p = $5h + 1
If $5p < 10 Then
Sleep(2000)
_8i($5p)
EndIf
EndIf
EndFunc
Func _8j()
WinSetState($46, "", @SW_HIDE)
If UBound($42) = 1 Then Return
For $1g = 1 To $42[0]
WinSetState($42[$1g], "", @SW_HIDE)
Next
EndFunc
Func _8k()
If Not ProcessExists("bdcam.exe") Then
Run($3z)
WinWait($41)
$46 = WinGetHandle($41)
WinSetState($46, "", @SW_HIDE)
Local $5q[1] = [0]
$42 = $5q
Sleep(2500)
_8e()
_8i(1)
_8j()
EndIf
_8d()
EndFunc
Func _8l()
Local $4n = _82()
Local $5r = False
Local $5s = MouseGetPos()
If $5s[0] <> $48 Or $5s[1] <> $49 Then
$5r = True
EndIf
$48 = $5s[0]
$49 = $5s[1]
If $5r Then Return True
If $4g = True Then
$4g = False
Return False
EndIf
For $1g = 1 To 221
If _5w(Hex($1g), $4n) Then
Return True
EndIf
Next
Return False
EndFunc
Func _8m()
If $47 = False Then
Return False
EndIf
If $4d = Null Then
$4d = TimerInit()
Return False
EndIf
Local $5t = TimerDiff($4d)
Return $5t > $3t
EndFunc
Func _8n()
If $47 = False Then
Return False
EndIf
If $4e = Null Then
Return False
EndIf
Local $5t = TimerDiff($4e)
Return $5t > $4i
EndFunc
If ProcessExists("bdcam.exe") Then
_8d()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_8c()
_8k()
Sleep($3u)
Local $5u = 0
Local $5s = MouseGetPos()
$48 = $5s[0]
$49 = $5s[1]
While True
Sleep($3v)
If _8l() Then
_8f()
ElseIf _8m() Then
_8g()
EndIf
If $4j = False And _8n() Then
_8g()
Sleep(1000)
_8f()
EndIf
$5u = $5u + $3v
If $5u > 5000 Then
$5u = 0
_8k()
EndIf
_8j()
WEnd
