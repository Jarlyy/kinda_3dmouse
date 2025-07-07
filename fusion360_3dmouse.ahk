#NoEnv
#SingleInstance Force
#Persistent
#InstallKeybdHook

; ===== НАСТРОЙКИ =====
port := "COM8"              ; Ваш COM-порт
baud := 115200
deadzone := 5               ; Уменьшена мертвая зона для мгновенного отклика
panSensitivity := 0.2      ; Чувствительность панорамирования
rotateSensitivity := 0.05   ; Чвствительность вращения
pollingRate := 8            ; Увеличена частота опроса

; ===== ИНИЦИАЛИЗАЦИЯ =====
COM_Handle := Serial_Init(port, baud)
if (COM_Handle = -1) {
    MsgBox Ошибка подключения к %port%
    ExitApp
}

; Состояния
panActive := false
rotateActive := false
dataBuffer := ""

; ===== ГЛАВНЫЙ ЦИКЛ =====
SetTimer, ProcessJoystick, %pollingRate%
return

ProcessJoystick:
    ; Чтение данных с минимальной задержкой
    rawData := Serial_Read(COM_Handle)
    if (rawData != "")
        dataBuffer .= rawData
    
    ; Обработка всех полных пакетов в буфере
    while (InStr(dataBuffer, "`n")) {
        packet := SubStr(dataBuffer, 1, InStr(dataBuffer, "`n")-1)
        dataBuffer := SubStr(dataBuffer, InStr(dataBuffer, "`n")+1)
        
        ; Парсинг: LX,LY,RX,RY
        values := StrSplit(packet, ",")
        if (values.Count() < 4)
            continue
        
        ; Нормализация (-100..100)
        ly := (values[1] - 512) / 5.12   ;lx := (values[1] - 512) / 5.12
        lx := (values[2] - 512) / 5.12   ;ly := (values[2] - 512) / 5.12
        ry := (values[3] - 512) / 5.12   ;rx := (values[3] - 512) / 5.12
        rx := (values[4] - 512) / 5.12   ;ry := (values[4] - 512) / 5.12
         
        ; Жесткая мертвая зона
        ApplyDeadZone(lx, deadzone)
        ApplyDeadZone(ly, deadzone)
        ApplyDeadZone(rx, deadzone)
        ApplyDeadZone(ry, deadzone)
        
        ; === ПАНОРАМИРОВАНИЕ (Левый стик) ===
        if (lx != 0 || ly != 0) {
            if (!panActive) {
                MouseClick, Middle,,, 1, 0, D
                panActive := true
            }
            
            MouseMove, % lx*panSensitivity, % -ly*panSensitivity, 0, R
        } 
        else if (panActive) {
            MouseClick, Middle,,, 1, 0, U
            panActive := false
        }
        
        ; === ВРАЩЕНИЕ (Правый стик) ===
; Явная обработка обеих осей
	if (rx != 0 || ry != 0) {
    	    if (!rotateActive) {
		Send {Shift down}
                MouseClick, Middle,,, 1, 0, D
        	rotateActive := true
            }
    
            MouseMove, % rx*rotateSensitivity, % -ry*rotateSensitivity, 0, R
        }
        else if (rotateActive) {
    	    MouseClick, Middle,,, 1, 0, U
	    Send {Shift up}
    	    rotateActive := false
	}
    }
return

; ===== ФУНКЦИИ =====
ApplyDeadZone(ByRef val, zone) {
    val := (Abs(val) < zone) ? 0 : val
}

Serial_Init(port, baud) {
    handle := DllCall("CreateFile"
        , "Str", "\\.\" . port
        , "UInt", 0xC0000000
        , "UInt", 0
        , "UInt", 0
        , "UInt", 3
        , "UInt", 0
        , "UInt", 0)
    
    if (handle = -1)
        return -1
    
    DCB := "baud=" . baud . " data=8 parity=N stop=1"
    DllCall("SetCommState", "Ptr", handle, "Str", DCB)
    return handle
}

Serial_Read(handle) {
    size := 0
    VarSetCapacity(data, 4096, 0)
    
    DllCall("ReadFile"
        , "Ptr", handle
        , "Ptr", &data
        , "UInt", 4096
        , "UInt*", size
        , "UInt", 0)
    
    if (size > 0)
        return StrGet(&data, size, "CP0")
    
    return ""
}

^Esc::ExitApp  ; Завершить скрипт при нажатии Ctrl + Esc