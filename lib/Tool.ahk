#Requires AutoHotkey v2.0

log_toggle := false

GetNameForPath(program_path){
  ; 获取程序的路径
  SplitPath program_path, &name
  return name
}

SearchProgram(target_app_path) {
  ; 程序正在运行
  if (WinExist("ahk_exe" GetNameForPath(target_app_path))) {
      return true
  } else {
      return false
  }
}

ActivateNoteProgram(note_app_names){
  Loop Parse note_app_names, "`n"{
    note_program := A_LoopField
    if (WinExist("ahk_exe" note_program)) {
      ActivateProgram(note_program)
      return
    }
  }
}

ActivateProgram(process_name){
  if WinActive("ahk_exe" process_name){
      return
  }

  if (WinExist("ahk_exe" process_name)) {
      WinActivate ("ahk_exe" process_name)
      Sleep 300 ; 给程序切换窗口的时间
  } else {
      MsgBox process_name " is not running"
      Exit
  }
}

; 安全的递归
global running_count := 0
SafeRecursion(){
  global running_count
  running_count++
  ToolTip("正在重试，第" running_count "次尝试...")
  SetTimer () => ToolTip(), -1000
  if (running_count > 5) {
    running_count := 0
    MsgBox "error: failed!"
    Exit
  }
}

; 等待释放指定按键
ReleaseKeyboard(keyName){
  if GetKeyState(keyName){
      if KeyWait(keyName,"T2") == 0{
          SafeRecursion()
          ReleaseKeyboard(keyName)
      }
  }
  running_count := 0
}

ReleaseCommonUseKeyboard(){
  ReleaseKeyboard("Control")
  ReleaseKeyboard("Shift")
  ReleaseKeyboard("Alt")
}

UrlDecode(Url, Enc := "UTF-8") {
  Pos := 1
  Loop {
    Pos := RegExMatch(Url, "i)(?:%[\da-f]{2})+", &code, Pos++)
    If (Pos = 0)
      Break
    code := code[0]
    var := Buffer(StrLen(code) // 3, 0)
    code := SubStr(code, 2)
    loop Parse code, "`%"
      NumPut("UChar", Integer("0x" . A_LoopField), var, A_Index - 1)
    Url := StrReplace(Url, "`%" code, StrGet(var, Enc))
  }
  Return Url
}

ParseUrl(url){
  ;url := "jv://open?path=https://www.bilibili.com/video/123456/?spm_id_from=..search-card.all.click&time=00:01:53.824"
  ; MsgBox url
  url := UrlDecode(url)
  
  index_of := InStr(url, "?")
  parameters_of_url := SubStr(url, index_of + 1)

  ; 1. 解析键值对
  parameters := StrSplit(parameters_of_url, "&")
  parameters_map := Map()

  ; 1.1 普通解析
  for index, pair in parameters {
    index_of := InStr(pair, "=")
    if (index_of > 0) {
      key := SubStr(pair, 1, index_of - 1)
      value := SubStr(pair, index_of + 1)
      parameters_map[key] := value
    }
  }
  return parameters_map
}