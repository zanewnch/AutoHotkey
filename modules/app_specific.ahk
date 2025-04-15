#Requires AutoHotkey v2.0+

; ======================================
; Cursor IDE Specific Shortcuts
; ======================================

#HotIf WinActive("ahk_exe cursor.exe")
^L:: {
    MoveCursorWorkbenchToPercentage(75, 83)  ; 移動滑鼠游標到 X:75%, Y:80% 的位置
    Return
}
#HotIf 