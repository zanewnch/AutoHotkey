#Requires AutoHotkey v2.0+

; Function to move mouse cursor to a percentage position on the screen
MoveCursorWorkbenchToPercentage(xPercent := cursor_workbench_x_axis, yPercent := global_y_axis) {
    global defaultXPos, defaultYPos
    if (xPercent = cursor_workbench_x_axis && yPercent = global_y_axis) {
        MouseMove(defaultXPos, defaultYPos, 0)
    } else {
        global screenWidth, screenHeight
        xPos := screenWidth * (xPercent / 100)
        yPos := screenHeight * (yPercent / 100)
        MouseMove(xPos, yPos, 0)
    }
    Return
} 