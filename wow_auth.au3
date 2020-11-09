#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Patou

 Script Function:
	Autologin for multiple acc WOW

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Includes

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <File.au3>

; Global vars

$configPath = @DesktopDir & "\wow_auth\"
$config = @DesktopDir & "\wow_auth\config.ini"

If NOT FileExists($config) Then
	DirCreate($configPath)
	_FileCreate ($config)
	MsgBox(0,"INFO", "Sélectionnez Wow.exe")
	$exePath = FileOpenDialog("", @HomeDrive & "\", "(Wow.exe)", $FD_FILEMUSTEXIST)
	IniWrite($config,"Config","exePath",$exePath)
	IniWrite($config,"Accounts","ExempleLogin","ExemplePassword")
Else
EndIf

$Path = "C:\Users\Matthieu\Desktop\World of Warcraft 3.3.5\Wow.exe"

; GUI

#Region ### START Koda GUI section ### Form=
$mainForm = GUICreate("AccMgmt", 136, 122, 192, 124)
$boxAcc = GUICtrlCreateList("", 8, 32, 121, 84)
$labelAcc = GUICtrlCreateLabel("Comptes", 8, 8, 58, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$buttonGo = GUICtrlCreateButton("GO", 80, 6, 43, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Events
Local $acc = IniReadSection($config, "Accounts")
	For $i = 1 To $acc[0][0]
		GUICtrlSetData($boxAcc, $acc[$i][0])
Next

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $buttonGo
			$loginSel = _GUICtrlListBox_GetText($boxAcc, _GUICtrlListBox_GetCurSel($boxAcc))
			$passSel = IniRead($config, "Accounts", $loginSel,"default")
            Logon($loginSel,$passSel)
			;Exit
	EndSwitch
WEnd

; Func
Func Logon($log, $pass)
	Run($Path, "")
	Local $hWnd = WinWaitActive("World of Warcraft", "", 10000)
	Local $hWndState = WinGetState($hWnd)
	ConsoleWrite("State : " & $hWndState)
	While Not BitAND($hWndState, 15)
	Sleep(1000)
	WEnd
	Sleep(2500)
	ControlSend($hWnd, "", "", $log)
	Sleep(100)
	ControlSend($hWnd, "", "", "{TAB}")
	Sleep(100)
	ControlSend($hWnd, "", "", $pass)
	ControlSend($hWnd, "", "", "{ENTER}")
	Sleep(100)
EndFunc
