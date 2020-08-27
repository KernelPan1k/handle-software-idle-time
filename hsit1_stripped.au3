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
Func _73(ByRef $1j, $1k, $1l, $1m = True)
If $1k > $1l Then Return
Local $1n = $1l - $1k + 1
Local $1g, $1i, $1o, $1p, $1q, $1r, $1s, $1t
If $1n < 45 Then
If $1m Then
$1g = $1k
While $1g < $1l
$1i = $1g
$1p = $1j[$1g + 1]
While $1p < $1j[$1i]
$1j[$1i + 1] = $1j[$1i]
$1i -= 1
If $1i + 1 = $1k Then ExitLoop
WEnd
$1j[$1i + 1] = $1p
$1g += 1
WEnd
Else
While 1
If $1k >= $1l Then Return 1
$1k += 1
If $1j[$1k] < $1j[$1k - 1] Then ExitLoop
WEnd
While 1
$1o = $1k
$1k += 1
If $1k > $1l Then ExitLoop
$1r = $1j[$1o]
$1s = $1j[$1k]
If $1r < $1s Then
$1s = $1r
$1r = $1j[$1k]
EndIf
$1o -= 1
While $1r < $1j[$1o]
$1j[$1o + 2] = $1j[$1o]
$1o -= 1
WEnd
$1j[$1o + 2] = $1r
While $1s < $1j[$1o]
$1j[$1o + 1] = $1j[$1o]
$1o -= 1
WEnd
$1j[$1o + 1] = $1s
$1k += 1
WEnd
$1t = $1j[$1l]
$1l -= 1
While $1t < $1j[$1l]
$1j[$1l + 1] = $1j[$1l]
$1l -= 1
WEnd
$1j[$1l + 1] = $1t
EndIf
Return 1
EndIf
Local $1u = BitShift($1n, 3) + BitShift($1n, 6) + 1
Local $1v, $1w, $1x, $1y, $1z, $20
$1x = Ceiling(($1k + $1l) / 2)
$1w = $1x - $1u
$1v = $1w - $1u
$1y = $1x + $1u
$1z = $1y + $1u
If $1j[$1w] < $1j[$1v] Then
$20 = $1j[$1w]
$1j[$1w] = $1j[$1v]
$1j[$1v] = $20
EndIf
If $1j[$1x] < $1j[$1w] Then
$20 = $1j[$1x]
$1j[$1x] = $1j[$1w]
$1j[$1w] = $20
If $20 < $1j[$1v] Then
$1j[$1w] = $1j[$1v]
$1j[$1v] = $20
EndIf
EndIf
If $1j[$1y] < $1j[$1x] Then
$20 = $1j[$1y]
$1j[$1y] = $1j[$1x]
$1j[$1x] = $20
If $20 < $1j[$1w] Then
$1j[$1x] = $1j[$1w]
$1j[$1w] = $20
If $20 < $1j[$1v] Then
$1j[$1w] = $1j[$1v]
$1j[$1v] = $20
EndIf
EndIf
EndIf
If $1j[$1z] < $1j[$1y] Then
$20 = $1j[$1z]
$1j[$1z] = $1j[$1y]
$1j[$1y] = $20
If $20 < $1j[$1x] Then
$1j[$1y] = $1j[$1x]
$1j[$1x] = $20
If $20 < $1j[$1w] Then
$1j[$1x] = $1j[$1w]
$1j[$1w] = $20
If $20 < $1j[$1v] Then
$1j[$1w] = $1j[$1v]
$1j[$1v] = $20
EndIf
EndIf
EndIf
EndIf
Local $21 = $1k
Local $22 = $1l
If(($1j[$1v] <> $1j[$1w]) And($1j[$1w] <> $1j[$1x]) And($1j[$1x] <> $1j[$1y]) And($1j[$1y] <> $1j[$1z])) Then
Local $23 = $1j[$1w]
Local $24 = $1j[$1y]
$1j[$1w] = $1j[$1k]
$1j[$1y] = $1j[$1l]
Do
$21 += 1
Until $1j[$21] >= $23
Do
$22 -= 1
Until $1j[$22] <= $24
$1o = $21
While $1o <= $22
$1q = $1j[$1o]
If $1q < $23 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $1q
$21 += 1
ElseIf $1q > $24 Then
While $1j[$22] > $24
$22 -= 1
If $22 + 1 = $1o Then ExitLoop 2
WEnd
If $1j[$22] < $23 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $1j[$22]
$21 += 1
Else
$1j[$1o] = $1j[$22]
EndIf
$1j[$22] = $1q
$22 -= 1
EndIf
$1o += 1
WEnd
$1j[$1k] = $1j[$21 - 1]
$1j[$21 - 1] = $23
$1j[$1l] = $1j[$22 + 1]
$1j[$22 + 1] = $24
_73($1j, $1k, $21 - 2, True)
_73($1j, $22 + 2, $1l, False)
If($21 < $1v) And($1z < $22) Then
While $1j[$21] = $23
$21 += 1
WEnd
While $1j[$22] = $24
$22 -= 1
WEnd
$1o = $21
While $1o <= $22
$1q = $1j[$1o]
If $1q = $23 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $1q
$21 += 1
ElseIf $1q = $24 Then
While $1j[$22] = $24
$22 -= 1
If $22 + 1 = $1o Then ExitLoop 2
WEnd
If $1j[$22] = $23 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $23
$21 += 1
Else
$1j[$1o] = $1j[$22]
EndIf
$1j[$22] = $1q
$22 -= 1
EndIf
$1o += 1
WEnd
EndIf
_73($1j, $21, $22, False)
Else
Local $25 = $1j[$1x]
$1o = $21
While $1o <= $22
If $1j[$1o] = $25 Then
$1o += 1
ContinueLoop
EndIf
$1q = $1j[$1o]
If $1q < $25 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $1q
$21 += 1
Else
While $1j[$22] > $25
$22 -= 1
WEnd
If $1j[$22] < $25 Then
$1j[$1o] = $1j[$21]
$1j[$21] = $1j[$22]
$21 += 1
Else
$1j[$1o] = $25
EndIf
$1j[$22] = $1q
$22 -= 1
EndIf
$1o += 1
WEnd
_73($1j, $1k, $21 - 1, True)
_73($1j, $22 + 1, $1l, False)
EndIf
EndFunc
Func _7m($26, $27 = "*", $28 = $5, $29 = $9, $2a = $a, $2b = $c)
If Not FileExists($26) Then Return SetError(1, 1, "")
If $27 = Default Then $27 = "*"
If $28 = Default Then $28 = $5
If $29 = Default Then $29 = $9
If $2a = Default Then $2a = $a
If $2b = Default Then $2b = $c
If $29 > 1 Or Not IsInt($29) Then Return SetError(1, 6, "")
Local $2c = False
If StringLeft($26, 4) == "\\?\" Then
$2c = True
EndIf
Local $2d = ""
If StringRight($26, 1) = "\" Then
$2d = "\"
Else
$26 = $26 & "\"
EndIf
Local $2e[100] = [1]
$2e[1] = $26
Local $2f = 0, $2g = ""
If BitAND($28, $6) Then
$2f += 2
$2g &= "H"
$28 -= $6
EndIf
If BitAND($28, $7) Then
$2f += 4
$2g &= "S"
$28 -= $7
EndIf
Local $2h = 0
If BitAND($28, $8) Then
$2h = 0x400
$28 -= $8
EndIf
Local $2i = 0
If $29 < 0 Then
StringReplace($26, "\", "", 0, $e)
$2i = @extended - $29
EndIf
Local $2j = "", $2k = "", $2l = "*"
Local $2m = StringSplit($27, "|")
Switch $2m[0]
Case 3
$2k = $2m[3]
ContinueCase
Case 2
$2j = $2m[2]
ContinueCase
Case 1
$2l = $2m[1]
EndSwitch
Local $2n = ".+"
If $2l <> "*" Then
If Not _7p($2n, $2l) Then Return SetError(1, 2, "")
EndIf
Local $2o = ".+"
Switch $28
Case 0
Switch $29
Case 0
$2o = $2n
EndSwitch
Case 2
$2o = $2n
EndSwitch
Local $2p = ":"
If $2j <> "" Then
If Not _7p($2p, $2j) Then Return SetError(1, 3, "")
EndIf
Local $2q = ":"
If $29 Then
If $2k Then
If Not _7p($2q, $2k) Then Return SetError(1, 4, "")
EndIf
If $28 = 2 Then
$2q = $2p
EndIf
Else
$2q = $2p
EndIf
If Not($28 = 0 Or $28 = 1 Or $28 = 2) Then Return SetError(1, 5, "")
If Not($2a = 0 Or $2a = 1 Or $2a = 2) Then Return SetError(1, 7, "")
If Not($2b = 0 Or $2b = 1 Or $2b = 2) Then Return SetError(1, 8, "")
If $2h Then
Local $2r = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $2s = DllOpen('kernel32.dll'), $2t
EndIf
Local $2u[100] = [0]
Local $2v = $2u, $2w = $2u, $2x = $2u
Local $2y = False, $2z = 0, $30 = "", $31 = "", $32 = ""
Local $33 = 0, $34 = ''
Local $35[100][2] = [[0, 0]]
While $2e[0] > 0
$30 = $2e[$2e[0]]
$2e[0] -= 1
Switch $2b
Case 1
$32 = StringReplace($30, $26, "")
Case 2
If $2c Then
$32 = StringTrimLeft($30, 4)
Else
$32 = $30
EndIf
EndSwitch
If $2h Then
$2t = DllCall($2s, 'handle', 'FindFirstFileW', 'wstr', $30 & "*", 'struct*', $2r)
If @error Or Not $2t[0] Then
ContinueLoop
EndIf
$2z = $2t[0]
Else
$2z = FileFindFirstFile($30 & "*")
If $2z = -1 Then
ContinueLoop
EndIf
EndIf
If $28 = 0 And $2a And $2b Then
_7o($35, $32, $2v[0] + 1)
EndIf
$34 = ''
While 1
If $2h Then
$2t = DllCall($2s, 'int', 'FindNextFileW', 'handle', $2z, 'struct*', $2r)
If @error Or Not $2t[0] Then
ExitLoop
EndIf
$31 = DllStructGetData($2r, "FileName")
If $31 = ".." Then
ContinueLoop
EndIf
$33 = DllStructGetData($2r, "FileAttributes")
If $2f And BitAND($33, $2f) Then
ContinueLoop
EndIf
If BitAND($33, $2h) Then
ContinueLoop
EndIf
$2y = False
If BitAND($33, 16) Then
$2y = True
EndIf
Else
$2y = False
$31 = FileFindNextFile($2z, 1)
If @error Then
ExitLoop
EndIf
$34 = @extended
If StringInStr($34, "D") Then
$2y = True
EndIf
If StringRegExp($34, "[" & $2g & "]") Then
ContinueLoop
EndIf
EndIf
If $2y Then
Select
Case $29 < 0
StringReplace($30, "\", "", 0, $e)
If @extended < $2i Then
ContinueCase
EndIf
Case $29 = 1
If Not StringRegExp($31, $2q) Then
_7o($2e, $30 & $31 & "\")
EndIf
EndSelect
EndIf
If $2a Then
If $2y Then
If StringRegExp($31, $2o) And Not StringRegExp($31, $2q) Then
_7o($2x, $32 & $31 & $2d)
EndIf
Else
If StringRegExp($31, $2n) And Not StringRegExp($31, $2p) Then
If $30 = $26 Then
_7o($2w, $32 & $31)
Else
_7o($2v, $32 & $31)
EndIf
EndIf
EndIf
Else
If $2y Then
If $28 <> 1 And StringRegExp($31, $2o) And Not StringRegExp($31, $2q) Then
_7o($2u, $32 & $31 & $2d)
EndIf
Else
If $28 <> 2 And StringRegExp($31, $2n) And Not StringRegExp($31, $2p) Then
_7o($2u, $32 & $31)
EndIf
EndIf
EndIf
WEnd
If $2h Then
DllCall($2s, 'int', 'FindClose', 'ptr', $2z)
Else
FileClose($2z)
EndIf
WEnd
If $2h Then
DllClose($2s)
EndIf
If $2a Then
Switch $28
Case 2
If $2x[0] = 0 Then Return SetError(1, 9, "")
ReDim $2x[$2x[0] + 1]
$2u = $2x
_73($2u, 1, $2u[0])
Case 1
If $2w[0] = 0 And $2v[0] = 0 Then Return SetError(1, 9, "")
If $2b = 0 Then
_7n($2u, $2w, $2v)
_73($2u, 1, $2u[0])
Else
_7n($2u, $2w, $2v, 1)
EndIf
Case 0
If $2w[0] = 0 And $2x[0] = 0 Then Return SetError(1, 9, "")
If $2b = 0 Then
_7n($2u, $2w, $2v)
$2u[0] += $2x[0]
ReDim $2x[$2x[0] + 1]
_6k($2u, $2x, 1)
_73($2u, 1, $2u[0])
Else
Local $2u[$2v[0] + $2w[0] + $2x[0] + 1]
$2u[0] = $2v[0] + $2w[0] + $2x[0]
_73($2w, 1, $2w[0])
For $1g = 1 To $2w[0]
$2u[$1g] = $2w[$1g]
Next
Local $36 = $2w[0] + 1
_73($2x, 1, $2x[0])
Local $37 = ""
For $1g = 1 To $2x[0]
$2u[$36] = $2x[$1g]
$36 += 1
If $2d Then
$37 = $2x[$1g]
Else
$37 = $2x[$1g] & "\"
EndIf
Local $38 = 0, $39 = 0
For $1i = 1 To $35[0][0]
If $37 = $35[$1i][0] Then
$39 = $35[$1i][1]
If $1i = $35[0][0] Then
$38 = $2v[0]
Else
$38 = $35[$1i + 1][1] - 1
EndIf
If $2a = 1 Then
_73($2v, $39, $38)
EndIf
For $1o = $39 To $38
$2u[$36] = $2v[$1o]
$36 += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $2u[0] = 0 Then Return SetError(1, 9, "")
ReDim $2u[$2u[0] + 1]
EndIf
Return $2u
EndFunc
Func _7n(ByRef $3a, $3b, $3c, $2a = 0)
ReDim $3b[$3b[0] + 1]
If $2a = 1 Then _73($3b, 1, $3b[0])
$3a = $3b
$3a[0] += $3c[0]
ReDim $3c[$3c[0] + 1]
If $2a = 1 Then _73($3c, 1, $3c[0])
_6k($3a, $3c, 1)
EndFunc
Func _7o(ByRef $3d, $3e, $3f = -1)
If $3f = -1 Then
$3d[0] += 1
If UBound($3d) <= $3d[0] Then ReDim $3d[UBound($3d) * 2]
$3d[$3d[0]] = $3e
Else
$3d[0][0] += 1
If UBound($3d) <= $3d[0][0] Then ReDim $3d[UBound($3d) * 2][2]
$3d[$3d[0][0]][0] = $3e
$3d[$3d[0][0]][1] = $3f
EndIf
EndFunc
Func _7p(ByRef $27, $3g)
If StringRegExp($3g, "\\|/|:|\<|\>|\|") Then Return 0
$3g = StringReplace(StringStripWS(StringRegExpReplace($3g, "\s*;\s*", ";"), BitOR($f, $g)), ";", "|")
$3g = StringReplace(StringReplace(StringRegExpReplace($3g, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$27 = "(?i)^(" & $3g & ")\z"
Return 1
EndFunc
OnAutoItExitRegister("_81")
AutoItSetOption("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Opt("SendKeyDownDelay", 100)
Local Const $3h = 1000 * 30
Local Const $3i = 1000 * 10
Local Const $3j = 50
Local Const $3k = @ProgramFilesDir & "\Bandicam\bdcam.exe"
Local Const $3l = $3k & " /record"
Local Const $3m = $3k & " /stop"
Local Const $3n = $3k & " /nosplash"
Local Const $3o = "WsssM"
Local Const $3p = "[CLASS:Bandicam2.x]"
Local $3q[1] = [0]
Local Const $3r = 183
Local Const $3s = 5
Local $3t = 107374182400
Local $3u = Null
Local $3v = False
Local $3w = Null
Local $3x = Null
Local $3y = Null
Local $3z = Null
Local $40 = Null
Local $41 = Null
Local $42 = Null
Local $43 = False
Local $44 = False
Local $45 = Null
Local $46 = 540000
If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
$43 = True
$3t = 16106127360
EndIf
Func _81()
If $3y <> Null Then
DllClose($3y)
$3y = Null
EndIf
If $3z <> Null Then
DllClose($3z)
$3z = Null
EndIf
If $40 <> Null Then
DllClose($40)
$40 = Null
EndIf
EndFunc
Func _82()
If $3y = Null Then
$3y = DllOpen('user32.dll')
EndIf
Return $3y
EndFunc
Func _83()
If $3z = Null Then
$3z = DllOpen('kernel32.dll')
EndIf
Return $3z
EndFunc
Func _84()
If $40 = Null Then
$40 = DllOpen('shell32.dll')
EndIf
Return $40
EndFunc
Func _85()
Local $47 = 0
_3z($3o & "_MUTEX", True, 0)
$47 = _3()
Return $47 == $3r Or $47 == $3s
EndFunc
If _85() Then
Exit
EndIf
Func _86($48 = 1)
Local Const $49 = 1048
Local $0z = _8b($48)
If $0z = -1 Then Return -1
Local $4a = _82()
Local $4b = DllCall($4a, "lresult", "SendMessageW", "hwnd", $0z, "uint", $49, "wparam", 0, "lparam", 0)
If @error Then Return -1
Return $4b[0]
EndFunc
Func _87($48 = 1)
Local $4b = _86($48)
If $4b <= 0 Then Return -1
Local $4c[$4b]
For $1g = 0 To $4b - 1
$4c[$1g] = WinGetTitle(_89($1g, $48))
Next
Return $4c
EndFunc
Func _88($13, $48 = 1, $4d = 1)
Local Const $4e = 1047
Local Const $4f = 1053
Local $4a = _82()
Local $4g = _83()
Local Const $4h = BitOR(0x0008, 0x0010, 0x0400)
Local $4i
If @OSArch = "X86" Then
$4i = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
Else
$4i = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
EndIf
Local $4j
If @OSArch = "X86" Then
$4j = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
Else
$4j = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
EndIf
Local $4k = _8b($48)
If $4k = -1 Then Return SetError(1, 0, -1)
Local $4l, $4m = 0
Local $4n = DllCall($4a, "dword", "GetWindowThreadProcessId", "hwnd", $4k, "dword*", 0)
If @error Or Not $4n[2] Then SetError(2, 0, -1)
Local $4o = $4n[2]
Local $4p = DllCall($4g, "handle", "OpenProcess", "dword", $4h, "bool", False, "dword", $4o)
If @error Or Not $4p[0] Then Return SetError(3, 0, -1)
Local $4q = DllCall($4g, "ptr", "VirtualAllocEx", "handle", $4p[0], "ptr", 0, "ulong", DllStructGetSize($4i), "dword", 0x1000, "dword", 0x04)
If Not @error And $4q[0] Then
$4n = DllCall($4a, "lresult", "SendMessageW", "hwnd", $4k, "uint", $4e, "wparam", $13, "lparam", $4q[0])
If Not @error And $4n[0] Then
DllCall($4g, "bool", "ReadProcessMemory", "handle", $4p[0], "ptr", $4q[0], "struct*", $4i, "ulong", DllStructGetSize($4i), "ulong*", 0)
Switch $4d
Case 2
DllCall($4g, "bool", "ReadProcessMemory", "handle", $4p[0], "ptr", DllStructGetData($4i, 6), "struct*", $4j, "ulong", DllStructGetSize($4j), "ulong*", 0)
$4l = $4j
Case 3
$4l = ""
If BitShift(DllStructGetData($4i, 7), 16) <> 0 Then
Local $4r = DllStructCreate("wchar[1024]")
DllCall($4g, "bool", "ReadProcessMemory", "handle", $4p[0], "ptr", DllStructGetData($4i, 7), "struct*", $4r, "ulong", DllStructGetSize($4r), "ulong*", 0)
$4l = DllStructGetData($4r, 1)
EndIf
Case 4
If Not BitAND(DllStructGetData($4i, 3), 8) Then
Local $4s[2], $4t = DllStructCreate("int;int;int;int")
DllCall($4a, "lresult", "SendMessageW", "hwnd", $4k, "uint", $4f, "wparam", $13, "lparam", $4q[0])
DllCall($4g, "bool", "ReadProcessMemory", "handle", $4p[0], "ptr", $4q[0], "struct*", $4t, "ulong", DllStructGetSize($4t), "ulong*", 0)
$4n = DllCall($4a, "int", "MapWindowPoints", "hwnd", $4k, "ptr", 0, "struct*", $4t, "uint", 2)
$4s[0] = DllStructGetData($4t, 1)
$4s[1] = DllStructGetData($4t, 2)
$4l = $4s
Else
$4l = -1
EndIf
Case Else
$4l = $4i
EndSwitch
Else
$4m = 5
EndIf
DllCall($4g, "bool", "VirtualFreeEx", "handle", $4p[0], "ptr", $4q[0], "ulong", 0, "dword", 0x8000)
Else
$4m = 4
EndIf
DllCall($4g, "bool", "CloseHandle", "handle", $4p[0])
If $4m Then
Return SetError($4m, 0, -1)
Else
Return $4l
EndIf
EndFunc
Func _89($13, $48 = 1)
Local $4j = _88($13, $48, 2)
If @error Then
Return SetError(@error, 0, -1)
Else
Return Ptr(DllStructGetData($4j, 1))
EndIf
EndFunc
Func _8a($4u, $48 = 1)
Local $4a = _82()
Local $4v = _84()
Local $4j = _88($4u, $48, 2)
If @error Then Return SetError(@error, 0, -1)
Local $4w = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
DllStructSetData($4w, 1, DllStructGetSize($4w))
DllStructSetData($4w, 2, Ptr(DllStructGetData($4j, 1)))
DllStructSetData($4w, 3, DllStructGetData($4j, 2))
Local $4n = DllCall($4v, "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $4w)
DllCall($4a, "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0)
If IsArray($4n) And $4n[0] Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _8b($48 = 1)
Local $0z, $4n = -1
Local $4a = _82()
If $48 = 1 Then
$0z = DllCall($4a, "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
If @error Then Return -1
$0z = DllCall($4a, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
If @error Then Return -1
If @OSVersion <> "WIN_2000" Then
$0z = DllCall($4a, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
If @error Then Return -1
EndIf
$0z = DllCall($4a, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$4n = $0z[0]
ElseIf $48 = 2 Then
$0z = DllCall($4a, "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
If @error Then Return -1
$0z = DllCall($4a, "hwnd", "FindWindowEx", "hwnd", $0z[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
If @error Then Return -1
$4n = $0z[0]
EndIf
Return $4n
EndFunc
Local $4x = ""
If @OSArch = "X64" Then $4x = "64"
Local $4y = "HKCU" & $4x & "\Software\BANDISOFT\BANDICAM\OPTION"
RegWrite($4y, "bRecordWhenRunning", "REG_DWORD", 0)
RegWrite($4y, "bVideoHotkeyMute", "REG_DWORD", 0)
RegWrite($4y, "bVideoHotkeyPause", "REG_DWORD", 0)
RegWrite($4y, "bVideoHotkeyWebcam", "REG_DWORD", 0)
RegWrite($4y, "bVideoHotkey", "REG_DWORD", 0)
RegWrite($4y, "bStartMinimized", "REG_DWORD", 1)
RegWrite($4y, "nTargetMode", "REG_DWORD", 1)
RegWrite($4y, "nTargetFullOpacity", "REG_DWORD", 20)
RegWrite($4y, "nTargetOpacity", "REG_DWORD", 20)
RegWrite($4y, "bTargetFullPinnedUp", "REG_DWORD", 1)
RegWrite($4y, "nScreenRecordingSubMode", "REG_DWORD", 1)
If $43 = True Then
RegWrite($4y, "bVideoHotkey", "REG_DWORD", 1)
RegWrite($4y, "dwVideoHotkey", "REG_DWORD", 458809)
EndIf
$45 = RegRead($4y, "sOutputFolder")
If @error <> 0 Or 1 <> FileExists($45) Then $45 = Null
Func _8c()
If Not $45 Then Return
Local $4z = DirGetSize($45)
If $4z < $3t Then Return
Local $50 = _7m($45, "*.avi;*.mp4;*.bfix", $4, $9, $b, $d)
If @error = 1 Or $50 = "" Or UBound($50) < 2 Then Return
For $1g = 1 To UBound($50) - 1
Local $51 = FileGetSize($50[$1g])
FileDelete($50[$1g])
$4z = $4z - $51
If $4z < $3t Then ExitLoop
Next
EndFunc
Func _8d()
Local $48 = 1
If $43 = False Then $48 = 2
Local $52 = _87($48)
For $1g = 0 To UBound($52) - 1
If StringRegExp($52[$1g], "(?i).*Bandicam.*") Then
_8a($1g, $48)
EndIf
Next
EndFunc
Func _8e()
$3v = False
$3w = Null
$3x = Null
$41 = Null
$42 = Null
EndFunc
Func _8f()
$41 = Null
If $3v = True Then Return
$3v = True
If $43 = False Then
Run($3l)
Else
Send("^!+9")
EndIf
$42 = TimerInit()
_8d()
EndFunc
Func _8g()
If $3v = False Then Return
$3v = False
$41 = Null
$42 = Null
If $43 = False Then
Run($3m)
Else
Send("^!+9")
$44 = True
EndIf
_8d()
_8c()
EndFunc
Func _8h($53)
Local $13 = $3q[0] + 1
ReDim $3q[$13 + 1]
$3q[$13] = $53
$3q[0] = $13
EndFunc
Func _8i()
Local $3d = WinList()
For $1g = 1 To $3d[0][0]
If $3d[$1g][0] = "" And BitAND(WinGetState($3d[$1g][1]), $3) Then
Local $54 = $3d[$1g][1]
Local $55 = $3d[$1g][0]
Local $56 = WinGetPos($54)
Local $57 = $56[0]
Local $58 = $56[1]
Local $59 = $56[2]
Local $5a = $56[3]
If $58 > -50 And $58 < 20 And $5a > 0 And $5a < 80 And $59 > 0 And $57 > -80 And $55 = "" Then
_8h($54)
EndIf
EndIf
Next
EndFunc
Func _8j()
WinSetState($3u, "", @SW_HIDE)
If UBound($3q) = 1 Then Return
For $1g = 1 To $3q[0]
WinSetState($3q[$1g], "", @SW_HIDE)
Next
EndFunc
Func _8k()
If Not ProcessExists("bdcam.exe") Then
Run($3n)
WinWait($3p)
$3u = WinGetHandle($3p)
WinSetState($3u, "", @SW_HIDE)
Local $5b[1] = [0]
$3q = $5b
Sleep(2500)
_8e()
_8i()
_8j()
EndIf
_8d()
EndFunc
Func _8l()
Local $4a = _82()
Local $5c = False
Local $5d = MouseGetPos()
If $5d[0] <> $3w Or $5d[1] <> $3x Then
$5c = True
EndIf
$3w = $5d[0]
$3x = $5d[1]
If $5c Then Return True
If $44 = True Then
$44 = False
Return False
EndIf
For $1g = 1 To 221
If _5w(Hex($1g), $4a) Then
Return True
EndIf
Next
Return False
EndFunc
Func _8m()
If $3v = False Then
Return False
EndIf
If $41 = Null Then
$41 = TimerInit()
Return False
EndIf
Local $5e = TimerDiff($41)
Return $5e > $3h
EndFunc
Func _8n()
ConsoleWrite(" $bIsRunning " & $3v & @CRLF)
If $3v = False Then
Return False
EndIf
ConsoleWrite(" $hTimer " & $41 & @CRLF)
If $42 = Null Then
Return False
EndIf
Local $5e = TimerDiff($42)
ConsoleWrite(" $fDiff " & $5e & " " & $46 & @CRLF)
Return $5e > $46
EndFunc
If ProcessExists("bdcam.exe") Then
_8d()
ProcessClose("bdcam.exe")
Sleep(2000)
EndIf
_8c()
_8k()
Sleep($3i)
Local $5f = 0
Local $5d = MouseGetPos()
$3w = $5d[0]
$3x = $5d[1]
While True
Sleep($3j)
If _8l() Then
_8f()
ElseIf _8m() Then
_8g()
EndIf
If _8n() Then
_8g()
Sleep(1000)
_8f()
EndIf
$5f = $5f + $3j
If $5f > 5000 Then
$5f = 0
_8k()
EndIf
_8j()
WEnd
