Local $aList = WinList()

For $i = 1 To $aList[0][0]
	Local $cHandle = $aList[$i][1]
	Local $cTitle = $aList[$i][0]
	Local $aPos = WinGetPos($cHandle)
	Local $iX = $aPos[0]
	Local $iY = $aPos[1]
	Local $iW = $aPos[2]
	Local $iH = $aPos[3]

	If $iX = 0 And $iY = 0 And $iH < 100 Then
		Local $sReport = "Handle: " & $cHandle _
				 & " title: " & $cTitle _
				 & " X: " & $iX _
				 & " Y: " & $iY _
				 & " W: " & $iW _
				 & " H: " & $iH _
				 & @CRLF
		FileWrite(@DesktopDir & "\WsssM_debug.txt", $sReport)
	EndIf
Next
