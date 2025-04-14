#Requires AutoHotkey v2.0+

; Screen dimensions
global screenWidth := A_ScreenWidth
global screenHeight := A_ScreenHeight

; Cursor position percentages
global cursor_workbench_x_axis := 25
global global_y_axis := 50

; Default cursor positions
global defaultXPos := screenWidth * (cursor_workbench_x_axis / 100)
global defaultYPos := screenHeight * (global_y_axis / 100)

; Mouse movement settings
global mouseMoveStep := 70 