#Requires AutoHotkey v2.0+

; Core Configuration
#InputLevel 1
#UseHook false
SendMode("Input")
SetTitleMatchMode(2)
SetWorkingDir(A_ScriptDir)

; Include modules
#Include modules/config.ahk
#Include modules/utils.ahk
#Include modules/app_shortcuts.ahk
#Include modules/keyboard_shortcuts.ahk
#Include modules/app_specific.ahk

; Fix for Standard Ctrl Key Combinations
#InputLevel 0
~^a::Return  ; Pass through Ctrl+A (Select All)
~^c::Return  ; Pass through Ctrl+C (Copy)
~^v::Return  ; Pass through Ctrl+V (Paste)
~^x::Return  ; Pass through Ctrl+X (Cut)
~^z::Return  ; Pass through Ctrl+Z (Undo)
~^y::Return  ; Pass through Ctrl+Y (Redo)
~^f::Return  ; Pass through Ctrl+F (Find)
~^s::Return  ; Pass through Ctrl+S (Save)
#InputLevel 1

; Mouse Simulation Shortcuts
SetCapsLockState("AlwaysOff")
CapsLock::Return

; Scroll controls
CapsLock & Up::Send("{WheelUp}")
CapsLock & Down::Send("{WheelDown}")
CapsLock & Left::Send("{WheelLeft}")
CapsLock & Right::Send("{WheelRight}")

; Mouse clicks
!Enter::Click
!Backspace::Click("Right")

; Tab + Arrow Keys for Mouse Movement
Tab::Return
Tab & Up::MouseMove(0, -mouseMoveStep, 0, "R")
Tab & Down::MouseMove(0, mouseMoveStep, 0, "R")
Tab & Left::MouseMove(-mouseMoveStep, 0, 0, "R")
Tab & Right::MouseMove(mouseMoveStep, 0, 0, "R")
Tab & Enter::Click
Tab & Backspace::Click("Right") 