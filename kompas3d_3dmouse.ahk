#NoEnv
#SingleInstance Force
#Persistent
#InstallKeybdHook
#InstallMouseHook

; === Настройки ===
JoyNumber := 1
DeadZone := 3
ButtonL2 := 7   ; Масштаб -
ButtonR2 := 8   ; Масштаб +

; === Режимы КОМПАС-3D ===
PanKey := "MButton"     ; Средняя кнопка мыши для панорамирования
RotateKey := "RButton"  ; Правая кнопка для вращения

; === Чувствительность ===
PanSensitivity := 0.25
RotateSensitivity := 0.2

; === Главный цикл ===
SetTimer, WatchJoystick, 20
return

WatchJoystick:
    ; Нормализация осей (-100..100)
    LX := (GetKeyState(JoyNumber . "JoyX") - 50) * 2
    LY := (GetKeyState(JoyNumber . "JoyY") - 50) * 2
    RX := (GetKeyState(JoyNumber . "JoyZ") - 50) * 2
    RY := (GetKeyState(JoyNumber . "JoyR") - 50) * 2
    
    ; Мёртвая зона
    ApplyDeadZone(LX, DeadZone)
    ApplyDeadZone(LY, DeadZone)
    ApplyDeadZone(RX, DeadZone)
    ApplyDeadZone(RY, DeadZone)
    
    ; === Автоматическое управление ===
    ; Панорамирование (левый стик)
    if (LX != 0 || LY != 0)
    {
        if !IsPanActive
        {
            Send {%PanKey% down}
            IsPanActive := true
        }
        MouseMove, % LX*PanSensitivity, % LY*PanSensitivity, 0, R
    }
    else if IsPanActive
    {
        Send {%PanKey% up}
        IsPanActive := false
    }
    
    ; Вращение (правый стик)
    if (RX != 0 || RY != 0)
    {
        if !IsRotateActive
        {
            Send {%RotateKey% down}
            IsRotateActive := true
        }
        MouseMove, % RX*RotateSensitivity, % -RY*RotateSensitivity, 0, R
    }
    else if IsRotateActive
    {
        Send {%RotateKey% up}
        IsRotateActive := false
    }
    
    ; Масштабирование (L2/R2)
    if GetKeyState(JoyNumber . "Joy" . ButtonL2)
        Send {WheelDown}
    
    if GetKeyState(JoyNumber . "Joy" . ButtonR2)
        Send {WheelUp}
return

ApplyDeadZone(ByRef val, zone) {
    val := (Abs(val) < zone) ? 0 : val
}

Esc::ExitApp
