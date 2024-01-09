#Requires AutoHotkey v2.0

key := "obsidian2bookxnotepro"
value := A_ScriptDir "\" key ".exe"

set_boot_up(){
    RegWrite value, "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", key
}

get_boot_up(){
    try
        regValue := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", key)
    catch as OSError ; if the key doesn't exist
        return false
    
    if (regValue == value)
        return true
    else
        return false
}

remove_boot_up(){
    try
        RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", key)
    catch as OSError ; if the key doesn't exist
        return false
}

adaptive_bootup(){
    if get_boot_up(){
        remove_boot_up()
        MsgBox "已取消开机启动"
    }
    else{
        set_boot_up()
        MsgBox "已设置开机启动"
    }
}